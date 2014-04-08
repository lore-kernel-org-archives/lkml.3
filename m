Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756671AbaDHMdK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 08:33:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59356 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756327AbaDHMdI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 08:33:08 -0400
Date: Tue, 8 Apr 2014 14:33:04 +0200
From: Jean Delvare <jdelvare@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Matt Mackall <mpm@selenic.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/3] hw_random: Turn HW_RANDOM into a menuconfig
Message-ID: <20140408143304.65c9deee@endymion.delvare>
In-Reply-To: <20140408142731.48c9f92f@endymion.delvare>
References: <20140408142731.48c9f92f@endymion.delvare>
Organization: SUSE Linux
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes configuration more convenient IMHO, and avoids having to
repeat the dependency on HW_RANDOM for every single driver.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
---
 drivers/char/hw_random/Kconfig |   56 +++++++++++++++++++++--------------------
 1 file changed, 30 insertions(+), 26 deletions(-)

--- linux-3.15-rc0.orig/drivers/char/hw_random/Kconfig	2014-04-08 13:12:50.845233756 +0200
+++ linux-3.15-rc0/drivers/char/hw_random/Kconfig	2014-04-08 13:21:15.503752935 +0200
@@ -2,7 +2,7 @@
 # Hardware Random Number Generator (RNG) configuration
 #
 
-config HW_RANDOM
+menuconfig HW_RANDOM
 	tristate "Hardware Random Number Generator Core support"
 	default m
 	---help---
@@ -20,9 +20,11 @@ config HW_RANDOM
 
 	  If unsure, say Y.
 
+if HW_RANDOM
+
 config HW_RANDOM_TIMERIOMEM
 	tristate "Timer IOMEM HW Random Number Generator support"
-	depends on HW_RANDOM && HAS_IOMEM
+	depends on HAS_IOMEM
 	---help---
 	  This driver provides kernel-side support for a generic Random
 	  Number Generator used by reading a 'dumb' iomem address that
@@ -36,7 +38,7 @@ config HW_RANDOM_TIMERIOMEM
 
 config HW_RANDOM_INTEL
 	tristate "Intel HW Random Number Generator support"
-	depends on HW_RANDOM && (X86 || IA64) && PCI
+	depends on (X86 || IA64) && PCI
 	default HW_RANDOM
 	---help---
 	  This driver provides kernel-side support for the Random Number
@@ -49,7 +51,7 @@ config HW_RANDOM_INTEL
 
 config HW_RANDOM_AMD
 	tristate "AMD HW Random Number Generator support"
-	depends on HW_RANDOM && (X86 || PPC_MAPLE) && PCI
+	depends on (X86 || PPC_MAPLE) && PCI
 	default HW_RANDOM
 	---help---
 	  This driver provides kernel-side support for the Random Number
@@ -62,7 +64,7 @@ config HW_RANDOM_AMD
 
 config HW_RANDOM_ATMEL
 	tristate "Atmel Random Number Generator support"
-	depends on HW_RANDOM && HAVE_CLK
+	depends on HAVE_CLK
 	default (HW_RANDOM && ARCH_AT91)
 	---help---
 	  This driver provides kernel-side support for the Random Number
@@ -75,7 +77,7 @@ config HW_RANDOM_ATMEL
 
 config HW_RANDOM_BCM63XX
 	tristate "Broadcom BCM63xx Random Number Generator support"
-	depends on HW_RANDOM && BCM63XX
+	depends on BCM63XX
 	default HW_RANDOM
 	---help---
 	  This driver provides kernel-side support for the Random Number
@@ -88,7 +90,7 @@ config HW_RANDOM_BCM63XX
 
 config HW_RANDOM_BCM2835
 	tristate "Broadcom BCM2835 Random Number Generator support"
-	depends on HW_RANDOM && ARCH_BCM2835
+	depends on ARCH_BCM2835
 	default HW_RANDOM
 	---help---
 	  This driver provides kernel-side support for the Random Number
