Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752147AbaJTNZz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 09:25:55 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:43478 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949AbaJTNZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 09:25:45 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-arm-kernel@lists.infradead.org
Cc: monstr@monstr.eu, Josh Cartwright <josh.cartwright@ni.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Rob Herring <robherring2@gmail.com>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/3] ARM: zynq: Move common.h to generic location
Date: Mon, 20 Oct 2014 15:25:31 +0200
Message-Id: <742a19eb987f3f99b42ba4b7e7ebc27bf19d7d72.1413811526.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-23005-1413811533-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-23005-1413811533-0001

include/soc/zynq/ is the right location for this header
to be able to share information from this header with other
drivers which require it.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---

Changes in v2:
- Update pm.c added in 3.17 too - Soren pointed on it

 arch/arm/mach-zynq/common.c                       |  2 +-
 arch/arm/mach-zynq/hotplug.c                      | 14 --------------
 arch/arm/mach-zynq/platsmp.c                      |  2 +-
 arch/arm/mach-zynq/pm.c                           |  2 +-
 arch/arm/mach-zynq/slcr.c                         |  2 +-
 {arch/arm/mach-zynq => include/soc/zynq}/common.h |  0
 6 files changed, 4 insertions(+), 18 deletions(-)
 delete mode 100644 arch/arm/mach-zynq/hotplug.c
 rename {arch/arm/mach-zynq => include/soc/zynq}/common.h (100%)

diff --git a/arch/arm/mach-zynq/common.c b/arch/arm/mach-zynq/common.c
index 26f92c28d22b..c488eb264072 100644
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
deleted file mode 100644
index b685c89f11e4..000000000000
--- a/arch/arm/mach-zynq/hotplug.c
+++ /dev/null
@@ -1,14 +0,0 @@
-/*
- * Copyright (C) 2012-2013 Xilinx
- *
- * based on linux/arch/arm/mach-realview/hotplug.c
- *
- * Copyright (C) 2002 ARM Ltd.
- * All Rights Reserved
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-#include <asm/proc-fns.h>
-
diff --git a/arch/arm/mach-zynq/platsmp.c b/arch/arm/mach-zynq/platsmp.c
index 52d768ff7857..bfb1315b04ea 100644
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
diff --git a/arch/arm/mach-zynq/pm.c b/arch/arm/mach-zynq/pm.c
index 911fcf865be8..31df24ce1ce5 100644
--- a/arch/arm/mach-zynq/pm.c
+++ b/arch/arm/mach-zynq/pm.c
@@ -22,7 +22,7 @@
 #include <linux/io.h>
 #include <linux/of_address.h>
 #include <linux/of_device.h>
-#include "common.h"
+#include <soc/zynq/common.h>

 /* register offsets */
 #define DDRC_CTRL_REG1_OFFS		0x60
diff --git a/arch/arm/mach-zynq/slcr.c b/arch/arm/mach-zynq/slcr.c
index d4cb50cf97c0..22d9d54d2333 100644
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


--=_mimegpg-monstr-desktop-23005-1413811533-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlRFDU0ACgkQykllyylKDCFyAgCbBfH/494BIT9LqdQlKakyZYSs
Sz8An1lNMRfCGux0uPVqC5FmdGn1KX9E
=Xy/f
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-23005-1413811533-0001--
