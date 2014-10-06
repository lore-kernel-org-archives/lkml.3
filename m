Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752348AbaJFLom (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 07:44:42 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:52861 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795AbaJFLol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 07:44:41 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-arm-kernel@lists.infradead.org
Cc: monstr@monstr.eu, Josh Cartwright <josh.cartwright@ni.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Rob Herring <robherring2@gmail.com>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] ARM: zynq: Move common.h to generic location
Date: Mon,  6 Oct 2014 13:44:24 +0200
Message-Id: <565908c2d70764e281d6a9b28d9599cea87823a3.1412595859.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-12307-1412595866-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-12307-1412595866-0001

include/soc/zynq/ is the right location for this header
to be able to share information from this header with other
drivers which require it.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---

 arch/arm/mach-zynq/common.c                       | 2 +-
 arch/arm/mach-zynq/hotplug.c                      | 2 +-
 arch/arm/mach-zynq/platsmp.c                      | 2 +-
 arch/arm/mach-zynq/slcr.c                         | 2 +-
 {arch/arm/mach-zynq => include/soc/zynq}/common.h | 0
 5 files changed, 4 insertions(+), 4 deletions(-)
 rename {arch/arm/mach-zynq => include/soc/zynq}/common.h (100%)

diff --git a/arch/arm/mach-zynq/common.c b/arch/arm/mach-zynq/common.c
index 31a6fa40ba37..ead1935aac79 100644
--- a/arch/arm/mach-zynq/common.c
+++ b/arch/arm/mach-zynq/common.c
@@ -42,7 +42,7 @@
 #include <asm/system_info.h>
 #include <asm/hardware/cache-l2x0.h>

-#include "common.h"
+#include <soc/zynq/common.h>

 #define ZYNQ_DEVCFG_MCTRL		0x80
 #define ZYNQ_DEVCFG_PS_VERSION_SHIFT	28
diff --git a/arch/arm/mach-zynq/hotplug.c b/arch/arm/mach-zynq/hotplug.c
index 5052c70326e4..95d74f68032a 100644
--- a/arch/arm/mach-zynq/hotplug.c
+++ b/arch/arm/mach-zynq/hotplug.c
@@ -16,7 +16,7 @@

 #include <asm/cacheflush.h>
 #include <asm/cp15.h>
-#include "common.h"
+#include <soc/zynq/common.h>

 static inline void zynq_cpu_enter_lowpower(void)
 {
diff --git a/arch/arm/mach-zynq/platsmp.c b/arch/arm/mach-zynq/platsmp.c
index abc82ef085c1..56581ccd7c14 100644
--- a/arch/arm/mach-zynq/platsmp.c
+++ b/arch/arm/mach-zynq/platsmp.c
@@ -25,7 +25,7 @@
 #include <asm/cacheflush.h>
 #include <asm/smp_scu.h>
 #include <linux/irqchip/arm-gic.h>
-#include "common.h"
+#include <soc/zynq/common.h>

 /*
  * Store number of cores in the system
diff --git a/arch/arm/mach-zynq/slcr.c b/arch/arm/mach-zynq/slcr.c
index c43a2d16e223..cb7c46165728 100644
--- a/arch/arm/mach-zynq/slcr.c
+++ b/arch/arm/mach-zynq/slcr.c
@@ -19,7 +19,7 @@
 #include <linux/of_address.h>
 #include <linux/regmap.h>
 #include <linux/clk/zynq.h>
-#include "common.h"
+#include <soc/zynq/common.h>

 /* register offsets */
 #define SLCR_UNLOCK_OFFSET		0x8   /* SCLR unlock register */
diff --git a/arch/arm/mach-zynq/common.h b/include/soc/zynq/common.h
similarity index 100%
rename from arch/arm/mach-zynq/common.h
rename to include/soc/zynq/common.h
--
1.8.2.3


--=_mimegpg-monstr-desktop-12307-1412595866-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlQygJoACgkQykllyylKDCH2PwCgnPA7hv3XLc/HmJw2jqheOMEW
IYsAoJNi5PW3c/OrRsjPFtS5CqSRGQ76
=5I43
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-12307-1412595866-0001--
