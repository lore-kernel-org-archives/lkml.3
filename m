Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758291Ab3D2NkZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 09:40:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3898 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757559Ab3D2NkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 09:40:17 -0400
X-Authority-Analysis: v=2.0 cv=GtrACzJC c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=ELjXsXzyGrsA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=fhmIoiB-me0A:10 a=yIO2ty_LV7bzYZ279TkA:9 a=QEXdDO2ut3YA:10 a=Gq9PjJF5URkA:10 a=jeBq3FmKZ4MA:10 a=iqsOIytiB-36zrqd:21 a=iIiu4z75JhdQDBPQ:21 a=O6DwpKgAWj3KIXSsWWEA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130429134016.228713678@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 29 Apr 2013 09:39:40 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 1/2] ktest: Allow tests to use different GRUB_MENUs
References: <20130429133939.352003598@goodmis.org>
Content-Disposition: inline; filename=0001-ktest-Allow-tests-to-use-different-GRUB_MENUs.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

To save connecting and searching for a given grub menu for each test,
ktest.pl will cache the grub number it found. The problem is that
different tests might use a different grub menu, but ktest.pl will
ignore it.

Instead, have ktest.pl check if the grub menu it used to cache the
content is the same as when it grabbed the menu. If not, grab it again,
otherwise just return the cached value.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 4e67d52..7958cd4 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -108,6 +108,7 @@ my $scp_to_target;
 my $scp_to_target_install;
 my $power_off;
 my $grub_menu;
+my $last_grub_menu;
 my $grub_file;
 my $grub_number;
 my $grub_reboot;
@@ -1538,7 +1539,8 @@ sub run_scp_mod {
=20
 sub get_grub2_index {
=20
-    return if (defined($grub_number));
+    return if (defined($grub_number) && defined($last_grub_menu) &&
+	       $last_grub_menu eq $grub_menu);
=20
     doprint "Find grub2 menu ... ";
     $grub_number =3D -1;
@@ -1565,6 +1567,7 @@ sub get_grub2_index {
     die "Could not find '$grub_menu' in $grub_file on $machine"
 	if (!$found);
     doprint "$grub_number\n";
+    $last_grub_menu =3D $grub_menu;
 }
=20
 sub get_grub_index {
@@ -1577,7 +1580,8 @@ sub get_grub_index {
     if ($reboot_type ne "grub") {
 	return;
     }
-    return if (defined($grub_number));
+    return if (defined($grub_number) && defined($last_grub_menu) &&
+	       $last_grub_menu eq $grub_menu);
=20
     doprint "Find grub menu ... ";
     $grub_number =3D -1;
@@ -1604,6 +1608,7 @@ sub get_grub_index {
     die "Could not find '$grub_menu' in /boot/grub/menu on $machine"
 	if (!$found);
     doprint "$grub_number\n";
+    $last_grub_menu =3D $grub_menu;
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

iQEcBAABAgAGBQJRfnhAAAoJEOdOSU1xswtMWMUIAMFAfiMVxkuA9BY9H4iGlHWw
hj3bokCtlznNc8RSmg+Iw8Vj/7AZy4NYQvrNn5W0vN0i7Z1XQyyWRp5uMI2keht9
T9dMVNkEiS5S1qtQNEHuOUOZdEGd+L8OcpQ4LPpEhFYifF6EpsT4QrtiA3rt9nGl
BILFmzqwA4/54xuu7RFfmOIRXMwIfFN4T/DzFuGP0KI7yurgaT8417zhnZ3SwaR7
gsIoPVZk8IMt2Zk97R6zvZpB6dokmXQ14XTFUNRKfpUuZgpro7mx37fCjEwmqU/T
LiV/QgIo93BeqPPaMe0cPg23UguqudPVU35xkAvf69XzT8OsHwB0V5nPJMtIeyI=
=oVgT
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
