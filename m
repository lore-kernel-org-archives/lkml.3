Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755266AbaAUV2G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 16:28:06 -0500
Received: from mail.windriver.com ([147.11.1.11]:56638 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754834AbaAUV0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 16:26:00 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arch@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        David Airlie <airlied@linux.ie>, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kukjin Kim <kgene.kim@samsung.com>, Corey Minyard <minyard@acm.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peter Huewe <peterhuewe@gmx.de>, Ashley Lai <ashley@ashleylai.com>,
        Marcel Selhorst <tpmdd@selhorst.net>
Subject: [PATCH 56/73] drivers/char: delete non-required instances of include <linux/init.h>
Date: Tue, 21 Jan 2014 16:22:59 -0500
Message-ID: <1390339396-3479-57-git-send-email-paul.gortmaker@windriver.com>
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

Cc: David Airlie <airlied@linux.ie>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: Corey Minyard <minyard@acm.org>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Peter Huewe <peterhuewe@gmx.de>
Cc: Ashley Lai <ashley@ashleylai.com>
Cc: Marcel Selhorst <tpmdd@selhorst.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/char/agp/frontend.c          | 1 -
 drivers/char/agp/generic.c           | 1 -
 drivers/char/agp/intel-gtt.c         | 1 -
 drivers/char/agp/sgi-agp.c           | 1 -
 drivers/char/hw_random/bcm2835-rng.c | 1 -
 drivers/char/hw_random/core.c        | 1 -
 drivers/char/hw_random/exynos-rng.c  | 1 -
 drivers/char/hw_random/n2-drv.c      | 1 -
 drivers/char/hw_random/nomadik-rng.c | 1 -
 drivers/char/hw_random/octeon-rng.c  | 1 -
 drivers/char/ipmi/ipmi_si_intf.c     | 1 -
 drivers/char/mwave/3780i.c           | 1 -
 drivers/char/tile-srom.c             | 1 -
 drivers/char/tpm/tpm_i2c_infineon.c  | 1 -
 drivers/char/tpm/tpm_i2c_stm_st33.c  | 1 -
 15 files changed, 15 deletions(-)

diff --git a/drivers/char/agp/frontend.c b/drivers/char/agp/frontend.c
index 1b19239..8121b4c 100644
--- a/drivers/char/agp/frontend.c
+++ b/drivers/char/agp/frontend.c
@@ -31,7 +31,6 @@
 #include <linux/module.h>
 #include <linux/mman.h>
 #include <linux/pci.h>
-#include <linux/init.h>
 #include <linux/miscdevice.h>
 #include <linux/agp_backend.h>
 #include <linux/agpgart.h>
diff --git a/drivers/char/agp/generic.c b/drivers/char/agp/generic.c
index f39437a..0fbccce 100644
--- a/drivers/char/agp/generic.c
+++ b/drivers/char/agp/generic.c
@@ -29,7 +29,6 @@
  */
 #include <linux/module.h>
 #include <linux/pci.h>
-#include <linux/init.h>
 #include <linux/pagemap.h>
 #include <linux/miscdevice.h>
 #include <linux/pm.h>
diff --git a/drivers/char/agp/intel-gtt.c b/drivers/char/agp/intel-gtt.c
index 5c85350..9a024f8 100644
--- a/drivers/char/agp/intel-gtt.c
+++ b/drivers/char/agp/intel-gtt.c
@@ -17,7 +17,6 @@
 
 #include <linux/module.h>
 #include <linux/pci.h>
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/pagemap.h>
 #include <linux/agp_backend.h>
diff --git a/drivers/char/agp/sgi-agp.c b/drivers/char/agp/sgi-agp.c
index 05b8d02..3051c73 100644
--- a/drivers/char/agp/sgi-agp.c
+++ b/drivers/char/agp/sgi-agp.c
@@ -15,7 +15,6 @@
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/slab.h>
-#include <linux/init.h>
 #include <linux/agp_backend.h>
 #include <asm/sn/addrs.h>
 #include <asm/sn/io.h>
diff --git a/drivers/char/hw_random/bcm2835-rng.c b/drivers/char/hw_random/bcm2835-rng.c
index 43577ca..8c3b255 100644
--- a/drivers/char/hw_random/bcm2835-rng.c
+++ b/drivers/char/hw_random/bcm2835-rng.c
@@ -8,7 +8,6 @@
  */
 
 #include <linux/hw_random.h>
-#include <linux/init.h>
 #include <linux/io.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index a0f7724..b9495a8 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -37,7 +37,6 @@
 #include <linux/kernel.h>
 #include <linux/fs.h>
 #include <linux/sched.h>
-#include <linux/init.h>
 #include <linux/miscdevice.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
diff --git a/drivers/char/hw_random/exynos-rng.c b/drivers/char/hw_random/exynos-rng.c
index 402ccfb..9f8277c 100644
--- a/drivers/char/hw_random/exynos-rng.c
+++ b/drivers/char/hw_random/exynos-rng.c
@@ -22,7 +22,6 @@
 #include <linux/hw_random.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/io.h>
 #include <linux/platform_device.h>
 #include <linux/clk.h>
diff --git a/drivers/char/hw_random/n2-drv.c b/drivers/char/hw_random/n2-drv.c
index f9beed5..432232e 100644
--- a/drivers/char/hw_random/n2-drv.c
+++ b/drivers/char/hw_random/n2-drv.c
@@ -7,7 +7,6 @@
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/delay.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/workqueue.h>
 #include <linux/preempt.h>
diff --git a/drivers/char/hw_random/nomadik-rng.c b/drivers/char/hw_random/nomadik-rng.c
index 232b87f..00e9d2d 100644
--- a/drivers/char/hw_random/nomadik-rng.c
+++ b/drivers/char/hw_random/nomadik-rng.c
@@ -10,7 +10,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/device.h>
 #include <linux/amba/bus.h>
 #include <linux/hw_random.h>
diff --git a/drivers/char/hw_random/octeon-rng.c b/drivers/char/hw_random/octeon-rng.c
index f2885db..b5cc342 100644
--- a/drivers/char/hw_random/octeon-rng.c
+++ b/drivers/char/hw_random/octeon-rng.c
@@ -10,7 +10,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/device.h>
 #include <linux/hw_random.h>
diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
index 15e4a60..4a2d7c6 100644
--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -61,7 +61,6 @@
 #include <linux/ipmi_smi.h>
 #include <asm/io.h>
 #include "ipmi_si_sm.h"
-#include <linux/init.h>
 #include <linux/dmi.h>
 #include <linux/string.h>
 #include <linux/ctype.h>
diff --git a/drivers/char/mwave/3780i.c b/drivers/char/mwave/3780i.c
index 881c9e5..2874004 100644
--- a/drivers/char/mwave/3780i.c
+++ b/drivers/char/mwave/3780i.c
@@ -50,7 +50,6 @@
 #include <linux/unistd.h>
 #include <linux/delay.h>
 #include <linux/ioport.h>
-#include <linux/init.h>
 #include <linux/bitops.h>
 #include <linux/sched.h>	/* cond_resched() */
 
diff --git a/drivers/char/tile-srom.c b/drivers/char/tile-srom.c
index 0e506ba..bd37747 100644
--- a/drivers/char/tile-srom.c
+++ b/drivers/char/tile-srom.c
@@ -20,7 +20,6 @@
 
 #include <linux/module.h>
 #include <linux/moduleparam.h>
-#include <linux/init.h>
 #include <linux/kernel.h>	/* printk() */
 #include <linux/slab.h>		/* kmalloc() */
 #include <linux/fs.h>		/* everything... */
diff --git a/drivers/char/tpm/tpm_i2c_infineon.c b/drivers/char/tpm/tpm_i2c_infineon.c
index 52b9b2b..472af4b 100644
--- a/drivers/char/tpm/tpm_i2c_infineon.c
+++ b/drivers/char/tpm/tpm_i2c_infineon.c
@@ -21,7 +21,6 @@
  *
  *
  */
-#include <linux/init.h>
 #include <linux/i2c.h>
 #include <linux/module.h>
 #include <linux/wait.h>
diff --git a/drivers/char/tpm/tpm_i2c_stm_st33.c b/drivers/char/tpm/tpm_i2c_stm_st33.c
index 5b0dd8e..3b7bf21 100644
--- a/drivers/char/tpm/tpm_i2c_stm_st33.c
+++ b/drivers/char/tpm/tpm_i2c_stm_st33.c
@@ -38,7 +38,6 @@
 #include <linux/miscdevice.h>
 #include <linux/kernel.h>
 #include <linux/delay.h>
-#include <linux/init.h>
 #include <linux/wait.h>
 #include <linux/string.h>
 #include <linux/interrupt.h>
-- 
1.8.4.1

