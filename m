Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753634AbaLANZI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 08:25:08 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:44496 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753584AbaLANZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 08:25:05 -0500
From: Michal Simek <michal.simek@xilinx.com>
To: linux-arm-kernel@lists.infradead.org,
        Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>
Cc: monstr@monstr.eu, Josh Cartwright <josh.cartwright@ni.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Rob Herring <robherring2@gmail.com>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH v5 1/7] ARM: zynq: Extract smp related functions out of common.h
Date: Mon,  1 Dec 2014 14:24:52 +0100
Message-Id: <7f692ba291115cb229eac6082cadbcf68a05c205.1417440250.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <cover.1417440250.git.michal.simek@xilinx.com>
References: <cover.1417440250.git.michal.simek@xilinx.com>
In-Reply-To: <cover.1417440250.git.michal.simek@xilinx.com>
References: <cover.1417440250.git.michal.simek@xilinx.com>
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-3267-1417440301-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-3267-1417440301-0001

Create topic headers not to share all functions.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---

Changes in v5: None
Changes in v4:
- New patch in this series

Changes in v3: None
Changes in v2: None

 arch/arm/mach-zynq/common.c  |  1 +
 arch/arm/mach-zynq/common.h  | 10 ----------
 arch/arm/mach-zynq/platsmp.c |  1 +
 arch/arm/mach-zynq/smp.h     | 30 ++++++++++++++++++++++++++++++
 4 files changed, 32 insertions(+), 10 deletions(-)
 create mode 100644 arch/arm/mach-zynq/smp.h

diff --git a/arch/arm/mach-zynq/common.c b/arch/arm/mach-zynq/common.c
index 26f92c28d22b..45cb778b344d 100644
--- a/arch/arm/mach-zynq/common.c
+++ b/arch/arm/mach-zynq/common.c
@@ -43,6 +43,7 @@
 #include <asm/hardware/cache-l2x0.h>

 #include "common.h"
+#include "smp.h"

 #define ZYNQ_DEVCFG_MCTRL		0x80
 #define ZYNQ_DEVCFG_PS_VERSION_SHIFT	28
diff --git a/arch/arm/mach-zynq/common.h b/arch/arm/mach-zynq/common.h
index 382c60e9aa16..0667cc79f179 100644
--- a/arch/arm/mach-zynq/common.h
+++ b/arch/arm/mach-zynq/common.h
@@ -17,8 +17,6 @@
 #ifndef __MACH_ZYNQ_COMMON_H__
 #define __MACH_ZYNQ_COMMON_H__

-void zynq_secondary_startup(void);
-
 extern int zynq_slcr_init(void);
 extern int zynq_early_slcr_init(void);
 extern void zynq_slcr_system_reset(void);
@@ -28,14 +26,6 @@ extern bool zynq_slcr_cpu_state_read(int cpu);
 extern void zynq_slcr_cpu_state_write(int cpu, bool die);
 extern u32 zynq_slcr_get_device_id(void);

-#ifdef CONFIG_SMP
-extern char zynq_secondary_trampoline;
-extern char zynq_secondary_trampoline_jump;
-extern char zynq_secondary_trampoline_end;
-extern int zynq_cpun_start(u32 address, int cpu);
-extern struct smp_operations zynq_smp_ops __initdata;
-#endif
-
 extern void __iomem *zynq_scu_base;

 void zynq_pm_late_init(void);
diff --git a/arch/arm/mach-zynq/platsmp.c b/arch/arm/mach-zynq/platsmp.c
index 52d768ff7857..5aa6b9ee95fc 100644
--- a/arch/arm/mach-zynq/platsmp.c
+++ b/arch/arm/mach-zynq/platsmp.c
@@ -26,6 +26,7 @@
 #include <asm/smp_scu.h>
 #include <linux/irqchip/arm-gic.h>
 #include "common.h"
+#include "smp.h"

 /*
  * Store number of cores in the system
diff --git a/arch/arm/mach-zynq/smp.h b/arch/arm/mach-zynq/smp.h
new file mode 100644
index 000000000000..0277540e352c
--- /dev/null
+++ b/arch/arm/mach-zynq/smp.h
@@ -0,0 +1,30 @@
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
+#ifndef __MACH_ZYNQ_SMP_H__
+#define __MACH_ZYNQ_SMP_H__
+
+void zynq_secondary_startup(void);
+
+#ifdef CONFIG_SMP
+extern char zynq_secondary_trampoline;
+extern char zynq_secondary_trampoline_jump;
+extern char zynq_secondary_trampoline_end;
+extern int zynq_cpun_start(u32 address, int cpu);
+extern struct smp_operations zynq_smp_ops __initdata;
+#endif
+
+#endif
--
1.8.2.3


--=_mimegpg-monstr-desktop-3267-1417440301-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlR8bC0ACgkQykllyylKDCEmUQCdF4xYcOIuox1nsqJyAlmRck/m
fjkAoJRrTe2lNRi5m0bpuPsMjRVgtPf6
=RxrI
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-3267-1417440301-0001--
