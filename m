Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757906Ab3BBOUi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 09:20:38 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20565 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757555Ab3BBOT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 09:19:56 -0500
X-Authority-Analysis: v=2.0 cv=C91rOHz+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=JMyPhzVSDtsA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=6LGJgfoBzO0A:10 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=VKC3MH5HhMgxWjk6F5QA:9 a=QEXdDO2ut3YA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=zodU6UT3ZjDzNcM0M2cA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130202141955.317938675@goodmis.org>
User-Agent: quilt/0.60-1
Date: Sat, 02 Feb 2013 09:18:46 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jovi Zhang <bookjovi@gmail.com>
Subject: [PATCH 04/11] tracing: Remove second iterator initializer
References: <20130202141842.189550803@goodmis.org>
Content-Disposition: inline; filename=0004-tracing-Remove-second-iterator-initializer.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Jovi Zhang <bookjovi@gmail.com>

The trace iterator is already initialized by trace_init_global_iter(),
so there is no need to initialize it again.

Link: http://lkml.kernel.org/r/CACV3sb+G1YnO6168JhY3dEadmJi58pA5-2cSZT8E0WV=
HJNFt9Q@mail.gmail.com

Signed-off-by: Jovi Zhang <bookjovi@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 07888e1..d399592 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -5030,6 +5030,7 @@ __ftrace_dump(bool disable_tracing, enum ftrace_dump_=
mode oops_dump_mode)
 	if (disable_tracing)
 		ftrace_kill();
=20
+	/* Simulate the iterator */
 	trace_init_global_iter(&iter);
=20
 	for_each_tracing_cpu(cpu) {
@@ -5041,10 +5042,6 @@ __ftrace_dump(bool disable_tracing, enum ftrace_dump=
_mode oops_dump_mode)
 	/* don't look at user memory in panic mode */
 	trace_flags &=3D ~TRACE_ITER_SYM_USEROBJ;
=20
-	/* Simulate the iterator */
-	iter.tr =3D &global_trace;
-	iter.trace =3D current_trace;
-
 	switch (oops_dump_mode) {
 	case DUMP_ALL:
 		iter.cpu_file =3D TRACE_PIPE_ALL_CPU;
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRDSCLAAoJEOdOSU1xswtM6DsH/0eBTguW/WSDUe1rURm/48Jj
zzH8KJh9lJLMRWyf5LysJMgkoaq2yaFSHUws/QXb+L2umXC04Rhrxh1YqDpfp+r7
9378gD8uFOIsuyFoyMAAjpHMK9LJof+i2MybklzHcAOqRzYX+4nIwwd2mFKLeFbe
joRBNcSYaW09lGAgv5/TAeuN+Ct6oat7AS660GlCrJp/z10zBaLxfXXYoQeDOg7A
VX/xI+K7M727+V3KhaitrBq4o/WF47qO8c00agtX1xFnd8dev5FrMFWV5pBm/+LJ
Kz3Y6d8qfCtrbt25se0fTfy9pjTPcmGL1yZLQhGcs9X8ZCosgr615A8Z+xl/jTw=
=V/vG
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
