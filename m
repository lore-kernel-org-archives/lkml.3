Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755106AbaAFOim (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 09:38:42 -0500
Received: from mail-ee0-f42.google.com ([74.125.83.42]:59731 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754923AbaAFOhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 09:37:43 -0500
From: Michal Simek <michal.simek@xilinx.com>
To: linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>
Cc: monstr@monstr.eu, Josh Cartwright <josh.cartwright@ni.com>,
        Rob Herring <robherring2@gmail.com>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH 5/7] ARM: zynq: Make zynq_slcr_base static
Date: Mon,  6 Jan 2014 15:36:41 +0100
Message-Id: <a03727927a64135bb9bc61ddfe07b7f7f028de72.1389018985.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <cover.1389018985.git.michal.simek@xilinx.com>
References: <cover.1389018985.git.michal.simek@xilinx.com>
In-Reply-To: <cover.1389018985.git.michal.simek@xilinx.com>
References: <cover.1389018985.git.michal.simek@xilinx.com>
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-32364-1389019057-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-32364-1389019057-0001

From: Steffen Trumtrar <s.trumtrar@pengutronix.de>

The pointer doesn't need to be passed around any more.
Make it static.

Signed-off-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---
 arch/arm/mach-zynq/common.h | 1 -
 arch/arm/mach-zynq/slcr.c   | 2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm/mach-zynq/common.h b/arch/arm/mach-zynq/common.h
index 1548b85..b097844 100644
--- a/arch/arm/mach-zynq/common.h
+++ b/arch/arm/mach-zynq/common.h
@@ -34,7 +34,6 @@ extern int zynq_cpun_start(u32 address, int cpu);
 extern struct smp_operations zynq_smp_ops __initdata;
 #endif

-extern void __iomem *zynq_slcr_base;
 extern void __iomem *zynq_scu_base;

 /* Hotplug */
diff --git a/arch/arm/mach-zynq/slcr.c b/arch/arm/mach-zynq/slcr.c
index 2891dcf..a679dff 100644
--- a/arch/arm/mach-zynq/slcr.c
+++ b/arch/arm/mach-zynq/slcr.c
@@ -31,7 +31,7 @@
 #define SLCR_A9_CPU_CLKSTOP		0x10
 #define SLCR_A9_CPU_RST			0x1

-void __iomem *zynq_slcr_base;
+static void __iomem *zynq_slcr_base;
 static struct regmap *zynq_slcr_regmap;

 /**
--
1.8.2.3


--=_mimegpg-monstr-desktop-32364-1389019057-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlLKv7EACgkQykllyylKDCH+HgCfVKm4qNY85ivdm7U87W7SPqse
DXcAn3xwjKQVj+lTs3/Al90MUlct/qaE
=t9iD
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-32364-1389019057-0001--
