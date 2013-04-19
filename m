Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030579Ab3DSOGB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 10:06:01 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:31727 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030494Ab3DSOF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 10:05:58 -0400
X-Authority-Analysis: v=2.0 cv=UY7TuduN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=Vr6F6wcmAogA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=YkI2SxshDmYA:10 a=57SyGIRnAAAA:8 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=bY8bSRiNex79ag6D3ywA:9 a=QEXdDO2ut3YA:10 a=lSinr4eg3GwA:10 a=TIV7c6GJmisA:10 a=LI9Vle30uBYA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=Y8Ioc38kJW9iZjkh-vIA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130419140556.537659608@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 19 Apr 2013 10:04:04 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung.kim@lge.com>, <stable@vger.kernel.org>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [for-next][PATCH 2/7] tracing: Fix off-by-one on allocating stat->pages
References: <20130419140402.730041313@goodmis.org>
Content-Disposition: inline; filename=0002-tracing-Fix-off-by-one-on-allocating-stat-pages.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Namhyung Kim <namhyung.kim@lge.com>

The first page was allocated separately, so no need to start from 0.

Link: http://lkml.kernel.org/r/1364820385-32027-2-git-send-email-namhyung@k=
ernel.org

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: stable@vger.kernel.org
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 548a1f7..c9f3149 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -676,7 +676,7 @@ int ftrace_profile_pages_init(struct ftrace_profile_sta=
t *stat)
=20
 	pages =3D DIV_ROUND_UP(functions, PROFILES_PER_PAGE);
=20
-	for (i =3D 0; i < pages; i++) {
+	for (i =3D 1; i < pages; i++) {
 		pg->next =3D (void *)get_zeroed_page(GFP_KERNEL);
 		if (!pg->next)
 			goto out_free;
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRcU9EAAoJEOdOSU1xswtM054IAJ0RrtSwwkbzqVBd4nGtFqGL
AWeMdCLHWmFhSw5Cosmj5tHJG1Xp+bfTaHnkuvOWJYMM+kYJuq9Lqx7tIjkgAVno
j4EzhYCreXSx4iiKJcIy53tf5KkB81JdTAmNr0mlSq3/sXbMkIo6638gwWPxtAI9
ANJ7tLUq7e2TZH9JUdWcVIlNXEfrfwDTdb2S7Gwj8DLzzkZzkJG2vqQAi5UEUMpy
/PM3PQtG+14465EC4mBvgA6q5Bc8rRdosbIKzm9LAO9ZN9IBoOa4m2Ybvw2oV8y8
w8hRVJUbTnzTUw3BFlbgWjJA/P6FHsjpCj97FOJinr8/oDAXyfUd3BF32Vmyq+k=
=5Xcj
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
