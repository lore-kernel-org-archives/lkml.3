Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758252Ab3D2NkW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 09:40:22 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11525 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757564Ab3D2NkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 09:40:17 -0400
X-Authority-Analysis: v=2.0 cv=cOZiQyiN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=LijW9n3POo0A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=jVTGEc6FO80A:10 a=h8qlLsB7_Goybcdr6IYA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=_jWeWtWqzZMYQQE3:21 a=5HgBHOx_j3BQGaK4:21 a=EcN1wJU1wUPO8NwiG7EA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130429134016.443620920@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 29 Apr 2013 09:39:41 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 2/2] ktest: Reset grub menu cache with different machines
References: <20130429133939.352003598@goodmis.org>
Content-Disposition: inline; filename=0002-ktest-Reset-grub-menu-cache-with-different-machines.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Different tests may use a different machine. In such cases, we need to
try to get the current grub menu index. If the same grub menu is used
for two different machines, it may not be at the same index on the
second machine. A search for the index must be performed again.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 7958cd4..0d7fd8b 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -73,6 +73,7 @@ my $ktest_config;
 my $version;
 my $have_version =3D 0;
 my $machine;
+my $last_machine;
 my $ssh_user;
 my $tmpdir;
 my $builddir;
@@ -1540,7 +1541,8 @@ sub run_scp_mod {
 sub get_grub2_index {
=20
     return if (defined($grub_number) && defined($last_grub_menu) &&
-	       $last_grub_menu eq $grub_menu);
+	       $last_grub_menu eq $grub_menu && defined($last_machine) &&
+	       $last_machine eq $machine);
=20
     doprint "Find grub2 menu ... ";
     $grub_number =3D -1;
@@ -1568,6 +1570,7 @@ sub get_grub2_index {
 	if (!$found);
     doprint "$grub_number\n";
     $last_grub_menu =3D $grub_menu;
+    $last_machine =3D $machine;
 }
=20
 sub get_grub_index {
@@ -1581,7 +1584,8 @@ sub get_grub_index {
 	return;
     }
     return if (defined($grub_number) && defined($last_grub_menu) &&
-	       $last_grub_menu eq $grub_menu);
+	       $last_grub_menu eq $grub_menu && defined($last_machine) &&
+	       $last_machine eq $machine);
=20
     doprint "Find grub menu ... ";
     $grub_number =3D -1;
@@ -1609,6 +1613,7 @@ sub get_grub_index {
 	if (!$found);
     doprint "$grub_number\n";
     $last_grub_menu =3D $grub_menu;
+    $last_machine =3D $machine;
 }
=20
 sub wait_for_input
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRfnhAAAoJEOdOSU1xswtMTu0H+wdrwDfQlTTLaKKYzjVxZ88c
H5W/aghMUfBk4cRdVQZQaT5wANFEuMTZFpXs7eYmqFf577MoOAwJnxBNFHy2cxok
PLwAn16zV1//VjDZS3cPp/6hTMlR8klMRmxqBSVQLDrcmYiQwurjo0RcKAbKWEY/
KKp46LIdXPBkAaXxVVCtuTLLaHOFqdW8bs5i+WgS/Xdp1n6DSYSTjgY/SJv11Nge
ZnSeXiVZ6i+Pnbf0vkqig248kV+wxi4ecZpbWKJEI/fJ99Xn6aYYqhc5tU1fhYMt
lxsPVzdEB5VFOTJwlnWkoMYh7jkAKJZ15XX7akWqvW5AlsCCHl+8UwCjZGCu17g=
=igIH
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
