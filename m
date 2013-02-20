Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935774Ab3BTEJb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 23:09:31 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:6692 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934950Ab3BTEJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 23:09:28 -0500
X-Authority-Analysis: v=2.0 cv=UN5f7Vjy c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=JeqlLnWLhPYA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=uPdVS1cV1AwA:10 a=jIrssqiBtzHEFHHwAZkA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=MaYUZf2eLgT1Ce9srkcA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130220040926.931296865@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 19 Feb 2013 23:07:30 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 2/7] ktest: Strip off \n when reading which files were modified
References: <20130220040728.921685169@goodmis.org>
Content-Disposition: inline; filename=0002-ktest-Strip-off-n-when-reading-which-files-were-modi.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

The patchcheck test looks at what files are modified for each patch it
checks and makes sure that those files do not produce any warnings.

Unfortunately, when it read the diffstat, the newlines were added on the
files and this made compares miss warnings, and commits that should not
have passed, ktest let pass.

Fix this by using the perl command "chomp" that strips off whitespace at
the end of lines.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index d6690df..cc9925a 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -1925,6 +1925,10 @@ sub check_buildlog {
=20
     my @files =3D `git show $patch | diffstat -l`;
=20
+    foreach my $file (@files) {
+	chomp $file;
+    }
+
     open(IN, "git show $patch |") or
 	dodie "failed to show $patch";
     while (<IN>) {
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRJEx3AAoJEOdOSU1xswtM0TgIAJdLrYawXNlvcqHgf3XlbjSw
pxv/J9OVC0wLKts9+KO98EP0Ec1VbI5gHmwjm+HS3RGwdOxmItHPEycog9/bWOWK
6fLFNKqXvqTBkl7npzXVlYpL1qnWKoPxUXzo7qo8BbL2scD1oI2ney+YjEyHbkKO
z5gVOVbp7ZKQoXPDnLaNoJH0yHQatXM0GsZPXz4jHwFQkCoOuEx5BNOSpS9o4uOu
N410D4V1Q4tgauQN7i02rZAVl+LBA2Y/KOb6a73VKThg/zTzKxKLgmQMszvSAe6c
HtU2dmwgj2qr16OgrgqSOTSajO604+PLqVolC8KtH+0f3fbitfuPaS78fOo1qkg=
=kmJK
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
