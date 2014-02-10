Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796AbaBJKhM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 05:37:12 -0500
Received: from mail-ee0-f48.google.com ([74.125.83.48]:51615 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089AbaBJKhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 05:37:10 -0500
From: Michal Simek <michal.simek@xilinx.com>
To: linux-arm-kernel@lists.infradead.org
Cc: monstr@monstr.eu, Josh Cartwright <josh.cartwright@ni.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Rob Herring <robherring2@gmail.com>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: zynq: Add waituart implementation
Date: Mon, 10 Feb 2014 11:37:03 +0100
Message-Id: <13a04fc77bd93b2ad5a15a8967627a11fb7c8925.1392028615.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-22013-1392028623-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-22013-1392028623-0001

Add missing waituart implementation.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---

 arch/arm/include/debug/zynq.S | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/include/debug/zynq.S b/arch/arm/include/debug/zynq.S
index f9aa974..0b762fa 100644
--- a/arch/arm/include/debug/zynq.S
+++ b/arch/arm/include/debug/zynq.S
@@ -42,6 +42,9 @@
 		.endm

 		.macro	waituart,rd,rx
+1001:		ldr	\rd, [\rx, #UART_SR_OFFSET]
+		tst	\rd, #UART_SR_TXEMPTY
+		beq	1001b
 		.endm

 		.macro	busyuart,rd,rx
--
1.8.2.3


--=_mimegpg-monstr-desktop-22013-1392028623-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlL4q88ACgkQykllyylKDCGGVgCfQGfyw1vgX6obu/J3SXkZrgrs
JPUAoJjP4B6D0vtoT34zEtq+49chjtWa
=7RZ7
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-22013-1392028623-0001--
