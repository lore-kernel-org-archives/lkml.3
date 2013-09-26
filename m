Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190Ab3IZSvd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 14:51:33 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:65355 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754124Ab3IZSv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 14:51:27 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH 10/21] drivers: clean-up prom.h implicit includes
Date: Thu, 26 Sep 2013 13:50:45 -0500
Message-Id: <1380221456-11192-11-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1380221456-11192-1-git-send-email-robherring2@gmail.com>
References: <1380221456-11192-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

Powerpc is a mess of implicit includes by prom.h. Add the necessary
explicit includes to drivers in preparation of prom.h cleanup.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
---
 drivers/ata/sata_fsl.c                | 2 ++
 drivers/char/bsr.c                    | 1 +
 drivers/char/hw_random/pasemi-rng.c   | 1 +
 drivers/cpufreq/pasemi-cpufreq.c      | 1 +
 drivers/crypto/caam/ctrl.c            | 3 +++
 drivers/crypto/caam/jr.c              | 2 ++
 drivers/dma/fsldma.c                  | 2 ++
 drivers/edac/cell_edac.c              | 1 +
 drivers/i2c/busses/i2c-mpc.c          | 2 ++
 drivers/i2c/busses/i2c-powermac.c     | 1 +
 drivers/input/serio/xilinx_ps2.c      | 1 +
 drivers/macintosh/macio_asic.c        | 2 ++
 drivers/macintosh/rack-meter.c        | 2 ++
 drivers/macintosh/smu.c               | 1 +
 drivers/macintosh/via-pmu.c           | 2 ++
 drivers/mtd/nand/fsl_elbc_nand.c      | 1 +
 drivers/mtd/nand/pasemi_nand.c        | 2 ++
 drivers/net/ethernet/ibm/emac/core.c  | 2 ++
 drivers/net/ethernet/ibm/emac/mal.c   | 1 +
 drivers/net/ethernet/ibm/emac/rgmii.c | 1 +
 drivers/net/ethernet/ibm/emac/tah.c   | 1 +
 drivers/net/ethernet/ibm/emac/zmii.c  | 1 +
 drivers/pcmcia/electra_cf.c           | 2 ++
 drivers/tty/ehv_bytechan.c            | 1 +
 drivers/tty/serial/pmac_zilog.c       | 2 ++
 drivers/usb/host/ehci-ppc-of.c        | 2 ++
 drivers/usb/host/ohci-ppc-of.c        | 2 ++
 sound/aoa/core/gpio-feature.c         | 3 ++-
 sound/aoa/soundbus/i2sbus/core.c      | 2 ++
 sound/ppc/pmac.c                      | 2 ++
 sound/ppc/tumbler.c                   | 1 +
 31 files changed, 49 insertions(+), 1 deletion(-)

diff --git a/drivers/ata/sata_fsl.c b/drivers/ata/sata_fsl.c
index 851bd3f..fb0b40a 100644
--- a/drivers/ata/sata_fsl.c
+++ b/drivers/ata/sata_fsl.c
@@ -24,6 +24,8 @@
 #include <scsi/scsi_cmnd.h>
 #include <linux/libata.h>
 #include <asm/io.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
 #include <linux/of_platform.h>
 
 static unsigned int intr_coalescing_count;
diff --git a/drivers/char/bsr.c b/drivers/char/bsr.c
index 0671e45..8fedbc2 100644
--- a/drivers/char/bsr.c
+++ b/drivers/char/bsr.c
@@ -21,6 +21,7 @@
 
 #include <linux/kernel.h>
 #include <linux/of.h>
+#include <linux/of_address.h>
 #include <linux/of_device.h>
 #include <linux/of_platform.h>
 #include <linux/fs.h>
diff --git a/drivers/char/hw_random/pasemi-rng.c b/drivers/char/hw_random/pasemi-rng.c
index c6df5b2..c66279b 100644
--- a/drivers/char/hw_random/pasemi-rng.c
+++ b/drivers/char/hw_random/pasemi-rng.c
@@ -24,6 +24,7 @@
 #include <linux/platform_device.h>
 #include <linux/hw_random.h>
 #include <linux/delay.h>
+#include <linux/of_address.h>
 #include <linux/of_platform.h>
 #include <asm/io.h>
 
