Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535AbaAUV1n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 16:27:43 -0500
Received: from mail1.windriver.com ([147.11.146.13]:50848 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755168AbaAUV0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 16:26:04 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arch@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Wolfram Sang <wsa@the-dreams.de>, Jean Delvare <khali@linux-fr.org>,
        <linux-i2c@vger.kernel.org>
Subject: [PATCH 51/73] drivers/i2c: delete non-required instances of include <linux/init.h>
Date: Tue, 21 Jan 2014 16:22:54 -0500
Message-ID: <1390339396-3479-52-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.4.1
In-Reply-To: <1390339396-3479-1-git-send-email-paul.gortmaker@windriver.com>
References: <1390339396-3479-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

None of these files are actually using any __init type directives
and hence don't need to include <linux/init.h>.  Most are just a
left over from __devinit and __cpuinit removal, or simply due to
code getting copied from one driver to the next.

Cc: Wolfram Sang <wsa@the-dreams.de>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: linux-i2c@vger.kernel.org
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/i2c/algos/i2c-algo-bit.c           | 1 -
 drivers/i2c/algos/i2c-algo-pca.c           | 1 -
 drivers/i2c/algos/i2c-algo-pcf.c           | 1 -
 drivers/i2c/busses/i2c-ali1535.c           | 1 -
 drivers/i2c/busses/i2c-ali1563.c           | 1 -
 drivers/i2c/busses/i2c-ali15x3.c           | 1 -
 drivers/i2c/busses/i2c-amd756.c            | 1 -
 drivers/i2c/busses/i2c-amd8111.c           | 1 -
 drivers/i2c/busses/i2c-au1550.c            | 1 -
 drivers/i2c/busses/i2c-cbus-gpio.c         | 1 -
 drivers/i2c/busses/i2c-cpm.c               | 1 -
 drivers/i2c/busses/i2c-eg20t.c             | 1 -
 drivers/i2c/busses/i2c-exynos5.c           | 1 -
 drivers/i2c/busses/i2c-highlander.c        | 1 -
 drivers/i2c/busses/i2c-hydra.c             | 1 -
 drivers/i2c/busses/i2c-ibm_iic.c           | 1 -
 drivers/i2c/busses/i2c-iop3xx.c            | 1 -
 drivers/i2c/busses/i2c-isch.c              | 1 -
 drivers/i2c/busses/i2c-ismt.c              | 1 -
 drivers/i2c/busses/i2c-mpc.c               | 1 -
 drivers/i2c/busses/i2c-nforce2.c           | 1 -
 drivers/i2c/busses/i2c-ocores.c            | 1 -
 drivers/i2c/busses/i2c-octeon.c            | 1 -
 drivers/i2c/busses/i2c-pca-platform.c      | 1 -
 drivers/i2c/busses/i2c-piix4.c             | 1 -
 drivers/i2c/busses/i2c-pmcmsp.c            | 1 -
 drivers/i2c/busses/i2c-powermac.c          | 1 -
 drivers/i2c/busses/i2c-puv3.c              | 1 -
 drivers/i2c/busses/i2c-rcar.c              | 1 -
 drivers/i2c/busses/i2c-scmi.c              | 1 -
 drivers/i2c/busses/i2c-sh7760.c            | 1 -
 drivers/i2c/busses/i2c-simtec.c            | 1 -
 drivers/i2c/busses/i2c-sis630.c            | 1 -
 drivers/i2c/busses/i2c-sis96x.c            | 1 -
 drivers/i2c/busses/i2c-via.c               | 1 -
 drivers/i2c/busses/i2c-xiic.c              | 1 -
 drivers/i2c/busses/i2c-xlr.c               | 1 -
 drivers/i2c/busses/scx200_i2c.c            | 1 -
 drivers/i2c/muxes/i2c-arb-gpio-challenge.c | 1 -
 drivers/i2c/muxes/i2c-mux-gpio.c           | 1 -
 drivers/i2c/muxes/i2c-mux-pca9541.c        | 1 -
 drivers/i2c/muxes/i2c-mux-pca954x.c        | 1 -
 drivers/i2c/muxes/i2c-mux-pinctrl.c        | 1 -
 43 files changed, 43 deletions(-)

diff --git a/drivers/i2c/algos/i2c-algo-bit.c b/drivers/i2c/algos/i2c-algo-bit.c
index fad22b0..8c29f36 100644
--- a/drivers/i2c/algos/i2c-algo-bit.c
+++ b/drivers/i2c/algos/i2c-algo-bit.c
@@ -25,7 +25,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/delay.h>
-#include <linux/init.h>
 #include <linux/errno.h>
 #include <linux/sched.h>
 #include <linux/i2c.h>
diff --git a/drivers/i2c/algos/i2c-algo-pca.c b/drivers/i2c/algos/i2c-algo-pca.c
index f892a42..8b10f88 100644
--- a/drivers/i2c/algos/i2c-algo-pca.c
+++ b/drivers/i2c/algos/i2c-algo-pca.c
@@ -24,7 +24,6 @@
 #include <linux/moduleparam.h>
 #include <linux/delay.h>
 #include <linux/jiffies.h>
-#include <linux/init.h>
 #include <linux/errno.h>
 #include <linux/i2c.h>
 #include <linux/i2c-algo-pca.h>
diff --git a/drivers/i2c/algos/i2c-algo-pcf.c b/drivers/i2c/algos/i2c-algo-pcf.c
index 5c23795..3437009 100644
--- a/drivers/i2c/algos/i2c-algo-pcf.c
+++ b/drivers/i2c/algos/i2c-algo-pcf.c
@@ -30,7 +30,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/delay.h>
-#include <linux/init.h>
 #include <linux/errno.h>
 #include <linux/i2c.h>
 #include <linux/i2c-algo-pcf.h>
diff --git a/drivers/i2c/busses/i2c-ali1535.c b/drivers/i2c/busses/i2c-ali1535.c
index 3f49181..7d60d3a 100644
--- a/drivers/i2c/busses/i2c-ali1535.c
+++ b/drivers/i2c/busses/i2c-ali1535.c
@@ -58,7 +58,6 @@
 #include <linux/delay.h>
 #include <linux/ioport.h>
 #include <linux/i2c.h>
-#include <linux/init.h>
 #include <linux/acpi.h>
 #include <linux/io.h>
 
diff --git a/drivers/i2c/busses/i2c-ali1563.c b/drivers/i2c/busses/i2c-ali1563.c
index 84ccd94..4611e47 100644
--- a/drivers/i2c/busses/i2c-ali1563.c
+++ b/drivers/i2c/busses/i2c-ali1563.c
@@ -20,7 +20,6 @@
 #include <linux/delay.h>
 #include <linux/i2c.h>
 #include <linux/pci.h>
-#include <linux/init.h>
 #include <linux/acpi.h>
 
 #define ALI1563_MAX_TIMEOUT	500
diff --git a/drivers/i2c/busses/i2c-ali15x3.c b/drivers/i2c/busses/i2c-ali15x3.c
index 26bcc61..4823206 100644
--- a/drivers/i2c/busses/i2c-ali15x3.c
+++ b/drivers/i2c/busses/i2c-ali15x3.c
@@ -65,7 +65,6 @@
 #include <linux/ioport.h>
 #include <linux/delay.h>
 #include <linux/i2c.h>
-#include <linux/init.h>
 #include <linux/acpi.h>
 #include <linux/io.h>
 
diff --git a/drivers/i2c/busses/i2c-amd756.c b/drivers/i2c/busses/i2c-amd756.c
index e13e2aa..819d3c1 100644
--- a/drivers/i2c/busses/i2c-amd756.c
+++ b/drivers/i2c/busses/i2c-amd756.c
@@ -41,7 +41,6 @@
 #include <linux/stddef.h>
 #include <linux/ioport.h>
 #include <linux/i2c.h>
-#include <linux/init.h>
 #include <linux/acpi.h>
 #include <linux/io.h>
 
diff --git a/drivers/i2c/busses/i2c-amd8111.c b/drivers/i2c/busses/i2c-amd8111.c
index a44e6e7..f3d4d79 100644
--- a/drivers/i2c/busses/i2c-amd8111.c
+++ b/drivers/i2c/busses/i2c-amd8111.c
@@ -13,7 +13,6 @@
 #include <linux/kernel.h>
 #include <linux/stddef.h>
 #include <linux/ioport.h>
-#include <linux/init.h>
 #include <linux/i2c.h>
 #include <linux/delay.h>
 #include <linux/acpi.h>
diff --git a/drivers/i2c/busses/i2c-au1550.c b/drivers/i2c/busses/i2c-au1550.c
index b5b8923..8762458 100644
--- a/drivers/i2c/busses/i2c-au1550.c
+++ b/drivers/i2c/busses/i2c-au1550.c
@@ -31,7 +31,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
-#include <linux/init.h>
 #include <linux/errno.h>
 #include <linux/i2c.h>
 #include <linux/slab.h>
diff --git a/drivers/i2c/busses/i2c-cbus-gpio.c b/drivers/i2c/busses/i2c-cbus-gpio.c
index ce7ffba..bdf040f 100644
--- a/drivers/i2c/busses/i2c-cbus-gpio.c
+++ b/drivers/i2c/busses/i2c-cbus-gpio.c
@@ -19,7 +19,6 @@
 #include <linux/io.h>
 #include <linux/i2c.h>
 #include <linux/gpio.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/delay.h>
 #include <linux/errno.h>
diff --git a/drivers/i2c/busses/i2c-cpm.c b/drivers/i2c/busses/i2c-cpm.c
index 3e5ea2c..be7f0a2 100644
--- a/drivers/i2c/busses/i2c-cpm.c
+++ b/drivers/i2c/busses/i2c-cpm.c
@@ -33,7 +33,6 @@
 #include <linux/module.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
-#include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/errno.h>
 #include <linux/stddef.h>
diff --git a/drivers/i2c/busses/i2c-eg20t.c b/drivers/i2c/busses/i2c-eg20t.c
index ff15ae9..e08e458 100644
--- a/drivers/i2c/busses/i2c-eg20t.c
+++ b/drivers/i2c/busses/i2c-eg20t.c
@@ -18,7 +18,6 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/delay.h>
-#include <linux/init.h>
 #include <linux/errno.h>
 #include <linux/i2c.h>
 #include <linux/fs.h>
diff --git a/drivers/i2c/busses/i2c-exynos5.c b/drivers/i2c/busses/i2c-exynos5.c
index 044f85b..9fd711c 100644
--- a/drivers/i2c/busses/i2c-exynos5.c
+++ b/drivers/i2c/busses/i2c-exynos5.c
@@ -12,7 +12,6 @@
 #include <linux/module.h>
 
 #include <linux/i2c.h>
-#include <linux/init.h>
 #include <linux/time.h>
 #include <linux/interrupt.h>
 #include <linux/delay.h>
diff --git a/drivers/i2c/busses/i2c-highlander.c b/drivers/i2c/busses/i2c-highlander.c
index 436b0f2..512fcfa 100644
--- a/drivers/i2c/busses/i2c-highlander.c
+++ b/drivers/i2c/busses/i2c-highlander.c
@@ -12,7 +12,6 @@
  * of this archive for more details.
  */
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/i2c.h>
 #include <linux/platform_device.h>
diff --git a/drivers/i2c/busses/i2c-hydra.c b/drivers/i2c/busses/i2c-hydra.c
index 79c3d90..e248257 100644
--- a/drivers/i2c/busses/i2c-hydra.c
+++ b/drivers/i2c/busses/i2c-hydra.c
@@ -27,7 +27,6 @@
 #include <linux/types.h>
 #include <linux/i2c.h>
 #include <linux/i2c-algo-bit.h>
-#include <linux/init.h>
 #include <linux/io.h>
 #include <asm/hydra.h>
 
diff --git a/drivers/i2c/busses/i2c-ibm_iic.c b/drivers/i2c/busses/i2c-ibm_iic.c
index f744410..274312c 100644
--- a/drivers/i2c/busses/i2c-ibm_iic.c
+++ b/drivers/i2c/busses/i2c-ibm_iic.c
@@ -36,7 +36,6 @@
 #include <linux/ioport.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
-#include <linux/init.h>
 #include <linux/interrupt.h>
 #include <asm/irq.h>
 #include <linux/io.h>
diff --git a/drivers/i2c/busses/i2c-iop3xx.c b/drivers/i2c/busses/i2c-iop3xx.c
index dd24aa0..3d16c2f 100644
--- a/drivers/i2c/busses/i2c-iop3xx.c
+++ b/drivers/i2c/busses/i2c-iop3xx.c
@@ -34,7 +34,6 @@
 #include <linux/module.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
-#include <linux/init.h>
 #include <linux/errno.h>
 #include <linux/platform_device.h>
 #include <linux/i2c.h>
diff --git a/drivers/i2c/busses/i2c-isch.c b/drivers/i2c/busses/i2c-isch.c
index af21304..cf99dbf 100644
--- a/drivers/i2c/busses/i2c-isch.c
+++ b/drivers/i2c/busses/i2c-isch.c
@@ -33,7 +33,6 @@
 #include <linux/stddef.h>
 #include <linux/ioport.h>
 #include <linux/i2c.h>
-#include <linux/init.h>
 #include <linux/io.h>
 #include <linux/acpi.h>
 
diff --git a/drivers/i2c/busses/i2c-ismt.c b/drivers/i2c/busses/i2c-ismt.c
index bb132ea..8ce4f51 100644
--- a/drivers/i2c/busses/i2c-ismt.c
+++ b/drivers/i2c/busses/i2c-ismt.c
@@ -62,7 +62,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/pci.h>
 #include <linux/kernel.h>
 #include <linux/stddef.h>
diff --git a/drivers/i2c/busses/i2c-mpc.c b/drivers/i2c/busses/i2c-mpc.c
index b6a741c..f539163 100644
--- a/drivers/i2c/busses/i2c-mpc.c
+++ b/drivers/i2c/busses/i2c-mpc.c
@@ -16,7 +16,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/sched.h>
-#include <linux/init.h>
 #include <linux/of_address.h>
 #include <linux/of_irq.h>
 #include <linux/of_platform.h>
diff --git a/drivers/i2c/busses/i2c-nforce2.c b/drivers/i2c/busses/i2c-nforce2.c
index ac88f40..0038c45 100644
--- a/drivers/i2c/busses/i2c-nforce2.c
+++ b/drivers/i2c/busses/i2c-nforce2.c
@@ -51,7 +51,6 @@
 #include <linux/kernel.h>
 #include <linux/stddef.h>
 #include <linux/ioport.h>
-#include <linux/init.h>
 #include <linux/i2c.h>
 #include <linux/delay.h>
 #include <linux/dmi.h>
diff --git a/drivers/i2c/busses/i2c-ocores.c b/drivers/i2c/busses/i2c-ocores.c
index c61f37a..80e06fa 100644
--- a/drivers/i2c/busses/i2c-ocores.c
+++ b/drivers/i2c/busses/i2c-ocores.c
@@ -15,7 +15,6 @@
 #include <linux/err.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/errno.h>
 #include <linux/platform_device.h>
 #include <linux/i2c.h>
diff --git a/drivers/i2c/busses/i2c-octeon.c b/drivers/i2c/busses/i2c-octeon.c
index b929ba2..81042b0 100644
--- a/drivers/i2c/busses/i2c-octeon.c
+++ b/drivers/i2c/busses/i2c-octeon.c
@@ -18,7 +18,6 @@
 #include <linux/delay.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
-#include <linux/init.h>
 #include <linux/i2c.h>
 #include <linux/io.h>
 #include <linux/of.h>
diff --git a/drivers/i2c/busses/i2c-pca-platform.c b/drivers/i2c/busses/i2c-pca-platform.c
index 39e2755..845f125 100644
--- a/drivers/i2c/busses/i2c-pca-platform.c
+++ b/drivers/i2c/busses/i2c-pca-platform.c
@@ -12,7 +12,6 @@
  */
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/delay.h>
 #include <linux/jiffies.h>
diff --git a/drivers/i2c/busses/i2c-piix4.c b/drivers/i2c/busses/i2c-piix4.c
index a028617..66eaed9 100644
--- a/drivers/i2c/busses/i2c-piix4.c
+++ b/drivers/i2c/busses/i2c-piix4.c
@@ -38,7 +38,6 @@
 #include <linux/ioport.h>
 #include <linux/i2c.h>
 #include <linux/slab.h>
-#include <linux/init.h>
 #include <linux/dmi.h>
 #include <linux/acpi.h>
 #include <linux/io.h>
diff --git a/drivers/i2c/busses/i2c-pmcmsp.c b/drivers/i2c/busses/i2c-pmcmsp.c
index f6389e2..8564768 100644
--- a/drivers/i2c/busses/i2c-pmcmsp.c
+++ b/drivers/i2c/busses/i2c-pmcmsp.c
@@ -26,7 +26,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/i2c.h>
 #include <linux/interrupt.h>
diff --git a/drivers/i2c/busses/i2c-powermac.c b/drivers/i2c/busses/i2c-powermac.c
index 8c87f4a..01e9677 100644
--- a/drivers/i2c/busses/i2c-powermac.c
+++ b/drivers/i2c/busses/i2c-powermac.c
@@ -24,7 +24,6 @@
 #include <linux/kernel.h>
 #include <linux/types.h>
 #include <linux/i2c.h>
-#include <linux/init.h>
 #include <linux/device.h>
 #include <linux/platform_device.h>
 #include <linux/of_irq.h>
diff --git a/drivers/i2c/busses/i2c-puv3.c b/drivers/i2c/busses/i2c-puv3.c
index ac80199..c83fc3c 100644
--- a/drivers/i2c/busses/i2c-puv3.c
+++ b/drivers/i2c/busses/i2c-puv3.c
@@ -17,7 +17,6 @@
 #include <linux/types.h>
 #include <linux/delay.h>
 #include <linux/i2c.h>
-#include <linux/init.h>
 #include <linux/clk.h>
 #include <linux/platform_device.h>
 #include <linux/io.h>
diff --git a/drivers/i2c/busses/i2c-rcar.c b/drivers/i2c/busses/i2c-rcar.c
index 2c2fd7c..4f5be21 100644
--- a/drivers/i2c/busses/i2c-rcar.c
+++ b/drivers/i2c/busses/i2c-rcar.c
@@ -26,7 +26,6 @@
 #include <linux/clk.h>
 #include <linux/delay.h>
 #include <linux/err.h>
-#include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
 #include <linux/i2c.h>
diff --git a/drivers/i2c/busses/i2c-scmi.c b/drivers/i2c/busses/i2c-scmi.c
index 5992355..dfc98df 100644
--- a/drivers/i2c/busses/i2c-scmi.c
+++ b/drivers/i2c/busses/i2c-scmi.c
@@ -12,7 +12,6 @@
 #include <linux/slab.h>
 #include <linux/kernel.h>
 #include <linux/stddef.h>
-#include <linux/init.h>
 #include <linux/i2c.h>
 #include <linux/acpi.h>
 
diff --git a/drivers/i2c/busses/i2c-sh7760.c b/drivers/i2c/busses/i2c-sh7760.c
index 5e8f136..d76f3d9 100644
--- a/drivers/i2c/busses/i2c-sh7760.c
+++ b/drivers/i2c/busses/i2c-sh7760.c
@@ -11,7 +11,6 @@
 #include <linux/delay.h>
 #include <linux/err.h>
 #include <linux/i2c.h>
-#include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/ioport.h>
 #include <linux/platform_device.h>
diff --git a/drivers/i2c/busses/i2c-simtec.c b/drivers/i2c/busses/i2c-simtec.c
index 4fc87e7..294c80f 100644
--- a/drivers/i2c/busses/i2c-simtec.c
+++ b/drivers/i2c/busses/i2c-simtec.c
@@ -20,7 +20,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
diff --git a/drivers/i2c/busses/i2c-sis630.c b/drivers/i2c/busses/i2c-sis630.c
index 36a9556..19b8505 100644
--- a/drivers/i2c/busses/i2c-sis630.c
+++ b/drivers/i2c/busses/i2c-sis630.c
@@ -45,7 +45,6 @@
 #include <linux/delay.h>
 #include <linux/pci.h>
 #include <linux/ioport.h>
-#include <linux/init.h>
 #include <linux/i2c.h>
 #include <linux/acpi.h>
 #include <linux/io.h>
diff --git a/drivers/i2c/busses/i2c-sis96x.c b/drivers/i2c/busses/i2c-sis96x.c
index b9faf9b..f8aa0c2 100644
--- a/drivers/i2c/busses/i2c-sis96x.c
+++ b/drivers/i2c/busses/i2c-sis96x.c
@@ -36,7 +36,6 @@
 #include <linux/stddef.h>
 #include <linux/ioport.h>
 #include <linux/i2c.h>
-#include <linux/init.h>
 #include <linux/acpi.h>
 #include <linux/io.h>
 
diff --git a/drivers/i2c/busses/i2c-via.c b/drivers/i2c/busses/i2c-via.c
index be66251..49d7f14 100644
--- a/drivers/i2c/busses/i2c-via.c
+++ b/drivers/i2c/busses/i2c-via.c
@@ -22,7 +22,6 @@
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/ioport.h>
-#include <linux/init.h>
 #include <linux/i2c.h>
 #include <linux/i2c-algo-bit.h>
 #include <linux/io.h>
diff --git a/drivers/i2c/busses/i2c-xiic.c b/drivers/i2c/busses/i2c-xiic.c
index 6f9918f..2810750 100644
--- a/drivers/i2c/busses/i2c-xiic.c
+++ b/drivers/i2c/busses/i2c-xiic.c
@@ -30,7 +30,6 @@
  */
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/errno.h>
 #include <linux/err.h>
 #include <linux/delay.h>
diff --git a/drivers/i2c/busses/i2c-xlr.c b/drivers/i2c/busses/i2c-xlr.c
index 7945b05..17f7352 100644
--- a/drivers/i2c/busses/i2c-xlr.c
+++ b/drivers/i2c/busses/i2c-xlr.c
@@ -11,7 +11,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/slab.h>
-#include <linux/init.h>
 #include <linux/ioport.h>
 #include <linux/delay.h>
 #include <linux/errno.h>
diff --git a/drivers/i2c/busses/scx200_i2c.c b/drivers/i2c/busses/scx200_i2c.c
index ae1258b..8eadf0f4 100644
--- a/drivers/i2c/busses/scx200_i2c.c
+++ b/drivers/i2c/busses/scx200_i2c.c
@@ -26,7 +26,6 @@
 #include <linux/module.h>
 #include <linux/errno.h>
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/i2c.h>
 #include <linux/i2c-algo-bit.h>
 #include <linux/io.h>
diff --git a/drivers/i2c/muxes/i2c-arb-gpio-challenge.c b/drivers/i2c/muxes/i2c-arb-gpio-challenge.c
index c58e093..69afffa 100644
--- a/drivers/i2c/muxes/i2c-arb-gpio-challenge.c
+++ b/drivers/i2c/muxes/i2c-arb-gpio-challenge.c
@@ -19,7 +19,6 @@
 #include <linux/kernel.h>
 #include <linux/i2c.h>
 #include <linux/i2c-mux.h>
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/of_gpio.h>
 #include <linux/platform_device.h>
diff --git a/drivers/i2c/muxes/i2c-mux-gpio.c b/drivers/i2c/muxes/i2c-mux-gpio.c
index 8a8c56f..d8989c8 100644
--- a/drivers/i2c/muxes/i2c-mux-gpio.c
+++ b/drivers/i2c/muxes/i2c-mux-gpio.c
@@ -12,7 +12,6 @@
 #include <linux/i2c-mux.h>
 #include <linux/i2c-mux-gpio.h>
 #include <linux/platform_device.h>
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/gpio.h>
diff --git a/drivers/i2c/muxes/i2c-mux-pca9541.c b/drivers/i2c/muxes/i2c-mux-pca9541.c
index c4f08ad..cb77277 100644
--- a/drivers/i2c/muxes/i2c-mux-pca9541.c
+++ b/drivers/i2c/muxes/i2c-mux-pca9541.c
@@ -17,7 +17,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/jiffies.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
diff --git a/drivers/i2c/muxes/i2c-mux-pca954x.c b/drivers/i2c/muxes/i2c-mux-pca954x.c
index e835304..c5ac5f8 100644
--- a/drivers/i2c/muxes/i2c-mux-pca954x.c
+++ b/drivers/i2c/muxes/i2c-mux-pca954x.c
@@ -40,7 +40,6 @@
 #include <linux/i2c.h>
 #include <linux/i2c-mux.h>
 #include <linux/i2c/pca954x.h>
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/of_gpio.h>
 #include <linux/slab.h>
diff --git a/drivers/i2c/muxes/i2c-mux-pinctrl.c b/drivers/i2c/muxes/i2c-mux-pinctrl.c
index d7978dc..4ff0ef3 100644
--- a/drivers/i2c/muxes/i2c-mux-pinctrl.c
+++ b/drivers/i2c/muxes/i2c-mux-pinctrl.c
@@ -18,7 +18,6 @@
 
 #include <linux/i2c.h>
 #include <linux/i2c-mux.h>
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/pinctrl/consumer.h>
 #include <linux/i2c-mux-pinctrl.h>
-- 
1.8.4.1

