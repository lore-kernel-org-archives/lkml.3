Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532Ab3A2VXi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 16:23:38 -0500
Received: from mail-bk0-f44.google.com ([209.85.214.44]:44279 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646Ab3A2VXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 16:23:36 -0500
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] ARM: dove: cleanup includes
Date: Tue, 29 Jan 2013 22:23:09 +0100
Message-Id: <1359494590-26005-1-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1355790269-10596-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1355790269-10596-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch cleans unneccessary includes and reorders the remaining
includes in common dove code.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Changelog:
[v2]
- restructure patches to first cleanup common.c includes [1/2]
  and then split legacy and DT specific code [2/2]
- removed v1 patch "[PATCH 3/3] ARM: Dove: add Cubox sdhci card
  detect gpio" that was taken independently

Cc: Russell King <linux@arm.linux.org.uk>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/mach-dove/common.c |   29 +++++++++--------------------
 1 file changed, 9 insertions(+), 20 deletions(-)

diff --git a/arch/arm/mach-dove/common.c b/arch/arm/mach-dove/common.c
index 89f4f99..be887feea 100644
--- a/arch/arm/mach-dove/common.c
+++ b/arch/arm/mach-dove/common.c
@@ -8,35 +8,24 @@
  * warranty of any kind, whether express or implied.
  */
 
-#include <linux/kernel.h>
-#include <linux/delay.h>
-#include <linux/init.h>
-#include <linux/platform_device.h>
-#include <linux/pci.h>
 #include <linux/clk-provider.h>
 #include <linux/clk/mvebu.h>
-#include <linux/ata_platform.h>
-#include <linux/gpio.h>
+#include <linux/dma-mapping.h>
+#include <linux/init.h>
 #include <linux/of.h>
 #include <linux/of_platform.h>
-#include <asm/page.h>
-#include <asm/setup.h>
-#include <asm/timex.h>
+#include <linux/platform_data/dma-mv_xor.h>
+#include <linux/platform_data/usb-ehci-orion.h>
+#include <linux/platform_device.h>
 #include <asm/hardware/cache-tauros2.h>
+#include <asm/mach/arch.h>
 #include <asm/mach/map.h>
 #include <asm/mach/time.h>
-#include <asm/mach/pci.h>
-#include <mach/dove.h>
-#include <mach/pm.h>
 #include <mach/bridge-regs.h>
-#include <asm/mach/arch.h>
-#include <linux/irq.h>
-#include <plat/time.h>
-#include <linux/platform_data/usb-ehci-orion.h>
-#include <linux/platform_data/dma-mv_xor.h>
-#include <plat/irq.h>
+#include <mach/pm.h>
 #include <plat/common.h>
-#include <plat/addr-map.h>
+#include <plat/irq.h>
+#include <plat/time.h>
 #include "common.h"
 
 /*****************************************************************************
-- 
1.7.10.4

