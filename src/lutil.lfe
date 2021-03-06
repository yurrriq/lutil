(defmodule lutil
  "misc utility functions"
  (export all))

;; The clj macros are included here to allow for easy use
;; in the REPL when one slurps this module.
(include-lib "lfe/include/clj.lfe")

(defun uuid4 ()
  "Adapted from the implementation given [here][1].

  [1]: https://github.com/afiskon/erlang-uuid-v4/blob/8c03a11524f6bccf984575877b533ef30a009175/src/uuid.erl"
  (let* (((binary
            (a (size 32))
            (b (size 16))
            (c (size 16))
            (d (size 16))
            (e (size 48))) (crypto:rand_bytes 16))
         (format-template '"~8.16.0b-~4.16.0b-4~3.16.0b-~4.16.0b-~12.16.0b")
         (uuid-data (list a b (band c #x0fff) (band d #x3fff) (bor #x8000 e)))
         (string (io_lib:format format-template uuid-data)))
    (list_to_binary string)))

(defun uuid4
  "A wrapper for [[uuid4/0]]."
  (((tuple 'type 'binary))
    (uuid4))
  (((tuple 'type 'list))
    (binary_to_list (uuid4)))
  (((tuple 'type 'atom))
    (binary_to_atom (uuid4) 'latin1)))

(defun get-app-version (app-name)
  "DEPRECATED.

  Provided for backwards compatibility."
  (lr3-ver-util:get-app-version app-name))

(defun get-version ()
  (lr3-ver-util:get-app-version 'lutil))

(defun get-versions ()
  (++ (lr3-ver-util:get-versions)
      `(#(kla ,(lr3-ver-util:get-app-version 'kla))
        #(clj ,(lr3-ver-util:get-app-version 'clj))
        #(lutil ,(get-version)))))

(defun check (x)
  (=/= x 'false))

(defun get-env-funcs (env)
  (lists:sort
    (lists:map
      (lambda (x)
        (element 1 x))
      (element 3 env))))

(defun warn (msg)
  (warn msg ()))

(defun warn (msg args)
  (lfe_io:format (++ msg "~n") args))

(defun deprecated ()
  (deprecated "This functionality has been deprecated."))

(defun deprecated (msg)
  (warn (++ "Deprecated: " msg)))
