Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030595Ab3DSOGD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 10:06:03 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27674 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030550Ab3DSOGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 10:06:00 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=7SwZq4Ep4YMA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=pxLsrvAuApAA:10 a=57SyGIRnAAAA:8 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=0p_tGu2-1vAFuR1vD4QA:9 a=QEXdDO2ut3YA:10 a=lSinr4eg3GwA:10 a=TIV7c6GJmisA:10 a=LI9Vle30uBYA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=G5oE9OIVXgYX4RrsyoEA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130419140556.765331055@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 19 Apr 2013 10:04:05 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung.kim@lge.com>, <stable@vger.kernel.org>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [for-next][PATCH 3/7] tracing: Reset ftrace_graph_filter_enabled if count is zero
References: <20130419140402.730041313@goodmis.org>
Content-Disposition: inline; filename=0003-tracing-Reset-ftrace_graph_filter_enabled-if-count-i.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Namhyung Kim <namhyung.kim@lge.com>

The ftrace_graph_count can be decreased with a "!" pattern, so that
the enabled flag should be updated too.

Link: http://lkml.kernel.org/r/1365663698-2413-1-git-send-email-namhyung@ke=
rnel.org

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: stable@vger.kernel.org
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index c9f3149..9e31987 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -3792,7 +3792,8 @@ out:
 	if (fail)
 		return -EINVAL;
=20
-	ftrace_graph_filter_enabled =3D 1;
+	ftrace_graph_filter_enabled =3D !!(*idx);
+
 	return 0;
 }
=20
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRcU9EAAoJEOdOSU1xswtMklAH/25Aunu+4m8CShQBreihe6er
tF/vmz3/Y8+Ygrh0ExCsHBJItWKHdMqOvZecSvQ9dfDp8rSk4HXKB3fvOoZ8PV8o
6dfwOHEKkCzqxbACQmFQUcX6CK7qksYugCVlNd/A8RQX67zGE32YPGU3tUG5JGP4
vTk23hzrcDvO4W8URfmmo7IxZ6fRFTRNWIY6OT4e9SZn2xRGFeqZcvpR18bhLaVJ
wc2/EMkHNzA+U/9P0h7a8sYnhmaTgmyFKUQspxnnNUUJzTXW0ud2pOg7tJtq92DT
TGbXjt7/5tupFMieaWjFSilLYZkQ0CuRE5Zdolrq+HM0pqpsbCbihpeYCfS0+p4=
=P+1a
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
