Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159AbaIZKH5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 06:07:57 -0400
Received: from mga14.intel.com ([192.55.52.115]:7420 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755134AbaIZKHz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 06:07:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="391941553"
From: Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Mika Westerberg <mika.westerberg@intel.com>,
        Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>,
        GPIO Subsystem Mailing List <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCHv2 2/3] gpio: sch: Add support for Intel Quark X1000 SoC
Date: Fri, 26 Sep 2014 18:07:26 +0800
Message-Id: <1411726047-3224-3-git-send-email-rebecca.swee.fun.chang@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1411726047-3224-1-git-send-email-rebecca.swee.fun.chang@intel.com>
References: <1411726047-3224-1-git-send-email-rebecca.swee.fun.chang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Intel Quark X1000 provides a total of 16 GPIOs. The GPIOs are split between
the legacy I/O bridge and the GPIO controller.

GPIO-SCH is the GPIO pins on legacy bridge for Intel Quark SoC.
Intel Quark X1000 has 2 GPIOs powered by the core power well and 6 from
the suspend power well.

This piece of work is derived from Dan O'Donovan's initial work for Quark
X1000 enabling.

Signed-off-by: Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
---
 drivers/gpio/Kconfig    |   11 +++++++++--
 drivers/gpio/gpio-sch.c |    6 ++++++
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 690904a..64683a9 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -356,25 +356,32 @@ config GPIO_VR41XX
 	  Say yes here to support the NEC VR4100 series General-purpose I/O Uint
 
 config GPIO_SCH
-	tristate "Intel SCH/TunnelCreek/Centerton GPIO"
+	tristate "Intel SCH/TunnelCreek/Centerton/Quark X1000 GPIO"
 	depends on PCI && X86
 	select MFD_CORE
 	select LPC_SCH
 	help
 	  Say yes here to support GPIO interface on Intel Poulsbo SCH,
-	  Intel Tunnel Creek processor or Intel Centerton processor.
+	  Intel Tunnel Creek processor, Intel Centerton processor or
+	  Intel Quark X1000 SoC.
+
 	  The Intel SCH contains a total of 14 GPIO pins. Ten GPIOs are
 	  powered by the core power rail and are turned off during sleep
 	  modes (S3 and higher). The remaining four GPIOs are powered by
 	  the Intel SCH suspend power supply. These GPIOs remain
 	  active during S3. The suspend powered GPIOs can be used to wake the
 	  system from the Suspend-to-RAM state.
+
 	  The Intel Tunnel Creek processor has 5 GPIOs powered by the
 	  core power rail and 9 from suspend power supply.
+
 	  The Intel Centerton processor has a total of 30 GPIO pins.
 	  Twenty-one are powered by the core power rail and 9 from the
 	  suspend power supply.
 
+	  The Intel Quark X1000 SoC has 2 GPIOs powered by the core
+	  power well and 6 from the suspend power well.
+
 config GPIO_ICH
 	tristate "Intel ICH GPIO"
 	depends on PCI && X86
diff --git a/drivers/gpio/gpio-sch.c b/drivers/gpio/gpio-sch.c
index 6e89be9..952990f 100644
--- a/drivers/gpio/gpio-sch.c
+++ b/drivers/gpio/gpio-sch.c
@@ -241,6 +241,12 @@ static int sch_gpio_probe(struct platform_device *pdev)
 		sch->chip.ngpio = 30;
 		break;
 
+	case PCI_DEVICE_ID_INTEL_QUARK_X1000_ILB:
+		sch->core_base = 0;
+		sch->resume_base = 2;
+		sch->chip.ngpio = 8;
+		break;
+
 	default:
 		return -ENODEV;
 	}
-- 
1.7.9.5

