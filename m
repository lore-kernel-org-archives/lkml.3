Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757811Ab3BBOUy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 09:20:54 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:16662 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757613Ab3BBOT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 09:19:57 -0500
X-Authority-Analysis: v=2.0 cv=bJmU0YCZ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=2nB7RNwxyKsA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=D8busaIx4ccA:10 a=GvQkQWPkAAAA:8 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=NufY4J3AAAAA:8 a=6kcgh8hLkRGSLAEeN_MA:9 a=QEXdDO2ut3YA:10 a=Wwjp7rKQgkIA:10 a=MSl-tDqOz04A:10 a=re9sYKne76oA:10 a=jeBq3FmKZ4MA:10 a=7sE7yg0GKJZYB-F9BzwA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130202141955.137013185@goodmis.org>
User-Agent: quilt/0.60-1
Date: Sat, 02 Feb 2013 09:18:45 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Christoph Lameter <cl@linux.com>, Shan Wei <davidshan@tencent.com>
Subject: [PATCH 03/11] tracing: Use __this_cpu_inc/dec operation instead of __get_cpu_var
References: <20130202141842.189550803@goodmis.org>
Content-Disposition: inline; filename=0003-tracing-Use-__this_cpu_inc-dec-operation-instead-of-.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Shan Wei <davidshan@tencent.com>

__this_cpu_inc_return() or __this_cpu_dec generates a single instruction,
which is faster than __get_cpu_var operation.

Link: http://lkml.kernel.org/r/50A9C1BD.1060308@gmail.com

Reviewed-by: Christoph Lameter <cl@linux.com>
Signed-off-by: Shan Wei <davidshan@tencent.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index ca9b7df..07888e1 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1344,7 +1344,7 @@ static void __ftrace_trace_stack(struct ring_buffer *=
buffer,
 	 */
 	preempt_disable_notrace();
=20
-	use_stack =3D ++__get_cpu_var(ftrace_stack_reserve);
+	use_stack =3D __this_cpu_inc_return(ftrace_stack_reserve);
 	/*
 	 * We don't need any atomic variables, just a barrier.
 	 * If an interrupt comes in, we don't care, because it would
@@ -1398,7 +1398,7 @@ static void __ftrace_trace_stack(struct ring_buffer *=
buffer,
  out:
 	/* Again, don't let gcc optimize things here */
 	barrier();
-	__get_cpu_var(ftrace_stack_reserve)--;
+	__this_cpu_dec(ftrace_stack_reserve);
 	preempt_enable_notrace();
=20
 }
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRDSCLAAoJEOdOSU1xswtMRO8IAKtC5yylhYPtGZZyS0cCZ2oe
TWL2gKs7CvsHkwZtnaxqDA46Zqtgdg8KhzqSzsoZViB6TgsU3GL4tQxZVv45RR2J
OJ2G1vKX1LJeK3FGfyOfyqMhZqH3opBkw2nFyXKYkG9EnOap0PI9Ngv8lpCl2XZS
QD4PdGwlv8BT7H4qo6/L4dwXIyTA4FWWb9pdjz1cN9Q8XEQwvTMf90ujHpZtIUMk
LSzsbXiAKGuVuKgzPmRQDG/+EAJeJ8c/ujwDpYPGd1tv8C+UeWpRiw1T7Y5GPPdo
kVbpbriHkDO9/U6D0OpM63/XQ9d+35W1znryO3132JEYP2ys96jxtOcZi5dWzrE=
=3kBs
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
