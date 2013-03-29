Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501Ab3C2NHz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 09:07:55 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:58941 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755370Ab3C2NHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 09:07:49 -0400
From: Alexandre Courbot <gnurou@gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Romain Naour <romain.naour@openwide.fr>
Cc: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, gnurou@gmail.com,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH 2/3] Remove GENERIC_GPIO config option
Date: Fri, 29 Mar 2013 06:11:17 -0700
Message-Id: <1364562678-8945-3-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.2
In-Reply-To: <1364562678-8945-1-git-send-email-acourbot@nvidia.com>
References: <1364562678-8945-1-git-send-email-acourbot@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GENERIC_GPIO has been made equivalent to GPIOLIB in architecture code
and all driver code has been switch to depend on GPIOLIB. It is thus
safe to have GENERIC_GPIO removed.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 Documentation/gpio.txt      | 10 +++++-----
 arch/alpha/Kconfig          |  3 ---
 arch/arm/Kconfig            |  3 ---
 arch/arm/plat-orion/gpio.c  |  2 +-
 arch/arm64/Kconfig          |  3 ---
 arch/avr32/Kconfig          |  3 ---
 arch/blackfin/Kconfig       |  3 ---
 arch/hexagon/Kconfig        |  3 ---
 arch/ia64/Kconfig           |  3 ---
 arch/m68k/Kconfig           |  3 ---
 arch/metag/Kconfig          |  3 ---
 arch/microblaze/Kconfig     |  3 ---
 arch/mips/Kconfig           |  3 ---
 arch/openrisc/Kconfig       |  3 ---
 arch/powerpc/Kconfig        |  5 -----
 arch/sh/Kconfig             |  3 ---
 arch/sparc/Kconfig          |  5 -----
 arch/unicore32/Kconfig      |  3 ---
 arch/x86/Kconfig            |  3 ---
 arch/xtensa/Kconfig         |  3 ---
 drivers/gpio/Kconfig        |  1 -
 drivers/gpio/gpio-lpc32xx.c |  2 +-
 22 files changed, 7 insertions(+), 66 deletions(-)

diff --git a/Documentation/gpio.txt b/Documentation/gpio.txt
index 77a1d11..6f83fa9 100644
--- a/Documentation/gpio.txt
+++ b/Documentation/gpio.txt
@@ -72,11 +72,11 @@ in this document, but drivers acting as clients to the GPIO interface must
 not care how it's implemented.)
 
 That said, if the convention is supported on their platform, drivers should
-use it when possible.  Platforms must declare GENERIC_GPIO support in their
-Kconfig (boolean true), and provide an <asm/gpio.h> file.  Drivers that can't
-work without standard GPIO calls should have Kconfig entries which depend
-on GENERIC_GPIO.  The GPIO calls are available, either as "real code" or as
-optimized-away stubs, when drivers use the include file:
+use it when possible.  Platforms must select ARCH_REQUIRE_GPIOLIB or
+ARCH_WANT_OPTIONAL_GPIOLIB in their Kconfig.  Drivers that can't work without
+standard GPIO calls should have Kconfig entries which depend on GPIOLIB.  The
+GPIO calls are available, either as "real code" or as optimized-away stubs,
+when drivers use the include file:
 
 	#include <linux/gpio.h>
 
diff --git a/arch/alpha/Kconfig b/arch/alpha/Kconfig
index 8a33ba0..282ff37 100644
--- a/arch/alpha/Kconfig
+++ b/arch/alpha/Kconfig
@@ -56,9 +56,6 @@ config GENERIC_CALIBRATE_DELAY
 	bool
 	default y
 
-config GENERIC_GPIO
-	bool
-
 config ZONE_DMA
 	bool
 	default y
diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 13b7394..ceac9a4 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -107,9 +107,6 @@ config MIGHT_HAVE_PCI
 config SYS_SUPPORTS_APM_EMULATION
 	bool
 
-config GENERIC_GPIO
-	bool
-
 config HAVE_TCM
 	bool
 	select GENERIC_ALLOCATOR