diff --git a/drivers/cpufreq/pasemi-cpufreq.c b/drivers/cpufreq/pasemi-cpufreq.c
index 534e43a..f4ec814 100644
--- a/drivers/cpufreq/pasemi-cpufreq.c
+++ b/drivers/cpufreq/pasemi-cpufreq.c
@@ -28,6 +28,7 @@
 #include <linux/cpufreq.h>
 #include <linux/timer.h>
 #include <linux/module.h>
+#include <linux/of_address.h>
 
 #include <asm/hw_irq.h>
 #include <asm/io.h>
diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index b010d42..3054870 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -5,6 +5,9 @@
  * Copyright 2008-2012 Freescale Semiconductor, Inc.
  */
 
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
+
 #include "compat.h"
 #include "regs.h"
 #include "intern.h"
diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
index 105ba4d..94b80a9 100644
--- a/drivers/crypto/caam/jr.c
+++ b/drivers/crypto/caam/jr.c
@@ -5,6 +5,8 @@
  * Copyright 2008-2012 Freescale Semiconductor, Inc.
  */
 
+#include <linux/of_irq.h>
+
 #include "compat.h"
 #include "regs.h"
 #include "jr.h"
diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index b3f3e90..61517dd 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -33,6 +33,8 @@
 #include <linux/delay.h>
 #include <linux/dma-mapping.h>
 #include <linux/dmapool.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
 #include <linux/of_platform.h>
 
 #include "dmaengine.h"
diff --git a/drivers/edac/cell_edac.c b/drivers/edac/cell_edac.c
index c2eaf33..9ee1c76 100644
--- a/drivers/edac/cell_edac.c
+++ b/drivers/edac/cell_edac.c
@@ -15,6 +15,7 @@
 #include <linux/platform_device.h>
 #include <linux/stop_machine.h>
 #include <linux/io.h>
+#include <linux/of_address.h>
 #include <asm/machdep.h>
 #include <asm/cell-regs.h>
 
diff --git a/drivers/i2c/busses/i2c-mpc.c b/drivers/i2c/busses/i2c-mpc.c
index b80c768..b6a741c 100644
--- a/drivers/i2c/busses/i2c-mpc.c
+++ b/drivers/i2c/busses/i2c-mpc.c
@@ -17,6 +17,8 @@
 #include <linux/module.h>
 #include <linux/sched.h>
 #include <linux/init.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
 #include <linux/of_platform.h>
 #include <linux/slab.h>
 
diff --git a/drivers/i2c/busses/i2c-powermac.c b/drivers/i2c/busses/i2c-powermac.c
index 37e8cfa..8c87f4a 100644
--- a/drivers/i2c/busses/i2c-powermac.c
+++ b/drivers/i2c/busses/i2c-powermac.c
@@ -27,6 +27,7 @@
 #include <linux/init.h>
 #include <linux/device.h>
 #include <linux/platform_device.h>
+#include <linux/of_irq.h>
 #include <asm/prom.h>
 #include <asm/pmac_low_i2c.h>
 
diff --git a/drivers/input/serio/xilinx_ps2.c b/drivers/input/serio/xilinx_ps2.c
index 4b7662a..b90eb4f 100644
--- a/drivers/input/serio/xilinx_ps2.c
+++ b/drivers/input/serio/xilinx_ps2.c
@@ -25,6 +25,7 @@
 #include <linux/io.h>
 #include <linux/of_address.h>
 #include <linux/of_device.h>
+#include <linux/of_irq.h>
 #include <linux/of_platform.h>
 
 #define DRIVER_NAME		"xilinx_ps2"
diff --git a/drivers/macintosh/macio_asic.c b/drivers/macintosh/macio_asic.c
index ac5c879..4f12c6f 100644
--- a/drivers/macintosh/macio_asic.c
+++ b/drivers/macintosh/macio_asic.c
@@ -24,6 +24,8 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/slab.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
 
 #include <asm/machdep.h>
 #include <asm/macio.h>
diff --git a/drivers/macintosh/rack-meter.c b/drivers/macintosh/rack-meter.c
index cad0e19..4192901 100644
--- a/drivers/macintosh/rack-meter.c
+++ b/drivers/macintosh/rack-meter.c
@@ -25,6 +25,8 @@
 #include <linux/pci.h>
 #include <linux/dma-mapping.h>
 #include <linux/kernel_stat.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
 
 #include <asm/io.h>
 #include <asm/prom.h>
diff --git a/drivers/macintosh/smu.c b/drivers/macintosh/smu.c
index b3b2d36..23b4a3b 100644
--- a/drivers/macintosh/smu.c
+++ b/drivers/macintosh/smu.c
@@ -35,6 +35,7 @@
 #include <linux/poll.h>
 #include <linux/mutex.h>
 #include <linux/of_device.h>
