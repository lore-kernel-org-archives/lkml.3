Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918AbaLAN1G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 08:27:06 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:36345 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753600AbaLANZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 08:25:08 -0500
From: Michal Simek <michal.simek@xilinx.com>
To: linux-arm-kernel@lists.infradead.org,
        Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>
Cc: monstr@monstr.eu, Josh Cartwright <josh.cartwright@ni.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Rob Herring <robherring2@gmail.com>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH v5 2/7] ARM: zynq: Extract slcr related functions out of common.h
Date: Mon,  1 Dec 2014 14:24:53 +0100
Message-Id: <c3392f6122c113c6bd36f3c8eae4065ffdd240ce.1417440250.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <cover.1417440250.git.michal.simek@xilinx.com>
References: <cover.1417440250.git.michal.simek@xilinx.com>
In-Reply-To: <cover.1417440250.git.michal.simek@xilinx.com>
References: <cover.1417440250.git.michal.simek@xilinx.com>
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-3276-1417440304-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-3276-1417440304-0001

Create topic headers not to share all functions.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---

Changes in v5: None
Changes in v4:
- New patch in this series

Changes in v3: None
Changes in v2: None

 arch/arm/mach-zynq/common.c  |  1 +
 arch/arm/mach-zynq/common.h  |  9 ---------
 arch/arm/mach-zynq/platsmp.c |  1 +
 arch/arm/mach-zynq/slcr.c    |  1 +
 arch/arm/mach-zynq/slcr.h    | 29 +++++++++++++++++++++++++++++
 5 files changed, 32 insertions(+), 9 deletions(-)
 create mode 100644 arch/arm/mach-zynq/slcr.h

diff --git a/arch/arm/mach-zynq/common.c b/arch/arm/mach-zynq/common.c
index 45cb778b344d..947e72b79496 100644
--- a/arch/arm/mach-zynq/common.c
+++ b/arch/arm/mach-zynq/common.c
@@ -43,6 +43,7 @@
 #include <asm/hardware/cache-l2x0.h>

 #include "common.h"
+#include "slcr.h"
 #include "smp.h"

 #define ZYNQ_DEVCFG_MCTRL		0x80
diff --git a/arch/arm/mach-zynq/common.h b/arch/arm/mach-zynq/common.h
index 0667cc79f179..5557de83058a 100644
--- a/arch/arm/mach-zynq/common.h
+++ b/arch/arm/mach-zynq/common.h
@@ -17,15 +17,6 @@
 #ifndef __MACH_ZYNQ_COMMON_H__
 #define __MACH_ZYNQ_COMMON_H__

-extern int zynq_slcr_init(void);
-extern int zynq_early_slcr_init(void);
-extern void zynq_slcr_system_reset(void);
-extern void zynq_slcr_cpu_stop(int cpu);
-extern void zynq_slcr_cpu_start(int cpu);
-extern bool zynq_slcr_cpu_state_read(int cpu);
-extern void zynq_slcr_cpu_state_write(int cpu, bool die);
-extern u32 zynq_slcr_get_device_id(void);
-
 extern void __iomem *zynq_scu_base;

 void zynq_pm_late_init(void);
diff --git a/arch/arm/mach-zynq/platsmp.c b/arch/arm/mach-zynq/platsmp.c
index 5aa6b9ee95fc..717ba2b922b1 100644
--- a/arch/arm/mach-zynq/platsmp.c
+++ b/arch/arm/mach-zynq/platsmp.c
@@ -26,6 +26,7 @@
 #include <asm/smp_scu.h>
 #include <linux/irqchip/arm-gic.h>
 #include "common.h"
+#include "slcr.h"
 #include "smp.h"

 /*
diff --git a/arch/arm/mach-zynq/slcr.c b/arch/arm/mach-zynq/slcr.c
index d4cb50cf97c0..40f8d7420334 100644
--- a/arch/arm/mach-zynq/slcr.c
+++ b/arch/arm/mach-zynq/slcr.c
@@ -20,6 +20,7 @@
 #include <linux/regmap.h>
 #include <linux/clk/zynq.h>
 #include "common.h"
+#include "slcr.h"

 /* register offsets */
 #define SLCR_UNLOCK_OFFSET		0x8   /* SCLR unlock register */
diff --git a/arch/arm/mach-zynq/slcr.h b/arch/arm/mach-zynq/slcr.h
new file mode 100644
index 000000000000..7b4edab666ee
--- /dev/null
+++ b/arch/arm/mach-zynq/slcr.h
@@ -0,0 +1,29 @@
+/*
+ * This file contains common function prototypes to avoid externs
+ * in the c files.
+ *
+ * Copyright (C) 2014 Xilinx
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __MACH_ZYNQ_SLCR_H__
+#define __MACH_ZYNQ_SLCR_H__
+
+extern int zynq_slcr_init(void);
+extern int zynq_early_slcr_init(void);
+extern void zynq_slcr_system_reset(void);
+extern void zynq_slcr_cpu_stop(int cpu);
+extern void zynq_slcr_cpu_start(int cpu);
+extern bool zynq_slcr_cpu_state_read(int cpu);
+extern void zynq_slcr_cpu_state_write(int cpu, bool die);
+extern u32 zynq_slcr_get_device_id(void);
+
+#endif
--
1.8.2.3


--=_mimegpg-monstr-desktop-3276-1417440304-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlR8bDAACgkQykllyylKDCH2BwCgnLJBwbCmF0BB0PRzNLQddnnH
BrsAn3W+RcejvEaVlgNCxN8twVGi9lc2
=Nuk1
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-3276-1417440304-0001--
