Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268AbaH2OM1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 10:12:27 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:47484 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528AbaH2OMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 10:12:25 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-arm-kernel@lists.infradead.org
Cc: monstr@monstr.eu, Josh Cartwright <josh.cartwright@ni.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Rob Herring <robherring2@gmail.com>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: zynq: Remove useless L2C AUX setting
Date: Fri, 29 Aug 2014 16:12:12 +0200
Message-Id: <66d0f1762b6b76559794d86e85d31398c337d109.1409321528.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-17731-1409321532-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-17731-1409321532-0001

AUX setting has no effect that's why remove it.

Warning log:
L2C: platform provided aux values match the hardware, so
have no effect.  Please remove them.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---

 arch/arm/mach-zynq/common.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-zynq/common.c b/arch/arm/mach-zynq/common.c
index 31a6fa40ba37..151bcbcb0f67 100644
--- a/arch/arm/mach-zynq/common.c
+++ b/arch/arm/mach-zynq/common.c
@@ -198,8 +198,8 @@ static const char * const zynq_dt_match[] = {

 DT_MACHINE_START(XILINX_EP107, "Xilinx Zynq Platform")
 	/* 64KB way size, 8-way associativity, parity disabled */
-	.l2c_aux_val	= 0x02000000,
-	.l2c_aux_mask	= 0xf0ffffff,
+	.l2c_aux_val	= 0x00000000,
+	.l2c_aux_mask	= 0xffffffff,
 	.smp		= smp_ops(zynq_smp_ops),
 	.map_io		= zynq_map_io,
 	.init_irq	= zynq_irq_init,
--
1.8.2.3


--=_mimegpg-monstr-desktop-17731-1409321532-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlQAijwACgkQykllyylKDCHrbACeJp2cDrwZFa7Hnv2kkFvExdz3
I0IAn0bLNR8xWVEHxQWE3lEI84FtLKNe
=jnmm
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-17731-1409321532-0001--