diff --git a/arch/arm/plat-orion/gpio.c b/arch/arm/plat-orion/gpio.c
index c29ee7e..59ddf4d 100644
--- a/arch/arm/plat-orion/gpio.c
+++ b/arch/arm/plat-orion/gpio.c
@@ -150,7 +150,7 @@ err_out:
 }
 
 /*
- * GENERIC_GPIO primitives.
+ * GPIO primitives.
  */
 static int orion_gpio_request(struct gpio_chip *chip, unsigned pin)
 {
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 9b6d19f..e6e7007 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -92,9 +92,6 @@ config SWIOTLB
 config IOMMU_HELPER
 	def_bool SWIOTLB
 
-config GENERIC_GPIO
-	bool
-
 source "init/Kconfig"
 
 source "kernel/Kconfig.freezer"
diff --git a/arch/avr32/Kconfig b/arch/avr32/Kconfig
index d22c6b4..ff775b8 100644
--- a/arch/avr32/Kconfig
+++ b/arch/avr32/Kconfig
@@ -26,9 +26,6 @@ config AVR32
 	  There is an AVR32 Linux project with a web page at
 	  http://avr32linux.org/.
 
-config GENERIC_GPIO
-	def_bool n
-
 config STACKTRACE_SUPPORT
 	def_bool y
 
diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index 20e203a..71dd50b 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -55,9 +55,6 @@ config GENERIC_BUG
 config ZONE_DMA
 	def_bool y
 
-config GENERIC_GPIO
-	def_bool n
-
 config FORCE_MAX_ZONEORDER
 	int
 	default "14"
diff --git a/arch/hexagon/Kconfig b/arch/hexagon/Kconfig
index e4decc6..21d6ba9 100644
--- a/arch/hexagon/Kconfig
+++ b/arch/hexagon/Kconfig
@@ -170,9 +170,6 @@ source "mm/Kconfig"
 
 source "kernel/Kconfig.hz"
 
-config GENERIC_GPIO
-	def_bool n
-
 endmenu
 
 source "init/Kconfig"
diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
index 9a02f71..38ef339 100644
--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -101,9 +101,6 @@ config GENERIC_CALIBRATE_DELAY
 config HAVE_SETUP_PER_CPU_AREA
 	def_bool y
 
-config GENERIC_GPIO
-	bool
-
 config DMI
 	bool
 	default y
diff --git a/arch/m68k/Kconfig b/arch/m68k/Kconfig
index 6de8133..821170e 100644
--- a/arch/m68k/Kconfig
+++ b/arch/m68k/Kconfig
@@ -35,9 +35,6 @@ config ARCH_HAS_ILOG2_U32
 config ARCH_HAS_ILOG2_U64
 	bool
 
-config GENERIC_GPIO
-	bool
-
 config GENERIC_HWEIGHT
 	bool
 	default y
diff --git a/arch/metag/Kconfig b/arch/metag/Kconfig
index afc8973..0e97f5c5 100644
--- a/arch/metag/Kconfig
+++ b/arch/metag/Kconfig
@@ -54,9 +54,6 @@ config GENERIC_HWEIGHT
 config GENERIC_CALIBRATE_DELAY
 	def_bool y
 
-config GENERIC_GPIO
-	def_bool n
-
 config NO_IOPORT
 	def_bool y
 
diff --git a/arch/microblaze/Kconfig b/arch/microblaze/Kconfig
index 1323fa2..4fb682a 100644
--- a/arch/microblaze/Kconfig
+++ b/arch/microblaze/Kconfig
@@ -56,9 +56,6 @@ config GENERIC_HWEIGHT
 config GENERIC_CALIBRATE_DELAY
 	def_bool y
 
-config GENERIC_GPIO
-	bool
-
 config GENERIC_CSUM
 	def_bool y
 
diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index ff0e563..5393981 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -1004,9 +1004,6 @@ config GENERIC_ISA_DMA_SUPPORT_BROKEN
 config ISA_DMA_API
 	bool
 
-config GENERIC_GPIO
-	bool
-
 config HOLES_IN_ZONE
 	bool
 
diff --git a/arch/openrisc/Kconfig b/arch/openrisc/Kconfig
index e324402..6c404ee 100644
--- a/arch/openrisc/Kconfig
+++ b/arch/openrisc/Kconfig
@@ -44,9 +44,6 @@ config GENERIC_HWEIGHT
 config NO_IOPORT
 	def_bool y
 
-config GENERIC_GPIO
-	def_bool n
-
 config TRACE_IRQFLAGS_SUPPORT
         def_bool y
 
diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index ea5bb04..9c5bc68 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -82,11 +82,6 @@ config GENERIC_HWEIGHT
 	bool
 	default y
 
-config GENERIC_GPIO
-	bool
-	help
-	  Generic GPIO API support
-
 config PPC
 	bool
 	default y
diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index 5e85963..f9391a6 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -92,9 +92,6 @@ config GENERIC_CSUM
 config GENERIC_HWEIGHT
 	def_bool y
 
-config GENERIC_GPIO
-	def_bool n
-
 config GENERIC_CALIBRATE_DELAY
 	bool
 
diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 3d361f2..90b3a0f 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -135,11 +135,6 @@ config GENERIC_ISA_DMA
 	bool
 	default y if SPARC32
 
-config GENERIC_GPIO
-	bool
-	help
-	  Generic GPIO API support
-
 config ARCH_SUPPORTS_DEBUG_PAGEALLOC
 	def_bool y if SPARC64
 
diff --git a/arch/unicore32/Kconfig b/arch/unicore32/Kconfig
index 468cd70..41bcc00 100644
--- a/arch/unicore32/Kconfig
+++ b/arch/unicore32/Kconfig
@@ -23,9 +23,6 @@ config UNICORE32
 	  designs licensed by PKUnity Ltd.
 	  Please see web page at <http://www.pkunity.com/>.
 
-config GENERIC_GPIO
-	bool
-
 config GENERIC_CSUM
 	def_bool y
 
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 70c0f3d..a6298c2 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -172,9 +172,6 @@ config GENERIC_BUG_RELATIVE_POINTERS
 config GENERIC_HWEIGHT
 	def_bool y
 
-config GENERIC_GPIO
-	bool
-
 config ARCH_MAY_HAVE_PC_FDC
 	def_bool y
 	depends on ISA_DMA_API
diff --git a/arch/xtensa/Kconfig b/arch/xtensa/Kconfig
index b09de49..acdfc61 100644
--- a/arch/xtensa/Kconfig
+++ b/arch/xtensa/Kconfig
@@ -33,9 +33,6 @@ config RWSEM_XCHGADD_ALGORITHM
 config GENERIC_HWEIGHT
 	def_bool y
 
-config GENERIC_GPIO
-	bool
-
 config ARCH_HAS_ILOG2_U32
 	def_bool n
 
diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 93aaadf..5d53aba 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -38,7 +38,6 @@ config GPIO_DEVRES
 menuconfig GPIOLIB
 	bool "GPIO Support"
 	depends on ARCH_WANT_OPTIONAL_GPIOLIB || ARCH_REQUIRE_GPIOLIB
-	select GENERIC_GPIO
 	help
 	  This enables GPIO support through the generic GPIO library.
 	  You only need to enable this, if you also want to enable
diff --git a/drivers/gpio/gpio-lpc32xx.c b/drivers/gpio/gpio-lpc32xx.c
index 36d7dee..4ad9c6b 100644
--- a/drivers/gpio/gpio-lpc32xx.c
+++ b/drivers/gpio/gpio-lpc32xx.c
@@ -255,7 +255,7 @@ static int __get_gpo_state_p3(struct lpc32xx_gpio_chip *group,
 }
 
 /*
- * GENERIC_GPIO primitives.
+ * GPIO primitives.
  */
 static int lpc32xx_gpio_dir_input_p012(struct gpio_chip *chip,
 	unsigned pin)
-- 
1.8.2

