Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751510AbaB0Uom (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 15:44:42 -0500
Received: from mail-qg0-f42.google.com ([209.85.192.42]:35036 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbaB0Uok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 15:44:40 -0500
MIME-Version: 1.0
In-Reply-To: <faa9e231-d561-417b-8b8b-95192cb0e56a@email.android.com>
References: <1393462087.24588.50.camel@joe-AO722>
	<530E8C2E.7080307@zytor.com>
	<1393466619.24588.65.camel@joe-AO722>
	<20140227022857.GC23659@thin>
	<1393469594.24588.71.camel@joe-AO722>
	<20140227025845.GA25145@thin>
	<530EB103.5070406@zytor.com>
	<1393472326.24588.82.camel@joe-AO722>
	<20140227040050.GA8449@nicira.com>
	<530EBCED.9020705@zytor.com>
	<20140227042636.GA9592@nicira.com>
	<530EBFC7.9030309@zytor.com>
	<CANeU7Q=RNXR00bQcPzJYTOcZmRSn3U31ZcadPTHu6Y_Uk0UnYw@mail.gmail.com>
	<faa9e231-d561-417b-8b8b-95192cb0e56a@email.android.com>
Date: Thu, 27 Feb 2014 12:44:37 -0800
X-Google-Sender-Auth: vLjWaYTx-93bZiuYkK-Uj7U_nsI
Message-ID: <CANeU7QnB1Yfd6SjLeUmB1Q-a+U6G221J8es7ckfjB-U45sAVMA@mail.gmail.com>
Subject: Re: [PATCH V2] sparse: Allow override of sizeof(bool) warning
From: Christopher Li <sparse@chrisli.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ben Pfaff <blp@nicira.com>, Joe Perches <joe@perches.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Linux-Sparse <linux-sparse@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 12:26 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> I would.
>

Joe, I assume you are OK with this patch, the default is now off.

Chris

Allow an override to emit or not the sizeof(bool) warning.
Add a "-Wsizeof-bool" description to the manpage.

Signed-off-by: Joe Perches <joe@perches.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Christopher Li <sparse@chrisli.org>
---
 evaluate.c | 3 ++-
 lib.c      | 2 ++
 lib.h      | 1 +
 sparse.1   | 8 ++++++++
 4 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/evaluate.c b/evaluate.c
index 6655615..a45f59b 100644
--- a/evaluate.c
+++ b/evaluate.c
@@ -2057,7 +2057,8 @@ static struct symbol *evaluate_sizeof(struct
expression *expr)
     }

     if (size == 1 && is_bool_type(type)) {
-        warning(expr->pos, "expression using sizeof bool");
+        if (Wsizeof_bool)
+            warning(expr->pos, "expression using sizeof bool");
         size = bits_in_char;
     }

diff --git a/lib.c b/lib.c
index 51b97fd..844797d 100644
--- a/lib.c
+++ b/lib.c
@@ -226,6 +226,7 @@ int Wparen_string = 0;
 int Wptr_subtraction_blows = 0;
 int Wreturn_void = 0;
 int Wshadow = 0;
+int Wsizeof_bool = 0;
 int Wtransparent_union = 0;
 int Wtypesign = 0;
 int Wundef = 0;
@@ -438,6 +439,7 @@ static const struct warning {
     { "ptr-subtraction-blows", &Wptr_subtraction_blows },
     { "return-void", &Wreturn_void },
     { "shadow", &Wshadow },
+    { "sizeof-bool", &Wsizeof_bool },
     { "transparent-union", &Wtransparent_union },
     { "typesign", &Wtypesign },
     { "undef", &Wundef },
diff --git a/lib.h b/lib.h
index f09b338..f6cd9b4 100644
--- a/lib.h
+++ b/lib.h
@@ -120,6 +120,7 @@ extern int Wparen_string;
 extern int Wptr_subtraction_blows;
 extern int Wreturn_void;
 extern int Wshadow;
+extern int Wsizeof_bool;
 extern int Wtransparent_union;
 extern int Wtypesign;
 extern int Wundef;
diff --git a/sparse.1 b/sparse.1
index cd6be26..54da09b 100644
--- a/sparse.1
+++ b/sparse.1
@@ -297,6 +297,14 @@ Such declarations can lead to error-prone code.
 Sparse does not issue these warnings by default.
 .
 .TP
+.B \-Wsizeof-bool
+Warn when checking the sizeof a _Bool.
+
+C99 does not specify the sizeof a _Bool.  gcc uses 1.
+
+Sparse does not issue these warnings by default.
+.
+.TP
 .B \-Wtransparent\-union
 Warn about any declaration using the GCC extension
 \fB__attribute__((transparent_union))\fR.
-- 
1.8.5.3