@@ -101,7 +103,7 @@ config HW_RANDOM_BCM2835
 
 config HW_RANDOM_GEODE
 	tristate "AMD Geode HW Random Number Generator support"
-	depends on HW_RANDOM && X86_32 && PCI
+	depends on X86_32 && PCI
 	default HW_RANDOM
 	---help---
 	  This driver provides kernel-side support for the Random Number
@@ -114,7 +116,7 @@ config HW_RANDOM_GEODE
 
 config HW_RANDOM_N2RNG
 	tristate "Niagara2 Random Number Generator support"
-	depends on HW_RANDOM && SPARC64
+	depends on SPARC64
 	default HW_RANDOM
 	---help---
 	  This driver provides kernel-side support for the Random Number
@@ -127,7 +129,7 @@ config HW_RANDOM_N2RNG
 
 config HW_RANDOM_VIA
 	tristate "VIA HW Random Number Generator support"
-	depends on HW_RANDOM && X86
+	depends on X86
 	default HW_RANDOM
 	---help---
 	  This driver provides kernel-side support for the Random Number
@@ -140,7 +142,7 @@ config HW_RANDOM_VIA
 
 config HW_RANDOM_IXP4XX
 	tristate "Intel IXP4xx NPU HW Pseudo-Random Number Generator support"
-	depends on HW_RANDOM && ARCH_IXP4XX
+	depends on ARCH_IXP4XX
 	default HW_RANDOM
 	---help---
 	  This driver provides kernel-side support for the Pseudo-Random
@@ -153,7 +155,7 @@ config HW_RANDOM_IXP4XX
 
 config HW_RANDOM_OMAP
 	tristate "OMAP Random Number Generator support"
-	depends on HW_RANDOM && (ARCH_OMAP16XX || ARCH_OMAP2PLUS)
+	depends on ARCH_OMAP16XX || ARCH_OMAP2PLUS
 	default HW_RANDOM
  	---help---
  	  This driver provides kernel-side support for the Random Number
@@ -167,7 +169,7 @@ config HW_RANDOM_OMAP
 
 config HW_RANDOM_OMAP3_ROM
 	tristate "OMAP3 ROM Random Number Generator support"
-	depends on HW_RANDOM && ARCH_OMAP3
+	depends on ARCH_OMAP3
 	default HW_RANDOM
 	---help---
 	  This driver provides kernel-side support for the Random Number
@@ -180,7 +182,7 @@ config HW_RANDOM_OMAP3_ROM
 
 config HW_RANDOM_OCTEON
 	tristate "Octeon Random Number Generator support"
-	depends on HW_RANDOM && CAVIUM_OCTEON_SOC
+	depends on CAVIUM_OCTEON_SOC
 	default HW_RANDOM
 	---help---
 	  This driver provides kernel-side support for the Random Number
@@ -193,7 +195,7 @@ config HW_RANDOM_OCTEON
 
 config HW_RANDOM_PASEMI
 	tristate "PA Semi HW Random Number Generator support"
-	depends on HW_RANDOM && PPC_PASEMI
+	depends on PPC_PASEMI
 	default HW_RANDOM
 	---help---
 	  This driver provides kernel-side support for the Random Number
@@ -206,7 +208,7 @@ config HW_RANDOM_PASEMI
 
 config HW_RANDOM_VIRTIO
 	tristate "VirtIO Random Number Generator support"
-	depends on HW_RANDOM && VIRTIO
+	depends on VIRTIO
 	---help---
 	  This driver provides kernel-side support for the virtual Random Number
 	  Generator hardware.
@@ -216,7 +218,7 @@ config HW_RANDOM_VIRTIO
 
 config HW_RANDOM_TX4939
 	tristate "TX4939 Random Number Generator support"
-	depends on HW_RANDOM && SOC_TX4939
+	depends on SOC_TX4939
 	default HW_RANDOM
 	---help---
 	  This driver provides kernel-side support for the Random Number
@@ -229,7 +231,7 @@ config HW_RANDOM_TX4939
 
 config HW_RANDOM_MXC_RNGA
 	tristate "Freescale i.MX RNGA Random Number Generator"
