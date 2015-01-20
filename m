Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752094AbbATImI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 03:42:08 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:53215 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976AbbATImG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 03:42:06 -0500
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org, monstr@monstr.eu
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org
Subject: [PATCH] microblaze: Remove *.dtb files in make clean
Date: Tue, 20 Jan 2015 09:41:55 +0100
Message-Id: <6554349f0d0f9a507ee55768fe476976a01d4746.1421743309.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-17084-1421743315-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-17084-1421743315-0001

dts/Makefile is called only for simpleImage target
which is causing that *.dtb are not removed.
This patch fix it.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---

 arch/microblaze/boot/Makefile     | 3 +--
 arch/microblaze/boot/dts/Makefile | 2 --
 2 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/microblaze/boot/Makefile b/arch/microblaze/boot/Makefile
index 8e211cc28dac..91d2068da1b9 100644
--- a/arch/microblaze/boot/Makefile
+++ b/arch/microblaze/boot/Makefile
@@ -34,5 +34,4 @@ $(obj)/simpleImage.%: vmlinux FORCE
 	$(call if_changed,strip)
 	@echo 'Kernel: $@ is ready' ' (#'`cat .version`')'

-
-clean-files += simpleImage.*.unstrip linux.bin.ub
+clean-files += simpleImage.*.unstrip linux.bin.ub dts/*.dtb
diff --git a/arch/microblaze/boot/dts/Makefile b/arch/microblaze/boot/dts/Makefile
index c4982d16e555..a3d2e42c3c97 100644
--- a/arch/microblaze/boot/dts/Makefile
+++ b/arch/microblaze/boot/dts/Makefile
@@ -16,5 +16,3 @@ quiet_cmd_cp = CP      $< $@$2

 # Rule to build device tree blobs
 DTC_FLAGS := -p 1024
-
-clean-files += *.dtb
--
1.8.2.3


--=_mimegpg-monstr-desktop-17084-1421743315-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlS+FNMACgkQykllyylKDCF4GwCeJ2XfJ8JZclnLrGyEYyKyrtmX
owcAoJPEyAMhn+3JUV/EJuKyFoLZWMJb
=/3vT
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-17084-1421743315-0001--