+#include <linux/of_irq.h>
 #include <linux/of_platform.h>
 #include <linux/slab.h>
 
diff --git a/drivers/macintosh/via-pmu.c b/drivers/macintosh/via-pmu.c
index 283e1b5..dee88e5 100644
--- a/drivers/macintosh/via-pmu.c
+++ b/drivers/macintosh/via-pmu.c
@@ -46,6 +46,8 @@
 #include <linux/suspend.h>
 #include <linux/cpu.h>
 #include <linux/compat.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
 #include <asm/prom.h>
 #include <asm/machdep.h>
 #include <asm/io.h>
diff --git a/drivers/mtd/nand/fsl_elbc_nand.c b/drivers/mtd/nand/fsl_elbc_nand.c
index 2065720..e59c886 100644
--- a/drivers/mtd/nand/fsl_elbc_nand.c
+++ b/drivers/mtd/nand/fsl_elbc_nand.c
@@ -28,6 +28,7 @@
 #include <linux/kernel.h>
 #include <linux/string.h>
 #include <linux/ioport.h>
+#include <linux/of_address.h>
 #include <linux/of_platform.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
diff --git a/drivers/mtd/nand/pasemi_nand.c b/drivers/mtd/nand/pasemi_nand.c
index 5a67082..4d17436 100644
--- a/drivers/mtd/nand/pasemi_nand.c
+++ b/drivers/mtd/nand/pasemi_nand.c
@@ -28,6 +28,8 @@
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/nand.h>
 #include <linux/mtd/nand_ecc.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
 #include <linux/of_platform.h>
 #include <linux/platform_device.h>
 #include <linux/pci.h>
diff --git a/drivers/net/ethernet/ibm/emac/core.c b/drivers/net/ethernet/ibm/emac/core.c
index 6b5c722..cdf2321 100644
--- a/drivers/net/ethernet/ibm/emac/core.c
+++ b/drivers/net/ethernet/ibm/emac/core.c
@@ -39,6 +39,8 @@
 #include <linux/bitops.h>
 #include <linux/workqueue.h>
 #include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
 #include <linux/of_net.h>
 #include <linux/slab.h>
 
diff --git a/drivers/net/ethernet/ibm/emac/mal.c b/drivers/net/ethernet/ibm/emac/mal.c
index dac564c..4742ba3 100644
--- a/drivers/net/ethernet/ibm/emac/mal.c
+++ b/drivers/net/ethernet/ibm/emac/mal.c
@@ -27,6 +27,7 @@
 
 #include <linux/delay.h>
 #include <linux/slab.h>
+#include <linux/of_irq.h>
 
 #include "core.h"
 #include <asm/dcr-regs.h>
diff --git a/drivers/net/ethernet/ibm/emac/rgmii.c b/drivers/net/ethernet/ibm/emac/rgmii.c
index c47e23d..4fb2f96 100644
--- a/drivers/net/ethernet/ibm/emac/rgmii.c
+++ b/drivers/net/ethernet/ibm/emac/rgmii.c
@@ -24,6 +24,7 @@
 #include <linux/slab.h>
 #include <linux/kernel.h>
 #include <linux/ethtool.h>
+#include <linux/of_address.h>
 #include <asm/io.h>
 
 #include "emac.h"
diff --git a/drivers/net/ethernet/ibm/emac/tah.c b/drivers/net/ethernet/ibm/emac/tah.c
index c231a4a..9f24769 100644
--- a/drivers/net/ethernet/ibm/emac/tah.c
+++ b/drivers/net/ethernet/ibm/emac/tah.c
@@ -18,6 +18,7 @@
  * Free Software Foundation;  either version 2 of the  License, or (at your
  * option) any later version.
  */
+#include <linux/of_address.h>
 #include <asm/io.h>
 
 #include "emac.h"
diff --git a/drivers/net/ethernet/ibm/emac/zmii.c b/drivers/net/ethernet/ibm/emac/zmii.c
index 4cdf286..9ca67a3 100644
--- a/drivers/net/ethernet/ibm/emac/zmii.c
+++ b/drivers/net/ethernet/ibm/emac/zmii.c
@@ -24,6 +24,7 @@
 #include <linux/slab.h>
 #include <linux/kernel.h>
 #include <linux/ethtool.h>
+#include <linux/of_address.h>
 #include <asm/io.h>
 
 #include "emac.h"
