Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759664Ab3EWQPD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 12:15:03 -0400
Received: from 8.mo2.mail-out.ovh.net ([188.165.52.147]:36390 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759497Ab3EWQOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 12:14:47 -0400
X-Greylist: delayed 900 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 May 2013 12:14:46 EDT
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Andrew Victor <linux@maxim.org.za>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
X-Ovh-Mailout: 178.32.228.2 (mo2.mail-out.ovh.net)
Subject: [PATCH v2 2/3] ARM: at91: move at91 aic driver to drivers/irqchip
Date: Thu, 23 May 2013 17:48:54 +0200
Message-Id: <1369324135-31211-3-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1369324135-31211-1-git-send-email-b.brezillon@overkiz.com>
References: <1369324135-31211-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 4256464598644077644
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrtddtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrtddtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move arch/arm/mach-at91/irq.c to drivers/irqchip/irq-at91.c.
Move arch/arm/mach-at91/at91_aic.h to include/linux/irqchip/at91.h to
avoid reference to machine specific hearder files.
Remove __ASSEMBLY__ section in header file (at91_aic_base is only used
in .c files).

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 arch/arm/mach-at91/Makefile                        |    2 +-
 arch/arm/mach-at91/at91rm9200.c                    |    2 +-
 arch/arm/mach-at91/at91sam9260.c                   |    2 +-
 arch/arm/mach-at91/at91sam9261.c                   |    2 +-
 arch/arm/mach-at91/at91sam9263.c                   |    2 +-
 arch/arm/mach-at91/at91sam9g45.c                   |    2 +-
 arch/arm/mach-at91/at91sam9rl.c                    |    2 +-
 arch/arm/mach-at91/at91x40.c                       |    2 +-
 arch/arm/mach-at91/board-1arm.c                    |    2 +-
 arch/arm/mach-at91/board-afeb-9260v1.c             |    2 +-
 arch/arm/mach-at91/board-cam60.c                   |    2 +-
 arch/arm/mach-at91/board-carmeva.c                 |    2 +-
 arch/arm/mach-at91/board-cpu9krea.c                |    2 +-
 arch/arm/mach-at91/board-cpuat91.c                 |    2 +-
 arch/arm/mach-at91/board-csb337.c                  |    2 +-
 arch/arm/mach-at91/board-csb637.c                  |    2 +-
 arch/arm/mach-at91/board-dt-rm9200.c               |    2 +-
 arch/arm/mach-at91/board-dt-sam9.c                 |    2 +-
 arch/arm/mach-at91/board-dt-sama5.c                |    2 +-
 arch/arm/mach-at91/board-eb01.c                    |    2 +-
 arch/arm/mach-at91/board-eb9200.c                  |    2 +-
 arch/arm/mach-at91/board-ecbat91.c                 |    2 +-
 arch/arm/mach-at91/board-eco920.c                  |    2 +-
 arch/arm/mach-at91/board-flexibity.c               |    2 +-
 arch/arm/mach-at91/board-foxg20.c                  |    2 +-
 arch/arm/mach-at91/board-gsia18s.c                 |    2 +-
 arch/arm/mach-at91/board-kafa.c                    |    2 +-
 arch/arm/mach-at91/board-kb9202.c                  |    2 +-
 arch/arm/mach-at91/board-pcontrol-g20.c            |    2 +-
 arch/arm/mach-at91/board-picotux200.c              |    2 +-
 arch/arm/mach-at91/board-qil-a9260.c               |    2 +-
 arch/arm/mach-at91/board-rm9200dk.c                |    2 +-
 arch/arm/mach-at91/board-rm9200ek.c                |    2 +-
 arch/arm/mach-at91/board-rsi-ews.c                 |    2 +-
 arch/arm/mach-at91/board-sam9-l9260.c              |    2 +-
 arch/arm/mach-at91/board-sam9260ek.c               |    2 +-
 arch/arm/mach-at91/board-sam9261ek.c               |    2 +-
 arch/arm/mach-at91/board-sam9263ek.c               |    2 +-
 arch/arm/mach-at91/board-sam9g20ek.c               |    2 +-
 arch/arm/mach-at91/board-sam9m10g45ek.c            |    2 +-
 arch/arm/mach-at91/board-sam9rlek.c                |    2 +-
 arch/arm/mach-at91/board-snapper9260.c             |    2 +-
 arch/arm/mach-at91/board-stamp9g20.c               |    2 +-
 arch/arm/mach-at91/board-usb-a926x.c               |    2 +-
 arch/arm/mach-at91/board-yl-9200.c                 |    2 +-
 arch/arm/mach-at91/pm.c                            |    2 +-
 drivers/irqchip/Makefile                           |    1 +
 .../mach-at91/irq.c => drivers/irqchip/irq-at91.c  |    4 ++--
 .../at91_aic.h => include/linux/irqchip/at91.h     |    6 +-----
 49 files changed, 50 insertions(+), 53 deletions(-)

diff --git a/arch/arm/mach-at91/Makefile b/arch/arm/mach-at91/Makefile
index 788562d..5333701 100644
--- a/arch/arm/mach-at91/Makefile
+++ b/arch/arm/mach-at91/Makefile
@@ -2,7 +2,7 @@
 # Makefile for the linux kernel.
 #
 
-obj-y		:= irq.o gpio.o setup.o
+obj-y		:= gpio.o setup.o
 obj-m		:=
 obj-n		:=
 obj-		:=
diff --git a/arch/arm/mach-at91/at91rm9200.c b/arch/arm/mach-at91/at91rm9200.c
index d193a40..39e7845 100644
--- a/arch/arm/mach-at91/at91rm9200.c
+++ b/arch/arm/mach-at91/at91rm9200.c
@@ -11,6 +11,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/irqchip/at91.h>
 
 #include <asm/irq.h>
 #include <asm/mach/arch.h>
@@ -21,7 +22,6 @@
 #include <mach/at91_st.h>
 #include <mach/cpu.h>
 
-#include "at91_aic.h"
 #include "soc.h"
 #include "generic.h"
 #include "clock.h"
diff --git a/arch/arm/mach-at91/at91sam9260.c b/arch/arm/mach-at91/at91sam9260.c
index a8ce245..5d06727 100644
--- a/arch/arm/mach-at91/at91sam9260.c
+++ b/arch/arm/mach-at91/at91sam9260.c
@@ -11,6 +11,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/irqchip/at91.h>
 
 #include <asm/proc-fns.h>
 #include <asm/irq.h>
@@ -22,7 +23,6 @@
 #include <mach/at91sam9260.h>
 #include <mach/at91_pmc.h>
 
-#include "at91_aic.h"
 #include "at91_rstc.h"
 #include "soc.h"
 #include "generic.h"
diff --git a/arch/arm/mach-at91/at91sam9261.c b/arch/arm/mach-at91/at91sam9261.c
index 25efb5a..554aa43 100644
--- a/arch/arm/mach-at91/at91sam9261.c
+++ b/arch/arm/mach-at91/at91sam9261.c
@@ -11,6 +11,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/irqchip/at91.h>
 
 #include <asm/proc-fns.h>
 #include <asm/irq.h>
@@ -21,7 +22,6 @@
 #include <mach/at91sam9261.h>
 #include <mach/at91_pmc.h>
 
-#include "at91_aic.h"
 #include "at91_rstc.h"
 #include "soc.h"
 #include "generic.h"
diff --git a/arch/arm/mach-at91/at91sam9263.c b/arch/arm/mach-at91/at91sam9263.c
index f44ffd2..481e993 100644
--- a/arch/arm/mach-at91/at91sam9263.c
+++ b/arch/arm/mach-at91/at91sam9263.c
@@ -11,6 +11,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/irqchip/at91.h>
 
 #include <asm/proc-fns.h>
 #include <asm/irq.h>
@@ -20,7 +21,6 @@
 #include <mach/at91sam9263.h>
 #include <mach/at91_pmc.h>
 
-#include "at91_aic.h"
 #include "at91_rstc.h"
 #include "soc.h"
 #include "generic.h"
diff --git a/arch/arm/mach-at91/at91sam9g45.c b/arch/arm/mach-at91/at91sam9g45.c
index 8b7fce0..bc198a9 100644
--- a/arch/arm/mach-at91/at91sam9g45.c
+++ b/arch/arm/mach-at91/at91sam9g45.c
@@ -12,6 +12,7 @@
 
 #include <linux/module.h>
 #include <linux/dma-mapping.h>
+#include <linux/irqchip/at91.h>
 
 #include <asm/irq.h>
 #include <asm/mach/arch.h>
@@ -21,7 +22,6 @@
 #include <mach/at91_pmc.h>
 #include <mach/cpu.h>
 
-#include "at91_aic.h"
 #include "soc.h"
 #include "generic.h"
 #include "clock.h"
diff --git a/arch/arm/mach-at91/at91sam9rl.c b/arch/arm/mach-at91/at91sam9rl.c
index f77fae5..65154f0 100644
--- a/arch/arm/mach-at91/at91sam9rl.c
+++ b/arch/arm/mach-at91/at91sam9rl.c
@@ -10,6 +10,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/irqchip/at91.h>
 
 #include <asm/proc-fns.h>
 #include <asm/irq.h>
@@ -21,7 +22,6 @@
 #include <mach/at91sam9rl.h>
 #include <mach/at91_pmc.h>
 
-#include "at91_aic.h"
 #include "at91_rstc.h"
 #include "soc.h"
 #include "generic.h"
diff --git a/arch/arm/mach-at91/at91x40.c b/arch/arm/mach-at91/at91x40.c
index 19ca793..4ae1400 100644
--- a/arch/arm/mach-at91/at91x40.c
+++ b/arch/arm/mach-at91/at91x40.c
@@ -14,6 +14,7 @@
 #include <linux/init.h>
 #include <linux/irq.h>
 #include <linux/io.h>
+#include <linux/irqchip/at91.h>
 #include <asm/proc-fns.h>
 #include <asm/system_misc.h>
 #include <asm/mach/arch.h>
@@ -21,7 +22,6 @@
 #include <mach/at91_st.h>
 #include <mach/timex.h>
 
-#include "at91_aic.h"
 #include "generic.h"
 
 /*
diff --git a/arch/arm/mach-at91/board-1arm.c b/arch/arm/mach-at91/board-1arm.c
index 8389e81..7c18c14 100644
--- a/arch/arm/mach-at91/board-1arm.c
+++ b/arch/arm/mach-at91/board-1arm.c
@@ -24,6 +24,7 @@
 #include <linux/mm.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
+#include <linux/irqchip/at91.h>
 
 #include <mach/hardware.h>
 #include <asm/setup.h>
@@ -36,7 +37,6 @@
 
 #include <mach/cpu.h>
 
-#include "at91_aic.h"
 #include "board.h"
 #include "generic.h"
 
diff --git a/arch/arm/mach-at91/board-afeb-9260v1.c b/arch/arm/mach-at91/board-afeb-9260v1.c
index 82832f1..f22552b 100644
--- a/arch/arm/mach-at91/board-afeb-9260v1.c
+++ b/arch/arm/mach-at91/board-afeb-9260v1.c
@@ -33,6 +33,7 @@
 #include <linux/spi/spi.h>
 #include <linux/clk.h>
 #include <linux/dma-mapping.h>
+#include <linux/irqchip/at91.h>
 
 #include <mach/hardware.h>
 #include <asm/setup.h>
@@ -43,7 +44,6 @@
 #include <asm/mach/map.h>
 #include <asm/mach/irq.h>
 
-#include "at91_aic.h"
 #include "board.h"
 #include "generic.h"
 
diff --git a/arch/arm/mach-at91/board-cam60.c b/arch/arm/mach-at91/board-cam60.c
index c1146d9..be01453 100644
--- a/arch/arm/mach-at91/board-cam60.c
+++ b/arch/arm/mach-at91/board-cam60.c
@@ -28,6 +28,7 @@
 #include <linux/platform_device.h>
 #include <linux/spi/spi.h>
 #include <linux/spi/flash.h>
+#include <linux/irqchip/at91.h>
 
 #include <mach/hardware.h>
 #include <asm/setup.h>
@@ -40,7 +41,6 @@
 
 #include <mach/at91sam9_smc.h>
 
-#include "at91_aic.h"
 #include "board.h"
 #include "sam9_smc.h"
 #include "generic.h"
diff --git a/arch/arm/mach-at91/board-carmeva.c b/arch/arm/mach-at91/board-carmeva.c
index c0aac79..96a9bee 100644
--- a/arch/arm/mach-at91/board-carmeva.c
+++ b/arch/arm/mach-at91/board-carmeva.c
@@ -25,6 +25,7 @@
 #include <linux/mm.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
+#include <linux/irqchip/at91.h>
 
 #include <asm/setup.h>
 #include <asm/mach-types.h>
@@ -36,7 +37,6 @@
 
 #include <mach/hardware.h>
 
-#include "at91_aic.h"
 #include "board.h"
 #include "generic.h"
 
diff --git a/arch/arm/mach-at91/board-cpu9krea.c b/arch/arm/mach-at91/board-cpu9krea.c
index c8ddf60..1148009 100644
--- a/arch/arm/mach-at91/board-cpu9krea.c
+++ b/arch/arm/mach-at91/board-cpu9krea.c
@@ -30,6 +30,7 @@
 #include <linux/gpio_keys.h>
 #include <linux/input.h>
 #include <linux/mtd/physmap.h>
+#include <linux/irqchip/at91.h>
 
 #include <asm/setup.h>
 #include <asm/mach-types.h>
@@ -44,7 +45,6 @@
 #include <mach/at91sam9260_matrix.h>
 #include <mach/at91_matrix.h>
 
-#include "at91_aic.h"
 #include "board.h"
 #include "sam9_smc.h"
 #include "generic.h"
diff --git a/arch/arm/mach-at91/board-cpuat91.c b/arch/arm/mach-at91/board-cpuat91.c
index b7675c8..75c5cd2 100644
--- a/arch/arm/mach-at91/board-cpuat91.c
+++ b/arch/arm/mach-at91/board-cpuat91.c
@@ -26,6 +26,7 @@
 #include <linux/platform_device.h>
 #include <linux/mtd/physmap.h>
 #include <linux/mtd/plat-ram.h>
+#include <linux/irqchip/at91.h>
 
 #include <mach/hardware.h>
 #include <asm/setup.h>
@@ -40,7 +41,6 @@
 #include <mach/at91_ramc.h>
 #include <mach/cpu.h>
 
-#include "at91_aic.h"
 #include "board.h"
 #include "generic.h"
 
diff --git a/arch/arm/mach-at91/board-csb337.c b/arch/arm/mach-at91/board-csb337.c
index 746120d..e651d5f 100644
--- a/arch/arm/mach-at91/board-csb337.c
+++ b/arch/arm/mach-at91/board-csb337.c
@@ -28,6 +28,7 @@
 #include <linux/mtd/physmap.h>
 #include <linux/input.h>
 #include <linux/gpio_keys.h>
+#include <linux/irqchip/at91.h>
 
 #include <asm/setup.h>
 #include <asm/mach-types.h>
@@ -39,7 +40,6 @@
 
 #include <mach/hardware.h>
 
-#include "at91_aic.h"
 #include "board.h"
 #include "generic.h"
 
diff --git a/arch/arm/mach-at91/board-csb637.c b/arch/arm/mach-at91/board-csb637.c
index c61f7d9..bec8c25 100644
--- a/arch/arm/mach-at91/board-csb637.c
+++ b/arch/arm/mach-at91/board-csb637.c
@@ -25,6 +25,7 @@
 #include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/mtd/physmap.h>
+#include <linux/irqchip/at91.h>
 
 #include <asm/setup.h>
 #include <asm/mach-types.h>
@@ -36,7 +37,6 @@
 
 #include <mach/hardware.h>
 
-#include "at91_aic.h"
 #include "board.h"
 #include "generic.h"
 
diff --git a/arch/arm/mach-at91/board-dt-rm9200.c b/arch/arm/mach-at91/board-dt-rm9200.c
index 13d7c62..67fff54 100644
--- a/arch/arm/mach-at91/board-dt-rm9200.c
+++ b/arch/arm/mach-at91/board-dt-rm9200.c
@@ -15,6 +15,7 @@
 #include <linux/of.h>
 #include <linux/of_irq.h>
 #include <linux/of_platform.h>
+#include <linux/irqchip/at91.h>
 
 #include <asm/setup.h>
 #include <asm/irq.h>
@@ -22,7 +23,6 @@
 #include <asm/mach/map.h>
 #include <asm/mach/irq.h>
 
-#include "at91_aic.h"
 #include "generic.h"
 
 
diff --git a/arch/arm/mach-at91/board-dt-sam9.c b/arch/arm/mach-at91/board-dt-sam9.c
index 4d291ae..65edc6e 100644
--- a/arch/arm/mach-at91/board-dt-sam9.c
+++ b/arch/arm/mach-at91/board-dt-sam9.c
@@ -14,6 +14,7 @@
 #include <linux/of.h>
 #include <linux/of_irq.h>
 #include <linux/of_platform.h>
+#include <linux/irqchip/at91.h>
 
 #include <asm/setup.h>
 #include <asm/irq.h>
@@ -21,7 +22,6 @@
 #include <asm/mach/map.h>
 #include <asm/mach/irq.h>
 
-#include "at91_aic.h"
 #include "board.h"
 #include "generic.h"
 
diff --git a/arch/arm/mach-at91/board-dt-sama5.c b/arch/arm/mach-at91/board-dt-sama5.c
index d39a459..015178f 100644
--- a/arch/arm/mach-at91/board-dt-sama5.c
+++ b/arch/arm/mach-at91/board-dt-sama5.c
@@ -16,6 +16,7 @@
 #include <linux/of_irq.h>
 #include <linux/of_platform.h>
 #include <linux/phy.h>
+#include <linux/irqchip/at91.h>
 
 #include <asm/setup.h>
 #include <asm/irq.h>
@@ -23,7 +24,6 @@
 #include <asm/mach/map.h>
 #include <asm/mach/irq.h>
 
-#include "at91_aic.h"
 #include "generic.h"
 
 
diff --git a/arch/arm/mach-at91/board-eb01.c b/arch/arm/mach-at91/board-eb01.c
index 8d84f46..f0804fd 100644
--- a/arch/arm/mach-at91/board-eb01.c
+++ b/arch/arm/mach-at91/board-eb01.c
@@ -23,12 +23,12 @@
 #include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/irq.h>
+#include <linux/irqchip/at91.h>
 #include <asm/mach-types.h>
 #include <mach/hardware.h>
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
 
-#include "at91_aic.h"
 #include "board.h"
 #include "generic.h"
 
diff --git a/arch/arm/mach-at91/board-eb9200.c b/arch/arm/mach-at91/board-eb9200.c
index 95a4a65..ce9ddb5 100644
--- a/arch/arm/mach-at91/board-eb9200.c
+++ b/arch/arm/mach-at91/board-eb9200.c
@@ -25,6 +25,7 @@
 #include <linux/mm.h>
 #include <linux/module.h>
 #include <linux/device.h>
+#include <linux/irqchip/at91.h>
 
 #include <mach/hardware.h>
 #include <asm/setup.h>
@@ -35,7 +36,6 @@
 #include <asm/mach/map.h>
 #include <asm/mach/irq.h>
 
-#include "at91_aic.h"
 #include "board.h"
 #include "generic.h"
 
diff --git a/arch/arm/mach-at91/board-ecbat91.c b/arch/arm/mach-at91/board-ecbat91.c
index 4bababc..971a309 100644
--- a/arch/arm/mach-at91/board-ecbat91.c
+++ b/arch/arm/mach-at91/board-ecbat91.c
@@ -27,6 +27,7 @@
 #include <linux/platform_device.h>
 #include <linux/spi/spi.h>
 #include <linux/spi/flash.h>
+#include <linux/irqchip/at91.h>
 
 #include <mach/hardware.h>
 #include <asm/setup.h>
@@ -39,7 +40,6 @@
 
 #include <mach/cpu.h>
 
-#include "at91_aic.h"
 #include "board.h"
 #include "generic.h"
 
diff --git a/arch/arm/mach-at91/board-eco920.c b/arch/arm/mach-at91/board-eco920.c
index ba6c6f7..f8463e1 100644
--- a/arch/arm/mach-at91/board-eco920.c
+++ b/arch/arm/mach-at91/board-eco920.c
@@ -18,6 +18,7 @@
 #include <linux/platform_device.h>
 #include <linux/mtd/physmap.h>
 #include <linux/gpio.h>
+#include <linux/irqchip/at91.h>
 
 #include <asm/mach-types.h>
 
@@ -28,7 +29,6 @@
 #include <mach/at91_ramc.h>
 #include <mach/cpu.h>
 
-#include "at91_aic.h"
 #include "board.h"
 #include "generic.h"
 
diff --git a/arch/arm/mach-at91/board-flexibity.c b/arch/arm/mach-at91/board-flexibity.c
index b9b1f59..8d3ea6d 100644
--- a/arch/arm/mach-at91/board-flexibity.c
+++ b/arch/arm/mach-at91/board-flexibity.c
@@ -25,6 +25,7 @@
 #include <linux/spi/spi.h>
 #include <linux/input.h>
 #include <linux/gpio.h>
+#include <linux/irqchip/at91.h>
 
 #include <asm/mach-types.h>
 
@@ -34,7 +35,6 @@
 
 #include <mach/hardware.h>
 
-#include "at91_aic.h"
 #include "board.h"
 #include "generic.h"
 
diff --git a/arch/arm/mach-at91/board-foxg20.c b/arch/arm/mach-at91/board-foxg20.c
index 816db05..14ec339 100644
--- a/arch/arm/mach-at91/board-foxg20.c
+++ b/arch/arm/mach-at91/board-foxg20.c
@@ -31,6 +31,7 @@
 #include <linux/input.h>
 #include <linux/clk.h>
 #include <linux/w1-gpio.h>
+#include <linux/irqchip/at91.h>
 
 #include <mach/hardware.h>
 #include <asm/setup.h>
@@ -43,7 +44,6 @@
 
 #include <mach/at91sam9_smc.h>
 
-#include "at91_aic.h"
 #include "board.h"
 #include "sam9_smc.h"
 #include "generic.h"
diff --git a/arch/arm/mach-at91/board-gsia18s.c b/arch/arm/mach-at91/board-gsia18s.c
index af6a925..0912ba5 100644
--- a/arch/arm/mach-at91/board-gsia18s.c
+++ b/arch/arm/mach-at91/board-gsia18s.c
@@ -26,13 +26,13 @@
 #include <linux/i2c/pcf857x.h>
 #include <linux/gpio_keys.h>
 #include <linux/input.h>
+#include <linux/irqchip/at91.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
 
 #include <mach/at91sam9_smc.h>
 
-#include "at91_aic.h"
 #include "board.h"
 #include "sam9_smc.h"
 #include "generic.h"
diff --git a/arch/arm/mach-at91/board-kafa.c b/arch/arm/mach-at91/board-kafa.c
index 31bd8c9..10970ba 100644
--- a/arch/arm/mach-at91/board-kafa.c
+++ b/arch/arm/mach-at91/board-kafa.c
@@ -24,6 +24,7 @@
 #include <linux/mm.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
+#include <linux/irqchip/at91.h>
 
 #include <mach/hardware.h>
 #include <asm/setup.h>
@@ -36,7 +37,6 @@
 
 #include <mach/cpu.h>
 
-#include "at91_aic.h"
 #include "board.h"
 #include "generic.h"
 
diff --git a/arch/arm/mach-at91/board-kb9202.c b/arch/arm/mach-at91/board-kb9202.c
index df43c2e..6a4a93c 100644
--- a/arch/arm/mach-at91/board-kb9202.c
+++ b/arch/arm/mach-at91/board-kb9202.c
@@ -25,6 +25,7 @@
 #include <linux/mm.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
+#include <linux/irqchip/at91.h>
 
 #include <mach/hardware.h>
 #include <asm/setup.h>
@@ -39,7 +40,6 @@
 #include <mach/at91rm9200_mc.h>
 #include <mach/at91_ramc.h>
 
-#include "at91_aic.h"
 #include "board.h"
 #include "generic.h"
 
diff --git a/arch/arm/mach-at91/board-pcontrol-g20.c b/arch/arm/mach-at91/board-pcontrol-g20.c
index 724c91b..456a5db 100644
--- a/arch/arm/mach-at91/board-pcontrol-g20.c
+++ b/arch/arm/mach-at91/board-pcontrol-g20.c
@@ -25,13 +25,13 @@
 #include <linux/platform_device.h>
 #include <linux/gpio.h>
 #include <linux/w1-gpio.h>
+#include <linux/irqchip/at91.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
 
 #include <mach/at91sam9_smc.h>
 
-#include "at91_aic.h"
 #include "board.h"
 #include "sam9_smc.h"
 #include "generic.h"
diff --git a/arch/arm/mach-at91/board-picotux200.c b/arch/arm/mach-at91/board-picotux200.c
index 479a034..e511065 100644
--- a/arch/arm/mach-at91/board-picotux200.c
+++ b/arch/arm/mach-at91/board-picotux200.c
@@ -27,6 +27,7 @@
 #include <linux/platform_device.h>
 #include <linux/spi/spi.h>
 #include <linux/mtd/physmap.h>
+#include <linux/irqchip/at91.h>
 
 #include <mach/hardware.h>
 #include <asm/setup.h>
@@ -40,7 +41,6 @@
 #include <mach/at91rm9200_mc.h>
 #include <mach/at91_ramc.h>
 
-#include "at91_aic.h"
 #include "board.h"
 #include "generic.h"
 
diff --git a/arch/arm/mach-at91/board-qil-a9260.c b/arch/arm/mach-at91/board-qil-a9260.c
index 1d7a4e7..2ffe497 100644
--- a/arch/arm/mach-at91/board-qil-a9260.c
+++ b/arch/arm/mach-at91/board-qil-a9260.c
@@ -30,6 +30,7 @@
 #include <linux/gpio_keys.h>
 #include <linux/input.h>
 #include <linux/clk.h>
+#include <linux/irqchip/at91.h>
 
 #include <asm/setup.h>
 #include <asm/mach-types.h>
@@ -42,7 +43,6 @@
 #include <mach/hardware.h>
 #include <mach/at91sam9_smc.h>
 
-#include "at91_aic.h"
 #include "at91_shdwc.h"
 #include "board.h"
 #include "sam9_smc.h"
diff --git a/arch/arm/mach-at91/board-rm9200dk.c b/arch/arm/mach-at91/board-rm9200dk.c
index cc04718..7a1e71d 100644
--- a/arch/arm/mach-at91/board-rm9200dk.c
+++ b/arch/arm/mach-at91/board-rm9200dk.c
@@ -29,6 +29,7 @@
 #include <linux/platform_device.h>
 #include <linux/spi/spi.h>
 #include <linux/mtd/physmap.h>
+#include <linux/irqchip/at91.h>
 
 #include <asm/setup.h>
 #include <asm/mach-types.h>
@@ -42,7 +43,6 @@
 #include <mach/at91rm9200_mc.h>
 #include <mach/at91_ramc.h>
 
-#include "at91_aic.h"
 #include "board.h"
 #include "generic.h"
 
diff --git a/arch/arm/mach-at91/board-rm9200ek.c b/arch/arm/mach-at91/board-rm9200ek.c
index 13a121a..46acbf9 100644
--- a/arch/arm/mach-at91/board-rm9200ek.c
+++ b/arch/arm/mach-at91/board-rm9200ek.c
@@ -29,6 +29,7 @@
 #include <linux/platform_device.h>
 #include <linux/spi/spi.h>
 #include <linux/mtd/physmap.h>
+#include <linux/irqchip/at91.h>
 
 #include <asm/setup.h>
 #include <asm/mach-types.h>
@@ -42,7 +43,6 @@
 #include <mach/at91rm9200_mc.h>
 #include <mach/at91_ramc.h>
 
-#include "at91_aic.h"
 #include "board.h"
 #include "generic.h"
 
diff --git a/arch/arm/mach-at91/board-rsi-ews.c b/arch/arm/mach-at91/board-rsi-ews.c
index d15ef0c..f7f4406 100644
--- a/arch/arm/mach-at91/board-rsi-ews.c
+++ b/arch/arm/mach-at91/board-rsi-ews.c
@@ -15,6 +15,7 @@
 #include <linux/platform_device.h>
 #include <linux/spi/spi.h>
 #include <linux/mtd/physmap.h>
+#include <linux/irqchip/at91.h>
 
 #include <asm/setup.h>
 #include <asm/mach-types.h>
@@ -28,7 +29,6 @@
 
 #include <linux/gpio.h>
 
-#include "at91_aic.h"
 #include "board.h"
 #include "generic.h"
 
diff --git a/arch/arm/mach-at91/board-sam9-l9260.c b/arch/arm/mach-at91/board-sam9-l9260.c
index 0907df4..72f9163 100644
--- a/arch/arm/mach-at91/board-sam9-l9260.c
+++ b/arch/arm/mach-at91/board-sam9-l9260.c
@@ -27,6 +27,7 @@
 #include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/spi/spi.h>
+#include <linux/irqchip/at91.h>
 
 #include <mach/hardware.h>
 #include <asm/setup.h>
@@ -39,7 +40,6 @@
 
 #include <mach/at91sam9_smc.h>
 
-#include "at91_aic.h"
 #include "board.h"
 #include "sam9_smc.h"
 #include "generic.h"
diff --git a/arch/arm/mach-at91/board-sam9260ek.c b/arch/arm/mach-at91/board-sam9260ek.c
index 0361c4d..ea5a9cb 100644
--- a/arch/arm/mach-at91/board-sam9260ek.c
+++ b/arch/arm/mach-at91/board-sam9260ek.c
@@ -31,6 +31,7 @@
 #include <linux/i2c/at24.h>
 #include <linux/gpio_keys.h>
 #include <linux/input.h>
+#include <linux/irqchip/at91.h>
 
 #include <asm/setup.h>
 #include <asm/mach-types.h>
@@ -44,7 +45,6 @@
 #include <mach/at91sam9_smc.h>
 #include <mach/system_rev.h>
 
-#include "at91_aic.h"
 #include "at91_shdwc.h"
 #include "board.h"
 #include "sam9_smc.h"
diff --git a/arch/arm/mach-at91/board-sam9261ek.c b/arch/arm/mach-at91/board-sam9261ek.c
index c28401a..a181855 100644
--- a/arch/arm/mach-at91/board-sam9261ek.c
+++ b/arch/arm/mach-at91/board-sam9261ek.c
@@ -33,6 +33,7 @@
 #include <linux/fb.h>
 #include <linux/gpio_keys.h>
 #include <linux/input.h>
+#include <linux/irqchip/at91.h>
 
 #include <video/atmel_lcdc.h>
 
@@ -48,7 +49,6 @@
 #include <mach/at91sam9_smc.h>
 #include <mach/system_rev.h>
 
-#include "at91_aic.h"
 #include "at91_shdwc.h"
 #include "board.h"
 #include "sam9_smc.h"
diff --git a/arch/arm/mach-at91/board-sam9263ek.c b/arch/arm/mach-at91/board-sam9263ek.c
index 1287d81..8f8e3f7 100644
--- a/arch/arm/mach-at91/board-sam9263ek.c
+++ b/arch/arm/mach-at91/board-sam9263ek.c
@@ -32,6 +32,7 @@
 #include <linux/gpio_keys.h>
 #include <linux/input.h>
 #include <linux/leds.h>
+#include <linux/irqchip/at91.h>
 
 #include <video/atmel_lcdc.h>
 
@@ -47,7 +48,6 @@
 #include <mach/at91sam9_smc.h>
 #include <mach/system_rev.h>
 
-#include "at91_aic.h"
 #include "at91_shdwc.h"
 #include "board.h"
 #include "sam9_smc.h"
diff --git a/arch/arm/mach-at91/board-sam9g20ek.c b/arch/arm/mach-at91/board-sam9g20ek.c
index c6ea31d..13a4c16 100644
--- a/arch/arm/mach-at91/board-sam9g20ek.c
+++ b/arch/arm/mach-at91/board-sam9g20ek.c
@@ -31,6 +31,7 @@
 #include <linux/regulator/machine.h>
 #include <linux/regulator/fixed.h>
 #include <linux/regulator/consumer.h>
+#include <linux/irqchip/at91.h>
 
 #include <linux/platform_data/at91_adc.h>
 
@@ -46,7 +47,6 @@
 #include <mach/at91sam9_smc.h>
 #include <mach/system_rev.h>
 
-#include "at91_aic.h"
 #include "board.h"
 #include "sam9_smc.h"
 #include "generic.h"
diff --git a/arch/arm/mach-at91/board-sam9m10g45ek.c b/arch/arm/mach-at91/board-sam9m10g45ek.c
index 139a67e..98f88f2 100644
--- a/arch/arm/mach-at91/board-sam9m10g45ek.c
+++ b/arch/arm/mach-at91/board-sam9m10g45ek.c
@@ -26,6 +26,7 @@
 #include <linux/leds.h>
 #include <linux/atmel-mci.h>
 #include <linux/delay.h>
+#include <linux/irqchip/at91.h>
 
 #include <linux/platform_data/at91_adc.h>
 
@@ -45,7 +46,6 @@
 #include <mach/at91sam9_smc.h>
 #include <mach/system_rev.h>
 
-#include "at91_aic.h"
 #include "at91_shdwc.h"
 #include "board.h"
 #include "sam9_smc.h"
diff --git a/arch/arm/mach-at91/board-sam9rlek.c b/arch/arm/mach-at91/board-sam9rlek.c
index fdcb1cc..6da0fdb 100644
--- a/arch/arm/mach-at91/board-sam9rlek.c
+++ b/arch/arm/mach-at91/board-sam9rlek.c
@@ -18,6 +18,7 @@
 #include <linux/clk.h>
 #include <linux/input.h>
 #include <linux/gpio_keys.h>
+#include <linux/irqchip/at91.h>
 
 #include <video/atmel_lcdc.h>
 
@@ -33,7 +34,6 @@
 #include <mach/at91sam9_smc.h>
 
 
-#include "at91_aic.h"
 #include "at91_shdwc.h"
 #include "board.h"
 #include "sam9_smc.h"
diff --git a/arch/arm/mach-at91/board-snapper9260.c b/arch/arm/mach-at91/board-snapper9260.c
index c07e86a..7cfc767 100644
--- a/arch/arm/mach-at91/board-snapper9260.c
+++ b/arch/arm/mach-at91/board-snapper9260.c
@@ -27,6 +27,7 @@
 #include <linux/platform_device.h>
 #include <linux/spi/spi.h>
 #include <linux/i2c/pca953x.h>
+#include <linux/irqchip/at91.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
@@ -34,7 +35,6 @@
 #include <mach/hardware.h>
 #include <mach/at91sam9_smc.h>
 
-#include "at91_aic.h"
 #include "board.h"
 #include "sam9_smc.h"
 #include "generic.h"
diff --git a/arch/arm/mach-at91/board-stamp9g20.c b/arch/arm/mach-at91/board-stamp9g20.c
index 4977e6e..01d7245 100644
--- a/arch/arm/mach-at91/board-stamp9g20.c
+++ b/arch/arm/mach-at91/board-stamp9g20.c
@@ -21,13 +21,13 @@
 #include <linux/platform_device.h>
 #include <linux/gpio.h>
 #include <linux/w1-gpio.h>
+#include <linux/irqchip/at91.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
 
 #include <mach/at91sam9_smc.h>
 
-#include "at91_aic.h"
 #include "board.h"
 #include "sam9_smc.h"
 #include "generic.h"
diff --git a/arch/arm/mach-at91/board-usb-a926x.c b/arch/arm/mach-at91/board-usb-a926x.c
index a0f7d74..a89b733 100644
--- a/arch/arm/mach-at91/board-usb-a926x.c
+++ b/arch/arm/mach-at91/board-usb-a926x.c
@@ -31,6 +31,7 @@
 #include <linux/gpio.h>
 #include <linux/input.h>
 #include <linux/spi/mmc_spi.h>
+#include <linux/irqchip/at91.h>
 
 #include <asm/setup.h>
 #include <asm/mach-types.h>
@@ -43,7 +44,6 @@
 #include <mach/hardware.h>
 #include <mach/at91sam9_smc.h>
 
-#include "at91_aic.h"
 #include "at91_shdwc.h"
 #include "board.h"
 #include "sam9_smc.h"
diff --git a/arch/arm/mach-at91/board-yl-9200.c b/arch/arm/mach-at91/board-yl-9200.c
index ac3b263..a858ea1 100644
--- a/arch/arm/mach-at91/board-yl-9200.c
+++ b/arch/arm/mach-at91/board-yl-9200.c
@@ -33,6 +33,7 @@
 #include <linux/mtd/physmap.h>
 #include <linux/gpio_keys.h>
 #include <linux/input.h>
+#include <linux/irqchip/at91.h>
 
 #include <asm/setup.h>
 #include <asm/mach-types.h>
@@ -47,7 +48,6 @@
 #include <mach/at91_ramc.h>
 #include <mach/cpu.h>
 
-#include "at91_aic.h"
 #include "board.h"
 #include "generic.h"
 
diff --git a/arch/arm/mach-at91/pm.c b/arch/arm/mach-at91/pm.c
index 530db30..6577307 100644
--- a/arch/arm/mach-at91/pm.c
+++ b/arch/arm/mach-at91/pm.c
@@ -19,6 +19,7 @@
 #include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/io.h>
+#include <linux/irqchip/at91.h>
 
 #include <asm/irq.h>
 #include <linux/atomic.h>
@@ -28,7 +29,6 @@
 #include <mach/at91_pmc.h>
 #include <mach/cpu.h>
 
-#include "at91_aic.h"
 #include "generic.h"
 #include "pm.h"
 
diff --git a/drivers/irqchip/Makefile b/drivers/irqchip/Makefile
index cda4cb5..208b708 100644
--- a/drivers/irqchip/Makefile
+++ b/drivers/irqchip/Makefile
@@ -1,5 +1,6 @@
 obj-$(CONFIG_IRQCHIP)			+= irqchip.o
 
+obj-$(CONFIG_ARCH_AT91)			+= irq-at91.o
 obj-$(CONFIG_ARCH_BCM2835)		+= irq-bcm2835.o
 obj-$(CONFIG_ARCH_EXYNOS)		+= exynos-combiner.o
 obj-$(CONFIG_ARCH_MVEBU)		+= irq-armada-370-xp.o
diff --git a/arch/arm/mach-at91/irq.c b/drivers/irqchip/irq-at91.c
similarity index 99%
rename from arch/arm/mach-at91/irq.c
rename to drivers/irqchip/irq-at91.c
index 18c653f..ca49096 100644
--- a/arch/arm/mach-at91/irq.c
+++ b/drivers/irqchip/irq-at91.c
@@ -1,5 +1,5 @@
 /*
- * linux/arch/arm/mach-at91/irq.c
+ * drivers/irqchip/irq-at91.c
  *
  *  Copyright (C) 2004 SAN People
  *  Copyright (C) 2004 ATMEL
@@ -32,6 +32,7 @@
 #include <linux/irqdomain.h>
 #include <linux/err.h>
 #include <linux/slab.h>
+#include <linux/irqchip/at91.h>
 
 #include <mach/hardware.h>
 #include <asm/irq.h>
@@ -42,7 +43,6 @@
 #include <asm/mach/irq.h>
 #include <asm/mach/map.h>
 
-#include "at91_aic.h"
 
 void __iomem *at91_aic_base;
 static struct irq_domain *at91_aic_domain;
diff --git a/arch/arm/mach-at91/at91_aic.h b/include/linux/irqchip/at91.h
similarity index 97%
rename from arch/arm/mach-at91/at91_aic.h
rename to include/linux/irqchip/at91.h
index be8680d..42f1260 100644
--- a/arch/arm/mach-at91/at91_aic.h
+++ b/include/linux/irqchip/at91.h
@@ -1,5 +1,5 @@
 /*
- * arch/arm/mach-at91/include/mach/at91_aic.h
+ * include/linux/irqchip/at91.h
  *
  * Copyright (C) 2005 Ivan Kokshaysky
  * Copyright (C) SAN People
@@ -16,7 +16,6 @@
 #ifndef AT91_AIC_H
 #define AT91_AIC_H
 
-#ifndef __ASSEMBLY__
 extern void __iomem *at91_aic_base;
 
 #define at91_aic_read(field) \
@@ -24,9 +23,6 @@ extern void __iomem *at91_aic_base;
 
 #define at91_aic_write(field, value) \
 	__raw_writel(value, at91_aic_base + field)
-#else
-.extern at91_aic_base
-#endif
 
 /* Number of irq lines managed by AIC */
 #define NR_AIC_IRQS	32
-- 
1.7.9.5