-	depends on HW_RANDOM && ARCH_HAS_RNGA
+	depends on ARCH_HAS_RNGA
 	---help---
 	  This driver provides kernel-side support for the Random Number
 	  Generator hardware found on Freescale i.MX processors.
@@ -241,7 +243,7 @@ config HW_RANDOM_MXC_RNGA
 
 config HW_RANDOM_NOMADIK
 	tristate "ST-Ericsson Nomadik Random Number Generator support"
-	depends on HW_RANDOM && ARCH_NOMADIK
+	depends on ARCH_NOMADIK
 	---help---
 	  This driver provides kernel-side support for the Random Number
 	  Generator hardware found on ST-Ericsson SoCs (8815 and 8500).
@@ -253,7 +255,7 @@ config HW_RANDOM_NOMADIK
 
 config HW_RANDOM_PICOXCELL
 	tristate "Picochip picoXcell true random number generator support"
-	depends on HW_RANDOM && ARCH_PICOXCELL && PICOXCELL_PC3X3
+	depends on ARCH_PICOXCELL && PICOXCELL_PC3X3
 	---help---
 	  This driver provides kernel-side support for the Random Number
 	  Generator hardware found on Picochip PC3x3 and later devices.
@@ -265,7 +267,7 @@ config HW_RANDOM_PICOXCELL
 
 config HW_RANDOM_PPC4XX
 	tristate "PowerPC 4xx generic true random number generator support"
-	depends on HW_RANDOM && PPC && 4xx
+	depends on PPC && 4xx
 	---help---
 	 This driver provides the kernel-side support for the TRNG hardware
 	 found in the security function of some PowerPC 4xx SoCs.
@@ -277,7 +279,7 @@ config HW_RANDOM_PPC4XX
 
 config HW_RANDOM_PSERIES
 	tristate "pSeries HW Random Number Generator support"
-	depends on HW_RANDOM && PPC64 && IBMVIO
+	depends on PPC64 && IBMVIO
 	default HW_RANDOM
 	---help---
 	  This driver provides kernel-side support for the Random Number
@@ -290,7 +292,7 @@ config HW_RANDOM_PSERIES
 
 config HW_RANDOM_POWERNV
 	tristate "PowerNV Random Number Generator support"
-	depends on HW_RANDOM && PPC_POWERNV
+	depends on PPC_POWERNV
 	default HW_RANDOM
 	---help---
 	  This is the driver for Random Number Generator hardware found
@@ -303,7 +305,7 @@ config HW_RANDOM_POWERNV
 
 config HW_RANDOM_EXYNOS
 	tristate "EXYNOS HW random number generator support"
-	depends on HW_RANDOM && HAS_IOMEM && HAVE_CLK
+	depends on HAS_IOMEM && HAVE_CLK
 	---help---
 	  This driver provides kernel-side support for the Random Number
 	  Generator hardware found on EXYNOS SOCs.
@@ -315,7 +317,7 @@ config HW_RANDOM_EXYNOS
 
 config HW_RANDOM_TPM
 	tristate "TPM HW Random Number Generator support"
-	depends on HW_RANDOM && TCG_TPM
+	depends on TCG_TPM
 	default HW_RANDOM
 	---help---
 	  This driver provides kernel-side support for the Random Number
@@ -328,7 +330,7 @@ config HW_RANDOM_TPM
 
 config HW_RANDOM_MSM
 	tristate "Qualcomm SoCs Random Number Generator support"
-	depends on HW_RANDOM && ARCH_QCOM
+	depends on ARCH_QCOM
 	---help---
 	  This driver provides kernel-side support for the Random Number
 	  Generator hardware found on Qualcomm SoCs.
@@ -338,6 +340,8 @@ config HW_RANDOM_MSM
 
 	  If unsure, say Y.
 
+endif # HW_RANDOM
+
 config UML_RANDOM
 	depends on UML
 	tristate "Hardware random number generator"

-- 
Jean Delvare
SUSE L3 Support
