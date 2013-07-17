Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755418Ab3GQNiS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 09:38:18 -0400
Received: from 19.mo1.mail-out.ovh.net ([178.32.97.206]:55104 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754900Ab3GQNiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 09:38:16 -0400
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Mike Turquette <mturquette@linaro.org>,
        Andrew Victor <linux@maxim.org.za>,
        Russell King <linux@arm.linux.org.uk>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Josh Wu <josh.wu@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, Boris BREZILLON <b.brezillon@overkiz.com>
X-Ovh-Mailout: 178.32.228.1 (mo1.mail-out.ovh.net)
Subject: [PATCH v2 01/42] ARM: at91: move at91_pmc.h to include/linux/clk/at91.h
Date: Wed, 17 Jul 2013 15:37:27 +0200
Message-Id: <1374068247-13574-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374068069-13496-1-git-send-email-b.brezillon@overkiz.com>
References: <1374068069-13496-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 11385099858862110828
X-Ovh-Remote: 78.236.240.82 (cha74-5-78-236-240-82.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeijedrvdegucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeijedrvdegucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
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
 rename arch/arm/mach-at91/include/mach/at91_pmc.h => include/linux/clk/at91.h (99%)

diff --git a/arch/arm/mach-at91/at91rm9200.c b/arch/arm/mach-at91/at91rm9200.c
index 4aad93d..8de5b02 100644
--- a/arch/arm/mach-at91/at91rm9200.c
+++ b/arch/arm/mach-at91/at91rm9200.c
@@ -12,13 +12,13 @@
 
 #include <linux/module.h>
 #include <linux/reboot.h>
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
index 5de6074..db9d89a 100644
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
index 0e07932..a4123bd 100644
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
index 6ce7d18..e0a1a68 100644
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
index 474ee04..29ba2ca 100644
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
index c7d670d..c270503 100644
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
index d4ec0d9..2694bd1 100644
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
index 2abee66..9fdea07 100644
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
index 6b2630a..cc263d0 100644
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
index 15afb5d..de425e0 100644
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
index b17fbcf..de3c519 100644
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
index f018017..a678537 100644
--- a/drivers/usb/gadget/atmel_usba_udc.c
+++ b/drivers/usb/gadget/atmel_usba_udc.c
@@ -326,7 +326,7 @@ static int vbus_is_present(struct usba_udc *udc)
 
 #if defined(CONFIG_ARCH_AT91SAM9RL)
 
-#include <mach/at91_pmc.h>
+#include <linux/clk/at91.h>
 
 static void toggle_bias(int is_on)
 {
diff --git a/arch/arm/mach-at91/include/mach/at91_pmc.h b/include/linux/clk/at91.h
similarity index 99%
rename from arch/arm/mach-at91/include/mach/at91_pmc.h
rename to include/linux/clk/at91.h
index c604cc6..0ce9586 100644
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