diff --git a/drivers/pcmcia/electra_cf.c b/drivers/pcmcia/electra_cf.c
index a007321a..1b206ea 100644
--- a/drivers/pcmcia/electra_cf.c
+++ b/drivers/pcmcia/electra_cf.c
@@ -30,6 +30,8 @@
 #include <linux/interrupt.h>
 #include <linux/mm.h>
 #include <linux/vmalloc.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
 #include <linux/of_platform.h>
 #include <linux/slab.h>
 
diff --git a/drivers/tty/ehv_bytechan.c b/drivers/tty/ehv_bytechan.c
index 9bffcec..0419b69 100644
--- a/drivers/tty/ehv_bytechan.c
+++ b/drivers/tty/ehv_bytechan.c
@@ -32,6 +32,7 @@
 #include <linux/poll.h>
 #include <asm/epapr_hcalls.h>
 #include <linux/of.h>
+#include <linux/of_irq.h>
 #include <linux/platform_device.h>
 #include <linux/cdev.h>
 #include <linux/console.h>
diff --git a/drivers/tty/serial/pmac_zilog.c b/drivers/tty/serial/pmac_zilog.c
index f87f1a0..246b4c3 100644
--- a/drivers/tty/serial/pmac_zilog.c
+++ b/drivers/tty/serial/pmac_zilog.c
@@ -57,6 +57,8 @@
 #include <linux/bitops.h>
 #include <linux/sysrq.h>
 #include <linux/mutex.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
 #include <asm/sections.h>
 #include <asm/io.h>
 #include <asm/irq.h>
diff --git a/drivers/usb/host/ehci-ppc-of.c b/drivers/usb/host/ehci-ppc-of.c
index 932293f..2b1694e 100644
--- a/drivers/usb/host/ehci-ppc-of.c
+++ b/drivers/usb/host/ehci-ppc-of.c
@@ -16,6 +16,8 @@
 #include <linux/signal.h>
 
 #include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
 #include <linux/of_platform.h>
 
 
diff --git a/drivers/usb/host/ohci-ppc-of.c b/drivers/usb/host/ohci-ppc-of.c
index 75f5a1e..81f3eba 100644
--- a/drivers/usb/host/ohci-ppc-of.c
+++ b/drivers/usb/host/ohci-ppc-of.c
@@ -14,6 +14,8 @@
  */
 
 #include <linux/signal.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
 #include <linux/of_platform.h>
 
 #include <asm/prom.h>
diff --git a/sound/aoa/core/gpio-feature.c b/sound/aoa/core/gpio-feature.c
index faa3174..f341539 100644
--- a/sound/aoa/core/gpio-feature.c
+++ b/sound/aoa/core/gpio-feature.c
@@ -10,8 +10,9 @@
  * registers.
  */
 
-#include <asm/pmac_feature.h>
+#include <linux/of_irq.h>
 #include <linux/interrupt.h>
+#include <asm/pmac_feature.h>
 #include "../aoa.h"
 
 /* TODO: these are lots of global variables
diff --git a/sound/aoa/soundbus/i2sbus/core.c b/sound/aoa/soundbus/i2sbus/core.c
index 15e7613..4678360 100644
--- a/sound/aoa/soundbus/i2sbus/core.c
+++ b/sound/aoa/soundbus/i2sbus/core.c
@@ -11,6 +11,8 @@
 #include <linux/pci.h>
 #include <linux/interrupt.h>
 #include <linux/dma-mapping.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
 
 #include <sound/core.h>
 
diff --git a/sound/ppc/pmac.c b/sound/ppc/pmac.c
index c93fbbb..7a43c0c 100644
--- a/sound/ppc/pmac.c
+++ b/sound/ppc/pmac.c
@@ -28,6 +28,8 @@
 #include <linux/interrupt.h>
 #include <linux/pci.h>
 #include <linux/dma-mapping.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
 #include <sound/core.h>
 #include "pmac.h"
 #include <sound/pcm_params.h>
diff --git a/sound/ppc/tumbler.c b/sound/ppc/tumbler.c
index b23354a..b9ffc17 100644
--- a/sound/ppc/tumbler.c
+++ b/sound/ppc/tumbler.c
@@ -31,6 +31,7 @@
 #include <linux/slab.h>
 #include <linux/interrupt.h>
 #include <linux/string.h>
+#include <linux/of_irq.h>
 #include <sound/core.h>
 #include <asm/io.h>
 #include <asm/irq.h>
-- 
1.8.1.2

