Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395AbaAUVau (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 16:30:50 -0500
Received: from mail.windriver.com ([147.11.1.11]:56614 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755016AbaAUVZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 16:25:51 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arch@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Laxman Dewangan <ldewangan@nvidia.com>, <dmaengine@vger.kernel.org>
Subject: [PATCH 70/73] drivers/dma: delete non-required instances of <linux/init.h>
Date: Tue, 21 Jan 2014 16:23:13 -0500
Message-ID: <1390339396-3479-71-git-send-email-paul.gortmaker@windriver.com>
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

Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Laxman Dewangan <ldewangan@nvidia.com>
Cc: dmaengine@vger.kernel.org
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/dma/bcm2835-dma.c     | 1 -
 drivers/dma/dma-jz4740.c      | 1 -
 drivers/dma/dw/core.c         | 1 -
 drivers/dma/ioat/dma.c        | 1 -
 drivers/dma/ioat/dma.h        | 1 -
 drivers/dma/ioat/dma_v2.c     | 1 -
 drivers/dma/iop-adma.c        | 1 -
 drivers/dma/k3dma.c           | 1 -
 drivers/dma/mmp_pdma.c        | 1 -
 drivers/dma/mmp_tdma.c        | 1 -
 drivers/dma/omap-dma.c        | 1 -
 drivers/dma/pch_dma.c         | 1 -
 drivers/dma/pl330.c           | 1 -
 drivers/dma/sh/rcar-hpbdma.c  | 1 -
 drivers/dma/sh/sudmac.c       | 1 -
 drivers/dma/tegra20-apb-dma.c | 1 -
 drivers/dma/timb_dma.c        | 1 -
 17 files changed, 17 deletions(-)

diff --git a/drivers/dma/bcm2835-dma.c b/drivers/dma/bcm2835-dma.c
index a036021..124f5cf 100644
--- a/drivers/dma/bcm2835-dma.c
+++ b/drivers/dma/bcm2835-dma.c
@@ -32,7 +32,6 @@
 #include <linux/dmaengine.h>
 #include <linux/dma-mapping.h>
 #include <linux/err.h>
-#include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/list.h>
 #include <linux/module.h>
diff --git a/drivers/dma/dma-jz4740.c b/drivers/dma/dma-jz4740.c
index 94c380f..3e49f2c 100644
--- a/drivers/dma/dma-jz4740.c
+++ b/drivers/dma/dma-jz4740.c
@@ -16,7 +16,6 @@
 #include <linux/dmaengine.h>
 #include <linux/dma-mapping.h>
 #include <linux/err.h>
-#include <linux/init.h>
 #include <linux/list.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
diff --git a/drivers/dma/dw/core.c b/drivers/dma/dw/core.c
index 13ac3f2..7109375 100644
--- a/drivers/dma/dw/core.c
+++ b/drivers/dma/dw/core.c
@@ -17,7 +17,6 @@
 #include <linux/dma-mapping.h>
 #include <linux/dmapool.h>
 #include <linux/err.h>
-#include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
 #include <linux/mm.h>
diff --git a/drivers/dma/ioat/dma.c b/drivers/dma/ioat/dma.c
index 8752918..45554f9 100644
--- a/drivers/dma/ioat/dma.c
+++ b/drivers/dma/ioat/dma.c
@@ -25,7 +25,6 @@
  * copy operations.
  */
 
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/pci.h>
diff --git a/drivers/dma/ioat/dma.h b/drivers/dma/ioat/dma.h
index 11fb877..6a8f169 100644
--- a/drivers/dma/ioat/dma.h
+++ b/drivers/dma/ioat/dma.h
@@ -24,7 +24,6 @@
 #include <linux/dmaengine.h>
 #include "hw.h"
 #include "registers.h"
-#include <linux/init.h>
 #include <linux/dmapool.h>
 #include <linux/cache.h>
 #include <linux/pci_ids.h>
diff --git a/drivers/dma/ioat/dma_v2.c b/drivers/dma/ioat/dma_v2.c
index 5d3affe..659e535 100644
--- a/drivers/dma/ioat/dma_v2.c
+++ b/drivers/dma/ioat/dma_v2.c
@@ -25,7 +25,6 @@
  * does asynchronous data movement and checksumming operations.
  */
 
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/pci.h>
diff --git a/drivers/dma/iop-adma.c b/drivers/dma/iop-adma.c
index c56137b..8d69f6c 100644
--- a/drivers/dma/iop-adma.c
+++ b/drivers/dma/iop-adma.c
@@ -22,7 +22,6 @@
  * on the Intel Xscale(R) family of I/O Processors (IOP 32x, 33x, 134x)
  */
 
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/delay.h>
 #include <linux/dma-mapping.h>
diff --git a/drivers/dma/k3dma.c b/drivers/dma/k3dma.c
index a1f911a..1004819 100644
--- a/drivers/dma/k3dma.c
+++ b/drivers/dma/k3dma.c
@@ -9,7 +9,6 @@
 #include <linux/sched.h>
 #include <linux/device.h>
 #include <linux/dmaengine.h>
-#include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
diff --git a/drivers/dma/mmp_pdma.c b/drivers/dma/mmp_pdma.c
index c1b7c3a..32e58ee 100644
--- a/drivers/dma/mmp_pdma.c
+++ b/drivers/dma/mmp_pdma.c
@@ -8,7 +8,6 @@
 
 #include <linux/err.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/types.h>
 #include <linux/interrupt.h>
 #include <linux/dma-mapping.h>
diff --git a/drivers/dma/mmp_tdma.c b/drivers/dma/mmp_tdma.c
index 33f96aa..dba6189 100644
--- a/drivers/dma/mmp_tdma.c
+++ b/drivers/dma/mmp_tdma.c
@@ -11,7 +11,6 @@
 
 #include <linux/err.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/types.h>
 #include <linux/interrupt.h>
 #include <linux/dma-mapping.h>
diff --git a/drivers/dma/omap-dma.c b/drivers/dma/omap-dma.c
index 362e7c4..f16e718 100644
--- a/drivers/dma/omap-dma.c
+++ b/drivers/dma/omap-dma.c
@@ -8,7 +8,6 @@
 #include <linux/dmaengine.h>
 #include <linux/dma-mapping.h>
 #include <linux/err.h>
-#include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/list.h>
 #include <linux/module.h>
diff --git a/drivers/dma/pch_dma.c b/drivers/dma/pch_dma.c
index 61fdc54..83344cf 100644
--- a/drivers/dma/pch_dma.c
+++ b/drivers/dma/pch_dma.c
@@ -19,7 +19,6 @@
 
 #include <linux/dmaengine.h>
 #include <linux/dma-mapping.h>
-#include <linux/init.h>
 #include <linux/pci.h>
 #include <linux/interrupt.h>
 #include <linux/module.h>
diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
index 73fa9b7..32abac3 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -13,7 +13,6 @@
 
 #include <linux/kernel.h>
 #include <linux/io.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/string.h>
diff --git a/drivers/dma/sh/rcar-hpbdma.c b/drivers/dma/sh/rcar-hpbdma.c
index 3083d90..8a7b9ba 100644
--- a/drivers/dma/sh/rcar-hpbdma.c
+++ b/drivers/dma/sh/rcar-hpbdma.c
@@ -18,7 +18,6 @@
 
 #include <linux/dmaengine.h>
 #include <linux/delay.h>
-#include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/module.h>
 #include <linux/platform_data/dma-rcar-hpbdma.h>
diff --git a/drivers/dma/sh/sudmac.c b/drivers/dma/sh/sudmac.c
index c7e9cdf..5c35337 100644
--- a/drivers/dma/sh/sudmac.c
+++ b/drivers/dma/sh/sudmac.c
@@ -14,7 +14,6 @@
  * published by the Free Software Foundation.
  */
 
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/interrupt.h>
diff --git a/drivers/dma/tegra20-apb-dma.c b/drivers/dma/tegra20-apb-dma.c
index 03ad64e..ff269dd 100644
--- a/drivers/dma/tegra20-apb-dma.c
+++ b/drivers/dma/tegra20-apb-dma.c
@@ -22,7 +22,6 @@
 #include <linux/dmaengine.h>
 #include <linux/dma-mapping.h>
 #include <linux/err.h>
-#include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
 #include <linux/mm.h>
diff --git a/drivers/dma/timb_dma.c b/drivers/dma/timb_dma.c
index 4506a7b..3ef05d6 100644
--- a/drivers/dma/timb_dma.c
+++ b/drivers/dma/timb_dma.c
@@ -22,7 +22,6 @@
 
 #include <linux/dmaengine.h>
 #include <linux/dma-mapping.h>
-#include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
 #include <linux/module.h>
-- 
1.8.4.1

