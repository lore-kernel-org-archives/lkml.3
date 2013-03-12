Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932613Ab3CLKOQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 06:14:16 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:4017 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755076Ab3CLKOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 06:14:12 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 12 Mar 2013 03:13:57 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Mike Frysinger <vapier@gentoo.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Ralf Baechle <ralf@linux-mips.org>, Jonas Bonn <jonas@southpole.se>,
        Josh Boyer <jwboyer@gmail.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        Vitaly Bordug <vitb@kernel.crashing.org>,
        Marcelo Tosatti <marcelo@kvack.org>, Paul Mundt <lethal@linux-sh.org>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>, Chris Zankel <chris@zankel.net>,
        Max Filippov <jcmvbkbc@gmail.com>
CC: Alexandre Courbot <gnurou@gmail.com>, <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [RFC 08/17] powerpc: remove redundant GENERIC_GPIO selection
Date: Tue, 12 Mar 2013 19:12:21 +0900
Message-ID: <1363083150-30964-9-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1363083150-30964-1-git-send-email-acourbot@nvidia.com>
References: <1363083150-30964-1-git-send-email-acourbot@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GENERIC_GPIO was explicitly selected along with ARCH_REQUIRE_GPIOLIB,
which itself selects GENERIC_GPIO.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 arch/powerpc/platforms/40x/Kconfig  | 1 -
 arch/powerpc/platforms/44x/Kconfig  | 1 -
 arch/powerpc/platforms/85xx/Kconfig | 1 -
 arch/powerpc/platforms/86xx/Kconfig | 3 ---
 arch/powerpc/platforms/8xx/Kconfig  | 1 -
 arch/powerpc/platforms/Kconfig      | 4 ----
 6 files changed, 11 deletions(-)

diff --git a/arch/powerpc/platforms/40x/Kconfig b/arch/powerpc/platforms/40x/Kconfig
index a392d12..d0b46a2 100644
--- a/arch/powerpc/platforms/40x/Kconfig
+++ b/arch/powerpc/platforms/40x/Kconfig
@@ -145,7 +145,6 @@ config PPC4xx_GPIO
 	bool "PPC4xx GPIO support"
 	depends on 40x
 	select ARCH_REQUIRE_GPIOLIB
-	select GENERIC_GPIO
 	help
 	  Enable gpiolib support for ppc40x based boards
 
diff --git a/arch/powerpc/platforms/44x/Kconfig b/arch/powerpc/platforms/44x/Kconfig
index 0effe9f..50306b8 100644
--- a/arch/powerpc/platforms/44x/Kconfig
+++ b/arch/powerpc/platforms/44x/Kconfig
@@ -248,7 +248,6 @@ config PPC4xx_GPIO
 	bool "PPC4xx GPIO support"
 	depends on 44x
 	select ARCH_REQUIRE_GPIOLIB
-	select GENERIC_GPIO
 	help
 	  Enable gpiolib support for ppc440 based boards
 
diff --git a/arch/powerpc/platforms/85xx/Kconfig b/arch/powerpc/platforms/85xx/Kconfig
index a0dcd57..78549b6 100644
--- a/arch/powerpc/platforms/85xx/Kconfig
+++ b/arch/powerpc/platforms/85xx/Kconfig
@@ -203,7 +203,6 @@ config GE_IMP3A
 	select DEFAULT_UIMAGE
 	select SWIOTLB
 	select MMIO_NVRAM
-	select GENERIC_GPIO
 	select ARCH_REQUIRE_GPIOLIB
 	select GE_FPGA
 	help
diff --git a/arch/powerpc/platforms/86xx/Kconfig b/arch/powerpc/platforms/86xx/Kconfig
index 7a6279e..1afd1e4 100644
--- a/arch/powerpc/platforms/86xx/Kconfig
+++ b/arch/powerpc/platforms/86xx/Kconfig
@@ -37,7 +37,6 @@ config GEF_PPC9A
 	bool "GE PPC9A"
 	select DEFAULT_UIMAGE
 	select MMIO_NVRAM
-	select GENERIC_GPIO
 	select ARCH_REQUIRE_GPIOLIB
 	select GE_FPGA
 	help
@@ -47,7 +46,6 @@ config GEF_SBC310
 	bool "GE SBC310"
 	select DEFAULT_UIMAGE
 	select MMIO_NVRAM
-	select GENERIC_GPIO
 	select ARCH_REQUIRE_GPIOLIB
 	select GE_FPGA
 	help
@@ -57,7 +55,6 @@ config GEF_SBC610
 	bool "GE SBC610"
 	select DEFAULT_UIMAGE
 	select MMIO_NVRAM
-	select GENERIC_GPIO
 	select ARCH_REQUIRE_GPIOLIB
 	select GE_FPGA
 	select HAS_RAPIDIO
diff --git a/arch/powerpc/platforms/8xx/Kconfig b/arch/powerpc/platforms/8xx/Kconfig
index 1fb0b3c..8dec3c0 100644
--- a/arch/powerpc/platforms/8xx/Kconfig
+++ b/arch/powerpc/platforms/8xx/Kconfig
@@ -114,7 +114,6 @@ config 8xx_COPYBACK
 
 config 8xx_GPIO
 	bool "GPIO API Support"
-	select GENERIC_GPIO
 	select ARCH_REQUIRE_GPIOLIB
 	help
 	  Saying Y here will cause the ports on an MPC8xx processor to be used
diff --git a/arch/powerpc/platforms/Kconfig b/arch/powerpc/platforms/Kconfig
index 52de8bc..15095d5 100644
--- a/arch/powerpc/platforms/Kconfig
+++ b/arch/powerpc/platforms/Kconfig
@@ -303,7 +303,6 @@ config QUICC_ENGINE
 config QE_GPIO
 	bool "QE GPIO support"
 	depends on QUICC_ENGINE
-	select GENERIC_GPIO
 	select ARCH_REQUIRE_GPIOLIB
 	help
 	  Say Y here if you're going to use hardware that connects to the
@@ -316,7 +315,6 @@ config CPM2
 	select PPC_LIB_RHEAP
 	select PPC_PCI_CHOICE
 	select ARCH_REQUIRE_GPIOLIB
-	select GENERIC_GPIO
 	help
 	  The CPM2 (Communications Processor Module) is a coprocessor on
 	  embedded CPUs made by Freescale.  Selecting this option means that
@@ -355,7 +353,6 @@ config OF_RTC
 config SIMPLE_GPIO
 	bool "Support for simple, memory-mapped GPIO controllers"
 	depends on PPC
-	select GENERIC_GPIO
 	select ARCH_REQUIRE_GPIOLIB
 	help
 	  Say Y here to support simple, memory-mapped GPIO controllers.
@@ -366,7 +363,6 @@ config SIMPLE_GPIO
 config MCU_MPC8349EMITX
 	bool "MPC8349E-mITX MCU driver"
 	depends on I2C=y && PPC_83xx
-	select GENERIC_GPIO
 	select ARCH_REQUIRE_GPIOLIB
 	help
 	  Say Y here to enable soft power-off functionality on the Freescale
-- 
1.8.1.5

