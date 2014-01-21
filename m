Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459AbaAUVcw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 16:32:52 -0500
Received: from mail.windriver.com ([147.11.1.11]:56572 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754900AbaAUVZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 16:25:42 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arch@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Chris Ball <chris@printf.net>, <linux-mmc@vger.kernel.org>
Subject: [PATCH 61/73] drivers/mmc: delete non-required instances of include <linux/init.h>
Date: Tue, 21 Jan 2014 16:23:04 -0500
Message-ID: <1390339396-3479-62-git-send-email-paul.gortmaker@windriver.com>
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

Cc: Chris Ball <chris@printf.net>
Cc: linux-mmc@vger.kernel.org
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/mmc/host/android-goldfish.c | 1 -
 drivers/mmc/host/bfin_sdh.c         | 1 -
 drivers/mmc/host/mmci.c             | 1 -
 drivers/mmc/host/msm_sdcc.c         | 1 -
 drivers/mmc/host/mxcmmc.c           | 1 -
 drivers/mmc/host/mxs-mmc.c          | 1 -
 drivers/mmc/host/omap.c             | 1 -
 drivers/mmc/host/omap_hsmmc.c       | 1 -
 drivers/mmc/host/pxamci.c           | 1 -
 drivers/mmc/host/sdhci-acpi.c       | 1 -
 drivers/mmc/host/sdhci-pxav2.c      | 1 -
 drivers/mmc/host/sdhci-pxav3.c      | 1 -
 drivers/mmc/host/sdhci-tegra.c      | 1 -
 drivers/mmc/host/wmt-sdmmc.c        | 1 -
 14 files changed, 14 deletions(-)

diff --git a/drivers/mmc/host/android-goldfish.c b/drivers/mmc/host/android-goldfish.c
index 8b4e20a..54fc950 100644
--- a/drivers/mmc/host/android-goldfish.c
+++ b/drivers/mmc/host/android-goldfish.c
@@ -35,7 +35,6 @@
 #include <linux/mmc/card.h>
 
 #include <linux/moduleparam.h>
-#include <linux/init.h>
 #include <linux/ioport.h>
 #include <linux/dma-mapping.h>
 #include <linux/delay.h>
diff --git a/drivers/mmc/host/bfin_sdh.c b/drivers/mmc/host/bfin_sdh.c
index 2b7f37e..e5efbbf 100644
--- a/drivers/mmc/host/bfin_sdh.c
+++ b/drivers/mmc/host/bfin_sdh.c
@@ -9,7 +9,6 @@
 #define DRIVER_NAME	"bfin-sdh"
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/ioport.h>
 #include <linux/platform_device.h>
 #include <linux/delay.h>
diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
index b931226..ebb64cd 100644
--- a/drivers/mmc/host/mmci.c
+++ b/drivers/mmc/host/mmci.c
@@ -10,7 +10,6 @@
  */
 #include <linux/module.h>
 #include <linux/moduleparam.h>
-#include <linux/init.h>
 #include <linux/ioport.h>
 #include <linux/device.h>
 #include <linux/interrupt.h>
diff --git a/drivers/mmc/host/msm_sdcc.c b/drivers/mmc/host/msm_sdcc.c
index 9405ecd..15933dc 100644
--- a/drivers/mmc/host/msm_sdcc.c
+++ b/drivers/mmc/host/msm_sdcc.c
@@ -17,7 +17,6 @@
 
 #include <linux/module.h>
 #include <linux/moduleparam.h>
-#include <linux/init.h>
 #include <linux/ioport.h>
 #include <linux/device.h>
 #include <linux/interrupt.h>
diff --git a/drivers/mmc/host/mxcmmc.c b/drivers/mmc/host/mxcmmc.c
index f7199c8..b573b50 100644
--- a/drivers/mmc/host/mxcmmc.c
+++ b/drivers/mmc/host/mxcmmc.c
@@ -18,7 +18,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/ioport.h>
 #include <linux/platform_device.h>
 #include <linux/interrupt.h>
diff --git a/drivers/mmc/host/mxs-mmc.c b/drivers/mmc/host/mxs-mmc.c
index 073e871..19633fe 100644
--- a/drivers/mmc/host/mxs-mmc.c
+++ b/drivers/mmc/host/mxs-mmc.c
@@ -21,7 +21,6 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/ioport.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
diff --git a/drivers/mmc/host/omap.c b/drivers/mmc/host/omap.c
index 98b6b6e..41f536f 100644
--- a/drivers/mmc/host/omap.c
+++ b/drivers/mmc/host/omap.c
@@ -13,7 +13,6 @@
 
 #include <linux/module.h>
 #include <linux/moduleparam.h>
-#include <linux/init.h>
 #include <linux/ioport.h>
 #include <linux/platform_device.h>
 #include <linux/interrupt.h>
diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index dbd32ad..2a629fb 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -16,7 +16,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/debugfs.h>
 #include <linux/dmaengine.h>
diff --git a/drivers/mmc/host/pxamci.c b/drivers/mmc/host/pxamci.c
index 32fe113..9427d67 100644
--- a/drivers/mmc/host/pxamci.c
+++ b/drivers/mmc/host/pxamci.c
@@ -17,7 +17,6 @@
  *	max block length up to 1023
  */
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/ioport.h>
 #include <linux/platform_device.h>
 #include <linux/delay.h>
diff --git a/drivers/mmc/host/sdhci-acpi.c b/drivers/mmc/host/sdhci-acpi.c
index 9ce17f6..4d68e1a 100644
--- a/drivers/mmc/host/sdhci-acpi.c
+++ b/drivers/mmc/host/sdhci-acpi.c
@@ -18,7 +18,6 @@
  *
  */
 
-#include <linux/init.h>
 #include <linux/export.h>
 #include <linux/module.h>
 #include <linux/device.h>
diff --git a/drivers/mmc/host/sdhci-pxav2.c b/drivers/mmc/host/sdhci-pxav2.c
index d51e061..b75a975 100644
--- a/drivers/mmc/host/sdhci-pxav2.c
+++ b/drivers/mmc/host/sdhci-pxav2.c
@@ -18,7 +18,6 @@
  */
 
 #include <linux/err.h>
-#include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/clk.h>
 #include <linux/module.h>
diff --git a/drivers/mmc/host/sdhci-pxav3.c b/drivers/mmc/host/sdhci-pxav3.c
index 793dacd..783c991 100644
--- a/drivers/mmc/host/sdhci-pxav3.c
+++ b/drivers/mmc/host/sdhci-pxav3.c
@@ -17,7 +17,6 @@
  *
  */
 #include <linux/err.h>
-#include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/clk.h>
 #include <linux/io.h>
diff --git a/drivers/mmc/host/sdhci-tegra.c b/drivers/mmc/host/sdhci-tegra.c
index a835898..ec7ebbc 100644
--- a/drivers/mmc/host/sdhci-tegra.c
+++ b/drivers/mmc/host/sdhci-tegra.c
@@ -14,7 +14,6 @@
 
 #include <linux/err.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/clk.h>
 #include <linux/io.h>
diff --git a/drivers/mmc/host/wmt-sdmmc.c b/drivers/mmc/host/wmt-sdmmc.c
index e902ed7..12a47ea 100644
--- a/drivers/mmc/host/wmt-sdmmc.c
+++ b/drivers/mmc/host/wmt-sdmmc.c
@@ -9,7 +9,6 @@
  *  published by the Free Software Foundation
  */
 
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/ioport.h>
-- 
1.8.4.1

