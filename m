Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756773AbaDHMgn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 08:36:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59423 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756207AbaDHMgl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 08:36:41 -0400
Date: Tue, 8 Apr 2014 14:36:37 +0200
From: Jean Delvare <jdelvare@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kukjin Kim <kgene.kim@samsung.com>, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 3/3] hw_random: Fix a few driver dependencies and defaults
Message-ID: <20140408143637.6d3be0d0@endymion.delvare>
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

HW_RANDOM_ATMEL should not only default to ARCH_AT91, it should depend
on it. This driver is useless on other architectures.

Likewise, HW_RANDOM_EXYNOS should depend on ARCH_EXYNOS, as it it
useless on other architectures.

Also set the default to HW_RANDOM for the few architecture-specific
drivers which didn't have it yet, for consistency.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Kukjin Kim <kgene.kim@samsung.com>
---
Note: untested, as I don't have any of the hardware in question.

 drivers/char/hw_random/Kconfig |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- linux-3.15-rc0.orig/drivers/char/hw_random/Kconfig	2014-04-08 13:21:15.503752935 +0200
+++ linux-3.15-rc0/drivers/char/hw_random/Kconfig	2014-04-08 13:43:43.440081827 +0200
@@ -64,8 +64,8 @@ config HW_RANDOM_AMD
 
 config HW_RANDOM_ATMEL
 	tristate "Atmel Random Number Generator support"
-	depends on HAVE_CLK
-	default (HW_RANDOM && ARCH_AT91)
+	depends on ARCH_AT91 && HAVE_CLK
+	default HW_RANDOM
 	---help---
 	  This driver provides kernel-side support for the Random Number
 	  Generator hardware found on Atmel AT91 devices.
@@ -232,6 +232,7 @@ config HW_RANDOM_TX4939
 config HW_RANDOM_MXC_RNGA
 	tristate "Freescale i.MX RNGA Random Number Generator"
 	depends on ARCH_HAS_RNGA
+	default HW_RANDOM
 	---help---
 	  This driver provides kernel-side support for the Random Number
 	  Generator hardware found on Freescale i.MX processors.
@@ -244,6 +245,7 @@ config HW_RANDOM_MXC_RNGA
 config HW_RANDOM_NOMADIK
 	tristate "ST-Ericsson Nomadik Random Number Generator support"
 	depends on ARCH_NOMADIK
+	default HW_RANDOM
 	---help---
 	  This driver provides kernel-side support for the Random Number
 	  Generator hardware found on ST-Ericsson SoCs (8815 and 8500).
@@ -256,6 +258,7 @@ config HW_RANDOM_NOMADIK
 config HW_RANDOM_PICOXCELL
 	tristate "Picochip picoXcell true random number generator support"
 	depends on ARCH_PICOXCELL && PICOXCELL_PC3X3
+	default HW_RANDOM
 	---help---
 	  This driver provides kernel-side support for the Random Number
 	  Generator hardware found on Picochip PC3x3 and later devices.
@@ -268,6 +271,7 @@ config HW_RANDOM_PICOXCELL
 config HW_RANDOM_PPC4XX
 	tristate "PowerPC 4xx generic true random number generator support"
 	depends on PPC && 4xx
+	default HW_RANDOM
 	---help---
 	 This driver provides the kernel-side support for the TRNG hardware
 	 found in the security function of some PowerPC 4xx SoCs.
@@ -305,7 +309,8 @@ config HW_RANDOM_POWERNV
 
 config HW_RANDOM_EXYNOS
 	tristate "EXYNOS HW random number generator support"
-	depends on HAS_IOMEM && HAVE_CLK
+	depends on ARCH_EXYNOS
+	default HW_RANDOM
 	---help---
 	  This driver provides kernel-side support for the Random Number
 	  Generator hardware found on EXYNOS SOCs.
@@ -331,6 +336,7 @@ config HW_RANDOM_TPM
 config HW_RANDOM_MSM
 	tristate "Qualcomm SoCs Random Number Generator support"
 	depends on ARCH_QCOM
+	default HW_RANDOM
 	---help---
 	  This driver provides kernel-side support for the Random Number
 	  Generator hardware found on Qualcomm SoCs.

-- 
Jean Delvare
SUSE L3 Support
