Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902Ab3FGO2Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 10:28:16 -0400
Received: from 19.mo1.mail-out.ovh.net ([178.32.97.206]:34910 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753333Ab3FGO2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 10:28:14 -0400
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Mike Turquette <mturquette@linaro.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Andrew Victor <linux@maxim.org.za>, Felipe Balbi <balbi@ti.com>
Cc: Boris BREZILLON <b.brezillon@overkiz.com>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
X-Ovh-Mailout: 178.32.228.1 (mo1.mail-out.ovh.net)
Subject: [RFC PATCH 01/50] ARM: at91: move at91_pmc.h to include/linux/clk/at91.h
Date: Fri,  7 Jun 2013 16:24:09 +0200
Message-Id: <1370615115-16979-2-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1370615115-16979-1-git-send-email-b.brezillon@overkiz.com>
References: <1370615115-16979-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 17110582361292715036
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrgedtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrgedtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves at91_pmc.h header from machine specific directory
(arch/arm/mach-at91/include/mach/at91_pmc.h) to clk include directory
(include/linux/clk/at91.h).
We need this to avoid reference to machine specific headers in clk
drivers.
 

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 arch/arm/mach-at91/at91rm9200.c                    |    2 +-
 arch/arm/mach-at91/at91sam9260.c                   |    2 +-
 arch/arm/mach-at91/at91sam9261.c                   |    2 +-
 arch/arm/mach-at91/at91sam9263.c                   |    2 +-
 arch/arm/mach-at91/at91sam9g45.c                   |    2 +-
 arch/arm/mach-at91/at91sam9n12.c                   |    2 +-
 arch/arm/mach-at91/at91sam9rl.c                    |    2 +-
 arch/arm/mach-at91/at91sam9x5.c                    |    2 +-
 arch/arm/mach-at91/clock.c                         |    2 +-
 arch/arm/mach-at91/pm.c                            |    2 +-
 arch/arm/mach-at91/pm_slowclock.S                  |    2 +-
 arch/arm/mach-at91/sama5d3.c                       |    2 +-
 arch/arm/mach-at91/setup.c                         |    2 +-
 drivers/usb/gadget/atmel_usba_udc.c                |    2 +-
 .../mach/at91_pmc.h => include/linux/clk/at91.h    |    2 +-
 15 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/arch/arm/mach-at91/at91rm9200.c b/arch/arm/mach-at91/at91rm9200.c
index d193a40..6ea6de7 100644
--- a/arch/arm/mach-at91/at91rm9200.c
+++ b/arch/arm/mach-at91/at91rm9200.c
@@ -11,13 +11,13 @@
  */
 
 #include <linux/module.h>
+#include <linux/clk/at91.h>
 
 #include <asm/irq.h>
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
 #include <asm/system_misc.h>
 #include <mach/at91rm9200.h>
-#include <mach/at91_pmc.h>
 #include <mach/at91_st.h>
 #include <mach/cpu.h>
 
diff --git a/arch/arm/mach-at91/at91sam9260.c b/arch/arm/mach-at91/at91sam9260.c
index a8ce245..df32768 100644
--- a/arch/arm/mach-at91/at91sam9260.c
+++ b/arch/arm/mach-at91/at91sam9260.c
@@ -11,6 +11,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/clk/at91.h>
 
 #include <asm/proc-fns.h>
 #include <asm/irq.h>
@@ -20,7 +21,6 @@
 #include <mach/cpu.h>
 #include <mach/at91_dbgu.h>
 #include <mach/at91sam9260.h>
-#include <mach/at91_pmc.h>
 
 #include "at91_aic.h"
 #include "at91_rstc.h"
diff --git a/arch/arm/mach-at91/at91sam9261.c b/arch/arm/mach-at91/at91sam9261.c
index 25efb5a..8a63b81 100644
--- a/arch/arm/mach-at91/at91sam9261.c
+++ b/arch/arm/mach-at91/at91sam9261.c
@@ -11,6 +11,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/clk/at91.h>
 
 #include <asm/proc-fns.h>
 #include <asm/irq.h>
@@ -19,7 +20,6 @@
 #include <asm/system_misc.h>
 #include <mach/cpu.h>
 #include <mach/at91sam9261.h>
-#include <mach/at91_pmc.h>
 
 #include "at91_aic.h"
 #include "at91_rstc.h"
diff --git a/arch/arm/mach-at91/at91sam9263.c b/arch/arm/mach-at91/at91sam9263.c
index f44ffd2..77b3c24 100644
--- a/arch/arm/mach-at91/at91sam9263.c
+++ b/arch/arm/mach-at91/at91sam9263.c
@@ -11,6 +11,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/clk/at91.h>
 
 #include <asm/proc-fns.h>
 #include <asm/irq.h>
@@ -18,7 +19,6 @@
 #include <asm/mach/map.h>
 #include <asm/system_misc.h>
 #include <mach/at91sam9263.h>
-#include <mach/at91_pmc.h>
 
 #include "at91_aic.h"
 #include "at91_rstc.h"
diff --git a/arch/arm/mach-at91/at91sam9g45.c b/arch/arm/mach-at91/at91sam9g45.c
index 8b7fce0..31a1304 100644
--- a/arch/arm/mach-at91/at91sam9g45.c
+++ b/arch/arm/mach-at91/at91sam9g45.c
@@ -12,13 +12,13 @@
 
 #include <linux/module.h>
 #include <linux/dma-mapping.h>
+#include <linux/clk/at91.h>
 
 #include <asm/irq.h>
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
 #include <asm/system_misc.h>
 #include <mach/at91sam9g45.h>
-#include <mach/at91_pmc.h>
 #include <mach/cpu.h>
 
 #include "at91_aic.h"
diff --git a/arch/arm/mach-at91/at91sam9n12.c b/arch/arm/mach-at91/at91sam9n12.c
index 13cdbcd..f9ff4d2 100644
--- a/arch/arm/mach-at91/at91sam9n12.c
+++ b/arch/arm/mach-at91/at91sam9n12.c
@@ -8,12 +8,12 @@
 
 #include <linux/module.h>
 #include <linux/dma-mapping.h>
+#include <linux/clk/at91.h>
 
 #include <asm/irq.h>
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
 #include <mach/at91sam9n12.h>
-#include <mach/at91_pmc.h>
 #include <mach/cpu.h>
 
 #include "board.h"
diff --git a/arch/arm/mach-at91/at91sam9rl.c b/arch/arm/mach-at91/at91sam9rl.c
index f77fae5..6fbda1a 100644
--- a/arch/arm/mach-at91/at91sam9rl.c
+++ b/arch/arm/mach-at91/at91sam9rl.c
@@ -10,6 +10,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/clk/at91.h>
 
 #include <asm/proc-fns.h>
 #include <asm/irq.h>
@@ -19,7 +20,6 @@
 #include <mach/cpu.h>
 #include <mach/at91_dbgu.h>
 #include <mach/at91sam9rl.h>
-#include <mach/at91_pmc.h>
 
 #include "at91_aic.h"
 #include "at91_rstc.h"
diff --git a/arch/arm/mach-at91/at91sam9x5.c b/arch/arm/mach-at91/at91sam9x5.c
index e631fec..83fc6b3 100644
--- a/arch/arm/mach-at91/at91sam9x5.c
+++ b/arch/arm/mach-at91/at91sam9x5.c
@@ -8,12 +8,12 @@
 
 #include <linux/module.h>
 #include <linux/dma-mapping.h>
+#include <linux/clk/at91.h>
 
 #include <asm/irq.h>
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
 #include <mach/at91sam9x5.h>
-#include <mach/at91_pmc.h>
 #include <mach/cpu.h>
 
 #include "board.h"
diff --git a/arch/arm/mach-at91/clock.c b/arch/arm/mach-at91/clock.c
index da84188..191e9e4 100644
--- a/arch/arm/mach-at91/clock.c
+++ b/arch/arm/mach-at91/clock.c
@@ -24,9 +24,9 @@
 #include <linux/clk.h>
 #include <linux/io.h>
 #include <linux/of_address.h>
+#include <linux/clk/at91.h>
 
 #include <mach/hardware.h>
-#include <mach/at91_pmc.h>
 #include <mach/cpu.h>
 
 #include <asm/proc-fns.h>
diff --git a/arch/arm/mach-at91/pm.c b/arch/arm/mach-at91/pm.c
index 530db30..d29702f 100644
--- a/arch/arm/mach-at91/pm.c
+++ b/arch/arm/mach-at91/pm.c
@@ -19,13 +19,13 @@
 #include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/io.h>
+#include <linux/clk/at91.h>
 
 #include <asm/irq.h>
 #include <linux/atomic.h>
 #include <asm/mach/time.h>
 #include <asm/mach/irq.h>
 
-#include <mach/at91_pmc.h>
 #include <mach/cpu.h>
 
 #include "at91_aic.h"
diff --git a/arch/arm/mach-at91/pm_slowclock.S b/arch/arm/mach-at91/pm_slowclock.S
index 098c28d..76387e0 100644
--- a/arch/arm/mach-at91/pm_slowclock.S
+++ b/arch/arm/mach-at91/pm_slowclock.S
@@ -13,8 +13,8 @@
  */
 
 #include <linux/linkage.h>
+#include <linux/clk/at91.h>
 #include <mach/hardware.h>
-#include <mach/at91_pmc.h>
 #include <mach/at91_ramc.h>
 
 
diff --git a/arch/arm/mach-at91/sama5d3.c b/arch/arm/mach-at91/sama5d3.c
index 4012797..32e0522 100644
--- a/arch/arm/mach-at91/sama5d3.c
+++ b/arch/arm/mach-at91/sama5d3.c
@@ -9,12 +9,12 @@
 
 #include <linux/module.h>
 #include <linux/dma-mapping.h>
+#include <linux/clk/at91.h>
 
 #include <asm/irq.h>
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
 #include <mach/sama5d3.h>
-#include <mach/at91_pmc.h>
 #include <mach/cpu.h>
 
 #include "soc.h"
diff --git a/arch/arm/mach-at91/setup.c b/arch/arm/mach-at91/setup.c
index e2f4bdd..7af1bbf 100644
--- a/arch/arm/mach-at91/setup.c
+++ b/arch/arm/mach-at91/setup.c
@@ -11,6 +11,7 @@
 #include <linux/pm.h>
 #include <linux/of_address.h>
 #include <linux/pinctrl/machine.h>
+#include <linux/clk/at91.h>
 
 #include <asm/system_misc.h>
 #include <asm/mach/map.h>
@@ -18,7 +19,6 @@
 #include <mach/hardware.h>
 #include <mach/cpu.h>
 #include <mach/at91_dbgu.h>
-#include <mach/at91_pmc.h>
 
 #include "at91_shdwc.h"
 #include "soc.h"
diff --git a/drivers/usb/gadget/atmel_usba_udc.c b/drivers/usb/gadget/atmel_usba_udc.c
index f2a970f..846a363 100644
--- a/drivers/usb/gadget/atmel_usba_udc.c
+++ b/drivers/usb/gadget/atmel_usba_udc.c
@@ -328,7 +328,7 @@ static int vbus_is_present(struct usba_udc *udc)
 
 #if defined(CONFIG_ARCH_AT91SAM9RL)
 
-#include <mach/at91_pmc.h>
+#include <linux/clk/at91.h>
 
 static void toggle_bias(int is_on)
 {
diff --git a/arch/arm/mach-at91/include/mach/at91_pmc.h b/include/linux/clk/at91.h
similarity index 99%
rename from arch/arm/mach-at91/include/mach/at91_pmc.h
rename to include/linux/clk/at91.h
index 31df120..58b1eba 100644
--- a/arch/arm/mach-at91/include/mach/at91_pmc.h
+++ b/include/linux/clk/at91.h
@@ -1,5 +1,5 @@
 /*
- * arch/arm/mach-at91/include/mach/at91_pmc.h
+ * include/linux/clk/at91.h
  *
  * Copyright (C) 2005 Ivan Kokshaysky
  * Copyright (C) SAN People
-- 
1.7.9.5

