Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932300Ab3COTzq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 15:55:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:21520 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755323Ab3COTvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 15:51:25 -0400
X-Authority-Analysis: v=2.0 cv=adbjbGUt c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=qIIfHHHXVvoA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=DqMiC3shMJwA:10 a=zxS_EEpcSkTCxOgGYOgA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=oJs8QbmOaUBpHXRXCMgA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130315195124.310613939@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 15 Mar 2013 15:39:47 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [for-next][PATCH 12/20] tracing: Add skip argument to trace_dump_stack()
References: <20130315193935.359219613@goodmis.org>
Content-Disposition: inline; filename=0012-tracing-Add-skip-argument-to-trace_dump_stack.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Altough the trace_dump_stack() already skips three functions in
the call to stack trace, which gets the stack trace to start
at the caller of the function, the caller may want to skip some
more too (as it may have helper functions).

Add a skip argument to the trace_dump_stack() that lets the caller
skip back tracing functions that it doesn't care about.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/kernel.h |    2 +-
 kernel/trace/trace.c   |   13 +++++++++----
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index d0a16fe..239dbb9 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -597,7 +597,7 @@ extern int __trace_puts(unsigned long ip, const char *s=
tr, int size);
 		__trace_puts(_THIS_IP_, str, strlen(str));		\
 })
=20
-extern void trace_dump_stack(void);
+extern void trace_dump_stack(int skip);
=20
 /*
  * The double __builtin_constant_p is because gcc will give us an error
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index c5b8446..8aa5321 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1657,8 +1657,9 @@ void __trace_stack(struct trace_array *tr, unsigned l=
ong flags, int skip,
=20
 /**
  * trace_dump_stack - record a stack back trace in the trace buffer
+ * @skip: Number of functions to skip (helper handlers)
  */
-void trace_dump_stack(void)
+void trace_dump_stack(int skip)
 {
 	unsigned long flags;
=20
@@ -1667,9 +1668,13 @@ void trace_dump_stack(void)
=20
 	local_save_flags(flags);
=20
-	/* skipping 3 traces, seems to get us at the caller of this function */
-	__ftrace_trace_stack(global_trace.trace_buffer.buffer, flags, 3,
-			     preempt_count(), NULL);
+	/*
+	 * Skip 3 more, seems to get us at the caller of
+	 * this function.
+	 */
+	skip +=3D 3;
+	__ftrace_trace_stack(global_trace.trace_buffer.buffer,
+			     flags, skip, preempt_count(), NULL);
 }
=20
 static DEFINE_PER_CPU(int, user_stack_count);
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRQ3u8AAoJEOdOSU1xswtMS5oH/jEi5dwkCoJsqeooZX/IjqCk
/LK2Ajjyc0PbKXyTXs3jCmIr7COBKKGT1rFmXgQIy0BkOLh8wfn4PJ74SZL423aS
bm71RawLKrqpNMTY9v4ZdZ5XCOfGnMOC5ZSHNj5UAK2PQ1O+ttbVWkZAzFAlzgO5
8BWhZ9U67Jnycc+IzOSHpywfW4puyAUtMPv3oCZcv+qPJKfVWs/ktxd7fhj0faWd
ajMXwKVhJArX+DUXYnD74wBaTPVZu8azg/jFgRAfaurpYwFlda13iEo5q2L+vybk
sEwRQsHvEF/cX2s2Xnio+6zT75VI0vMKYtyEm2J5hlyYmJy3E9ECX2LXssS9Hzc=
=+fC0
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
