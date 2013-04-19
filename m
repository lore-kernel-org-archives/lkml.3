Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030571Ab3DSOIV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 10:08:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:18171 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030543Ab3DSOF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 10:05:59 -0400
X-Authority-Analysis: v=2.0 cv=UY7TuduN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=rVOiUqZzVKcA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=MkHyw01v_KEA:10 a=57SyGIRnAAAA:8 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=uSpTwu3uDpLY0srXjz4A:9 a=QEXdDO2ut3YA:10 a=lSinr4eg3GwA:10 a=TIV7c6GJmisA:10 a=LI9Vle30uBYA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=GAsGbLxsrEEGLtNNkMgA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130419140557.213209813@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 19 Apr 2013 10:04:07 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung.kim@lge.com>, <stable@vger.kernel.org>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [for-next][PATCH 5/7] tracing: Check return value of tracing_init_dentry()
References: <20130419140402.730041313@goodmis.org>
Content-Disposition: inline; filename=0005-tracing-Check-return-value-of-tracing_init_dentry.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Namhyung Kim <namhyung.kim@lge.com>

Check return value and bail out if it's NULL.

Link: http://lkml.kernel.org/r/1365553093-10180-2-git-send-email-namhyung@k=
ernel.org

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: stable@vger.kernel.org
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c       |    2 ++
 kernel/trace/trace_stack.c |    2 ++
 kernel/trace/trace_stat.c  |    2 ++
 3 files changed, 6 insertions(+)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 07860b9..7297079 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -5953,6 +5953,8 @@ static __init int tracer_init_debugfs(void)
 	trace_access_lock_init();
=20
 	d_tracer =3D tracing_init_dentry();
+	if (!d_tracer)
+		return 0;
=20
 	init_tracer_debugfs(&global_trace, d_tracer);
=20
diff --git a/kernel/trace/trace_stack.c b/kernel/trace/trace_stack.c
index aab277b..8c3f37e 100644
--- a/kernel/trace/trace_stack.c
+++ b/kernel/trace/trace_stack.c
@@ -431,6 +431,8 @@ static __init int stack_trace_init(void)
 	struct dentry *d_tracer;
=20
 	d_tracer =3D tracing_init_dentry();
+	if (!d_tracer)
+		return 0;
=20
 	trace_create_file("stack_max_size", 0644, d_tracer,
 			&max_stack_size, &stack_max_size_fops);
diff --git a/kernel/trace/trace_stat.c b/kernel/trace/trace_stat.c
index 96cffb2..847f88a 100644
--- a/kernel/trace/trace_stat.c
+++ b/kernel/trace/trace_stat.c
@@ -307,6 +307,8 @@ static int tracing_stat_init(void)
 	struct dentry *d_tracing;
=20
 	d_tracing =3D tracing_init_dentry();
+	if (!d_tracing)
+		return 0;
=20
 	stat_dir =3D debugfs_create_dir("trace_stat", d_tracing);
 	if (!stat_dir)
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRcU9FAAoJEOdOSU1xswtMjFgIAKmoOqKz4KOdh1ar7J/y/C22
jp21RKdAFdU7Ea/UOZBonxTwoyDbgxsilSXbkAfmzmwhhoT6AOg2u3e7eaZIAplF
CkW2g/fJnMWdOIBNmVtrUSSErAy96hQ9+n+P6TCB0xXKQcef3biRUX8pmKEHDCcz
krNqZVpF7FQruz6vKGyMCwN3FbzKxrCN2gFXFoNSMcVmKZxaQtZyVY+BkdYWZmfq
6XNPDanoBLdtpEAhA4uS6s+JeNtpuu8pREriHmr6Q/ZntLZvFOZDPVmAfgZUBKDV
C7a6nK6XaXFD5NlFnMp2Wl9USvqE7iMAGFSLkNzjwege/4KGlLN3AkrG0Knof5M=
=pUe7
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
