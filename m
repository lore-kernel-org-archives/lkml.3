Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753040Ab3KKFgZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 00:36:25 -0500
Received: from mail-oa0-f53.google.com ([209.85.219.53]:56143 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752884Ab3KKFfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 00:35:52 -0500
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Rob Herring <rob.herring@calxeda.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Tejun Heo <tj@kernel.org>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>, linuxppc-dev@lists.ozlabs.org,
        linux-ide@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: [PATCH] powerpc: add explicit OF includes for ppc4xx
Date: Sun, 10 Nov 2013 23:35:43 -0600
Message-Id: <1384148143-14335-1-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

Commit b5b4bb3f6a11f9 (of: only include prom.h on sparc) removed implicit
includes of of_*.h headers by powerpc's prom.h. Some PPC4xx components
were missed in initial clean-up patch, so add the necessary includes
to fix ppc4xx builds.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: linuxppc-dev@lists.ozlabs.org
Cc: linux-ide@vger.kernel.org
Cc: linux-crypto@vger.kernel.org
---
I intend to send this patch to Linus with the rest of the DT clean-up
series.

Rob

 arch/powerpc/sysdev/ppc4xx_ocm.c     | 1 +
 arch/powerpc/sysdev/xilinx_intc.c    | 1 +
 drivers/ata/sata_dwc_460ex.c         | 2 ++
 drivers/char/hw_random/ppc4xx-rng.c  | 1 +
 drivers/crypto/amcc/crypto4xx_core.c | 3 +++
 drivers/dma/ppc4xx/adma.c            | 2 ++
 6 files changed, 10 insertions(+)

diff --git a/arch/powerpc/sysdev/ppc4xx_ocm.c b/arch/powerpc/sysdev/ppc4xx_ocm.c
index 1b15f93..b7c4345 100644
--- a/arch/powerpc/sysdev/ppc4xx_ocm.c
+++ b/arch/powerpc/sysdev/ppc4xx_ocm.c
@@ -26,6 +26,7 @@
 #include <linux/kernel.h>
 #include <linux/dma-mapping.h>
 #include <linux/of.h>
+#include <linux/of_address.h>
 #include <asm/rheap.h>
 #include <asm/ppc4xx_ocm.h>
 #include <linux/slab.h>
diff --git a/arch/powerpc/sysdev/xilinx_intc.c b/arch/powerpc/sysdev/xilinx_intc.c
index f4fdc94..83f943a 100644
--- a/arch/powerpc/sysdev/xilinx_intc.c
+++ b/arch/powerpc/sysdev/xilinx_intc.c
@@ -24,6 +24,7 @@
 #include <linux/irq.h>
 #include <linux/of.h>
 #include <linux/of_address.h>
+#include <linux/of_irq.h>
 #include <asm/io.h>
 #include <asm/processor.h>
 #include <asm/i8259.h>
diff --git a/drivers/ata/sata_dwc_460ex.c b/drivers/ata/sata_dwc_460ex.c
index 2e39173..523524b 100644
--- a/drivers/ata/sata_dwc_460ex.c
+++ b/drivers/ata/sata_dwc_460ex.c
@@ -31,6 +31,8 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/device.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
 #include <linux/of_platform.h>
 #include <linux/platform_device.h>
 #include <linux/libata.h>
diff --git a/drivers/char/hw_random/ppc4xx-rng.c b/drivers/char/hw_random/ppc4xx-rng.c
index 732c330..521f76b 100644
--- a/drivers/char/hw_random/ppc4xx-rng.c
+++ b/drivers/char/hw_random/ppc4xx-rng.c
@@ -13,6 +13,7 @@
 #include <linux/platform_device.h>
 #include <linux/hw_random.h>
 #include <linux/delay.h>
+#include <linux/of_address.h>
 #include <linux/of_platform.h>
 #include <asm/io.h>
 
diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
index f88e3d8..efaf630 100644
--- a/drivers/crypto/amcc/crypto4xx_core.c
+++ b/drivers/crypto/amcc/crypto4xx_core.c
@@ -27,6 +27,9 @@
 #include <linux/dma-mapping.h>
 #include <linux/platform_device.h>
 #include <linux/init.h>
+#include <linux/module.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
 #include <linux/of_platform.h>
 #include <linux/slab.h>
 #include <asm/dcr.h>
diff --git a/drivers/dma/ppc4xx/adma.c b/drivers/dma/ppc4xx/adma.c
index 370ff82..e24b5ef 100644
--- a/drivers/dma/ppc4xx/adma.c
+++ b/drivers/dma/ppc4xx/adma.c
@@ -42,6 +42,8 @@
 #include <linux/uaccess.h>
 #include <linux/proc_fs.h>
 #include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
 #include <linux/of_platform.h>
 #include <asm/dcr.h>
 #include <asm/dcr-regs.h>
-- 
1.8.1.2

