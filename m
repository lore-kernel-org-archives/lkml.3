Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755679Ab3C2NI3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 09:08:29 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:63747 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754833Ab3C2NHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 09:07:51 -0400
From: Alexandre Courbot <gnurou@gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Romain Naour <romain.naour@openwide.fr>
Cc: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, gnurou@gmail.com,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH 3/3] Rename CONFIG_GPIOLIB to CONFIG_GPIO
Date: Fri, 29 Mar 2013 06:11:18 -0700
Message-Id: <1364562678-8945-4-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.2
In-Reply-To: <1364562678-8945-1-git-send-email-acourbot@nvidia.com>
References: <1364562678-8945-1-git-send-email-acourbot@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The removal of CONFIG_GENERIC_GPIO turned gpiolib into the only way to
implement the generic GPIO API, effectively making it the "GPIO
framework".

This patch tries to reflect this reality by changing occurences of
GPIOLIB into the simpler GPIO in various places (notable configuration
options) and updating the documentation.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 Documentation/gpio.txt                            | 47 +++++++----------
 Documentation/zh_CN/gpio.txt                      |  6 +--
 arch/alpha/Kconfig                                |  2 +-
 arch/arm/Kconfig                                  | 64 +++++++++++------------
 arch/arm/configs/kzm9d_defconfig                  |  2 +-
 arch/arm/configs/mvebu_defconfig                  |  2 +-
 arch/arm/configs/realview-smp_defconfig           |  2 +-
 arch/arm/configs/realview_defconfig               |  2 +-
 arch/arm/mach-bcm/Kconfig                         |  2 +-
 arch/arm/mach-highbank/Kconfig                    |  2 +-
 arch/arm/mach-imx/Kconfig                         |  2 +-
 arch/arm/mach-omap2/Kconfig                       |  2 +-
 arch/arm/mach-picoxcell/Kconfig                   |  2 +-
 arch/arm/mach-s3c24xx/Kconfig                     |  2 +-
 arch/arm/mach-shmobile/Kconfig                    | 26 ++++-----
 arch/arm/mach-socfpga/Kconfig                     |  4 +-
 arch/arm/mach-vexpress/Kconfig                    |  2 +-
 arch/arm/mach-virt/Kconfig                        |  2 +-
 arch/arm/mach-vt8500/Kconfig                      |  2 +-
 arch/arm/plat-orion/Makefile                      |  2 +-
 arch/arm/plat-samsung/Kconfig                     |  2 +-
 arch/arm64/Kconfig                                |  2 +-
 arch/avr32/Kconfig                                |  2 +-
 arch/blackfin/Kconfig                             |  2 +-
 arch/blackfin/configs/BF518F-EZBRD_defconfig      |  2 +-
 arch/blackfin/configs/BF526-EZBRD_defconfig       |  2 +-
 arch/blackfin/configs/BF527-AD7160-EVAL_defconfig |  2 +-
 arch/blackfin/configs/BF527-EZKIT-V2_defconfig    |  2 +-
 arch/blackfin/configs/BF527-EZKIT_defconfig       |  2 +-
 arch/blackfin/configs/BF527-TLL6527M_defconfig    |  2 +-
 arch/blackfin/configs/BF533-EZKIT_defconfig       |  2 +-
 arch/blackfin/configs/BF533-STAMP_defconfig       |  2 +-
 arch/blackfin/configs/BF537-STAMP_defconfig       |  2 +-
 arch/blackfin/configs/BF538-EZKIT_defconfig       |  2 +-
 arch/blackfin/configs/BF548-EZKIT_defconfig       |  2 +-
 arch/blackfin/configs/BF561-ACVILON_defconfig     |  2 +-
 arch/blackfin/configs/BF561-EZKIT-SMP_defconfig   |  2 +-
 arch/blackfin/configs/BF561-EZKIT_defconfig       |  2 +-
 arch/blackfin/configs/BF609-EZKIT_defconfig       |  2 +-
 arch/blackfin/configs/CM-BF527_defconfig          |  2 +-
 arch/blackfin/configs/CM-BF537E_defconfig         |  2 +-
 arch/blackfin/configs/CM-BF537U_defconfig         |  2 +-
 arch/blackfin/configs/CM-BF561_defconfig          |  2 +-
 arch/blackfin/configs/DNP5370_defconfig           |  2 +-
 arch/blackfin/configs/TCM-BF518_defconfig         |  2 +-
 arch/blackfin/include/asm/gpio.h                  |  6 +--
 arch/blackfin/kernel/bfin_gpio.c                  |  2 +-
 arch/blackfin/mach-bf538/Makefile                 |  2 +-
 arch/blackfin/mach-bf538/include/mach/gpio.h      |  2 +-
 arch/hexagon/Kconfig                              |  4 +-
 arch/ia64/Kconfig                                 |  2 +-
 arch/m68k/Kconfig.cpu                             |  2 +-
 arch/m68k/include/asm/mcfgpio.h                   |  4 +-
 arch/m68k/platform/coldfire/gpio.c                |  2 +-
 arch/microblaze/Kconfig                           |  2 +-
 arch/microblaze/configs/mmu_defconfig             |  2 +-
 arch/microblaze/configs/nommu_defconfig           |  2 +-
 arch/microblaze/kernel/reset.c                    |  2 +-
 arch/mips/Kconfig                                 | 22 ++++----
 arch/mips/alchemy/Kconfig                         |  2 +-
 arch/mips/alchemy/common/Makefile                 |  2 +-
 arch/mips/alchemy/common/gpiolib.c                |  2 +-
 arch/mips/bcm47xx/Kconfig                         |  4 +-
 arch/mips/configs/db1000_defconfig                |  2 +-
 arch/mips/configs/gpr_defconfig                   |  2 +-
 arch/mips/configs/mtx1_defconfig                  |  2 +-
 arch/mips/include/asm/mach-au1x00/gpio-au1000.h   |  4 +-
 arch/mips/include/asm/mach-au1x00/gpio-au1300.h   |  2 +-
 arch/mips/include/asm/mach-au1x00/gpio.h          |  8 +--
 arch/mips/include/asm/mach-generic/gpio.h         |  2 +-
 arch/mips/loongson/common/Makefile                |  2 +-
 arch/mips/txx9/generic/setup.c                    |  2 +-
 arch/openrisc/Kconfig                             |  2 +-
 arch/powerpc/Kconfig                              |  2 +-
 arch/powerpc/configs/40x/virtex_defconfig         |  2 +-
 arch/powerpc/configs/44x/virtex5_defconfig        |  2 +-
 arch/powerpc/configs/mpc512x_defconfig            |  2 +-
 arch/powerpc/configs/wii_defconfig                |  2 +-
 arch/powerpc/platforms/40x/Kconfig                |  2 +-
 arch/powerpc/platforms/44x/Kconfig                |  2 +-
 arch/powerpc/platforms/512x/Kconfig               |  2 +-
 arch/powerpc/platforms/52xx/mpc52xx_gpt.c         |  8 +--
 arch/powerpc/platforms/83xx/Kconfig               |  6 +--
 arch/powerpc/platforms/85xx/Kconfig               | 14 ++---
 arch/powerpc/platforms/86xx/Kconfig               |  8 +--
 arch/powerpc/platforms/8xx/Kconfig                |  2 +-
 arch/powerpc/platforms/Kconfig                    |  8 +--
 arch/sh/Kconfig                                   | 20 +++----
 arch/sh/boards/Kconfig                            | 18 +++----
 arch/sh/boards/mach-highlander/Kconfig            |  2 +-
 arch/sh/boards/mach-rsk/Kconfig                   |  6 +--
 arch/sh/boards/mach-sdk7786/Makefile              |  2 +-
 arch/sh/boards/mach-x3proto/Makefile              |  2 +-
 arch/sh/include/asm/gpio.h                        |  4 +-
 arch/sh/kernel/cpu/sh2a/Makefile                  |  2 +-
 arch/sh/kernel/cpu/sh3/Makefile                   |  2 +-
 arch/sh/kernel/cpu/sh4a/Makefile                  |  2 +-
 arch/sparc/Kconfig                                |  2 +-
 arch/unicore32/Kconfig                            |  4 +-
 arch/x86/Kconfig                                  | 12 ++---
 arch/xtensa/Kconfig                               |  4 +-
 arch/xtensa/configs/s6105_defconfig               |  4 +-
 drivers/bcma/Kconfig                              |  2 +-
 drivers/block/Kconfig                             |  2 +-
 drivers/char/tpm/Kconfig                          |  2 +-
 drivers/extcon/Kconfig                            |  2 +-
 drivers/gpio/Kconfig                              | 18 +++----
 drivers/gpio/Makefile                             |  2 +-
 drivers/hwmon/Kconfig                             |  4 +-
 drivers/i2c/busses/Kconfig                        |  4 +-
 drivers/i2c/muxes/Kconfig                         |  2 +-
 drivers/input/keyboard/Kconfig                    |  6 +--
 drivers/input/keyboard/adp5588-keys.c             |  4 +-
 drivers/input/keyboard/adp5589-keys.c             |  4 +-
 drivers/input/misc/Kconfig                        |  8 +--
 drivers/input/mouse/Kconfig                       |  2 +-
 drivers/input/touchscreen/Kconfig                 |  4 +-
 drivers/input/touchscreen/ad7879.c                |  4 +-
 drivers/leds/Kconfig                              | 10 ++--
 drivers/leds/leds-tca6507.c                       |  8 +--
 drivers/media/dvb-frontends/cxd2820r_core.c       |  6 +--
 drivers/media/dvb-frontends/cxd2820r_priv.h       |  2 +-
 drivers/media/radio/wl128x/Kconfig                |  2 +-
 drivers/media/usb/em28xx/em28xx-dvb.c             |  4 +-
 drivers/mfd/Kconfig                               | 26 ++++-----
 drivers/misc/ti-st/Kconfig                        |  2 +-
 drivers/mtd/maps/Kconfig                          |  2 +-
 drivers/mtd/nand/Kconfig                          |  2 +-
 drivers/net/phy/Kconfig                           |  2 +-
 drivers/pinctrl/Kconfig                           |  4 +-
 drivers/pinctrl/sh-pfc/Kconfig                    | 30 +++++------
 drivers/pinctrl/spear/Kconfig                     |  2 +-
 drivers/platform/x86/Kconfig                      |  2 +-
 drivers/power/Kconfig                             |  2 +-
 drivers/regulator/Kconfig                         |  2 +-
 drivers/spi/Kconfig                               |  8 +--
 drivers/ssb/Kconfig                               |  2 +-
 drivers/staging/android/Kconfig                   |  2 +-
 drivers/staging/cptm1217/Kconfig                  |  2 +-
 drivers/staging/iio/accel/Kconfig                 |  2 +-
 drivers/staging/iio/adc/Kconfig                   |  6 +--
 drivers/staging/iio/addac/Kconfig                 |  2 +-
 drivers/staging/iio/magnetometer/Kconfig          |  2 +-
 drivers/staging/iio/resolver/Kconfig              |  4 +-
 drivers/staging/iio/trigger/Kconfig               |  2 +-
 drivers/staging/nvec/Kconfig                      |  2 +-
 drivers/staging/vme/devices/Kconfig               |  2 +-
 drivers/tty/serial/Kconfig                        |  2 +-
 drivers/tty/serial/max310x.c                      |  8 +--
 drivers/usb/otg/Kconfig                           |  2 +-
 drivers/video/Kconfig                             |  4 +-
 drivers/video/backlight/Kconfig                   |  4 +-
 drivers/w1/masters/Kconfig                        |  2 +-
 include/asm-generic/gpio.h                        |  6 +--
 include/linux/gpio.h                              |  6 +--
 include/linux/leds-tca6507.h                      |  2 +-
 include/linux/spi/ad7879.h                        |  2 +-
 include/sound/soc.h                               |  6 +--
 net/rfkill/Kconfig                                |  2 +-
 sound/soc/codecs/wm5100.c                         |  4 +-
 sound/soc/codecs/wm8903.c                         |  4 +-
 sound/soc/codecs/wm8962.c                         |  4 +-
 sound/soc/codecs/wm8996.c                         |  4 +-
 sound/soc/soc-jack.c                              |  4 +-
 164 files changed, 371 insertions(+), 378 deletions(-)

diff --git a/Documentation/gpio.txt b/Documentation/gpio.txt
index 6f83fa9..93825a4 100644
--- a/Documentation/gpio.txt
+++ b/Documentation/gpio.txt
@@ -63,18 +63,10 @@ used on a board that's wired differently.  Only least-common-denominator
 functionality can be very portable.  Other features are platform-specific,
 and that can be critical for glue logic.
 
-Plus, this doesn't require any implementation framework, just an interface.
-One platform might implement it as simple inline functions accessing chip
-registers; another might implement it by delegating through abstractions
-used for several very different kinds of GPIO controller.  (There is some
-optional code supporting such an implementation strategy, described later
-in this document, but drivers acting as clients to the GPIO interface must
-not care how it's implemented.)
-
 That said, if the convention is supported on their platform, drivers should
-use it when possible.  Platforms must select ARCH_REQUIRE_GPIOLIB or
-ARCH_WANT_OPTIONAL_GPIOLIB in their Kconfig.  Drivers that can't work without
-standard GPIO calls should have Kconfig entries which depend on GPIOLIB.  The
+use it when possible.  Platforms must select ARCH_REQUIRE_GPIO or
+ARCH_WANT_OPTIONAL_GPIO in their Kconfig.  Drivers that can't work without
+standard GPIO calls should have Kconfig entries which depend on GPIO.  The
 GPIO calls are available, either as "real code" or as optimized-away stubs,
 when drivers use the include file:
 
@@ -146,8 +138,8 @@ This helps avoid signal glitching during system startup.
 
 For compatibility with legacy interfaces to GPIOs, setting the direction
 of a GPIO implicitly requests that GPIO (see below) if it has not been
-requested already.  That compatibility is being removed from the optional
-gpiolib framework.
+requested already.  That compatibility is being removed from the GPIO
+framework.
 
 Setting the direction can fail if the GPIO number is invalid, or when
 that particular GPIO can't be used in that mode.  It's generally a bad
@@ -272,8 +264,8 @@ power management, such as by powering down unused chip sectors and, more
 easily, gating off unused clocks.
 
 For GPIOs that use pins known to the pinctrl subsystem, that subsystem should
-be informed of their use; a gpiolib driver's .request() operation may call
-pinctrl_request_gpio(), and a gpiolib driver's .free() operation may call
+be informed of their use; a GPIO driver's .request() operation may call
+pinctrl_request_gpio(), and a GPIO driver's .free() operation may call
 pinctrl_free_gpio(). The pinctrl subsystem allows a pinctrl_request_gpio()
 to succeed concurrently with a pin or pingroup being "owned" by a device for
 pin multiplexing.
@@ -462,7 +454,7 @@ cross-reference tables. These are described in
 Documentation/pinctrl.txt
 
 While the pin allocation is totally managed by the pinctrl subsystem,
-gpio (under gpiolib) is still maintained by gpio drivers. It may happen
+gpio is still maintained by gpio drivers. It may happen
 that different pin ranges in a SoC is managed by different gpio drivers.
 
 This makes it logical to let gpio drivers announce their pin ranges to
@@ -516,7 +508,8 @@ GPIO implementor's framework (OPTIONAL)
 =======================================
 As noted earlier, there is an optional implementation framework making it
 easier for platforms to support different kinds of GPIO controller using
-the same programming interface.  This framework is called "gpiolib".
+the same programming interface.  This framework is sometimes referred to
+as "gpiolib" for historical reasons.
 
 As a debugging aid, if debugfs is available a /sys/kernel/debug/gpio file
 will be found there.  That will list all the controllers registered through
@@ -554,7 +547,7 @@ either NULL or the label associated with that GPIO when it was requested.
 Platform Support
 ----------------
 To support this framework, a platform's Kconfig will "select" either
-ARCH_REQUIRE_GPIOLIB or ARCH_WANT_OPTIONAL_GPIOLIB
+ARCH_REQUIRE_GPIO or ARCH_WANT_OPTIONAL_GPIO
 and arrange that its <asm/gpio.h> includes <asm-generic/gpio.h> and defines
 three functions: gpio_get_value(), gpio_set_value(), and gpio_cansleep().
 
@@ -563,14 +556,14 @@ reflects the number of GPIOs in actual use on that platform, without
 wasting static table space.  (It should count both built-in/SoC GPIOs and
 also ones on GPIO expanders.
 
-ARCH_REQUIRE_GPIOLIB means that the gpiolib code will always get compiled
+ARCH_REQUIRE_GPIO means that the GPIO framework code will always get compiled
 into the kernel on that architecture.
 
-ARCH_WANT_OPTIONAL_GPIOLIB means the gpiolib code defaults to off and the user
-can enable it and build it into the kernel optionally.
+ARCH_WANT_OPTIONAL_GPIO means the GPIO framework code defaults to off and the
+user can enable it and build it into the kernel optionally.
 
 If neither of these options are selected, the platform does not support
-GPIOs through GPIO-lib and the code cannot be enabled by the user.
+GPIOs through the GPIO framework and the code cannot be enabled by the user.
 
 Trivial implementations of those functions can directly use framework
 code, which always dispatches through the gpio_chip:
@@ -620,11 +613,11 @@ the GPIO controller device becomes unavailable.
 
 Sysfs Interface for Userspace (OPTIONAL)
 ========================================
-Platforms which use the "gpiolib" implementors framework may choose to
-configure a sysfs user interface to GPIOs.  This is different from the
-debugfs interface, since it provides control over GPIO direction and
-value instead of just showing a gpio state summary.  Plus, it could be
-present on production systems without debugging support.
+Platforms which use the GPIO framework may choose to configure a sysfs user
+interface to GPIOs.  This is different from the debugfs interface, since it
+provides control over GPIO direction and value instead of just showing a
+gpio state summary.  Plus, it could be present on production systems without
+debugging support.
 
 Given appropriate hardware documentation for the system, userspace could
 know for example that GPIO #23 controls the write protect line used to
diff --git a/Documentation/zh_CN/gpio.txt b/Documentation/zh_CN/gpio.txt
index 4fa7b4e..99dbb69 100644
--- a/Documentation/zh_CN/gpio.txt
+++ b/Documentation/zh_CN/gpio.txt
@@ -473,7 +473,7 @@ GPIO 实现者的框架 (可选)
 平台支持
 -------
 为了支持这个框架，一个平台的 Kconfig 文件将会 "select"(选择)
-ARCH_REQUIRE_GPIOLIB 或 ARCH_WANT_OPTIONAL_GPIOLIB，并让它的
+ARCH_REQUIRE_GPIO 或 ARCH_WANT_OPTIONAL_GPIO，并让它的
 <asm/gpio.h> 包含 <asm-generic/gpio.h>，同时定义三个方法:
 gpio_get_value()、gpio_set_value()和 gpio_cansleep()。
 
@@ -481,9 +481,9 @@ gpio_get_value()、gpio_set_value()和 gpio_cansleep()。
 的实际数量,节省静态表的空间。(这个定义值应该包含片上系统内建 GPIO 和
 GPIO 扩展器中的数据。)
 
-ARCH_REQUIRE_GPIOLIB 意味着 gpiolib 核心在这个构架中将总是编译进内核。
+ARCH_REQUIRE_GPIO 意味着 gpiolib 核心在这个构架中将总是编译进内核。
 
-ARCH_WANT_OPTIONAL_GPIOLIB 意味着 gpiolib 核心默认关闭,且用户可以
+ARCH_WANT_OPTIONAL_GPIO 意味着 gpiolib 核心默认关闭,且用户可以
 使能它,并将其编译进内核(可选)。
 
 如果这些选项都没被选择,该平台就不通过 GPIO-lib 支持 GPIO,且代码不可以
diff --git a/arch/alpha/Kconfig b/arch/alpha/Kconfig
index 282ff37..7d3a18c 100644
--- a/arch/alpha/Kconfig
+++ b/arch/alpha/Kconfig
@@ -13,7 +13,7 @@ config ALPHA
 	select GENERIC_IRQ_PROBE
 	select AUTO_IRQ_AFFINITY if SMP
 	select GENERIC_IRQ_SHOW
-	select ARCH_WANT_OPTIONAL_GPIOLIB
+	select ARCH_WANT_OPTIONAL_GPIO
 	select ARCH_WANT_IPC_PARSE_VERSION
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select GENERIC_SMP_IDLE_THREAD
diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index ceac9a4..28f178a 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -313,13 +313,13 @@ config ARCH_INTEGRATOR
 
 config ARCH_REALVIEW
 	bool "ARM Ltd. RealView family"
-	select ARCH_WANT_OPTIONAL_GPIOLIB
+	select ARCH_WANT_OPTIONAL_GPIO
 	select ARM_AMBA
 	select ARM_TIMER_SP804
 	select COMMON_CLK
 	select COMMON_CLK_VERSATILE
 	select GENERIC_CLOCKEVENTS
-	select GPIO_PL061 if GPIOLIB
+	select GPIO_PL061 if GPIO
 	select ICST
 	select NEED_MACH_MEMORY_H
 	select PLAT_VERSATILE
@@ -329,7 +329,7 @@ config ARCH_REALVIEW
 
 config ARCH_VERSATILE
 	bool "ARM Ltd. Versatile family"
-	select ARCH_WANT_OPTIONAL_GPIOLIB
+	select ARCH_WANT_OPTIONAL_GPIO
 	select ARM_AMBA
 	select ARM_TIMER_SP804
 	select ARM_VIC
@@ -346,7 +346,7 @@ config ARCH_VERSATILE
 
 config ARCH_AT91
 	bool "Atmel AT91"
-	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_REQUIRE_GPIO
 	select CLKDEV_LOOKUP
 	select HAVE_CLK
 	select IRQ_DOMAIN
@@ -360,7 +360,7 @@ config ARCH_AT91
 
 config ARCH_BCM2835
 	bool "Broadcom BCM2835 family"
-	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_REQUIRE_GPIO
 	select ARM_AMBA
 	select ARM_ERRATA_411920
 	select ARM_TIMER_SP804
@@ -391,7 +391,7 @@ config ARCH_CNS3XXX
 
 config ARCH_CLPS711X
 	bool "Cirrus Logic CLPS711x/EP721x/EP731x-based"
-	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_REQUIRE_GPIO
 	select AUTO_ZRELADDR
 	select CLKDEV_LOOKUP
 	select COMMON_CLK
@@ -405,7 +405,7 @@ config ARCH_CLPS711X
 
 config ARCH_GEMINI
 	bool "Cortina Systems Gemini"
-	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_REQUIRE_GPIO
 	select ARCH_USES_GETTIMEOFFSET
 	select CPU_FA526
 	help
@@ -413,7 +413,7 @@ config ARCH_GEMINI
 
 config ARCH_SIRF
 	bool "CSR SiRF"
-	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_REQUIRE_GPIO
 	select AUTO_ZRELADDR
 	select COMMON_CLK
 	select GENERIC_CLOCKEVENTS
@@ -443,7 +443,7 @@ config ARCH_EBSA110
 config ARCH_EP93XX
 	bool "EP93xx-based"
 	select ARCH_HAS_HOLES_MEMORYMODEL
-	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_REQUIRE_GPIO
 	select ARCH_USES_GETTIMEOFFSET
 	select ARM_AMBA
 	select ARM_VIC
@@ -467,7 +467,7 @@ config ARCH_FOOTBRIDGE
 
 config ARCH_MXS
 	bool "Freescale MXS-based"
-	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_REQUIRE_GPIO
 	select CLKDEV_LOOKUP
 	select CLKSRC_MMIO
 	select COMMON_CLK
@@ -513,7 +513,7 @@ config ARCH_IOP13XX
 config ARCH_IOP32X
 	bool "IOP32x-based"
 	depends on MMU
-	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_REQUIRE_GPIO
 	select CPU_XSCALE
 	select NEED_MACH_GPIO_H
 	select NEED_RET_TO_USER
@@ -526,7 +526,7 @@ config ARCH_IOP32X
 config ARCH_IOP33X
 	bool "IOP33x-based"
 	depends on MMU
-	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_REQUIRE_GPIO
 	select CPU_XSCALE
 	select NEED_MACH_GPIO_H
 	select NEED_RET_TO_USER
@@ -539,7 +539,7 @@ config ARCH_IXP4XX
 	bool "IXP4xx-based"
 	depends on MMU
 	select ARCH_HAS_DMA_SET_COHERENT_MASK
-	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_REQUIRE_GPIO
 	select CLKSRC_MMIO
 	select CPU_XSCALE
 	select DMABOUNCE if PCI
@@ -551,7 +551,7 @@ config ARCH_IXP4XX
 
 config ARCH_DOVE
 	bool "Marvell Dove"
-	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_REQUIRE_GPIO
 	select CPU_V7
 	select GENERIC_CLOCKEVENTS
 	select MIGHT_HAVE_PCI
@@ -564,7 +564,7 @@ config ARCH_DOVE
 
 config ARCH_KIRKWOOD
 	bool "Marvell Kirkwood"
-	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_REQUIRE_GPIO
 	select CPU_FEROCEON
 	select GENERIC_CLOCKEVENTS
 	select PCI
@@ -578,7 +578,7 @@ config ARCH_KIRKWOOD
 
 config ARCH_MV78XX0
 	bool "Marvell MV78xx0"
-	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_REQUIRE_GPIO
 	select CPU_FEROCEON
 	select GENERIC_CLOCKEVENTS
 	select PCI
@@ -590,7 +590,7 @@ config ARCH_MV78XX0
 config ARCH_ORION5X
 	bool "Marvell Orion"
 	depends on MMU
-	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_REQUIRE_GPIO
 	select CPU_FEROCEON
 	select GENERIC_CLOCKEVENTS
 	select PCI
@@ -603,7 +603,7 @@ config ARCH_ORION5X
 config ARCH_MMP
 	bool "Marvell PXA168/910/MMP2"
 	depends on MMU
-	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_REQUIRE_GPIO
 	select CLKDEV_LOOKUP
 	select GENERIC_ALLOCATOR
 	select GENERIC_CLOCKEVENTS
@@ -618,7 +618,7 @@ config ARCH_MMP
 
 config ARCH_KS8695
 	bool "Micrel/Kendin KS8695"
-	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_REQUIRE_GPIO
 	select CLKSRC_MMIO
 	select CPU_ARM922T
 	select GENERIC_CLOCKEVENTS
@@ -629,7 +629,7 @@ config ARCH_KS8695
 
 config ARCH_W90X900
 	bool "Nuvoton W90X900 CPU"
-	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_REQUIRE_GPIO
 	select CLKDEV_LOOKUP
 	select CLKSRC_MMIO
 	select CPU_ARM926T
@@ -645,7 +645,7 @@ config ARCH_W90X900
 
 config ARCH_LPC32XX
 	bool "NXP LPC32XX"
-	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_REQUIRE_GPIO
 	select ARM_AMBA
 	select CLKDEV_LOOKUP
 	select CLKSRC_MMIO
@@ -661,7 +661,7 @@ config ARCH_LPC32XX
 config ARCH_TEGRA
 	bool "NVIDIA Tegra"
 	select ARCH_HAS_CPUFREQ
-	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_REQUIRE_GPIO
 	select CLKDEV_LOOKUP
 	select CLKSRC_MMIO
 	select CLKSRC_OF
@@ -681,7 +681,7 @@ config ARCH_PXA
 	depends on MMU
 	select ARCH_HAS_CPUFREQ
 	select ARCH_MTD_XIP
-	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_REQUIRE_GPIO
 	select ARM_CPU_SUSPEND if PM
 	select AUTO_ZRELADDR
 	select CLKDEV_LOOKUP
@@ -698,7 +698,7 @@ config ARCH_PXA
 
 config ARCH_MSM
 	bool "Qualcomm MSM"
-	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_REQUIRE_GPIO
 	select CLKDEV_LOOKUP
 	select GENERIC_CLOCKEVENTS
 	select HAVE_CLK
@@ -748,7 +748,7 @@ config ARCH_SA1100
 	bool "SA1100-based"
 	select ARCH_HAS_CPUFREQ
 	select ARCH_MTD_XIP
-	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_REQUIRE_GPIO
 	select ARCH_SPARSEMEM_ENABLE
 	select CLKDEV_LOOKUP
 	select CLKSRC_MMIO
@@ -783,7 +783,7 @@ config ARCH_S3C24XX
 config ARCH_S3C64XX
 	bool "Samsung S3C64XX"
 	select ARCH_HAS_CPUFREQ
-	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_REQUIRE_GPIO
 	select ARCH_USES_GETTIMEOFFSET
 	select ARM_VIC
 	select CLKDEV_LOOKUP
@@ -884,7 +884,7 @@ config ARCH_SHARK
 config ARCH_U300
 	bool "ST-Ericsson U300 Series"
 	depends on MMU
-	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_REQUIRE_GPIO
 	select ARM_AMBA
 	select ARM_PATCH_PHYS_VIRT
 	select ARM_VIC
@@ -902,7 +902,7 @@ config ARCH_U8500
 	bool "ST-Ericsson U8500 Series"
 	depends on MMU
 	select ARCH_HAS_CPUFREQ
-	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_REQUIRE_GPIO
 	select ARM_AMBA
 	select CLKDEV_LOOKUP
 	select CPU_V7
@@ -915,7 +915,7 @@ config ARCH_U8500
 
 config ARCH_NOMADIK
 	bool "STMicroelectronics Nomadik"
-	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_REQUIRE_GPIO
 	select ARM_AMBA
 	select ARM_VIC
 	select CLKSRC_NOMADIK_MTU
@@ -933,7 +933,7 @@ config ARCH_NOMADIK
 config PLAT_SPEAR
 	bool "ST SPEAr"
 	select ARCH_HAS_CPUFREQ
-	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_REQUIRE_GPIO
 	select ARM_AMBA
 	select CLKDEV_LOOKUP
 	select CLKSRC_MMIO
@@ -946,7 +946,7 @@ config PLAT_SPEAR
 config ARCH_DAVINCI
 	bool "TI DaVinci"
 	select ARCH_HAS_HOLES_MEMORYMODEL
-	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_REQUIRE_GPIO
 	select CLKDEV_LOOKUP
 	select GENERIC_ALLOCATOR
 	select GENERIC_CLOCKEVENTS
@@ -964,7 +964,7 @@ config ARCH_OMAP1
 	select ARCH_HAS_CPUFREQ
 	select ARCH_HAS_HOLES_MEMORYMODEL
 	select ARCH_OMAP
-	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_REQUIRE_GPIO
 	select CLKDEV_LOOKUP
 	select CLKSRC_MMIO
 	select GENERIC_CLOCKEVENTS
diff --git a/arch/arm/configs/kzm9d_defconfig b/arch/arm/configs/kzm9d_defconfig
index 6c37f4a..280f867 100644
--- a/arch/arm/configs/kzm9d_defconfig
+++ b/arch/arm/configs/kzm9d_defconfig
@@ -74,7 +74,7 @@ CONFIG_SERIAL_8250=y
 CONFIG_SERIAL_8250_CONSOLE=y
 CONFIG_SERIAL_8250_EM=y
 # CONFIG_HW_RANDOM is not set
-CONFIG_GPIOLIB=y
+CONFIG_GPIO=y
 CONFIG_GPIO_EM=y
 # CONFIG_HWMON is not set
 # CONFIG_HID_SUPPORT is not set
diff --git a/arch/arm/configs/mvebu_defconfig b/arch/arm/configs/mvebu_defconfig
index 2ec8119..8d6e850 100644
--- a/arch/arm/configs/mvebu_defconfig
+++ b/arch/arm/configs/mvebu_defconfig
@@ -47,7 +47,7 @@ CONFIG_MTD=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_M25P80=y
 CONFIG_SERIAL_8250_DW=y
-CONFIG_GPIOLIB=y
+CONFIG_GPIO=y
 CONFIG_GPIO_SYSFS=y
 CONFIG_USB_SUPPORT=y
 CONFIG_USB=y
diff --git a/arch/arm/configs/realview-smp_defconfig b/arch/arm/configs/realview-smp_defconfig
index abe61bf..31e875c 100644
--- a/arch/arm/configs/realview-smp_defconfig
+++ b/arch/arm/configs/realview-smp_defconfig
@@ -56,7 +56,7 @@ CONFIG_LEGACY_PTY_COUNT=16
 CONFIG_I2C=y
 CONFIG_I2C_VERSATILE=y
 CONFIG_SPI=y
-CONFIG_GPIOLIB=y
+CONFIG_GPIO=y
 # CONFIG_HWMON is not set
 CONFIG_FB=y
 CONFIG_FB_ARMCLCD=y
diff --git a/arch/arm/configs/realview_defconfig b/arch/arm/configs/realview_defconfig
index 7079cbe..4d876d1 100644
--- a/arch/arm/configs/realview_defconfig
+++ b/arch/arm/configs/realview_defconfig
@@ -55,7 +55,7 @@ CONFIG_LEGACY_PTY_COUNT=16
 CONFIG_I2C=y
 CONFIG_I2C_VERSATILE=y
 CONFIG_SPI=y
-CONFIG_GPIOLIB=y
+CONFIG_GPIO=y
 # CONFIG_HWMON is not set
 CONFIG_FB=y
 CONFIG_FB_ARMCLCD=y
diff --git a/arch/arm/mach-bcm/Kconfig b/arch/arm/mach-bcm/Kconfig
index bf02471..97c2df7 100644
--- a/arch/arm/mach-bcm/Kconfig
+++ b/arch/arm/mach-bcm/Kconfig
@@ -1,7 +1,7 @@
 config ARCH_BCM
 	bool "Broadcom SoC" if ARCH_MULTI_V7
 	depends on MMU
-	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_REQUIRE_GPIO
 	select ARM_ERRATA_754322
 	select ARM_ERRATA_764369 if SMP
 	select ARM_GIC
diff --git a/arch/arm/mach-highbank/Kconfig b/arch/arm/mach-highbank/Kconfig
index 44b12f9..5e58ec3 100644
--- a/arch/arm/mach-highbank/Kconfig
+++ b/arch/arm/mach-highbank/Kconfig
@@ -2,7 +2,7 @@ config ARCH_HIGHBANK
 	bool "Calxeda ECX-1000/2000 (Highbank/Midway)" if ARCH_MULTI_V7
 	select ARCH_HAS_CPUFREQ
 	select ARCH_HAS_OPP
-	select ARCH_WANT_OPTIONAL_GPIOLIB
+	select ARCH_WANT_OPTIONAL_GPIO
 	select ARM_AMBA
 	select ARM_GIC
 	select ARM_TIMER_SP804
diff --git a/arch/arm/mach-imx/Kconfig b/arch/arm/mach-imx/Kconfig
index 4c9c6f9..322901d 100644
--- a/arch/arm/mach-imx/Kconfig
+++ b/arch/arm/mach-imx/Kconfig
@@ -1,6 +1,6 @@
 config ARCH_MXC
 	bool "Freescale i.MX family" if ARCH_MULTI_V4_V5 || ARCH_MULTI_V6_V7
-	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_REQUIRE_GPIO
 	select ARM_PATCH_PHYS_VIRT
 	select AUTO_ZRELADDR if !ZBOOT_ROM
 	select CLKDEV_LOOKUP
diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
index 8111cd9..cb2519f 100644
--- a/arch/arm/mach-omap2/Kconfig
+++ b/arch/arm/mach-omap2/Kconfig
@@ -6,7 +6,7 @@ config ARCH_OMAP2PLUS
 	select ARCH_HAS_CPUFREQ
 	select ARCH_HAS_HOLES_MEMORYMODEL
 	select ARCH_OMAP
-	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_REQUIRE_GPIO
 	select CLKDEV_LOOKUP
 	select CLKSRC_MMIO
 	select GENERIC_CLOCKEVENTS
diff --git a/arch/arm/mach-picoxcell/Kconfig b/arch/arm/mach-picoxcell/Kconfig
index 13bae78..29f11c7 100644
--- a/arch/arm/mach-picoxcell/Kconfig
+++ b/arch/arm/mach-picoxcell/Kconfig
@@ -1,6 +1,6 @@
 config ARCH_PICOXCELL
 	bool "Picochip PicoXcell" if ARCH_MULTI_V6
-	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_REQUIRE_GPIO
 	select ARM_PATCH_PHYS_VIRT
 	select ARM_VIC
 	select CPU_V6K
diff --git a/arch/arm/mach-s3c24xx/Kconfig b/arch/arm/mach-s3c24xx/Kconfig
index 37f513d..0e4e0c2 100644
--- a/arch/arm/mach-s3c24xx/Kconfig
+++ b/arch/arm/mach-s3c24xx/Kconfig
@@ -11,7 +11,7 @@ if ARCH_S3C24XX
 
 config PLAT_S3C24XX
 	def_bool y
-	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_REQUIRE_GPIO
 	select NO_IOPORT
 	select S3C_DEV_NAND
 	select IRQ_DOMAIN
diff --git a/arch/arm/mach-shmobile/Kconfig b/arch/arm/mach-shmobile/Kconfig
index 9255546..af87484 100644
--- a/arch/arm/mach-shmobile/Kconfig
+++ b/arch/arm/mach-shmobile/Kconfig
@@ -4,14 +4,14 @@ comment "SH-Mobile System Type"
 
 config ARCH_SH7372
 	bool "SH-Mobile AP4 (SH7372)"
-	select ARCH_WANT_OPTIONAL_GPIOLIB
+	select ARCH_WANT_OPTIONAL_GPIO
 	select ARM_CPU_SUSPEND if PM || CPU_IDLE
 	select CPU_V7
 	select SH_CLK_CPG
 
 config ARCH_SH73A0
 	bool "SH-Mobile AG5 (R8A73A00)"
-	select ARCH_WANT_OPTIONAL_GPIOLIB
+	select ARCH_WANT_OPTIONAL_GPIO
 	select ARM_GIC
 	select CPU_V7
 	select I2C
@@ -19,13 +19,13 @@ config ARCH_SH73A0
 
 config ARCH_R8A7740
 	bool "R-Mobile A1 (R8A77400)"
-	select ARCH_WANT_OPTIONAL_GPIOLIB
+	select ARCH_WANT_OPTIONAL_GPIO
 	select CPU_V7
 	select SH_CLK_CPG
 
 config ARCH_R8A7779
 	bool "R-Car H1 (R8A77790)"
-	select ARCH_WANT_OPTIONAL_GPIOLIB
+	select ARCH_WANT_OPTIONAL_GPIO
 	select ARM_GIC
 	select CPU_V7
 	select SH_CLK_CPG
@@ -34,7 +34,7 @@ config ARCH_R8A7779
 
 config ARCH_EMEV2
 	bool "Emma Mobile EV2"
-	select ARCH_WANT_OPTIONAL_GPIOLIB
+	select ARCH_WANT_OPTIONAL_GPIO
 	select ARM_GIC
 	select CPU_V7
 
@@ -43,7 +43,7 @@ comment "SH-Mobile Board Type"
 config MACH_AP4EVB
 	bool "AP4EVB board"
 	depends on ARCH_SH7372
-	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_REQUIRE_GPIO
 	select REGULATOR_FIXED_VOLTAGE if REGULATOR
 	select SH_LCD_MIPI_DSI
 	select SND_SOC_AK4642 if SND_SIMPLE_CARD
@@ -64,14 +64,14 @@ endchoice
 config MACH_AG5EVM
 	bool "AG5EVM board"
 	depends on ARCH_SH73A0
-	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_REQUIRE_GPIO
 	select REGULATOR_FIXED_VOLTAGE if REGULATOR
 	select SH_LCD_MIPI_DSI
 
 config MACH_MACKEREL
 	bool "mackerel board"
 	depends on ARCH_SH7372
-	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_REQUIRE_GPIO
 	select REGULATOR_FIXED_VOLTAGE if REGULATOR
 	select SND_SOC_AK4642 if SND_SIMPLE_CARD
 	select USE_OF
@@ -79,19 +79,19 @@ config MACH_MACKEREL
 config MACH_KOTA2
 	bool "KOTA2 board"
 	depends on ARCH_SH73A0
-	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_REQUIRE_GPIO
 	select REGULATOR_FIXED_VOLTAGE if REGULATOR
 
 config MACH_BONITO
 	bool "bonito board"
 	depends on ARCH_R8A7740
-	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_REQUIRE_GPIO
 	select REGULATOR_FIXED_VOLTAGE if REGULATOR
 
 config MACH_ARMADILLO800EVA
 	bool "Armadillo-800 EVA board"
 	depends on ARCH_R8A7740
-	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_REQUIRE_GPIO
 	select REGULATOR_FIXED_VOLTAGE if REGULATOR
 	select SND_SOC_WM8978 if SND_SIMPLE_CARD
 	select USE_OF
@@ -99,7 +99,7 @@ config MACH_ARMADILLO800EVA
 config MACH_MARZEN
 	bool "MARZEN board"
 	depends on ARCH_R8A7779
-	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_REQUIRE_GPIO
 	select REGULATOR_FIXED_VOLTAGE if REGULATOR
 
 config MACH_KZM9D
@@ -111,7 +111,7 @@ config MACH_KZM9D
 config MACH_KZM9G
 	bool "KZM-A9-GT board"
 	depends on ARCH_SH73A0
-	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_REQUIRE_GPIO
 	select REGULATOR_FIXED_VOLTAGE if REGULATOR
 	select SND_SOC_AK4642 if SND_SIMPLE_CARD
 	select USE_OF
diff --git a/arch/arm/mach-socfpga/Kconfig b/arch/arm/mach-socfpga/Kconfig
index 566e804..fcdfa9c 100644
--- a/arch/arm/mach-socfpga/Kconfig
+++ b/arch/arm/mach-socfpga/Kconfig
@@ -1,6 +1,6 @@
 config ARCH_SOCFPGA
 	bool "Altera SOCFPGA family" if ARCH_MULTI_V7
-	select ARCH_WANT_OPTIONAL_GPIOLIB
+	select ARCH_WANT_OPTIONAL_GPIO
 	select ARM_AMBA
 	select ARM_GIC
 	select CACHE_L2X0
@@ -10,7 +10,7 @@ config ARCH_SOCFPGA
 	select DW_APB_TIMER
 	select DW_APB_TIMER_OF
 	select GENERIC_CLOCKEVENTS
-	select GPIO_PL061 if GPIOLIB
+	select GPIO_PL061 if GPIO
 	select HAVE_ARM_SCU
 	select HAVE_SMP
 	select SPARSE_IRQ
diff --git a/arch/arm/mach-vexpress/Kconfig b/arch/arm/mach-vexpress/Kconfig
index 52d315b..5469800 100644
--- a/arch/arm/mach-vexpress/Kconfig
+++ b/arch/arm/mach-vexpress/Kconfig
@@ -1,6 +1,6 @@
 config ARCH_VEXPRESS
 	bool "ARM Ltd. Versatile Express family" if ARCH_MULTI_V7
-	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_REQUIRE_GPIO
 	select ARM_AMBA
 	select ARM_GIC
 	select ARM_TIMER_SP804
diff --git a/arch/arm/mach-virt/Kconfig b/arch/arm/mach-virt/Kconfig
index 8958f0d..9b7fe02 100644
--- a/arch/arm/mach-virt/Kconfig
+++ b/arch/arm/mach-virt/Kconfig
@@ -1,6 +1,6 @@
 config ARCH_VIRT
 	bool "Dummy Virtual Machine" if ARCH_MULTI_V7
-	select ARCH_WANT_OPTIONAL_GPIOLIB
+	select ARCH_WANT_OPTIONAL_GPIO
 	select ARM_GIC
 	select ARM_ARCH_TIMER
 	select ARM_PSCI
diff --git a/arch/arm/mach-vt8500/Kconfig b/arch/arm/mach-vt8500/Kconfig
index e3e94b2..2946743c 100644
--- a/arch/arm/mach-vt8500/Kconfig
+++ b/arch/arm/mach-vt8500/Kconfig
@@ -1,7 +1,7 @@
 config ARCH_VT8500
 	bool
 	select ARCH_HAS_CPUFREQ
-	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_REQUIRE_GPIO
 	select CLKDEV_LOOKUP
 	select CLKSRC_OF
 	select GENERIC_CLOCKEVENTS
diff --git a/arch/arm/plat-orion/Makefile b/arch/arm/plat-orion/Makefile
index bbc0d6b..dc86078 100644
--- a/arch/arm/plat-orion/Makefile
+++ b/arch/arm/plat-orion/Makefile
@@ -5,6 +5,6 @@ ccflags-$(CONFIG_ARCH_MULTIPLATFORM) := -I$(srctree)/$(src)/include
 
 obj-y                             += addr-map.o
 
-orion-gpio-$(CONFIG_GPIOLIB)      += gpio.o
+orion-gpio-$(CONFIG_GPIO)      += gpio.o
 obj-$(CONFIG_PLAT_ORION_LEGACY)   += irq.o pcie.o time.o common.o mpp.o
 obj-$(CONFIG_PLAT_ORION_LEGACY)   += $(orion-gpio-y)
diff --git a/arch/arm/plat-samsung/Kconfig b/arch/arm/plat-samsung/Kconfig
index a9d5216..5a8ac99 100644
--- a/arch/arm/plat-samsung/Kconfig
+++ b/arch/arm/plat-samsung/Kconfig
@@ -17,7 +17,7 @@ config PLAT_S5P
 	bool
 	depends on (ARCH_S5P64X0 || ARCH_S5PC100 || ARCH_S5PV210 || ARCH_EXYNOS)
 	default y
-	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_REQUIRE_GPIO
 	select ARM_GIC if ARCH_EXYNOS
 	select ARM_VIC if !ARCH_EXYNOS
 	select GIC_NON_BANKED if ARCH_EXYNOS4
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index e6e7007..8de0d68 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -1,7 +1,7 @@
 config ARM64
 	def_bool y
 	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
-	select ARCH_WANT_OPTIONAL_GPIOLIB
+	select ARCH_WANT_OPTIONAL_GPIO
 	select ARCH_WANT_COMPAT_IPC_PARSE_VERSION
 	select ARCH_WANT_FRAME_POINTERS
 	select ARM_AMBA
diff --git a/arch/avr32/Kconfig b/arch/avr32/Kconfig
index ff775b8..839ae3e 100644
--- a/arch/avr32/Kconfig
+++ b/arch/avr32/Kconfig
@@ -75,7 +75,7 @@ config PLATFORM_AT32AP
 	select SUBARCH_AVR32B
 	select MMU
 	select PERFORMANCE_COUNTERS
-	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_REQUIRE_GPIO
 	select GENERIC_ALLOCATOR
 	select HAVE_FB_ATMEL
 
diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index 71dd50b..01a742c 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -31,7 +31,7 @@ config BLACKFIN
 	select HAVE_OPROFILE
 	select HAVE_PERF_EVENTS
 	select ARCH_HAVE_CUSTOM_GPIO_H
-	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_REQUIRE_GPIO
 	select HAVE_UID16
 	select VIRT_TO_BUS
 	select ARCH_WANT_IPC_PARSE_VERSION
diff --git a/arch/blackfin/configs/BF518F-EZBRD_defconfig b/arch/blackfin/configs/BF518F-EZBRD_defconfig
index 3830078..930184c 100644
--- a/arch/blackfin/configs/BF518F-EZBRD_defconfig
+++ b/arch/blackfin/configs/BF518F-EZBRD_defconfig
@@ -85,7 +85,7 @@ CONFIG_I2C_BLACKFIN_TWI=y
 CONFIG_I2C_BLACKFIN_TWI_CLK_KHZ=100
 CONFIG_SPI=y
 CONFIG_SPI_BFIN5XX=y
-CONFIG_GPIOLIB=y
+CONFIG_GPIO=y
 CONFIG_GPIO_SYSFS=y
 # CONFIG_HWMON is not set
 CONFIG_WATCHDOG=y
diff --git a/arch/blackfin/configs/BF526-EZBRD_defconfig b/arch/blackfin/configs/BF526-EZBRD_defconfig
index 2f2c6ac..dc41308 100644
--- a/arch/blackfin/configs/BF526-EZBRD_defconfig
+++ b/arch/blackfin/configs/BF526-EZBRD_defconfig
@@ -102,7 +102,7 @@ CONFIG_I2C_BLACKFIN_TWI=y
 CONFIG_I2C_BLACKFIN_TWI_CLK_KHZ=100
 CONFIG_SPI=y
 CONFIG_SPI_BFIN5XX=y
-CONFIG_GPIOLIB=y
+CONFIG_GPIO=y
 CONFIG_GPIO_SYSFS=y
 CONFIG_WATCHDOG=y
 CONFIG_BFIN_WDT=y
diff --git a/arch/blackfin/configs/BF527-AD7160-EVAL_defconfig b/arch/blackfin/configs/BF527-AD7160-EVAL_defconfig
index d95658f..a5c4ff42 100644
--- a/arch/blackfin/configs/BF527-AD7160-EVAL_defconfig
+++ b/arch/blackfin/configs/BF527-AD7160-EVAL_defconfig
@@ -69,7 +69,7 @@ CONFIG_I2C_BLACKFIN_TWI=y
 CONFIG_I2C_BLACKFIN_TWI_CLK_KHZ=400
 CONFIG_SPI=y
 CONFIG_SPI_BFIN5XX=y
-CONFIG_GPIOLIB=y
+CONFIG_GPIO=y
 CONFIG_GPIO_SYSFS=y
 # CONFIG_HWMON is not set
 CONFIG_FB=y
diff --git a/arch/blackfin/configs/BF527-EZKIT-V2_defconfig b/arch/blackfin/configs/BF527-EZKIT-V2_defconfig
index 91535c3..eaaeadc 100644
--- a/arch/blackfin/configs/BF527-EZKIT-V2_defconfig
+++ b/arch/blackfin/configs/BF527-EZKIT-V2_defconfig
@@ -110,7 +110,7 @@ CONFIG_I2C_BLACKFIN_TWI=y
 CONFIG_I2C_BLACKFIN_TWI_CLK_KHZ=100
 CONFIG_SPI=y
 CONFIG_SPI_BFIN5XX=y
-CONFIG_GPIOLIB=y
+CONFIG_GPIO=y
 CONFIG_GPIO_SYSFS=y
 # CONFIG_HWMON is not set
 CONFIG_WATCHDOG=y
diff --git a/arch/blackfin/configs/BF527-EZKIT_defconfig b/arch/blackfin/configs/BF527-EZKIT_defconfig
index 90b1753..41f8da6 100644
--- a/arch/blackfin/configs/BF527-EZKIT_defconfig
+++ b/arch/blackfin/configs/BF527-EZKIT_defconfig
@@ -104,7 +104,7 @@ CONFIG_I2C_BLACKFIN_TWI=y
 CONFIG_I2C_BLACKFIN_TWI_CLK_KHZ=100
 CONFIG_SPI=y
 CONFIG_SPI_BFIN5XX=y
-CONFIG_GPIOLIB=y
+CONFIG_GPIO=y
 CONFIG_GPIO_SYSFS=y
 # CONFIG_HWMON is not set
 CONFIG_WATCHDOG=y
diff --git a/arch/blackfin/configs/BF527-TLL6527M_defconfig b/arch/blackfin/configs/BF527-TLL6527M_defconfig
index cd0636b..451e605 100644
--- a/arch/blackfin/configs/BF527-TLL6527M_defconfig
+++ b/arch/blackfin/configs/BF527-TLL6527M_defconfig
@@ -113,7 +113,7 @@ CONFIG_I2C_CHARDEV=y
 CONFIG_I2C_SMBUS=y
 CONFIG_I2C_BLACKFIN_TWI=y
 CONFIG_I2C_BLACKFIN_TWI_CLK_KHZ=100
-CONFIG_GPIOLIB=y
+CONFIG_GPIO=y
 CONFIG_GPIO_SYSFS=y
 # CONFIG_HWMON is not set
 CONFIG_WATCHDOG=y
diff --git a/arch/blackfin/configs/BF533-EZKIT_defconfig b/arch/blackfin/configs/BF533-EZKIT_defconfig
index 16273a9..e5524f6 100644
--- a/arch/blackfin/configs/BF533-EZKIT_defconfig
+++ b/arch/blackfin/configs/BF533-EZKIT_defconfig
@@ -87,7 +87,7 @@ CONFIG_SERIAL_BFIN_CONSOLE=y
 # CONFIG_HW_RANDOM is not set
 CONFIG_SPI=y
 CONFIG_SPI_BFIN5XX=y
-CONFIG_GPIOLIB=y
+CONFIG_GPIO=y
 CONFIG_GPIO_SYSFS=y
 # CONFIG_HWMON is not set
 CONFIG_WATCHDOG=y
diff --git a/arch/blackfin/configs/BF533-STAMP_defconfig b/arch/blackfin/configs/BF533-STAMP_defconfig
index 0df2f92..5303122 100644
--- a/arch/blackfin/configs/BF533-STAMP_defconfig
+++ b/arch/blackfin/configs/BF533-STAMP_defconfig
@@ -88,7 +88,7 @@ CONFIG_I2C_CHARDEV=m
 CONFIG_I2C_GPIO=m
 CONFIG_SPI=y
 CONFIG_SPI_BFIN5XX=y
-CONFIG_GPIOLIB=y
+CONFIG_GPIO=y
 CONFIG_GPIO_SYSFS=y
 # CONFIG_HWMON is not set
 CONFIG_WATCHDOG=y
diff --git a/arch/blackfin/configs/BF537-STAMP_defconfig b/arch/blackfin/configs/BF537-STAMP_defconfig
index 91d3eda..0659304 100644
--- a/arch/blackfin/configs/BF537-STAMP_defconfig
+++ b/arch/blackfin/configs/BF537-STAMP_defconfig
@@ -97,7 +97,7 @@ CONFIG_I2C_BLACKFIN_TWI=m
 CONFIG_I2C_BLACKFIN_TWI_CLK_KHZ=100
 CONFIG_SPI=y
 CONFIG_SPI_BFIN5XX=y
-CONFIG_GPIOLIB=y
+CONFIG_GPIO=y
 CONFIG_GPIO_SYSFS=y
 # CONFIG_HWMON is not set
 CONFIG_WATCHDOG=y
diff --git a/arch/blackfin/configs/BF538-EZKIT_defconfig b/arch/blackfin/configs/BF538-EZKIT_defconfig
index 972aa62..8a8f725 100644
--- a/arch/blackfin/configs/BF538-EZKIT_defconfig
+++ b/arch/blackfin/configs/BF538-EZKIT_defconfig
@@ -102,7 +102,7 @@ CONFIG_I2C_BLACKFIN_TWI=m
 CONFIG_I2C_BLACKFIN_TWI_CLK_KHZ=100
 CONFIG_SPI=y
 CONFIG_SPI_BFIN5XX=y
-CONFIG_GPIOLIB=y
+CONFIG_GPIO=y
 CONFIG_GPIO_SYSFS=y
 # CONFIG_HWMON is not set
 CONFIG_WATCHDOG=y
diff --git a/arch/blackfin/configs/BF548-EZKIT_defconfig b/arch/blackfin/configs/BF548-EZKIT_defconfig
index e716fdf..6b90555 100644
--- a/arch/blackfin/configs/BF548-EZKIT_defconfig
+++ b/arch/blackfin/configs/BF548-EZKIT_defconfig
@@ -119,7 +119,7 @@ CONFIG_I2C_BLACKFIN_TWI=y
 CONFIG_I2C_BLACKFIN_TWI_CLK_KHZ=100
 CONFIG_SPI=y
 CONFIG_SPI_BFIN5XX=y
-CONFIG_GPIOLIB=y
+CONFIG_GPIO=y
 CONFIG_GPIO_SYSFS=y
 # CONFIG_HWMON is not set
 CONFIG_WATCHDOG=y
diff --git a/arch/blackfin/configs/BF561-ACVILON_defconfig b/arch/blackfin/configs/BF561-ACVILON_defconfig
index 9198837..3d55b5e 100644
--- a/arch/blackfin/configs/BF561-ACVILON_defconfig
+++ b/arch/blackfin/configs/BF561-ACVILON_defconfig
@@ -86,7 +86,7 @@ CONFIG_I2C_PCA_PLATFORM=y
 CONFIG_SPI=y
 CONFIG_SPI_BFIN5XX=y
 CONFIG_SPI_SPIDEV=y
-CONFIG_GPIOLIB=y
+CONFIG_GPIO=y
 CONFIG_GPIO_SYSFS=y
 CONFIG_GPIO_PCF857X=y
 CONFIG_SENSORS_LM75=y
diff --git a/arch/blackfin/configs/BF561-EZKIT-SMP_defconfig b/arch/blackfin/configs/BF561-EZKIT-SMP_defconfig
index e2a2fa5..5cdc3c0 100644
--- a/arch/blackfin/configs/BF561-EZKIT-SMP_defconfig
+++ b/arch/blackfin/configs/BF561-EZKIT-SMP_defconfig
@@ -87,7 +87,7 @@ CONFIG_SERIAL_BFIN_CONSOLE=y
 # CONFIG_HW_RANDOM is not set
 CONFIG_SPI=y
 CONFIG_SPI_BFIN5XX=y
-CONFIG_GPIOLIB=y
+CONFIG_GPIO=y
 CONFIG_GPIO_SYSFS=y
 # CONFIG_HWMON is not set
 CONFIG_WATCHDOG=y
diff --git a/arch/blackfin/configs/BF561-EZKIT_defconfig b/arch/blackfin/configs/BF561-EZKIT_defconfig
index 680730e..3392b29 100644
--- a/arch/blackfin/configs/BF561-EZKIT_defconfig
+++ b/arch/blackfin/configs/BF561-EZKIT_defconfig
@@ -89,7 +89,7 @@ CONFIG_SERIAL_BFIN_CONSOLE=y
 # CONFIG_HW_RANDOM is not set
 CONFIG_SPI=y
 CONFIG_SPI_BFIN5XX=y
-CONFIG_GPIOLIB=y
+CONFIG_GPIO=y
 CONFIG_GPIO_SYSFS=y
 # CONFIG_HWMON is not set
 CONFIG_WATCHDOG=y
diff --git a/arch/blackfin/configs/BF609-EZKIT_defconfig b/arch/blackfin/configs/BF609-EZKIT_defconfig
index 13eb732..d15a9b4 100644
--- a/arch/blackfin/configs/BF609-EZKIT_defconfig
+++ b/arch/blackfin/configs/BF609-EZKIT_defconfig
@@ -103,7 +103,7 @@ CONFIG_I2C_BLACKFIN_TWI=y
 CONFIG_I2C_BLACKFIN_TWI_CLK_KHZ=100
 CONFIG_SPI=y
 CONFIG_SPI_BFIN6XX=y
-CONFIG_GPIOLIB=y
+CONFIG_GPIO=y
 CONFIG_GPIO_SYSFS=y
 # CONFIG_HWMON is not set
 CONFIG_WATCHDOG=y
diff --git a/arch/blackfin/configs/CM-BF527_defconfig b/arch/blackfin/configs/CM-BF527_defconfig
index f59c80e..27e4f29 100644
--- a/arch/blackfin/configs/CM-BF527_defconfig
+++ b/arch/blackfin/configs/CM-BF527_defconfig
@@ -89,7 +89,7 @@ CONFIG_I2C_BLACKFIN_TWI=m
 CONFIG_I2C_BLACKFIN_TWI_CLK_KHZ=100
 CONFIG_SPI=y
 CONFIG_SPI_BFIN5XX=y
-CONFIG_GPIOLIB=y
+CONFIG_GPIO=y
 CONFIG_GPIO_SYSFS=y
 CONFIG_WATCHDOG=y
 CONFIG_BFIN_WDT=y
diff --git a/arch/blackfin/configs/CM-BF537E_defconfig b/arch/blackfin/configs/CM-BF537E_defconfig
index 2e47df7..c183f80 100644
--- a/arch/blackfin/configs/CM-BF537E_defconfig
+++ b/arch/blackfin/configs/CM-BF537E_defconfig
@@ -79,7 +79,7 @@ CONFIG_SERIAL_BFIN_UART1=y
 # CONFIG_HW_RANDOM is not set
 CONFIG_SPI=y
 CONFIG_SPI_BFIN5XX=y
-CONFIG_GPIOLIB=y
+CONFIG_GPIO=y
 CONFIG_GPIO_SYSFS=y
 CONFIG_USB_GADGET=m
 CONFIG_USB_ETH=m
diff --git a/arch/blackfin/configs/CM-BF537U_defconfig b/arch/blackfin/configs/CM-BF537U_defconfig
index 6da629f..9d55206 100644
--- a/arch/blackfin/configs/CM-BF537U_defconfig
+++ b/arch/blackfin/configs/CM-BF537U_defconfig
@@ -73,7 +73,7 @@ CONFIG_SERIAL_BFIN_UART1=y
 # CONFIG_HW_RANDOM is not set
 CONFIG_SPI=y
 CONFIG_SPI_BFIN5XX=y
-CONFIG_GPIOLIB=y
+CONFIG_GPIO=y
 CONFIG_GPIO_SYSFS=y
 CONFIG_USB_GADGET=y
 CONFIG_USB_ETH=y
diff --git a/arch/blackfin/configs/CM-BF561_defconfig b/arch/blackfin/configs/CM-BF561_defconfig
index 24936b9..7a61319 100644
--- a/arch/blackfin/configs/CM-BF561_defconfig
+++ b/arch/blackfin/configs/CM-BF561_defconfig
@@ -79,7 +79,7 @@ CONFIG_SERIAL_BFIN_CONSOLE=y
 # CONFIG_HW_RANDOM is not set
 CONFIG_SPI=y
 CONFIG_SPI_BFIN5XX=y
-CONFIG_GPIOLIB=y
+CONFIG_GPIO=y
 CONFIG_GPIO_SYSFS=y
 CONFIG_USB_GADGET=m
 CONFIG_USB_ETH=m
diff --git a/arch/blackfin/configs/DNP5370_defconfig b/arch/blackfin/configs/DNP5370_defconfig
index 89162d0..4e012c7 100644
--- a/arch/blackfin/configs/DNP5370_defconfig
+++ b/arch/blackfin/configs/DNP5370_defconfig
@@ -80,7 +80,7 @@ CONFIG_I2C_BLACKFIN_TWI=y
 CONFIG_SPI=y
 CONFIG_SPI_BFIN5XX=y
 CONFIG_SPI_SPIDEV=y
-CONFIG_GPIOLIB=y
+CONFIG_GPIO=y
 CONFIG_GPIO_SYSFS=y
 CONFIG_SENSORS_LM75=y
 # CONFIG_USB_SUPPORT is not set
diff --git a/arch/blackfin/configs/TCM-BF518_defconfig b/arch/blackfin/configs/TCM-BF518_defconfig
index e4ed865..1a4044a 100644
--- a/arch/blackfin/configs/TCM-BF518_defconfig
+++ b/arch/blackfin/configs/TCM-BF518_defconfig
@@ -93,7 +93,7 @@ CONFIG_I2C_BLACKFIN_TWI=y
 CONFIG_I2C_BLACKFIN_TWI_CLK_KHZ=100
 CONFIG_SPI=y
 CONFIG_SPI_BFIN5XX=y
-CONFIG_GPIOLIB=y
+CONFIG_GPIO=y
 CONFIG_GPIO_SYSFS=y
 # CONFIG_HWMON is not set
 CONFIG_WATCHDOG=y
diff --git a/arch/blackfin/include/asm/gpio.h b/arch/blackfin/include/asm/gpio.h
index 98d0133..1a815b8 100644
--- a/arch/blackfin/include/asm/gpio.h
+++ b/arch/blackfin/include/asm/gpio.h
@@ -191,7 +191,7 @@ void bfin_gpio_set_value(unsigned gpio, int value);
 #include <asm/irq.h>
 #include <asm/errno.h>
 
-#ifdef CONFIG_GPIOLIB
+#ifdef CONFIG_GPIO
 #include <asm-generic/gpio.h>		/* cansleep wrappers */
 
 static inline int gpio_get_value(unsigned int gpio)
@@ -220,7 +220,7 @@ static inline int gpio_to_irq(unsigned gpio)
 	return __gpio_to_irq(gpio);
 }
 
-#else /* !CONFIG_GPIOLIB */
+#else /* !CONFIG_GPIO */
 
 static inline int gpio_request(unsigned gpio, const char *label)
 {
@@ -319,7 +319,7 @@ static inline int gpio_to_irq(unsigned gpio)
 }
 
 #include <asm-generic/gpio.h>		/* cansleep wrappers */
-#endif	/* !CONFIG_GPIOLIB */
+#endif	/* !CONFIG_GPIO */
 
 static inline int irq_to_gpio(unsigned irq)
 {
diff --git a/arch/blackfin/kernel/bfin_gpio.c b/arch/blackfin/kernel/bfin_gpio.c
index ed978f1..2507696 100644
--- a/arch/blackfin/kernel/bfin_gpio.c
+++ b/arch/blackfin/kernel/bfin_gpio.c
@@ -1271,7 +1271,7 @@ static __init int gpio_register_proc(void)
 __initcall(gpio_register_proc);
 #endif
 
-#ifdef CONFIG_GPIOLIB
+#ifdef CONFIG_GPIO
 static int bfin_gpiolib_direction_input(struct gpio_chip *chip, unsigned gpio)
 {
 	return bfin_gpio_direction_input(gpio);
diff --git a/arch/blackfin/mach-bf538/Makefile b/arch/blackfin/mach-bf538/Makefile
index c0be54f..7846002 100644
--- a/arch/blackfin/mach-bf538/Makefile
+++ b/arch/blackfin/mach-bf538/Makefile
@@ -3,4 +3,4 @@
 #
 
 obj-y := ints-priority.o dma.o
-obj-$(CONFIG_GPIOLIB)	+= ext-gpio.o
+obj-$(CONFIG_GPIO)	+= ext-gpio.o
diff --git a/arch/blackfin/mach-bf538/include/mach/gpio.h b/arch/blackfin/mach-bf538/include/mach/gpio.h
index 3561c7d..948d1b6 100644
--- a/arch/blackfin/mach-bf538/include/mach/gpio.h
+++ b/arch/blackfin/mach-bf538/include/mach/gpio.h
@@ -8,7 +8,7 @@
 #define _MACH_GPIO_H_
 
 #define MAX_BLACKFIN_GPIOS 16
-#ifdef CONFIG_GPIOLIB
+#ifdef CONFIG_GPIO
 /* We only use the special logic with GPIOLIB devices */
 #define BFIN_SPECIAL_GPIO_BANKS 3
 #endif
diff --git a/arch/hexagon/Kconfig b/arch/hexagon/Kconfig
index 21d6ba9..44e1fe4 100644
--- a/arch/hexagon/Kconfig
+++ b/arch/hexagon/Kconfig
@@ -9,8 +9,8 @@ config HEXAGON
 	# select HAVE_REGS_AND_STACK_ACCESS_API
 	# select HAVE_HW_BREAKPOINT if PERF_EVENTS
 	# select ARCH_HAS_CPU_IDLE_WAIT
-	# select ARCH_WANT_OPTIONAL_GPIOLIB
-	# select ARCH_REQUIRE_GPIOLIB
+	# select ARCH_WANT_OPTIONAL_GPIO
+	# select ARCH_REQUIRE_GPIO
 	# select HAVE_CLK
 	# select GENERIC_PENDING_IRQ if SMP
 	select GENERIC_ATOMIC64
diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
index 38ef339..66ed2d4 100644
--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -31,7 +31,7 @@ config IA64
 	select GENERIC_IRQ_PROBE
 	select GENERIC_PENDING_IRQ if SMP
 	select GENERIC_IRQ_SHOW
-	select ARCH_WANT_OPTIONAL_GPIOLIB
+	select ARCH_WANT_OPTIONAL_GPIO
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select GENERIC_IOMAP
 	select GENERIC_SMP_IDLE_THREAD
diff --git a/arch/m68k/Kconfig.cpu b/arch/m68k/Kconfig.cpu
index d266787..c812b0c 100644
--- a/arch/m68k/Kconfig.cpu
+++ b/arch/m68k/Kconfig.cpu
@@ -22,7 +22,7 @@ config M68KCLASSIC
 
 config COLDFIRE
 	bool "Coldfire CPU family support"
-	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_REQUIRE_GPIO
 	select ARCH_HAVE_CUSTOM_GPIO_H
 	select CPU_HAS_NO_BITFIELDS
 	select CPU_HAS_NO_MULDIV64
diff --git a/arch/m68k/include/asm/mcfgpio.h b/arch/m68k/include/asm/mcfgpio.h
index fa1059f..e834016 100644
--- a/arch/m68k/include/asm/mcfgpio.h
+++ b/arch/m68k/include/asm/mcfgpio.h
@@ -16,7 +16,7 @@
 #ifndef mcfgpio_h
 #define mcfgpio_h
 
-#ifdef CONFIG_GPIOLIB
+#ifdef CONFIG_GPIO
 #include <asm-generic/gpio.h>
 #else
 
@@ -85,7 +85,7 @@ static inline void gpio_free(unsigned gpio)
 		__mcfgpio_free(gpio);
 }
 
-#endif /* CONFIG_GPIOLIB */
+#endif /* CONFIG_GPIO */
 
 
 /*
diff --git a/arch/m68k/platform/coldfire/gpio.c b/arch/m68k/platform/coldfire/gpio.c
index 9cd2b5c..3a79660 100644
--- a/arch/m68k/platform/coldfire/gpio.c
+++ b/arch/m68k/platform/coldfire/gpio.c
@@ -115,7 +115,7 @@ void __mcfgpio_free(unsigned gpio)
 }
 EXPORT_SYMBOL(__mcfgpio_free);
 
-#ifdef CONFIG_GPIOLIB
+#ifdef CONFIG_GPIO
 
 int mcfgpio_direction_input(struct gpio_chip *chip, unsigned offset)
 {
diff --git a/arch/microblaze/Kconfig b/arch/microblaze/Kconfig
index 4fb682a..1109812 100644
--- a/arch/microblaze/Kconfig
+++ b/arch/microblaze/Kconfig
@@ -7,7 +7,7 @@ config MICROBLAZE
 	select HAVE_FUNCTION_GRAPH_TRACER
 	select HAVE_DYNAMIC_FTRACE
 	select HAVE_FTRACE_MCOUNT_RECORD
-	select ARCH_WANT_OPTIONAL_GPIOLIB
+	select ARCH_WANT_OPTIONAL_GPIO
 	select HAVE_OPROFILE
 	select HAVE_ARCH_KGDB
 	select HAVE_DMA_ATTRS
diff --git a/arch/microblaze/configs/mmu_defconfig b/arch/microblaze/configs/mmu_defconfig
index d2b097a..665c31a 100644
--- a/arch/microblaze/configs/mmu_defconfig
+++ b/arch/microblaze/configs/mmu_defconfig
@@ -57,7 +57,7 @@ CONFIG_I2C=y
 CONFIG_I2C_XILINX=y
 CONFIG_SPI=y
 CONFIG_SPI_XILINX=y
-CONFIG_GPIOLIB=y
+CONFIG_GPIO=y
 CONFIG_GPIO_SYSFS=y
 CONFIG_GPIO_XILINX=y
 # CONFIG_HWMON is not set
diff --git a/arch/microblaze/configs/nommu_defconfig b/arch/microblaze/configs/nommu_defconfig
index 10b5172..b279cfe 100644
--- a/arch/microblaze/configs/nommu_defconfig
+++ b/arch/microblaze/configs/nommu_defconfig
@@ -64,7 +64,7 @@ CONFIG_I2C=y
 CONFIG_I2C_XILINX=y
 CONFIG_SPI=y
 CONFIG_SPI_XILINX=y
-CONFIG_GPIOLIB=y
+CONFIG_GPIO=y
 CONFIG_GPIO_SYSFS=y
 CONFIG_GPIO_XILINX=y
 # CONFIG_HWMON is not set
diff --git a/arch/microblaze/kernel/reset.c b/arch/microblaze/kernel/reset.c
index 2e5079a..e139dc7 100644
--- a/arch/microblaze/kernel/reset.c
+++ b/arch/microblaze/kernel/reset.c
@@ -12,7 +12,7 @@
 #include <asm/prom.h>
 
 /* Trigger specific functions */
-#ifdef CONFIG_GPIOLIB
+#ifdef CONFIG_GPIO
 
 #include <linux/of_gpio.h>
 
diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 5393981..6aad474 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -61,7 +61,7 @@ config MIPS_ALCHEMY
 	select SYS_HAS_CPU_MIPS32_R1
 	select SYS_SUPPORTS_32BIT_KERNEL
 	select SYS_SUPPORTS_APM_EMULATION
-	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_REQUIRE_GPIO
 	select SYS_SUPPORTS_ZBOOT
 	select USB_ARCH_HAS_OHCI
 	select USB_ARCH_HAS_EHCI
@@ -80,7 +80,7 @@ config AR7
 	select SYS_SUPPORTS_32BIT_KERNEL
 	select SYS_SUPPORTS_LITTLE_ENDIAN
 	select SYS_SUPPORTS_ZBOOT_UART16550
-	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_REQUIRE_GPIO
 	select VLYNQ
 	select HAVE_CLK
 	help
@@ -89,7 +89,7 @@ config AR7
 
 config ATH79
 	bool "Atheros AR71XX/AR724X/AR913X based boards"
-	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_REQUIRE_GPIO
 	select BOOT_RAW
 	select CEVT_R4K
 	select CSRC_R4K
@@ -106,7 +106,7 @@ config ATH79
 
 config BCM47XX
 	bool "Broadcom BCM47XX based boards"
-	select ARCH_WANT_OPTIONAL_GPIOLIB
+	select ARCH_WANT_OPTIONAL_GPIO
 	select BOOT_RAW
 	select CEVT_R4K
 	select CSRC_R4K
@@ -132,7 +132,7 @@ config BCM63XX
 	select SYS_SUPPORTS_BIG_ENDIAN
 	select SYS_HAS_EARLY_PRINTK
 	select SWAP_IO_SPACE
-	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_REQUIRE_GPIO
 	select HAVE_CLK
 	help
 	 Support for BCM63XX based boards
@@ -224,7 +224,7 @@ config MACH_JZ4740
 	select SYS_SUPPORTS_ZBOOT_UART16550
 	select DMA_NONCOHERENT
 	select IRQ_CPU
-	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_REQUIRE_GPIO
 	select SYS_HAS_EARLY_PRINTK
 	select HAVE_PWM
 	select HAVE_CLK
@@ -242,7 +242,7 @@ config LANTIQ
 	select SYS_SUPPORTS_32BIT_KERNEL
 	select SYS_SUPPORTS_MULTITHREADING
 	select SYS_HAS_EARLY_PRINTK
-	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_REQUIRE_GPIO
 	select SWAP_IO_SPACE
 	select BOOT_RAW
 	select HAVE_MACH_CLKDEV
@@ -372,7 +372,7 @@ config MACH_VR41XX
 	select CEVT_R4K
 	select CSRC_R4K
 	select SYS_HAS_CPU_VR41XX
-	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_REQUIRE_GPIO
 
 config NXP_STB220
 	bool "NXP STB220 board"
@@ -705,7 +705,7 @@ config MIKROTIK_RB532
 	select SYS_SUPPORTS_LITTLE_ENDIAN
 	select SWAP_IO_SPACE
 	select BOOT_RAW
-	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_REQUIRE_GPIO
 	help
 	  Support the Mikrotik(tm) RouterBoard 532 series,
 	  based on the IDT RC32434 SoC.
@@ -933,7 +933,7 @@ config CSRC_SB1250
 	bool
 
 config GPIO_TXX9
-	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_REQUIRE_GPIO
 	bool
 
 config FW_CFE
@@ -1194,7 +1194,7 @@ config CPU_LOONGSON2F
 	bool "Loongson 2F"
 	depends on SYS_HAS_CPU_LOONGSON2F
 	select CPU_LOONGSON2
-	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_REQUIRE_GPIO
 	help
 	  The Loongson 2F processor implements the MIPS III instruction set
 	  with many extensions.
diff --git a/arch/mips/alchemy/Kconfig b/arch/mips/alchemy/Kconfig
index c8862bd..3d5a14b 100644
--- a/arch/mips/alchemy/Kconfig
+++ b/arch/mips/alchemy/Kconfig
@@ -38,7 +38,7 @@ config MIPS_DB1000
 
 config MIPS_DB1235
 	bool "Alchemy DB1200/PB1200/DB1300/DB1550/PB1550 boards"
-	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_REQUIRE_GPIO
 	select HW_HAS_PCI
 	select DMA_COHERENT
 	select MIPS_DISABLE_OBSOLETE_IDE
diff --git a/arch/mips/alchemy/common/Makefile b/arch/mips/alchemy/common/Makefile
index cb83d8d..3e62e8d 100644
--- a/arch/mips/alchemy/common/Makefile
+++ b/arch/mips/alchemy/common/Makefile
@@ -10,5 +10,5 @@ obj-y += prom.o time.o clocks.o platform.o power.o setup.o \
 
 # optional gpiolib support
 ifeq ($(CONFIG_ALCHEMY_GPIO_INDIRECT),)
- obj-$(CONFIG_GPIOLIB) += gpiolib.o
+ obj-$(CONFIG_GPIO) += gpiolib.o
 endif
diff --git a/arch/mips/alchemy/common/gpiolib.c b/arch/mips/alchemy/common/gpiolib.c
index f9bc4f5..4fda65b 100644
--- a/arch/mips/alchemy/common/gpiolib.c
+++ b/arch/mips/alchemy/common/gpiolib.c
@@ -23,7 +23,7 @@
  *  675 Mass Ave, Cambridge, MA 02139, USA.
  *
  *  Notes :
- *	This file must ONLY be built when CONFIG_GPIOLIB=y and
+ *	This file must ONLY be built when CONFIG_GPIO=y and
  *	 CONFIG_ALCHEMY_GPIO_INDIRECT=n, otherwise compilation will fail!
  *	au1000 SoC have only one GPIO block : GPIO1
  *	Au1100, Au15x0, Au12x0 have a second one : GPIO2
diff --git a/arch/mips/bcm47xx/Kconfig b/arch/mips/bcm47xx/Kconfig
index ba61192..5108e99 100644
--- a/arch/mips/bcm47xx/Kconfig
+++ b/arch/mips/bcm47xx/Kconfig
@@ -11,7 +11,7 @@ config BCM47XX_SSB
 	select SSB_DRIVER_PCICORE if PCI
 	select SSB_PCICORE_HOSTMODE if PCI
 	select SSB_DRIVER_GPIO
-	select GPIOLIB
+	select GPIO
 	default y
 	help
 	 Add support for old Broadcom BCM47xx boards with Sonics Silicon Backplane support.
@@ -27,7 +27,7 @@ config BCM47XX_BCMA
 	select BCMA_HOST_PCI if PCI
 	select BCMA_DRIVER_PCI_HOSTMODE if PCI
 	select BCMA_DRIVER_GPIO
-	select GPIOLIB
+	select GPIO
 	default y
 	help
 	 Add support for new Broadcom BCM47xx boards with Broadcom specific Advanced Microcontroller Bus.
diff --git a/arch/mips/configs/db1000_defconfig b/arch/mips/configs/db1000_defconfig
index face9d2..e14a75d 100644
--- a/arch/mips/configs/db1000_defconfig
+++ b/arch/mips/configs/db1000_defconfig
@@ -193,7 +193,7 @@ CONFIG_SERIAL_CORE=y
 CONFIG_SERIAL_CORE_CONSOLE=y
 CONFIG_TTY_PRINTK=y
 CONFIG_DEVPORT=y
-CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
+CONFIG_ARCH_WANT_OPTIONAL_GPIO=y
 CONFIG_FB=y
 CONFIG_FB_CFB_FILLRECT=y
 CONFIG_FB_CFB_COPYAREA=y
diff --git a/arch/mips/configs/gpr_defconfig b/arch/mips/configs/gpr_defconfig
index fb64589..647afcc 100644
--- a/arch/mips/configs/gpr_defconfig
+++ b/arch/mips/configs/gpr_defconfig
@@ -268,7 +268,7 @@ CONFIG_HW_RANDOM=y
 CONFIG_I2C=y
 CONFIG_I2C_CHARDEV=y
 CONFIG_I2C_GPIO=y
-CONFIG_GPIOLIB=y
+CONFIG_GPIO=y
 CONFIG_GPIO_SYSFS=y
 CONFIG_SENSORS_LM83=y
 CONFIG_WATCHDOG=y
diff --git a/arch/mips/configs/mtx1_defconfig b/arch/mips/configs/mtx1_defconfig
index 9fa8f16..49ab9d3 100644
--- a/arch/mips/configs/mtx1_defconfig
+++ b/arch/mips/configs/mtx1_defconfig
@@ -454,7 +454,7 @@ CONFIG_HW_RANDOM=y
 CONFIG_I2C=m
 CONFIG_I2C_CHARDEV=m
 CONFIG_I2C_GPIO=m
-CONFIG_GPIOLIB=y
+CONFIG_GPIO=y
 CONFIG_GPIO_SYSFS=y
 CONFIG_SENSORS_ADM1021=m
 CONFIG_SENSORS_ADM1025=m
diff --git a/arch/mips/include/asm/mach-au1x00/gpio-au1000.h b/arch/mips/include/asm/mach-au1x00/gpio-au1000.h
index 796afd0..c054912 100644
--- a/arch/mips/include/asm/mach-au1x00/gpio-au1000.h
+++ b/arch/mips/include/asm/mach-au1x00/gpio-au1000.h
@@ -548,7 +548,7 @@ static inline int alchemy_irq_to_gpio(int irq)
  * as required).
  */
 
-#ifndef CONFIG_GPIOLIB
+#ifndef CONFIG_GPIO
 
 #ifdef CONFIG_ALCHEMY_GPIOINT_AU1000
 
@@ -657,6 +657,6 @@ static inline void gpio_unexport(unsigned gpio)
 
 #endif	/* CONFIG_ALCHEMY_GPIOINT_AU1000 */
 
-#endif	/* !CONFIG_GPIOLIB */
+#endif	/* !CONFIG_GPIO */
 
 #endif /* _ALCHEMY_GPIO_AU1000_H_ */
diff --git a/arch/mips/include/asm/mach-au1x00/gpio-au1300.h b/arch/mips/include/asm/mach-au1x00/gpio-au1300.h
index ce02894..079c85a 100644
--- a/arch/mips/include/asm/mach-au1x00/gpio-au1300.h
+++ b/arch/mips/include/asm/mach-au1x00/gpio-au1300.h
@@ -145,7 +145,7 @@ static inline int au1300_gpio_getinitlvl(unsigned int gpio)
 * as required).
 */
 
-#ifndef CONFIG_GPIOLIB
+#ifndef CONFIG_GPIO
 
 #ifdef CONFIG_ALCHEMY_GPIOINT_AU1300
 
diff --git a/arch/mips/include/asm/mach-au1x00/gpio.h b/arch/mips/include/asm/mach-au1x00/gpio.h
index 22e7ff1..581d001 100644
--- a/arch/mips/include/asm/mach-au1x00/gpio.h
+++ b/arch/mips/include/asm/mach-au1x00/gpio.h
@@ -1,9 +1,9 @@
 /*
  * Alchemy GPIO support.
  *
- * With CONFIG_GPIOLIB=y different types of on-chip GPIO can be supported within
+ * With CONFIG_GPIO=y different types of on-chip GPIO can be supported within
  *  the same kernel image.
- * With CONFIG_GPIOLIB=n, your board must select ALCHEMY_GPIOINT_AU1XXX for the
+ * With CONFIG_GPIO=n, your board must select ALCHEMY_GPIOINT_AU1XXX for the
  *  appropriate CPU type (AU1000 currently).
  */
 
@@ -50,7 +50,7 @@ static inline void alchemy_gpio1_input_enable(void)
 * as required).
 */
 
-#ifdef CONFIG_GPIOLIB
+#ifdef CONFIG_GPIO
 
 /* wraps the cpu-dependent irq_to_gpio functions */
 /* FIXME: gpiolib needs an irq_to_gpio hook */
@@ -81,6 +81,6 @@ static inline int __au_irq_to_gpio(unsigned int irq)
 #endif	/* !CONFIG_ALCHEMY_GPIO_INDIRECT */
 
 
-#endif	/* CONFIG_GPIOLIB */
+#endif	/* CONFIG_GPIO */
 
 #endif	/* _ALCHEMY_GPIO_H_ */
diff --git a/arch/mips/include/asm/mach-generic/gpio.h b/arch/mips/include/asm/mach-generic/gpio.h
index b4e7020..8f67f92 100644
--- a/arch/mips/include/asm/mach-generic/gpio.h
+++ b/arch/mips/include/asm/mach-generic/gpio.h
@@ -1,7 +1,7 @@
 #ifndef __ASM_MACH_GENERIC_GPIO_H
 #define __ASM_MACH_GENERIC_GPIO_H
 
-#ifdef CONFIG_GPIOLIB
+#ifdef CONFIG_GPIO
 #define gpio_get_value	__gpio_get_value
 #define gpio_set_value	__gpio_set_value
 #define gpio_cansleep	__gpio_cansleep
diff --git a/arch/mips/loongson/common/Makefile b/arch/mips/loongson/common/Makefile
index 4c57b3e..5150230 100644
--- a/arch/mips/loongson/common/Makefile
+++ b/arch/mips/loongson/common/Makefile
@@ -4,7 +4,7 @@
 
 obj-y += setup.o init.o cmdline.o env.o time.o reset.o irq.o \
     pci.o bonito-irq.o mem.o machtype.o platform.o
-obj-$(CONFIG_GPIOLIB) += gpio.o
+obj-$(CONFIG_GPIO) += gpio.o
 
 #
 # Serial port support
diff --git a/arch/mips/txx9/generic/setup.c b/arch/mips/txx9/generic/setup.c
index 5364aab..7197df2 100644
--- a/arch/mips/txx9/generic/setup.c
+++ b/arch/mips/txx9/generic/setup.c
@@ -118,7 +118,7 @@ EXPORT_SYMBOL(clk_put);
 
 /* GPIO support */
 
-#ifdef CONFIG_GPIOLIB
+#ifdef CONFIG_GPIO
 int gpio_to_irq(unsigned gpio)
 {
 	return -EINVAL;
diff --git a/arch/openrisc/Kconfig b/arch/openrisc/Kconfig
index 6c404ee..10e432e 100644
--- a/arch/openrisc/Kconfig
+++ b/arch/openrisc/Kconfig
@@ -9,7 +9,7 @@ config OPENRISC
 	select OF_EARLY_FLATTREE
 	select IRQ_DOMAIN
 	select HAVE_MEMBLOCK
-	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_REQUIRE_GPIO
         select HAVE_ARCH_TRACEHOOK
 	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_IRQ_CHIP
diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 9c5bc68..4376512 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -93,7 +93,7 @@ config PPC
 	select HAVE_FUNCTION_TRACER
 	select HAVE_FUNCTION_GRAPH_TRACER
 	select SYSCTL_EXCEPTION_TRACE
-	select ARCH_WANT_OPTIONAL_GPIOLIB
+	select ARCH_WANT_OPTIONAL_GPIO
 	select VIRT_TO_BUS if !PPC64
 	select HAVE_IDE
 	select HAVE_IOREMAP_PROT
diff --git a/arch/powerpc/configs/40x/virtex_defconfig b/arch/powerpc/configs/40x/virtex_defconfig
index 0a81e1f..d9f2ab6 100644
--- a/arch/powerpc/configs/40x/virtex_defconfig
+++ b/arch/powerpc/configs/40x/virtex_defconfig
@@ -53,7 +53,7 @@ CONFIG_SERIAL_UARTLITE=y
 CONFIG_SERIAL_UARTLITE_CONSOLE=y
 CONFIG_SERIAL_OF_PLATFORM=y
 CONFIG_XILINX_HWICAP=y
-CONFIG_GPIOLIB=y
+CONFIG_GPIO=y
 CONFIG_GPIO_SYSFS=y
 CONFIG_GPIO_XILINX=y
 # CONFIG_HWMON is not set
diff --git a/arch/powerpc/configs/44x/virtex5_defconfig b/arch/powerpc/configs/44x/virtex5_defconfig
index 1eb3caf..56f154a 100644
--- a/arch/powerpc/configs/44x/virtex5_defconfig
+++ b/arch/powerpc/configs/44x/virtex5_defconfig
@@ -52,7 +52,7 @@ CONFIG_SERIAL_UARTLITE=y
 CONFIG_SERIAL_UARTLITE_CONSOLE=y
 CONFIG_SERIAL_OF_PLATFORM=y
 CONFIG_XILINX_HWICAP=y
-CONFIG_GPIOLIB=y
+CONFIG_GPIO=y
 CONFIG_GPIO_SYSFS=y
 CONFIG_GPIO_XILINX=y
 # CONFIG_HWMON is not set
diff --git a/arch/powerpc/configs/mpc512x_defconfig b/arch/powerpc/configs/mpc512x_defconfig
index 211fcc9..1f0f7ab 100644
--- a/arch/powerpc/configs/mpc512x_defconfig
+++ b/arch/powerpc/configs/mpc512x_defconfig
@@ -101,7 +101,7 @@ CONFIG_I2C_CHARDEV=y
 CONFIG_I2C_MPC=y
 CONFIG_SPI=y
 CONFIG_SPI_MPC512x_PSC=y
-CONFIG_GPIOLIB=y
+CONFIG_GPIO=y
 CONFIG_GPIO_SYSFS=y
 CONFIG_GPIO_MPC8XXX=y
 # CONFIG_HWMON is not set
diff --git a/arch/powerpc/configs/wii_defconfig b/arch/powerpc/configs/wii_defconfig
index 1e2b7d0..e00d261 100644
--- a/arch/powerpc/configs/wii_defconfig
+++ b/arch/powerpc/configs/wii_defconfig
@@ -85,7 +85,7 @@ CONFIG_NVRAM=y
 CONFIG_I2C=y
 CONFIG_I2C_CHARDEV=y
 CONFIG_I2C_GPIO=y
-CONFIG_GPIOLIB=y
+CONFIG_GPIO=y
 CONFIG_GPIO_SYSFS=y
 # CONFIG_HWMON is not set
 CONFIG_SSB_DEBUG=y
diff --git a/arch/powerpc/platforms/40x/Kconfig b/arch/powerpc/platforms/40x/Kconfig
index d0b46a2..94afdb8 100644
--- a/arch/powerpc/platforms/40x/Kconfig
+++ b/arch/powerpc/platforms/40x/Kconfig
@@ -144,7 +144,7 @@ config STB03xxx
 config PPC4xx_GPIO
 	bool "PPC4xx GPIO support"
 	depends on 40x
-	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_REQUIRE_GPIO
 	help
 	  Enable gpiolib support for ppc40x based boards
 
diff --git a/arch/powerpc/platforms/44x/Kconfig b/arch/powerpc/platforms/44x/Kconfig
index 50306b8..b30d07e 100644
--- a/arch/powerpc/platforms/44x/Kconfig
+++ b/arch/powerpc/platforms/44x/Kconfig
@@ -247,7 +247,7 @@ config PPC44x_SIMPLE
 config PPC4xx_GPIO
 	bool "PPC4xx GPIO support"
 	depends on 44x
-	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_REQUIRE_GPIO
 	help
 	  Enable gpiolib support for ppc440 based boards
 
diff --git a/arch/powerpc/platforms/512x/Kconfig b/arch/powerpc/platforms/512x/Kconfig
index c169998..cbcc57b 100644
--- a/arch/powerpc/platforms/512x/Kconfig
+++ b/arch/powerpc/platforms/512x/Kconfig
@@ -6,7 +6,7 @@ config PPC_MPC512x
 	select PPC_CLOCK
 	select PPC_PCI_CHOICE
 	select FSL_PCI if PCI
-	select ARCH_WANT_OPTIONAL_GPIOLIB
+	select ARCH_WANT_OPTIONAL_GPIO
 
 config MPC5121_ADS
 	bool "Freescale MPC5121E ADS"
diff --git a/arch/powerpc/platforms/52xx/mpc52xx_gpt.c b/arch/powerpc/platforms/52xx/mpc52xx_gpt.c
index 6929982..37f26a3 100644
--- a/arch/powerpc/platforms/52xx/mpc52xx_gpt.c
+++ b/arch/powerpc/platforms/52xx/mpc52xx_gpt.c
@@ -95,7 +95,7 @@ struct mpc52xx_gpt_priv {
 	u32 ipb_freq;
 	u8 wdt_mode;
 
-#if defined(CONFIG_GPIOLIB)
+#if defined(CONFIG_GPIO)
 	struct gpio_chip gc;
 #endif
 };
@@ -277,7 +277,7 @@ mpc52xx_gpt_irq_setup(struct mpc52xx_gpt_priv *gpt, struct device_node *node)
 /* ---------------------------------------------------------------------
  * GPIOLIB hooks
  */
-#if defined(CONFIG_GPIOLIB)
+#if defined(CONFIG_GPIO)
 static inline struct mpc52xx_gpt_priv *gc_to_mpc52xx_gpt(struct gpio_chip *gc)
 {
 	return container_of(gc, struct mpc52xx_gpt_priv, gc);
@@ -360,10 +360,10 @@ mpc52xx_gpt_gpio_setup(struct mpc52xx_gpt_priv *gpt, struct device_node *node)
 
 	dev_dbg(gpt->dev, "%s() complete.\n", __func__);
 }
-#else /* defined(CONFIG_GPIOLIB) */
+#else /* defined(CONFIG_GPIO) */
 static void
 mpc52xx_gpt_gpio_setup(struct mpc52xx_gpt_priv *p, struct device_node *np) { }
-#endif /* defined(CONFIG_GPIOLIB) */
+#endif /* defined(CONFIG_GPIO) */
 
 /***********************************************************************
  * Timer API
diff --git a/arch/powerpc/platforms/83xx/Kconfig b/arch/powerpc/platforms/83xx/Kconfig
index 670a033..7c8c9b2 100644
--- a/arch/powerpc/platforms/83xx/Kconfig
+++ b/arch/powerpc/platforms/83xx/Kconfig
@@ -117,7 +117,7 @@ endif
 # used for usb & gpio
 config PPC_MPC831x
 	bool
-	select ARCH_WANT_OPTIONAL_GPIOLIB
+	select ARCH_WANT_OPTIONAL_GPIO
 
 # used for math-emu
 config PPC_MPC832x
@@ -126,9 +126,9 @@ config PPC_MPC832x
 # used for usb & gpio
 config PPC_MPC834x
 	bool
-	select ARCH_WANT_OPTIONAL_GPIOLIB
+	select ARCH_WANT_OPTIONAL_GPIO
 
 # used for usb & gpio
 config PPC_MPC837x
 	bool
-	select ARCH_WANT_OPTIONAL_GPIOLIB
+	select ARCH_WANT_OPTIONAL_GPIO
diff --git a/arch/powerpc/platforms/85xx/Kconfig b/arch/powerpc/platforms/85xx/Kconfig
index 78549b6..3a73cd5 100644
--- a/arch/powerpc/platforms/85xx/Kconfig
+++ b/arch/powerpc/platforms/85xx/Kconfig
@@ -203,7 +203,7 @@ config GE_IMP3A
 	select DEFAULT_UIMAGE
 	select SWIOTLB
 	select MMIO_NVRAM
-	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_REQUIRE_GPIO
 	select GE_FPGA
 	help
 	  This option enables support for the GE Intelligent Platforms IMP3A
@@ -218,7 +218,7 @@ config P2041_RDB
 	select PPC_E500MC
 	select PHYS_64BIT
 	select SWIOTLB
-	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_REQUIRE_GPIO
 	select GPIO_MPC8XXX
 	select HAS_RAPIDIO
 	select PPC_EPAPR_HV_PIC
@@ -231,7 +231,7 @@ config P3041_DS
 	select PPC_E500MC
 	select PHYS_64BIT
 	select SWIOTLB
-	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_REQUIRE_GPIO
 	select GPIO_MPC8XXX
 	select HAS_RAPIDIO
 	select PPC_EPAPR_HV_PIC
@@ -244,7 +244,7 @@ config P4080_DS
 	select PPC_E500MC
 	select PHYS_64BIT
 	select SWIOTLB
-	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_REQUIRE_GPIO
 	select GPIO_MPC8XXX
 	select HAS_RAPIDIO
 	select PPC_EPAPR_HV_PIC
@@ -253,7 +253,7 @@ config P4080_DS
 
 config SGY_CTS1000
 	tristate "Servergy CTS-1000 support"
-	select GPIOLIB
+	select GPIO
 	select OF_GPIO
 	depends on P4080_DS
 	help
@@ -268,7 +268,7 @@ config P5020_DS
 	select PPC_E500MC
 	select PHYS_64BIT
 	select SWIOTLB
-	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_REQUIRE_GPIO
 	select GPIO_MPC8XXX
 	select HAS_RAPIDIO
 	select PPC_EPAPR_HV_PIC
@@ -282,7 +282,7 @@ config P5040_DS
 	select PPC_E500MC
 	select PHYS_64BIT
 	select SWIOTLB
-	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_REQUIRE_GPIO
 	select GPIO_MPC8XXX
 	select HAS_RAPIDIO
 	select PPC_EPAPR_HV_PIC
diff --git a/arch/powerpc/platforms/86xx/Kconfig b/arch/powerpc/platforms/86xx/Kconfig
index 1afd1e4..e31e9cf8 100644
--- a/arch/powerpc/platforms/86xx/Kconfig
+++ b/arch/powerpc/platforms/86xx/Kconfig
@@ -4,7 +4,7 @@ menuconfig PPC_86xx
 	depends on 6xx
 	select FSL_SOC
 	select ALTIVEC
-	select ARCH_WANT_OPTIONAL_GPIOLIB
+	select ARCH_WANT_OPTIONAL_GPIO
 	help
 	  The Freescale E600 SoCs have 74xx cores.
 
@@ -37,7 +37,7 @@ config GEF_PPC9A
 	bool "GE PPC9A"
 	select DEFAULT_UIMAGE
 	select MMIO_NVRAM
-	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_REQUIRE_GPIO
 	select GE_FPGA
 	help
 	  This option enables support for the GE PPC9A.
@@ -46,7 +46,7 @@ config GEF_SBC310
 	bool "GE SBC310"
 	select DEFAULT_UIMAGE
 	select MMIO_NVRAM
-	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_REQUIRE_GPIO
 	select GE_FPGA
 	help
 	  This option enables support for the GE SBC310.
@@ -55,7 +55,7 @@ config GEF_SBC610
 	bool "GE SBC610"
 	select DEFAULT_UIMAGE
 	select MMIO_NVRAM
-	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_REQUIRE_GPIO
 	select GE_FPGA
 	select HAS_RAPIDIO
 	help
diff --git a/arch/powerpc/platforms/8xx/Kconfig b/arch/powerpc/platforms/8xx/Kconfig
index 8dec3c0..d99597f 100644
--- a/arch/powerpc/platforms/8xx/Kconfig
+++ b/arch/powerpc/platforms/8xx/Kconfig
@@ -114,7 +114,7 @@ config 8xx_COPYBACK
 
 config 8xx_GPIO
 	bool "GPIO API Support"
-	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_REQUIRE_GPIO
 	help
 	  Saying Y here will cause the ports on an MPC8xx processor to be used
 	  with the GPIO API.  If you say N here, the kernel needs less memory.
diff --git a/arch/powerpc/platforms/Kconfig b/arch/powerpc/platforms/Kconfig
index 15095d5..0228c34 100644
--- a/arch/powerpc/platforms/Kconfig
+++ b/arch/powerpc/platforms/Kconfig
@@ -303,7 +303,7 @@ config QUICC_ENGINE
 config QE_GPIO
 	bool "QE GPIO support"
 	depends on QUICC_ENGINE
-	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_REQUIRE_GPIO
 	help
 	  Say Y here if you're going to use hardware that connects to the
 	  QE GPIOs.
@@ -314,7 +314,7 @@ config CPM2
 	select CPM
 	select PPC_LIB_RHEAP
 	select PPC_PCI_CHOICE
-	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_REQUIRE_GPIO
 	help
 	  The CPM2 (Communications Processor Module) is a coprocessor on
 	  embedded CPUs made by Freescale.  Selecting this option means that
@@ -353,7 +353,7 @@ config OF_RTC
 config SIMPLE_GPIO
 	bool "Support for simple, memory-mapped GPIO controllers"
 	depends on PPC
-	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_REQUIRE_GPIO
 	help
 	  Say Y here to support simple, memory-mapped GPIO controllers.
 	  These are usually BCSRs used to control board's switches, LEDs,
@@ -363,7 +363,7 @@ config SIMPLE_GPIO
 config MCU_MPC8349EMITX
 	bool "MPC8349E-mITX MCU driver"
 	depends on I2C=y && PPC_83xx
-	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_REQUIRE_GPIO
 	help
 	  Say Y here to enable soft power-off functionality on the Freescale
 	  boards with the MPC8349E-mITX-compatible MCU chips. This driver will
diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index f9391a6..db33b81 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -267,7 +267,7 @@ config CPU_SUBTYPE_SH7203
 	select CPU_HAS_FPU
 	select SYS_SUPPORTS_CMT
 	select SYS_SUPPORTS_MTU2
-	select ARCH_WANT_OPTIONAL_GPIOLIB
+	select ARCH_WANT_OPTIONAL_GPIO
 	select PINCTRL
 
 config CPU_SUBTYPE_SH7206
@@ -356,7 +356,7 @@ config CPU_SUBTYPE_SH7720
 	select CPU_SH3
 	select CPU_HAS_DSP
 	select SYS_SUPPORTS_CMT
-	select ARCH_WANT_OPTIONAL_GPIOLIB
+	select ARCH_WANT_OPTIONAL_GPIO
 	select USB_ARCH_HAS_OHCI
 	select USB_OHCI_SH if USB_OHCI_HCD
 	select PINCTRL
@@ -424,7 +424,7 @@ config CPU_SUBTYPE_SH7723
 	select ARCH_SHMOBILE
 	select ARCH_SPARSEMEM_ENABLE
 	select SYS_SUPPORTS_CMT
-	select ARCH_WANT_OPTIONAL_GPIOLIB
+	select ARCH_WANT_OPTIONAL_GPIO
 	select PINCTRL
 	help
 	  Select SH7723 if you have an SH-MobileR2 CPU.
@@ -436,7 +436,7 @@ config CPU_SUBTYPE_SH7724
 	select ARCH_SHMOBILE
 	select ARCH_SPARSEMEM_ENABLE
 	select SYS_SUPPORTS_CMT
-	select ARCH_WANT_OPTIONAL_GPIOLIB
+	select ARCH_WANT_OPTIONAL_GPIO
 	select PINCTRL
 	help
 	  Select SH7724 if you have an SH-MobileR2R CPU.
@@ -445,7 +445,7 @@ config CPU_SUBTYPE_SH7734
 	bool "Support SH7734 processor"
 	select CPU_SH4A
 	select CPU_SHX2
-	select ARCH_WANT_OPTIONAL_GPIOLIB
+	select ARCH_WANT_OPTIONAL_GPIO
 	select USB_ARCH_HAS_OHCI
 	select USB_ARCH_HAS_EHCI
 	select PINCTRL
@@ -456,7 +456,7 @@ config CPU_SUBTYPE_SH7757
 	bool "Support SH7757 processor"
 	select CPU_SH4A
 	select CPU_SHX2
-	select ARCH_WANT_OPTIONAL_GPIOLIB
+	select ARCH_WANT_OPTIONAL_GPIO
 	select USB_ARCH_HAS_OHCI
 	select USB_ARCH_HAS_EHCI
 	select PINCTRL
@@ -485,7 +485,7 @@ config CPU_SUBTYPE_SH7785
 	select CPU_SHX2
 	select ARCH_SPARSEMEM_ENABLE
 	select SYS_SUPPORTS_NUMA
-	select ARCH_WANT_OPTIONAL_GPIOLIB
+	select ARCH_WANT_OPTIONAL_GPIO
 	select PINCTRL
 
 config CPU_SUBTYPE_SH7786
@@ -494,7 +494,7 @@ config CPU_SUBTYPE_SH7786
 	select CPU_SHX3
 	select CPU_HAS_PTEAEX
 	select GENERIC_CLOCKEVENTS_BROADCAST if SMP
-	select ARCH_WANT_OPTIONAL_GPIOLIB
+	select ARCH_WANT_OPTIONAL_GPIO
 	select USB_ARCH_HAS_OHCI
 	select USB_OHCI_SH if USB_OHCI_HCD
 	select USB_ARCH_HAS_EHCI
@@ -506,7 +506,7 @@ config CPU_SUBTYPE_SHX3
 	select CPU_SH4A
 	select CPU_SHX3
 	select GENERIC_CLOCKEVENTS_BROADCAST if SMP
-	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_REQUIRE_GPIO
 	select PINCTRL
 
 # SH4AL-DSP Processor Support
@@ -525,7 +525,7 @@ config CPU_SUBTYPE_SH7722
 	select ARCH_SPARSEMEM_ENABLE
 	select SYS_SUPPORTS_NUMA
 	select SYS_SUPPORTS_CMT
-	select ARCH_WANT_OPTIONAL_GPIOLIB
+	select ARCH_WANT_OPTIONAL_GPIO
 	select PINCTRL
 
 config CPU_SUBTYPE_SH7366
diff --git a/arch/sh/boards/Kconfig b/arch/sh/boards/Kconfig
index fb58057..a1983db 100644
--- a/arch/sh/boards/Kconfig
+++ b/arch/sh/boards/Kconfig
@@ -55,7 +55,7 @@ config SH_7724_SOLUTION_ENGINE
 	bool "SolutionEngine7724"
 	select SOLUTION_ENGINE
 	depends on CPU_SUBTYPE_SH7724
-	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_REQUIRE_GPIO
 	select SND_SOC_AK4642 if SND_SIMPLE_CARD
 	select REGULATOR_FIXED_VOLTAGE if REGULATOR
 	help
@@ -159,7 +159,7 @@ config SH_SDK7786
 	depends on CPU_SUBTYPE_SH7786
 	select SYS_SUPPORTS_PCI
 	select NO_IOPORT if !PCI
-	select ARCH_WANT_OPTIONAL_GPIOLIB
+	select ARCH_WANT_OPTIONAL_GPIO
 	select HAVE_SRAM_POOL
 	select REGULATOR_FIXED_VOLTAGE if REGULATOR
 	help
@@ -175,7 +175,7 @@ config SH_HIGHLANDER
 config SH_SH7757LCR
 	bool "SH7757LCR"
 	depends on CPU_SUBTYPE_SH7757
-	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_REQUIRE_GPIO
 	select REGULATOR_FIXED_VOLTAGE if REGULATOR
 
 config SH_SH7785LCR
@@ -202,14 +202,14 @@ config SH_SH7785LCR_PT
 config SH_URQUELL
 	bool "Urquell"
 	depends on CPU_SUBTYPE_SH7786
-	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_REQUIRE_GPIO
 	select SYS_SUPPORTS_PCI
 	select NO_IOPORT if !PCI
 
 config SH_MIGOR
 	bool "Migo-R"
 	depends on CPU_SUBTYPE_SH7722
-	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_REQUIRE_GPIO
 	select REGULATOR_FIXED_VOLTAGE if REGULATOR
 	help
 	  Select Migo-R if configuring for the SH7722 Migo-R platform
@@ -218,7 +218,7 @@ config SH_MIGOR
 config SH_AP325RXA
 	bool "AP-325RXA"
 	depends on CPU_SUBTYPE_SH7723
-	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_REQUIRE_GPIO
 	select REGULATOR_FIXED_VOLTAGE if REGULATOR
 	help
 	  Renesas "AP-325RXA" support.
@@ -227,7 +227,7 @@ config SH_AP325RXA
 config SH_KFR2R09
 	bool "KFR2R09"
 	depends on CPU_SUBTYPE_SH7724
-	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_REQUIRE_GPIO
 	select REGULATOR_FIXED_VOLTAGE if REGULATOR
 	help
 	  "Kit For R2R for 2009" support.
@@ -235,7 +235,7 @@ config SH_KFR2R09
 config SH_ECOVEC
 	bool "EcoVec"
 	depends on CPU_SUBTYPE_SH7724
-	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_REQUIRE_GPIO
 	select SND_SOC_DA7210 if SND_SIMPLE_CARD
 	select REGULATOR_FIXED_VOLTAGE if REGULATOR
 	help
@@ -312,7 +312,7 @@ config SH_X3PROTO
 config SH_MAGIC_PANEL_R2
 	bool "Magic Panel R2"
 	depends on CPU_SUBTYPE_SH7720
-	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_REQUIRE_GPIO
 	select REGULATOR_FIXED_VOLTAGE if REGULATOR
 	help
 	  Select Magic Panel R2 if configuring for Magic Panel R2.
diff --git a/arch/sh/boards/mach-highlander/Kconfig b/arch/sh/boards/mach-highlander/Kconfig
index def49cc..db41ffc 100644
--- a/arch/sh/boards/mach-highlander/Kconfig
+++ b/arch/sh/boards/mach-highlander/Kconfig
@@ -18,7 +18,7 @@ config SH_R7780MP
 config SH_R7785RP
 	bool "R7785RP board support"
 	depends on CPU_SUBTYPE_SH7785
-	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_REQUIRE_GPIO
 
 endchoice
 
diff --git a/arch/sh/boards/mach-rsk/Kconfig b/arch/sh/boards/mach-rsk/Kconfig
index 458a11f..f4e3beb 100644
--- a/arch/sh/boards/mach-rsk/Kconfig
+++ b/arch/sh/boards/mach-rsk/Kconfig
@@ -10,17 +10,17 @@ config SH_RSK7201
 
 config SH_RSK7203
 	bool "RSK7203"
-	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_REQUIRE_GPIO
 	depends on CPU_SUBTYPE_SH7203
 
 config SH_RSK7264
 	bool "RSK2+SH7264"
-	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_REQUIRE_GPIO
 	depends on CPU_SUBTYPE_SH7264
 
 config SH_RSK7269
 	bool "RSK2+SH7269"
-	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_REQUIRE_GPIO
 	depends on CPU_SUBTYPE_SH7269
 
 endchoice
diff --git a/arch/sh/boards/mach-sdk7786/Makefile b/arch/sh/boards/mach-sdk7786/Makefile
index 45d32e3..33a0111 100644
--- a/arch/sh/boards/mach-sdk7786/Makefile
+++ b/arch/sh/boards/mach-sdk7786/Makefile
@@ -1,4 +1,4 @@
 obj-y	:= fpga.o irq.o nmi.o setup.o
 
-obj-$(CONFIG_GPIOLIB)		+= gpio.o
+obj-$(CONFIG_GPIO)		+= gpio.o
 obj-$(CONFIG_HAVE_SRAM_POOL)	+= sram.o
diff --git a/arch/sh/boards/mach-x3proto/Makefile b/arch/sh/boards/mach-x3proto/Makefile
index 0cbe3d0..9e49425 100644
--- a/arch/sh/boards/mach-x3proto/Makefile
+++ b/arch/sh/boards/mach-x3proto/Makefile
@@ -1,3 +1,3 @@
 obj-y += setup.o ilsel.o
 
-obj-$(CONFIG_GPIOLIB)		+= gpio.o
+obj-$(CONFIG_GPIO)		+= gpio.o
diff --git a/arch/sh/include/asm/gpio.h b/arch/sh/include/asm/gpio.h
index 7dfe15e..7d15f5f 100644
--- a/arch/sh/include/asm/gpio.h
+++ b/arch/sh/include/asm/gpio.h
@@ -22,7 +22,7 @@
 #define ARCH_NR_GPIOS 512
 #include <asm-generic/gpio.h>
 
-#ifdef CONFIG_GPIOLIB
+#ifdef CONFIG_GPIO
 
 static inline int gpio_get_value(unsigned gpio)
 {
@@ -49,6 +49,6 @@ static inline int irq_to_gpio(unsigned int irq)
 	return -ENOSYS;
 }
 
-#endif /* CONFIG_GPIOLIB */
+#endif /* CONFIG_GPIO */
 
 #endif /* __ASM_SH_GPIO_H */
diff --git a/arch/sh/kernel/cpu/sh2a/Makefile b/arch/sh/kernel/cpu/sh2a/Makefile
index 990195d..4ef7802 100644
--- a/arch/sh/kernel/cpu/sh2a/Makefile
+++ b/arch/sh/kernel/cpu/sh2a/Makefile
@@ -21,4 +21,4 @@ pinmux-$(CONFIG_CPU_SUBTYPE_SH7203)	:= pinmux-sh7203.o
 pinmux-$(CONFIG_CPU_SUBTYPE_SH7264)	:= pinmux-sh7264.o
 pinmux-$(CONFIG_CPU_SUBTYPE_SH7269)	:= pinmux-sh7269.o
 
-obj-$(CONFIG_GPIOLIB)			+= $(pinmux-y)
+obj-$(CONFIG_GPIO)			+= $(pinmux-y)
diff --git a/arch/sh/kernel/cpu/sh3/Makefile b/arch/sh/kernel/cpu/sh3/Makefile
index d3634ae..3ac2472 100644
--- a/arch/sh/kernel/cpu/sh3/Makefile
+++ b/arch/sh/kernel/cpu/sh3/Makefile
@@ -30,4 +30,4 @@ clock-$(CONFIG_CPU_SUBTYPE_SH7712)	:= clock-sh7712.o
 pinmux-$(CONFIG_CPU_SUBTYPE_SH7720)	:= pinmux-sh7720.o
 
 obj-y	+= $(clock-y)
-obj-$(CONFIG_GPIOLIB)			+= $(pinmux-y)
+obj-$(CONFIG_GPIO)			+= $(pinmux-y)
diff --git a/arch/sh/kernel/cpu/sh4a/Makefile b/arch/sh/kernel/cpu/sh4a/Makefile
index 0705df7..0f31f81 100644
--- a/arch/sh/kernel/cpu/sh4a/Makefile
+++ b/arch/sh/kernel/cpu/sh4a/Makefile
@@ -47,6 +47,6 @@ pinmux-$(CONFIG_CPU_SUBTYPE_SHX3)	:= pinmux-shx3.o
 
 obj-y					+= $(clock-y)
 obj-$(CONFIG_SMP)			+= $(smp-y)
-obj-$(CONFIG_GPIOLIB)			+= $(pinmux-y)
+obj-$(CONFIG_GPIO)			+= $(pinmux-y)
 obj-$(CONFIG_PERF_EVENTS)		+= perf_event.o
 obj-$(CONFIG_HAVE_HW_BREAKPOINT)	+= ubc.o
diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 90b3a0f..c3ea70c 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -19,7 +19,7 @@ config SPARC
 	select HAVE_ARCH_KGDB if !SMP || SPARC64
 	select HAVE_ARCH_TRACEHOOK
 	select SYSCTL_EXCEPTION_TRACE
-	select ARCH_WANT_OPTIONAL_GPIOLIB
+	select ARCH_WANT_OPTIONAL_GPIO
 	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
 	select RTC_CLASS
 	select RTC_DRV_M48T59
diff --git a/arch/unicore32/Kconfig b/arch/unicore32/Kconfig
index 41bcc00..10c1114 100644
--- a/arch/unicore32/Kconfig
+++ b/arch/unicore32/Kconfig
@@ -85,7 +85,7 @@ config ARCH_PUV3
 	select CPU_UCV2
 	select GENERIC_CLOCKEVENTS
 	select HAVE_CLK
-	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_REQUIRE_GPIO
 	select ARCH_HAS_CPUFREQ
 
 # CONFIGs for ARCH_PUV3
@@ -153,7 +153,7 @@ source "mm/Kconfig"
 
 config LEDS
 	def_bool y
-	depends on GPIOLIB
+	depends on GPIO
 
 config ALIGNMENT_TRAP
 	def_bool y
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index a6298c2..868c1de 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -33,7 +33,7 @@ config X86
 	select HAVE_MEMBLOCK
 	select HAVE_MEMBLOCK_NODE_MAP
 	select ARCH_DISCARD_MEMBLOCK
-	select ARCH_WANT_OPTIONAL_GPIOLIB
+	select ARCH_WANT_OPTIONAL_GPIO
 	select ARCH_WANT_FRAME_POINTERS
 	select HAVE_DMA_ATTRS
 	select HAVE_DMA_CONTIGUOUS if !SWIOTLB
@@ -545,7 +545,7 @@ config STA2X11
 	select X86_DMA_REMAP
 	select SWIOTLB
 	select MFD_STA2X11
-	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_REQUIRE_GPIO
 	default n
 	---help---
 	  This adds support for boards based on the STA2X11 IO-Hub,
@@ -2151,7 +2151,7 @@ config SCx200HR_TIMER
 config OLPC
 	bool "One Laptop Per Child support"
 	depends on !X86_PAE
-	select GPIOLIB
+	select GPIO
 	select OF
 	select OF_PROMTREE
 	select IRQ_DOMAIN
@@ -2201,7 +2201,7 @@ config OLPC_XO15_SCI
 
 config ALIX
 	bool "PCEngines ALIX System Support (LED setup)"
-	select GPIOLIB
+	select GPIO
 	---help---
 	  This option enables system support for the PCEngines ALIX.
 	  At present this just sets up LEDs for GPIO control on
@@ -2215,13 +2215,13 @@ config ALIX
 
 config NET5501
 	bool "Soekris Engineering net5501 System Support (LEDS, GPIO, etc)"
-	select GPIOLIB
+	select GPIO
 	---help---
 	  This option enables system support for the Soekris Engineering net5501.
 
 config GEOS
 	bool "Traverse Technologies GEOS System Support (LEDS, GPIO, etc)"
-	select GPIOLIB
+	select GPIO
 	depends on DMI
 	---help---
 	  This option enables system support for the Traverse Technologies GEOS.
diff --git a/arch/xtensa/Kconfig b/arch/xtensa/Kconfig
index acdfc61..f7b6c42 100644
--- a/arch/xtensa/Kconfig
+++ b/arch/xtensa/Kconfig
@@ -15,7 +15,7 @@ config XTENSA
 	select MODULES_USE_ELF_RELA
 	select GENERIC_PCI_IOMAP
 	select ARCH_WANT_IPC_PARSE_VERSION
-	select ARCH_WANT_OPTIONAL_GPIOLIB
+	select ARCH_WANT_OPTIONAL_GPIO
 	select CLONE_BACKWARDS
 	select IRQ_DOMAIN
 	select HAVE_OPROFILE
@@ -80,7 +80,7 @@ config XTENSA_VARIANT_DC233C
 config XTENSA_VARIANT_S6000
 	bool "s6000 - Stretch software configurable processor"
 	select VARIANT_IRQ_SWITCH
-	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_REQUIRE_GPIO
 	select XTENSA_CALIBRATE_CCOUNT
 endchoice
 
diff --git a/arch/xtensa/configs/s6105_defconfig b/arch/xtensa/configs/s6105_defconfig
index 4799c6a..a55213b 100644
--- a/arch/xtensa/configs/s6105_defconfig
+++ b/arch/xtensa/configs/s6105_defconfig
@@ -353,8 +353,8 @@ CONFIG_UNIX98_PTYS=y
 # CONFIG_TCG_TPM is not set
 # CONFIG_I2C is not set
 # CONFIG_SPI is not set
-CONFIG_ARCH_REQUIRE_GPIOLIB=y
-CONFIG_GPIOLIB=y
+CONFIG_ARCH_REQUIRE_GPIO=y
+CONFIG_GPIO=y
 # CONFIG_DEBUG_GPIO is not set
 # CONFIG_GPIO_SYSFS is not set
 
diff --git a/drivers/bcma/Kconfig b/drivers/bcma/Kconfig
index 8b4221c..392cb47 100644
--- a/drivers/bcma/Kconfig
+++ b/drivers/bcma/Kconfig
@@ -67,7 +67,7 @@ config BCMA_DRIVER_GMAC_CMN
 
 config BCMA_DRIVER_GPIO
 	bool "BCMA GPIO driver"
-	depends on BCMA && GPIOLIB
+	depends on BCMA && GPIO
 	help
 	  Driver to provide access to the GPIO pins of the bcma bus.
 
diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
index 5dc0dae..3f8178f 100644
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -434,7 +434,7 @@ config ATA_OVER_ETH
 
 config MG_DISK
 	tristate "mGine mflash, gflash support"
-	depends on ARM && GPIOLIB
+	depends on ARM && GPIO
 	help
 	  mGine mFlash(gFlash) block device driver
 
diff --git a/drivers/char/tpm/Kconfig b/drivers/char/tpm/Kconfig
index dbfd564..3345974 100644
--- a/drivers/char/tpm/Kconfig
+++ b/drivers/char/tpm/Kconfig
@@ -84,7 +84,7 @@ config TCG_IBMVTPM
 config TCG_ST33_I2C
         tristate "STMicroelectronics ST33 I2C TPM"
         depends on I2C
-        depends on GPIOLIB
+        depends on GPIO
         ---help---
         If you have a TPM security chip from STMicroelectronics working with
         an I2C bus say Yes and it will be accessible from within Linux.
diff --git a/drivers/extcon/Kconfig b/drivers/extcon/Kconfig
index 3297301..5ae51eb 100644
--- a/drivers/extcon/Kconfig
+++ b/drivers/extcon/Kconfig
@@ -16,7 +16,7 @@ comment "Extcon Device Drivers"
 
 config EXTCON_GPIO
 	tristate "GPIO extcon support"
-	depends on GPIOLIB
+	depends on GPIO
 	help
 	  Say Y here to enable GPIO based extcon support. Note that GPIO
 	  extcon supports single state per extcon instance.
diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 5d53aba..e2f377d 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -10,19 +10,19 @@ config ARCH_HAVE_CUSTOM_GPIO_H
 	  overriding the default implementations.  New uses of this are
 	  strongly discouraged.
 
-config ARCH_WANT_OPTIONAL_GPIOLIB
+config ARCH_WANT_OPTIONAL_GPIO
 	bool
 	help
 	  Select this config option from the architecture Kconfig, if
 	  it is possible to use gpiolib on the architecture, but let the
 	  user decide whether to actually build it or not.
-	  Select this instead of ARCH_REQUIRE_GPIOLIB, if your architecture does
+	  Select this instead of ARCH_REQUIRE_GPIO, if your architecture does
 	  not depend on GPIOs being available, but rather let the user
 	  decide whether he needs it or not.
 
-config ARCH_REQUIRE_GPIOLIB
+config ARCH_REQUIRE_GPIO
 	bool
-	select GPIOLIB
+	select GPIO
 	help
 	  Platforms select gpiolib if they use this infrastructure
 	  for all their GPIOs, usually starting with ones integrated
@@ -35,9 +35,9 @@ config GPIO_DEVRES
 	depends on HAS_IOMEM
 
 
-menuconfig GPIOLIB
+menuconfig GPIO
 	bool "GPIO Support"
-	depends on ARCH_WANT_OPTIONAL_GPIOLIB || ARCH_REQUIRE_GPIOLIB
+	depends on ARCH_WANT_OPTIONAL_GPIO || ARCH_REQUIRE_GPIO
 	help
 	  This enables GPIO support through the generic GPIO library.
 	  You only need to enable this, if you also want to enable
@@ -45,7 +45,7 @@ menuconfig GPIOLIB
 
 	  If unsure, say N.
 
-if GPIOLIB
+if GPIO
 
 config OF_GPIO
 	def_bool y
@@ -157,7 +157,7 @@ config GPIO_MPC8XXX
 
 config GPIO_MSM_V1
 	tristate "Qualcomm MSM GPIO v1"
-	depends on GPIOLIB && ARCH_MSM && (ARCH_MSM7X00A || ARCH_MSM7X30 || ARCH_QSD8X50)
+	depends on GPIO && ARCH_MSM && (ARCH_MSM7X00A || ARCH_MSM7X30 || ARCH_QSD8X50)
 	help
 	  Say yes here to support the GPIO interface on ARM v6 based
 	  Qualcomm MSM chips.  Most of the pins on the MSM can be
@@ -165,7 +165,7 @@ config GPIO_MSM_V1
 
 config GPIO_MSM_V2
 	tristate "Qualcomm MSM GPIO v2"
-	depends on GPIOLIB && ARCH_MSM
+	depends on GPIO && ARCH_MSM
 	help
 	  Say yes here to support the GPIO interface on ARM v7 based
 	  Qualcomm MSM chips.  Most of the pins on the MSM can be
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index 22e07bc..c4f4ecc 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -3,7 +3,7 @@
 ccflags-$(CONFIG_DEBUG_GPIO)	+= -DDEBUG
 
 obj-$(CONFIG_GPIO_DEVRES)	+= devres.o
-obj-$(CONFIG_GPIOLIB)		+= gpiolib.o
+obj-$(CONFIG_GPIO)		+= gpiolib.o
 obj-$(CONFIG_OF_GPIO)		+= gpiolib-of.o
 obj-$(CONFIG_GPIO_ACPI)		+= gpiolib-acpi.o
 
diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
index 89ac1cb..e4b302c 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -446,7 +446,7 @@ config SENSORS_GL520SM
 
 config SENSORS_GPIO_FAN
 	tristate "GPIO fan"
-	depends on GPIOLIB
+	depends on GPIO
 	help
 	  If you say yes here you get support for fans connected to GPIO lines.
 
@@ -936,7 +936,7 @@ source drivers/hwmon/pmbus/Kconfig
 
 config SENSORS_SHT15
 	tristate "Sensiron humidity and temperature sensors. SHT15 and compat."
-	depends on GPIOLIB
+	depends on GPIO
 	help
 	  If you say yes here you get support for the Sensiron SHT10, SHT11,
 	  SHT15, SHT71, SHT75 humidity and temperature sensors.
diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index 631736e..10397a1 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -363,7 +363,7 @@ config I2C_BLACKFIN_TWI_CLK_KHZ
 
 config I2C_CBUS_GPIO
 	tristate "CBUS I2C driver"
-	depends on GPIOLIB
+	depends on GPIO
 	help
 	  Support for CBUS access using I2C API. Mostly relevant for Nokia
 	  Internet Tablets (770, N800 and N810).
@@ -436,7 +436,7 @@ config I2C_EG20T
 
 config I2C_GPIO
 	tristate "GPIO-based bitbanging I2C"
-	depends on GPIOLIB
+	depends on GPIO
 	select I2C_ALGOBIT
 	help
 	  This is a very simple bitbanging I2C driver utilizing the
diff --git a/drivers/i2c/muxes/Kconfig b/drivers/i2c/muxes/Kconfig
index 40062ed..ca5b4ef 100644
--- a/drivers/i2c/muxes/Kconfig
+++ b/drivers/i2c/muxes/Kconfig
@@ -7,7 +7,7 @@ menu "Multiplexer I2C Chip support"
 
 config I2C_MUX_GPIO
 	tristate "GPIO-based I2C multiplexer"
-	depends on GPIOLIB
+	depends on GPIO
 	help
 	  If you say yes to this option, support will be included for a
 	  GPIO based I2C multiplexer. This driver provides access to
diff --git a/drivers/input/keyboard/Kconfig b/drivers/input/keyboard/Kconfig
index 772666f..066eda1 100644
--- a/drivers/input/keyboard/Kconfig
+++ b/drivers/input/keyboard/Kconfig
@@ -175,7 +175,7 @@ config KEYBOARD_EP93XX
 
 config KEYBOARD_GPIO
 	tristate "GPIO Buttons"
-	depends on GPIOLIB
+	depends on GPIO
 	help
 	  This driver implements support for buttons connected
 	  to GPIO pins of various CPUs (and some other chips).
@@ -190,7 +190,7 @@ config KEYBOARD_GPIO
 
 config KEYBOARD_GPIO_POLLED
 	tristate "Polled GPIO buttons"
-	depends on GPIOLIB
+	depends on GPIO
 	select INPUT_POLLDEV
 	help
 	  This driver implements support for buttons connected
@@ -241,7 +241,7 @@ config KEYBOARD_TCA8418
 
 config KEYBOARD_MATRIX
 	tristate "GPIO driven matrix keypad support"
-	depends on GPIOLIB
+	depends on GPIO
 	select INPUT_MATRIXKMAP
 	help
 	  Enable support for GPIO driven matrix keypad.
diff --git a/drivers/input/keyboard/adp5588-keys.c b/drivers/input/keyboard/adp5588-keys.c
index dbd2047..760d484 100644
--- a/drivers/input/keyboard/adp5588-keys.c
+++ b/drivers/input/keyboard/adp5588-keys.c
@@ -46,7 +46,7 @@ struct adp5588_kpad {
 	unsigned short keycode[ADP5588_KEYMAPSIZE];
 	const struct adp5588_gpi_map *gpimap;
 	unsigned short gpimapsize;
-#ifdef CONFIG_GPIOLIB
+#ifdef CONFIG_GPIO
 	unsigned char gpiomap[ADP5588_MAXGPIO];
 	bool export_gpio;
 	struct gpio_chip gc;
@@ -71,7 +71,7 @@ static int adp5588_write(struct i2c_client *client, u8 reg, u8 val)
 	return i2c_smbus_write_byte_data(client, reg, val);
 }
 
-#ifdef CONFIG_GPIOLIB
+#ifdef CONFIG_GPIO
 static int adp5588_gpio_get_value(struct gpio_chip *chip, unsigned off)
 {
 	struct adp5588_kpad *kpad = container_of(chip, struct adp5588_kpad, gc);
diff --git a/drivers/input/keyboard/adp5589-keys.c b/drivers/input/keyboard/adp5589-keys.c
index 67d12b3..0896c54 100644
--- a/drivers/input/keyboard/adp5589-keys.c
+++ b/drivers/input/keyboard/adp5589-keys.c
@@ -237,7 +237,7 @@ struct adp5589_kpad {
 	unsigned extend_cfg;
 	bool is_adp5585;
 	bool adp5585_support_row5;
-#ifdef CONFIG_GPIOLIB
+#ifdef CONFIG_GPIO
 	unsigned char gpiomap[ADP5589_MAXGPIO];
 	bool export_gpio;
 	struct gpio_chip gc;
@@ -385,7 +385,7 @@ static int adp5589_write(struct i2c_client *client, u8 reg, u8 val)
 	return i2c_smbus_write_byte_data(client, reg, val);
 }
 
-#ifdef CONFIG_GPIOLIB
+#ifdef CONFIG_GPIO
 static int adp5589_gpio_get_value(struct gpio_chip *chip, unsigned off)
 {
 	struct adp5589_kpad *kpad = container_of(chip, struct adp5589_kpad, gc);
diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
index 262cda2..8ad78d5 100644
--- a/drivers/input/misc/Kconfig
+++ b/drivers/input/misc/Kconfig
@@ -214,7 +214,7 @@ config INPUT_APANEL
 config INPUT_GP2A
 	tristate "Sharp GP2AP002A00F I2C Proximity/Opto sensor driver"
 	depends on I2C
-	depends on GPIOLIB
+	depends on GPIO
 	help
 	  Say Y here if you have a Sharp GP2AP002A00F proximity/als combo-chip
 	  hooked to an I2C bus.
@@ -224,7 +224,7 @@ config INPUT_GP2A
 
 config INPUT_GPIO_TILT_POLLED
 	tristate "Polled GPIO tilt switch"
-	depends on GPIOLIB
+	depends on GPIO
 	select INPUT_POLLDEV
 	help
 	  This driver implements support for tilt switches connected
@@ -472,7 +472,7 @@ config INPUT_PWM_BEEPER
 
 config INPUT_GPIO_ROTARY_ENCODER
 	tristate "Rotary encoders connected to GPIO pins"
-	depends on GPIOLIB
+	depends on GPIO
 	help
 	  Say Y here to add support for rotary encoders connected to GPIO lines.
 	  Check file:Documentation/input/rotary-encoder.txt for more
@@ -484,7 +484,7 @@ config INPUT_GPIO_ROTARY_ENCODER
 config INPUT_RB532_BUTTON
 	tristate "Mikrotik Routerboard 532 button interface"
 	depends on MIKROTIK_RB532
-	depends on GPIOLIB
+	depends on GPIO
 	select INPUT_POLLDEV
 	help
 	  Say Y here if you want support for the S1 button built into
diff --git a/drivers/input/mouse/Kconfig b/drivers/input/mouse/Kconfig
index effa9c5..b3cdb21 100644
--- a/drivers/input/mouse/Kconfig
+++ b/drivers/input/mouse/Kconfig
@@ -295,7 +295,7 @@ config MOUSE_VSXXXAA
 
 config MOUSE_GPIO
 	tristate "GPIO mouse"
-	depends on GPIOLIB
+	depends on GPIO
 	select INPUT_POLLDEV
 	help
 	  This driver simulates a mouse on GPIO lines of various CPUs (and some
diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
index f9a5fd8..ec15eb7 100644
--- a/drivers/input/touchscreen/Kconfig
+++ b/drivers/input/touchscreen/Kconfig
@@ -101,7 +101,7 @@ config TOUCHSCREEN_ATMEL_MXT
 config TOUCHSCREEN_AUO_PIXCIR
 	tristate "AUO in-cell touchscreen using Pixcir ICs"
 	depends on I2C
-	depends on GPIOLIB
+	depends on GPIO
 	help
 	  Say Y here if you have a AUO display with in-cell touchscreen
 	  using Pixcir ICs.
@@ -126,7 +126,7 @@ config TOUCHSCREEN_BU21013
 config TOUCHSCREEN_CY8CTMG110
 	tristate "cy8ctmg110 touchscreen"
 	depends on I2C
-	depends on GPIOLIB
+	depends on GPIO
 	help
 	  Say Y here if you have a cy8ctmg110 capacitive touchscreen on
 	  an AAVA device.
diff --git a/drivers/input/touchscreen/ad7879.c b/drivers/input/touchscreen/ad7879.c
index facd305..a075a939 100644
--- a/drivers/input/touchscreen/ad7879.c
+++ b/drivers/input/touchscreen/ad7879.c
@@ -111,7 +111,7 @@ struct ad7879 {
 	struct device		*dev;
 	struct input_dev	*input;
 	struct timer_list	timer;
-#ifdef CONFIG_GPIOLIB
+#ifdef CONFIG_GPIO
 	struct gpio_chip	gc;
 	struct mutex		mutex;
 #endif
@@ -378,7 +378,7 @@ static const struct attribute_group ad7879_attr_group = {
 	.attrs = ad7879_attributes,
 };
 
-#ifdef CONFIG_GPIOLIB
+#ifdef CONFIG_GPIO
 static int ad7879_gpio_direction_input(struct gpio_chip *chip,
 					unsigned gpio)
 {
diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index 2a53177..c1596cf 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -163,7 +163,7 @@ config LEDS_PCA9532
 config LEDS_PCA9532_GPIO
 	bool "Enable GPIO support for PCA9532"
 	depends on LEDS_PCA9532
-	depends on GPIOLIB
+	depends on GPIO
 	help
 	  Allow unused pins on PCA9532 to be used as gpio.
 
@@ -173,7 +173,7 @@ config LEDS_PCA9532_GPIO
 config LEDS_GPIO
 	tristate "LED Support for GPIO connected LEDs"
 	depends on LEDS_CLASS
-	depends on GPIOLIB
+	depends on GPIO
 	help
 	  This option enables support for the LEDs connected to GPIO
 	  outputs. To be useful the particular board must have LEDs
@@ -352,7 +352,7 @@ config LEDS_INTEL_SS4200
 config LEDS_LT3593
 	tristate "LED driver for LT3593 controllers"
 	depends on LEDS_CLASS
-	depends on GPIOLIB
+	depends on GPIO
 	help
 	  This option enables support for LEDs driven by a Linear Technology
 	  LT3593 controller. This controller uses a special one-wire pulse
@@ -421,7 +421,7 @@ config LEDS_ASIC3
 
 config LEDS_RENESAS_TPU
 	bool "LED support for Renesas TPU"
-	depends on LEDS_CLASS=y && HAVE_CLK && GPIOLIB
+	depends on LEDS_CLASS=y && HAVE_CLK && GPIO
 	help
 	  This option enables build of the LED TPU platform driver,
 	  suitable to drive any TPU channel on newer Renesas SoCs.
@@ -543,7 +543,7 @@ config LEDS_TRIGGER_CPU
 config LEDS_TRIGGER_GPIO
 	tristate "LED GPIO Trigger"
 	depends on LEDS_TRIGGERS
-	depends on GPIOLIB
+	depends on GPIO
 	help
 	  This allows LEDs to be controlled by gpio events. It's good
 	  when using gpios as switches and triggering the needed LEDs
diff --git a/drivers/leds/leds-tca6507.c b/drivers/leds/leds-tca6507.c
index 070ba07..2cb88a4b 100644
--- a/drivers/leds/leds-tca6507.c
+++ b/drivers/leds/leds-tca6507.c
@@ -175,7 +175,7 @@ struct tca6507_chip {
 		int			bank;	/* Bank used, or -1 */
 		int			blink;	/* Set if hardware-blinking */
 	} leds[NUM_LEDS];
-#ifdef CONFIG_GPIOLIB
+#ifdef CONFIG_GPIO
 	struct gpio_chip		gpio;
 	const char			*gpio_name[NUM_LEDS];
 	int				gpio_map[NUM_LEDS];
@@ -584,7 +584,7 @@ static int tca6507_blink_set(struct led_classdev *led_cdev,
 	return 0;
 }
 
-#ifdef CONFIG_GPIOLIB
+#ifdef CONFIG_GPIO
 static void tca6507_gpio_set_value(struct gpio_chip *gc,
 				   unsigned offset, int val)
 {
@@ -655,7 +655,7 @@ static void tca6507_remove_gpio(struct tca6507_chip *tca)
 			"gpiochip_remove()", err);
 	}
 }
-#else /* CONFIG_GPIOLIB */
+#else /* CONFIG_GPIO */
 static int tca6507_probe_gpios(struct i2c_client *client,
 			       struct tca6507_chip *tca,
 			       struct tca6507_platform_data *pdata)
@@ -665,7 +665,7 @@ static int tca6507_probe_gpios(struct i2c_client *client,
 static void tca6507_remove_gpio(struct tca6507_chip *tca)
 {
 }
-#endif /* CONFIG_GPIOLIB */
+#endif /* CONFIG_GPIO */
 
 #ifdef CONFIG_OF
 static struct tca6507_platform_data *
diff --git a/drivers/media/dvb-frontends/cxd2820r_core.c b/drivers/media/dvb-frontends/cxd2820r_core.c
index 9b658c1..5f7fb7d 100644
--- a/drivers/media/dvb-frontends/cxd2820r_core.c
+++ b/drivers/media/dvb-frontends/cxd2820r_core.c
@@ -571,7 +571,7 @@ static void cxd2820r_release(struct dvb_frontend *fe)
 
 	dev_dbg(&priv->i2c->dev, "%s\n", __func__);
 
-#ifdef CONFIG_GPIOLIB
+#ifdef CONFIG_GPIO
 	/* remove GPIOs */
 	if (priv->gpio_chip.label) {
 		ret = gpiochip_remove(&priv->gpio_chip);
@@ -594,7 +594,7 @@ static int cxd2820r_i2c_gate_ctrl(struct dvb_frontend *fe, int enable)
 	return cxd2820r_wr_reg_mask(priv, 0xdb, enable ? 1 : 0, 0x1);
 }
 
-#ifdef CONFIG_GPIOLIB
+#ifdef CONFIG_GPIO
 static int cxd2820r_gpio_direction_output(struct gpio_chip *chip, unsigned nr,
 		int val)
 {
@@ -710,7 +710,7 @@ struct dvb_frontend *cxd2820r_attach(const struct cxd2820r_config *cfg,
 		goto error;
 
 	if (gpio_chip_base) {
-#ifdef CONFIG_GPIOLIB
+#ifdef CONFIG_GPIO
 		/* add GPIOs */
 		priv->gpio_chip.label = KBUILD_MODNAME;
 		priv->gpio_chip.dev = &priv->i2c->dev;
diff --git a/drivers/media/dvb-frontends/cxd2820r_priv.h b/drivers/media/dvb-frontends/cxd2820r_priv.h
index 7ff5f60..01beacd 100644
--- a/drivers/media/dvb-frontends/cxd2820r_priv.h
+++ b/drivers/media/dvb-frontends/cxd2820r_priv.h
@@ -44,7 +44,7 @@ struct cxd2820r_priv {
 	u8 bank[2];
 #define GPIO_COUNT 3
 	u8 gpio[GPIO_COUNT];
-#ifdef CONFIG_GPIOLIB
+#ifdef CONFIG_GPIO
 	struct gpio_chip gpio_chip;
 #endif
 
diff --git a/drivers/media/radio/wl128x/Kconfig b/drivers/media/radio/wl128x/Kconfig
index f359be7..0747d4d 100644
--- a/drivers/media/radio/wl128x/Kconfig
+++ b/drivers/media/radio/wl128x/Kconfig
@@ -4,7 +4,7 @@
 menu "Texas Instruments WL128x FM driver (ST based)"
 config RADIO_WL128X
 	tristate "Texas Instruments WL128x FM Radio"
-	depends on VIDEO_V4L2 && RFKILL && GPIOLIB && TTY
+	depends on VIDEO_V4L2 && RFKILL && GPIO && TTY
 	select TI_ST if NET
 	help
 	Choose Y here if you have this FM radio chip.
diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index a81ec2e..bf623cb 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -672,7 +672,7 @@ static int em28xx_pctv_290e_set_lna(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct em28xx *dev = fe->dvb->priv;
-#ifdef CONFIG_GPIOLIB
+#ifdef CONFIG_GPIO
 	struct em28xx_dvb *dvb = dev->dvb;
 	int ret;
 	unsigned long flags;
@@ -1104,7 +1104,7 @@ static int em28xx_dvb_init(struct em28xx *dev)
 				goto out_free;
 			}
 
-#ifdef CONFIG_GPIOLIB
+#ifdef CONFIG_GPIO
 			/* enable LNA for DVB-T, DVB-T2 and DVB-C */
 			result = gpio_request_one(dvb->lna_gpio,
 					GPIOF_OUT_INIT_LOW, NULL);
diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index c346941..730b332 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -57,7 +57,7 @@ config MFD_SM501
 
 config MFD_SM501_GPIO
 	bool "Export GPIO via GPIO layer"
-	depends on MFD_SM501 && GPIOLIB
+	depends on MFD_SM501 && GPIO
 	 ---help---
 	 This option uses the gpio library layer to export the 64 GPIO
 	 lines on the SM501. The platform data is used to supply the
@@ -75,7 +75,7 @@ config MFD_RTSX_PCI
 
 config MFD_ASIC3
 	bool "Support for Compaq ASIC3"
-	depends on GENERIC_HARDIRQS && GPIOLIB && ARM
+	depends on GENERIC_HARDIRQS && GPIO && ARM
 	select MFD_CORE
 	 ---help---
 	  This driver supports the ASIC3 multifunction chip found on many
@@ -118,7 +118,7 @@ config MFD_TI_AM335X_TSCADC
 
 config HTC_EGPIO
 	bool "HTC EGPIO support"
-	depends on GENERIC_HARDIRQS && GPIOLIB && ARM
+	depends on GENERIC_HARDIRQS && GPIO && ARM
 	help
 	    This driver supports the CPLD egpio chip present on
 	    several HTC phones.  It provides basic support for input
@@ -136,7 +136,7 @@ config HTC_PASIC3
 
 config HTC_I2CPLD
 	bool "HTC I2C PLD chip support"
-	depends on I2C=y && GPIOLIB
+	depends on I2C=y && GPIO
 	help
 	  If you say yes here you get support for the supposed CPLD
 	  found on omap850 HTC devices like the HTC Wizard and HTC Herald.
@@ -146,7 +146,7 @@ config HTC_I2CPLD
 config UCB1400_CORE
 	tristate "Philips UCB1400 Core driver"
 	depends on AC97_BUS
-	depends on GPIOLIB
+	depends on GPIO
 	help
 	  This enables support for the Philips UCB1400 core functions.
 	  The UCB1400 is an AC97 audio codec.
@@ -183,7 +183,7 @@ config TPS6105X
 
 config TPS65010
 	tristate "TPS6501x Power Management chips"
-	depends on I2C && GPIOLIB
+	depends on I2C && GPIO
 	default y if MACH_OMAP_H2 || MACH_OMAP_H3 || MACH_OMAP_OSK
 	help
 	  If you say yes here you get support for the TPS6501x series of
@@ -238,7 +238,7 @@ config MFD_TPS6586X
 
 config MFD_TPS65910
 	bool "TPS65910 Power Management chip"
-	depends on I2C=y && GPIOLIB && GENERIC_HARDIRQS
+	depends on I2C=y && GPIO && GENERIC_HARDIRQS
 	select MFD_CORE
 	select REGMAP_I2C
 	select REGMAP_IRQ
@@ -249,13 +249,13 @@ config MFD_TPS65910
 
 config MFD_TPS65912
 	bool
-	depends on GPIOLIB
+	depends on GPIO
 
 config MFD_TPS65912_I2C
 	bool "TPS65912 Power Management chip with I2C"
 	select MFD_CORE
 	select MFD_TPS65912
-	depends on I2C=y && GPIOLIB && GENERIC_HARDIRQS
+	depends on I2C=y && GPIO && GENERIC_HARDIRQS
 	help
 	  If you say yes here you get support for the TPS65912 series of
 	  PM chips with I2C interface.
@@ -264,7 +264,7 @@ config MFD_TPS65912_SPI
 	bool "TPS65912 Power Management chip with SPI"
 	select MFD_CORE
 	select MFD_TPS65912
-	depends on SPI_MASTER && GPIOLIB && GENERIC_HARDIRQS
+	depends on SPI_MASTER && GPIO && GENERIC_HARDIRQS
 	help
 	  If you say yes here you get support for the TPS65912 series of
 	  PM chips with SPI interface.
@@ -438,7 +438,7 @@ config MFD_TC6387XB
 config MFD_TC6393XB
 	bool "Support Toshiba TC6393XB"
 	depends on ARM && HAVE_CLK
-	select GPIOLIB
+	select GPIO
 	select MFD_CORE
 	select MFD_TMIO
 	help
@@ -904,7 +904,7 @@ config MFD_CS5535
 config MFD_TIMBERDALE
 	tristate "Support for the Timberdale FPGA"
 	select MFD_CORE
-	depends on PCI && GPIOLIB
+	depends on PCI && GPIO
 	---help---
 	This is the core driver for the timberdale FPGA. This device is a
 	multifunction device which exposes numerous platform devices.
@@ -1033,7 +1033,7 @@ config MFD_TPS65090
 config MFD_AAT2870_CORE
 	bool "Support for the AnalogicTech AAT2870"
 	select MFD_CORE
-	depends on I2C=y && GPIOLIB && GENERIC_HARDIRQS
+	depends on I2C=y && GPIO && GENERIC_HARDIRQS
 	help
 	  If you say yes here you get support for the AAT2870.
 	  This driver provides common support for accessing the device,
diff --git a/drivers/misc/ti-st/Kconfig b/drivers/misc/ti-st/Kconfig
index f34dcc5..b44355c 100644
--- a/drivers/misc/ti-st/Kconfig
+++ b/drivers/misc/ti-st/Kconfig
@@ -5,7 +5,7 @@
 menu "Texas Instruments shared transport line discipline"
 config TI_ST
 	tristate "Shared transport core driver"
-	depends on NET && GPIOLIB && TTY
+	depends on NET && GPIO && TTY
 	select FW_LOADER
 	help
 	  This enables the shared transport core driver for TI
diff --git a/drivers/mtd/maps/Kconfig b/drivers/mtd/maps/Kconfig
index c269383..72708a4 100644
--- a/drivers/mtd/maps/Kconfig
+++ b/drivers/mtd/maps/Kconfig
@@ -419,7 +419,7 @@ config MTD_BFIN_ASYNC
 
 config MTD_GPIO_ADDR
 	tristate "GPIO-assisted Flash Chip Support"
-	depends on GPIOLIB
+	depends on GPIO
 	depends on MTD_COMPLEX_MAPPINGS
 	help
 	  Map driver which allows flashes to be partially physically addressed
diff --git a/drivers/mtd/nand/Kconfig b/drivers/mtd/nand/Kconfig
index 5d54ad3..c98451e 100644
--- a/drivers/mtd/nand/Kconfig
+++ b/drivers/mtd/nand/Kconfig
@@ -89,7 +89,7 @@ config MTD_NAND_H1900
 
 config MTD_NAND_GPIO
 	tristate "GPIO NAND Flash driver"
-	depends on GPIOLIB && ARM
+	depends on GPIO && ARM
 	help
 	  This enables a GPIO based NAND flash driver.
 
diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index 1e11f2b..9da08cb 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -126,7 +126,7 @@ config MDIO_BITBANG
 
 config MDIO_GPIO
 	tristate "Support for GPIO lib-based bitbanged MDIO buses"
-	depends on MDIO_BITBANG && GPIOLIB
+	depends on MDIO_BITBANG && GPIO
 	---help---
 	  Supports GPIO lib-based MDIO busses.
 
diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
index 34f51d2..7b423aa 100644
--- a/drivers/pinctrl/Kconfig
+++ b/drivers/pinctrl/Kconfig
@@ -204,7 +204,7 @@ config PINCTRL_U300
 
 config PINCTRL_COH901
 	bool "ST-Ericsson U300 COH 901 335/571 GPIO"
-	depends on GPIOLIB && ARCH_U300 && PINCTRL_U300
+	depends on GPIO && ARCH_U300 && PINCTRL_U300
 	help
 	  Say yes here to support GPIO interface on ST-Ericsson U300.
 	  The names of the two IP block variants supported are
@@ -218,7 +218,7 @@ config PINCTRL_SAMSUNG
 
 config PINCTRL_EXYNOS
 	bool "Pinctrl driver data for Samsung EXYNOS SoCs"
-	depends on OF && GPIOLIB
+	depends on OF && GPIO
 	select PINCTRL_SAMSUNG
 
 config PINCTRL_EXYNOS5440
diff --git a/drivers/pinctrl/sh-pfc/Kconfig b/drivers/pinctrl/sh-pfc/Kconfig
index 99ba8e4..0c33051 100644
--- a/drivers/pinctrl/sh-pfc/Kconfig
+++ b/drivers/pinctrl/sh-pfc/Kconfig
@@ -6,8 +6,8 @@ if ARCH_SHMOBILE || SUPERH
 
 config PINCTRL_SH_PFC
 	# XXX move off the gpio dependency
-	depends on GPIOLIB
-	select GPIO_SH_PFC if ARCH_REQUIRE_GPIOLIB
+	depends on GPIO
+	select GPIO_SH_PFC if ARCH_REQUIRE_GPIO
 	select PINMUX
 	select PINCONF
 	def_bool y
@@ -16,7 +16,7 @@ config PINCTRL_SH_PFC
 
 config GPIO_SH_PFC
 	bool "SuperH PFC GPIO support"
-	depends on PINCTRL_SH_PFC && GPIOLIB
+	depends on PINCTRL_SH_PFC && GPIO
 	help
 	  This enables support for GPIOs within the SoC's pin function
 	  controller.
@@ -34,19 +34,19 @@ config PINCTRL_PFC_R8A7779
 config PINCTRL_PFC_SH7203
 	def_bool y
 	depends on CPU_SUBTYPE_SH7203
-	depends on GPIOLIB
+	depends on GPIO
 	select PINCTRL_SH_PFC
 
 config PINCTRL_PFC_SH7264
 	def_bool y
 	depends on CPU_SUBTYPE_SH7264
-	depends on GPIOLIB
+	depends on GPIO
 	select PINCTRL_SH_PFC
 
 config PINCTRL_PFC_SH7269
 	def_bool y
 	depends on CPU_SUBTYPE_SH7269
-	depends on GPIOLIB
+	depends on GPIO
 	select PINCTRL_SH_PFC
 
 config PINCTRL_PFC_SH7372
@@ -62,55 +62,55 @@ config PINCTRL_PFC_SH73A0
 config PINCTRL_PFC_SH7720
 	def_bool y
 	depends on CPU_SUBTYPE_SH7720
-	depends on GPIOLIB
+	depends on GPIO
 	select PINCTRL_SH_PFC
 
 config PINCTRL_PFC_SH7722
 	def_bool y
 	depends on CPU_SUBTYPE_SH7722
-	depends on GPIOLIB
+	depends on GPIO
 	select PINCTRL_SH_PFC
 
 config PINCTRL_PFC_SH7723
 	def_bool y
 	depends on CPU_SUBTYPE_SH7723
-	depends on GPIOLIB
+	depends on GPIO
 	select PINCTRL_SH_PFC
 
 config PINCTRL_PFC_SH7724
 	def_bool y
 	depends on CPU_SUBTYPE_SH7724
-	depends on GPIOLIB
+	depends on GPIO
 	select PINCTRL_SH_PFC
 
 config PINCTRL_PFC_SH7734
 	def_bool y
 	depends on CPU_SUBTYPE_SH7734
-	depends on GPIOLIB
+	depends on GPIO
 	select PINCTRL_SH_PFC
 
 config PINCTRL_PFC_SH7757
 	def_bool y
 	depends on CPU_SUBTYPE_SH7757
-	depends on GPIOLIB
+	depends on GPIO
 	select PINCTRL_SH_PFC
 
 config PINCTRL_PFC_SH7785
 	def_bool y
 	depends on CPU_SUBTYPE_SH7785
-	depends on GPIOLIB
+	depends on GPIO
 	select PINCTRL_SH_PFC
 
 config PINCTRL_PFC_SH7786
 	def_bool y
 	depends on CPU_SUBTYPE_SH7786
-	depends on GPIOLIB
+	depends on GPIO
 	select PINCTRL_SH_PFC
 
 config PINCTRL_PFC_SHX3
 	def_bool y
 	depends on CPU_SUBTYPE_SHX3
-	depends on GPIOLIB
+	depends on GPIO
 	select PINCTRL_SH_PFC
 
 endif
diff --git a/drivers/pinctrl/spear/Kconfig b/drivers/pinctrl/spear/Kconfig
index 04d93e6..74dbf01 100644
--- a/drivers/pinctrl/spear/Kconfig
+++ b/drivers/pinctrl/spear/Kconfig
@@ -47,7 +47,7 @@ config PINCTRL_SPEAR1340
 
 config PINCTRL_SPEAR_PLGPIO
 	bool "SPEAr SoC PLGPIO Controller"
-	depends on GPIOLIB && PINCTRL_SPEAR
+	depends on GPIO && PINCTRL_SPEAR
 	help
 	  Say yes here to support PLGPIO controller on ST Microelectronics SPEAr
 	  SoCs.
diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index 3338437..73571f0 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -663,7 +663,7 @@ config INTEL_SCU_IPC_UTIL
 
 config GPIO_INTEL_PMIC
 	bool "Intel PMIC GPIO support"
-	depends on INTEL_SCU_IPC && GPIOLIB
+	depends on INTEL_SCU_IPC && GPIO
 	---help---
 	  Say Y here to support GPIO via the SCU IPC interface
 	  on Intel MID platforms.
diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
index 9e00c38..d6f04f8 100644
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -289,7 +289,7 @@ config CHARGER_LP8788
 
 config CHARGER_GPIO
 	tristate "GPIO charger"
-	depends on GPIOLIB
+	depends on GPIO
 	help
 	  Say Y to include support for chargers which report their online status
 	  through a GPIO pin.
diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index 8bb2644..e2d5459 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -66,7 +66,7 @@ config REGULATOR_USERSPACE_CONSUMER
 
 config REGULATOR_GPIO
 	tristate "GPIO regulator support"
-	depends on GPIOLIB
+	depends on GPIO
 	help
 	  This driver provides support for regulators that can be
 	  controlled via gpios.
diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
index 134b6f3..5939299 100644
--- a/drivers/spi/Kconfig
+++ b/drivers/spi/Kconfig
@@ -61,7 +61,7 @@ config SPI_ALTERA
 
 config SPI_ATH79
 	tristate "Atheros AR71XX/AR724X/AR913X SPI controller driver"
-	depends on ATH79 && GPIOLIB
+	depends on ATH79 && GPIO
 	select SPI_BITBANG
 	help
 	  This enables support for the SPI controller present on the
@@ -163,7 +163,7 @@ config SPI_FALCON
 
 config SPI_GPIO
 	tristate "GPIO-based bitbanging SPI Master"
-	depends on GPIOLIB
+	depends on GPIO
 	select SPI_BITBANG
 	help
 	  This simple GPIO bitbanging SPI master uses the arch-neutral GPIO
@@ -240,7 +240,7 @@ config SPI_FSL_ESPI
 
 config SPI_OC_TINY
 	tristate "OpenCores tiny SPI"
-	depends on GPIOLIB
+	depends on GPIO
 	select SPI_BITBANG
 	help
 	  This is the driver for OpenCores tiny SPI master controller.
@@ -430,7 +430,7 @@ config SPI_TOPCLIFF_PCH
 
 config SPI_TXX9
 	tristate "Toshiba TXx9 SPI controller"
-	depends on GPIOLIB && CPU_TX49XX
+	depends on GPIO && CPU_TX49XX
 	help
 	  SPI driver for Toshiba TXx9 MIPS SoCs
 
diff --git a/drivers/ssb/Kconfig b/drivers/ssb/Kconfig
index 5ff3a4f..4132a40 100644
--- a/drivers/ssb/Kconfig
+++ b/drivers/ssb/Kconfig
@@ -167,7 +167,7 @@ config SSB_DRIVER_GIGE
 
 config SSB_DRIVER_GPIO
 	bool "SSB GPIO driver"
-	depends on SSB && GPIOLIB
+	depends on SSB && GPIO
 	help
 	  Driver to provide access to the GPIO pins on the bus.
 
diff --git a/drivers/staging/android/Kconfig b/drivers/staging/android/Kconfig
index 9feb6ff..176cdd0 100644
--- a/drivers/staging/android/Kconfig
+++ b/drivers/staging/android/Kconfig
@@ -54,7 +54,7 @@ config ANDROID_TIMED_OUTPUT
 
 config ANDROID_TIMED_GPIO
 	tristate "Android timed gpio driver"
-	depends on GPIOLIB && ANDROID_TIMED_OUTPUT
+	depends on GPIO && ANDROID_TIMED_OUTPUT
 	default n
 
 config ANDROID_LOW_MEMORY_KILLER
diff --git a/drivers/staging/cptm1217/Kconfig b/drivers/staging/cptm1217/Kconfig
index 43b1cc0..94e4f3a 100644
--- a/drivers/staging/cptm1217/Kconfig
+++ b/drivers/staging/cptm1217/Kconfig
@@ -1,7 +1,7 @@
 config TOUCHSCREEN_CLEARPAD_TM1217
 	tristate "Synaptics Clearpad TM1217"
 	depends on I2C
-	depends on GPIOLIB
+	depends on GPIO
 	depends on INPUT
 	help
 	  Say Y here if you have a Synaptics Clearpad TM1217 Controller
diff --git a/drivers/staging/iio/accel/Kconfig b/drivers/staging/iio/accel/Kconfig
index ad45dfb..fb888a8 100644
--- a/drivers/staging/iio/accel/Kconfig
+++ b/drivers/staging/iio/accel/Kconfig
@@ -61,7 +61,7 @@ config LIS3L02DQ
 	depends on SPI
 	select IIO_TRIGGER if IIO_BUFFER
 	depends on !IIO_BUFFER || IIO_KFIFO_BUF
-	depends on GPIOLIB
+	depends on GPIO
 	help
 	  Say yes here to build SPI support for the ST microelectronics
 	  accelerometer. The driver supplies direct access via sysfs files
diff --git a/drivers/staging/iio/adc/Kconfig b/drivers/staging/iio/adc/Kconfig
index a48eee1..ba7f18b 100644
--- a/drivers/staging/iio/adc/Kconfig
+++ b/drivers/staging/iio/adc/Kconfig
@@ -12,7 +12,7 @@ config AD7291
 
 config AD7606
 	tristate "Analog Devices AD7606 ADC driver"
-	depends on GPIOLIB
+	depends on GPIO
 	select IIO_BUFFER
 	select IIO_TRIGGERED_BUFFER
 	help
@@ -60,7 +60,7 @@ config AD799X_RING_BUFFER
 config AD7780
 	tristate "Analog Devices AD7780 and similar ADCs driver"
 	depends on SPI
-	depends on GPIOLIB
+	depends on GPIO
 	select AD_SIGMA_DELTA
 	help
 	  Say yes here to build support for Analog Devices AD7170, AD7171,
@@ -73,7 +73,7 @@ config AD7780
 config AD7816
 	tristate "Analog Devices AD7816/7/8 temperature sensor and ADC driver"
 	depends on SPI
-	depends on GPIOLIB
+	depends on GPIO
 	help
 	  Say yes here to build support for Analog Devices AD7816/7/8
 	  temperature sensors and ADC.
diff --git a/drivers/staging/iio/addac/Kconfig b/drivers/staging/iio/addac/Kconfig
index e6795e0..6ea8ab4 100644
--- a/drivers/staging/iio/addac/Kconfig
+++ b/drivers/staging/iio/addac/Kconfig
@@ -5,7 +5,7 @@ menu "Analog digital bi-direction converters"
 
 config ADT7316
 	tristate "Analog Devices ADT7316/7/8 ADT7516/7/9 temperature sensor, ADC and DAC driver"
-	depends on GPIOLIB
+	depends on GPIO
 	help
 	  Say yes here to build support for Analog Devices ADT7316, ADT7317, ADT7318
 	  and ADT7516, ADT7517, ADT7519 temperature sensors, ADC and DAC.
diff --git a/drivers/staging/iio/magnetometer/Kconfig b/drivers/staging/iio/magnetometer/Kconfig
index df5e0d4..7288f48 100644
--- a/drivers/staging/iio/magnetometer/Kconfig
+++ b/drivers/staging/iio/magnetometer/Kconfig
@@ -6,7 +6,7 @@ menu "Magnetometer sensors"
 config SENSORS_AK8975
 	tristate "Asahi Kasei AK8975 3-Axis Magnetometer"
 	depends on I2C
-	depends on GPIOLIB
+	depends on GPIO
 	help
 	  Say yes here to build support for Asahi Kasei AK8975 3-Axis
 	  Magnetometer.
diff --git a/drivers/staging/iio/resolver/Kconfig b/drivers/staging/iio/resolver/Kconfig
index ce360f1..11c862d 100644
--- a/drivers/staging/iio/resolver/Kconfig
+++ b/drivers/staging/iio/resolver/Kconfig
@@ -13,7 +13,7 @@ config AD2S90
 config AD2S1200
 	tristate "Analog Devices ad2s1200/ad2s1205 driver"
 	depends on SPI
-	depends on GPIOLIB
+	depends on GPIO
 	help
 	  Say yes here to build support for Analog Devices spi resolver
 	  to digital converters, ad2s1200 and ad2s1205, provides direct access
@@ -22,7 +22,7 @@ config AD2S1200
 config AD2S1210
 	tristate "Analog Devices ad2s1210 driver"
 	depends on SPI
-	depends on GPIOLIB
+	depends on GPIO
 	help
 	  Say yes here to build support for Analog Devices spi resolver
 	  to digital converters, ad2s1210, provides direct access via sysfs.
diff --git a/drivers/staging/iio/trigger/Kconfig b/drivers/staging/iio/trigger/Kconfig
index 1a051da..390a11c 100644
--- a/drivers/staging/iio/trigger/Kconfig
+++ b/drivers/staging/iio/trigger/Kconfig
@@ -14,7 +14,7 @@ config IIO_PERIODIC_RTC_TRIGGER
 
 config IIO_GPIO_TRIGGER
 	tristate "GPIO trigger"
-	depends on GPIOLIB
+	depends on GPIO
 	help
 	  Provides support for using GPIO pins as IIO triggers.
 
diff --git a/drivers/staging/nvec/Kconfig b/drivers/staging/nvec/Kconfig
index f779fdc..7b7e79c 100644
--- a/drivers/staging/nvec/Kconfig
+++ b/drivers/staging/nvec/Kconfig
@@ -1,6 +1,6 @@
 config MFD_NVEC
 	bool "NV Tegra Embedded Controller SMBus Interface"
-	depends on I2C && GPIOLIB && ARCH_TEGRA
+	depends on I2C && GPIO && ARCH_TEGRA
 	select MFD_CORE
 	help
 	    Say Y here to enable support for a nVidia compliant embedded
diff --git a/drivers/staging/vme/devices/Kconfig b/drivers/staging/vme/devices/Kconfig
index 8e8bbb1..2348472 100644
--- a/drivers/staging/vme/devices/Kconfig
+++ b/drivers/staging/vme/devices/Kconfig
@@ -10,7 +10,7 @@ config VME_USER
 
 config VME_PIO2
 	tristate "GE PIO2 VME"
-	depends on STAGING && GPIOLIB
+	depends on STAGING && GPIO
 	help
 	  Say Y here to include support for the GE PIO2. The PIO2 is a 6U VME
 	  slave card, implementing 32 solid-state relay switched IO lines, in
diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
index 7e7006f..278bbb4 100644
--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -1336,7 +1336,7 @@ config SERIAL_ALTERA_UART_CONSOLE
 
 config SERIAL_IFX6X60
         tristate "SPI protocol driver for Infineon 6x60 modem (EXPERIMENTAL)"
-	depends on GPIOLIB && SPI
+	depends on GPIO && SPI
 	help
 	  Support for the IFX6x60 modem devices on Intel MID platforms.
 
diff --git a/drivers/tty/serial/max310x.c b/drivers/tty/serial/max310x.c
index 0c2422c..71e2b07 100644
--- a/drivers/tty/serial/max310x.c
+++ b/drivers/tty/serial/max310x.c
@@ -273,7 +273,7 @@ struct max310x_port {
 	int			uartclk;
 
 	unsigned int		nr_gpio;
-#ifdef CONFIG_GPIOLIB
+#ifdef CONFIG_GPIO
 	struct gpio_chip	gpio;
 #endif
 
@@ -928,7 +928,7 @@ static int max310x_resume(struct spi_device *spi)
 	return uart_resume_port(&s->uart, &s->port);
 }
 
-#ifdef CONFIG_GPIOLIB
+#ifdef CONFIG_GPIO
 static int max310x_gpio_get(struct gpio_chip *chip, unsigned offset)
 {
 	unsigned int val = 0;
@@ -1160,7 +1160,7 @@ static int max310x_probe(struct spi_device *spi)
 	s->port.ops		= &max310x_ops;
 	uart_add_one_port(&s->uart, &s->port);
 
-#ifdef CONFIG_GPIOLIB
+#ifdef CONFIG_GPIO
 	/* Setup GPIO cotroller */
 	if (pdata->gpio_base) {
 		s->gpio.owner		= THIS_MODULE;
@@ -1213,7 +1213,7 @@ static int max310x_remove(struct spi_device *spi)
 
 	uart_unregister_driver(&s->uart);
 
-#ifdef CONFIG_GPIOLIB
+#ifdef CONFIG_GPIO
 	if (s->pdata->gpio_base) {
 		ret = gpiochip_remove(&s->gpio);
 		if (ret)
diff --git a/drivers/usb/otg/Kconfig b/drivers/usb/otg/Kconfig
index 8377868..26ea7e2 100644
--- a/drivers/usb/otg/Kconfig
+++ b/drivers/usb/otg/Kconfig
@@ -19,7 +19,7 @@ if USB || USB_GADGET
 #
 config USB_GPIO_VBUS
 	tristate "GPIO based peripheral-only VBUS sensing 'transceiver'"
-	depends on GPIOLIB
+	depends on GPIO
 	select USB_OTG_UTILS
 	help
 	  Provides simple GPIO VBUS sensing for controllers with an
diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
index df9c738..4a7a33b 100644
--- a/drivers/video/Kconfig
+++ b/drivers/video/Kconfig
@@ -1575,7 +1575,7 @@ config FB_VIA
        select FB_CFB_IMAGEBLIT
        select I2C_ALGOBIT
        select I2C
-       select GPIOLIB
+       select GPIO
        help
 	  This is the frame buffer device driver for Graphics chips of VIA
 	  UniChrome (Pro) Family (CLE266,PM800/CN400,P4M800CE/P4M800Pro/
@@ -2481,7 +2481,7 @@ config FB_SSD1307
 	tristate "Solomon SSD1307 framebuffer support"
 	depends on FB && I2C
 	depends on OF
-	depends on GPIOLIB
+	depends on GPIO
 	select FB_SYS_FOPS
 	select FB_SYS_FILLRECT
 	select FB_SYS_COPYAREA
diff --git a/drivers/video/backlight/Kconfig b/drivers/video/backlight/Kconfig
index b83d155..9dba860 100644
--- a/drivers/video/backlight/Kconfig
+++ b/drivers/video/backlight/Kconfig
@@ -36,14 +36,14 @@ config LCD_CORGI
 
 config LCD_L4F00242T03
 	tristate "Epson L4F00242T03 LCD"
-	depends on SPI_MASTER && GPIOLIB
+	depends on SPI_MASTER && GPIO
 	help
 	  SPI driver for Epson L4F00242T03. This provides basic support
 	  for init and powering the LCD up/down through a sysfs interface.
 
 config LCD_LMS283GF05
 	tristate "Samsung LMS283GF05 LCD"
-	depends on SPI_MASTER && GPIOLIB
+	depends on SPI_MASTER && GPIO
 	help
 	  SPI driver for Samsung LMS283GF05. This provides basic support
 	  for powering the LCD up/down through a sysfs interface.
diff --git a/drivers/w1/masters/Kconfig b/drivers/w1/masters/Kconfig
index 2bd1257..23a0fdb 100644
--- a/drivers/w1/masters/Kconfig
+++ b/drivers/w1/masters/Kconfig
@@ -50,7 +50,7 @@ config W1_MASTER_DS1WM
 
 config W1_MASTER_GPIO
 	tristate "GPIO 1-wire busmaster"
-	depends on GPIOLIB
+	depends on GPIO
 	help
 	  Say Y here if you want to communicate with your 1-wire devices using
 	  GPIO pins. This driver uses the GPIO API to control the wire.
diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
index bde6469..960698c 100644
--- a/include/asm-generic/gpio.h
+++ b/include/asm-generic/gpio.h
@@ -7,7 +7,7 @@
 #include <linux/of.h>
 #include <linux/pinctrl/pinctrl.h>
 
-#ifdef CONFIG_GPIOLIB
+#ifdef CONFIG_GPIO
 
 #include <linux/compiler.h>
 
@@ -247,7 +247,7 @@ gpiochip_remove_pin_ranges(struct gpio_chip *chip)
 
 #endif /* CONFIG_PINCTRL */
 
-#else	/* !CONFIG_GPIOLIB */
+#else	/* !CONFIG_GPIO */
 
 static inline bool gpio_is_valid(int number)
 {
@@ -276,7 +276,7 @@ static inline void gpio_set_value_cansleep(unsigned gpio, int value)
 	__gpio_set_value(gpio, value);
 }
 
-#endif /* !CONFIG_GPIOLIB */
+#endif /* !CONFIG_GPIO */
 
 #ifndef CONFIG_GPIO_SYSFS
 
diff --git a/include/linux/gpio.h b/include/linux/gpio.h
index 552e3f4..287b13f 100644
--- a/include/linux/gpio.h
+++ b/include/linux/gpio.h
@@ -39,7 +39,7 @@ struct gpio {
 	const char	*label;
 };
 
-#ifdef CONFIG_GPIOLIB
+#ifdef CONFIG_GPIO
 
 #ifdef CONFIG_ARCH_HAVE_CUSTOM_GPIO_H
 #include <asm/gpio.h>
@@ -74,7 +74,7 @@ static inline int irq_to_gpio(unsigned int irq)
 
 #endif /* ! CONFIG_ARCH_HAVE_CUSTOM_GPIO_H */
 
-#else /* ! CONFIG_GPIOLIB */
+#else /* ! CONFIG_GPIO */
 
 #include <linux/kernel.h>
 #include <linux/types.h>
@@ -226,7 +226,7 @@ gpiochip_remove_pin_ranges(struct gpio_chip *chip)
 	WARN_ON(1);
 }
 
-#endif /* ! CONFIG_GPIOLIB */
+#endif /* ! CONFIG_GPIO */
 
 struct device;
 
diff --git a/include/linux/leds-tca6507.h b/include/linux/leds-tca6507.h
index dcabf4f..b2efe63 100644
--- a/include/linux/leds-tca6507.h
+++ b/include/linux/leds-tca6507.h
@@ -24,7 +24,7 @@
 
 struct tca6507_platform_data {
 	struct led_platform_data leds;
-#ifdef CONFIG_GPIOLIB
+#ifdef CONFIG_GPIO
 	int gpio_base;
 	void (*setup)(unsigned gpio_base, unsigned ngpio);
 #endif
diff --git a/include/linux/spi/ad7879.h b/include/linux/spi/ad7879.h
index 58368be..6633e5b 100644
--- a/include/linux/spi/ad7879.h
+++ b/include/linux/spi/ad7879.h
@@ -31,7 +31,7 @@ struct ad7879_platform_data {
 	 */
 	u8	median;
 	/* 1 = AUX/VBAT/GPIO export GPIO to gpiolib
-	 * requires CONFIG_GPIOLIB
+	 * requires CONFIG_GPIO
 	 */
 	bool	gpio_export;
 	/* identifies the first GPIO number handled by this chip;
diff --git a/include/sound/soc.h b/include/sound/soc.h
index a6a059c..a2cacb5 100644
--- a/include/sound/soc.h
+++ b/include/sound/soc.h
@@ -332,7 +332,7 @@ struct snd_soc_cache_ops;
 #include <sound/soc-dapm.h>
 #include <sound/soc-dpcm.h>
 
-#ifdef CONFIG_GPIOLIB
+#ifdef CONFIG_GPIO
 struct snd_soc_jack_gpio;
 #endif
 
@@ -437,7 +437,7 @@ void snd_soc_jack_notifier_unregister(struct snd_soc_jack *jack,
 int snd_soc_jack_add_zones(struct snd_soc_jack *jack, int count,
 			  struct snd_soc_jack_zone *zones);
 int snd_soc_jack_get_type(struct snd_soc_jack *jack, int micbias_voltage);
-#ifdef CONFIG_GPIOLIB
+#ifdef CONFIG_GPIO
 int snd_soc_jack_add_gpios(struct snd_soc_jack *jack, int count,
 			struct snd_soc_jack_gpio *gpios);
 void snd_soc_jack_free_gpios(struct snd_soc_jack *jack, int count,
@@ -590,7 +590,7 @@ struct snd_soc_jack_zone {
  *		       to provide more complex checks (eg, reading an
  *		       ADC).
  */
-#ifdef CONFIG_GPIOLIB
+#ifdef CONFIG_GPIO
 struct snd_soc_jack_gpio {
 	unsigned int gpio;
 	const char *name;
diff --git a/net/rfkill/Kconfig b/net/rfkill/Kconfig
index 78efe89..c7dcb70 100644
--- a/net/rfkill/Kconfig
+++ b/net/rfkill/Kconfig
@@ -36,7 +36,7 @@ config RFKILL_REGULATOR
 
 config RFKILL_GPIO
 	tristate "GPIO RFKILL driver"
-	depends on RFKILL && GPIOLIB && HAVE_CLK
+	depends on RFKILL && GPIO && HAVE_CLK
 	default n
 	help
 	  If you say yes here you get support of a generic gpio RFKILL
diff --git a/sound/soc/codecs/wm5100.c b/sound/soc/codecs/wm5100.c
index ac1745d..265bb33 100644
--- a/sound/soc/codecs/wm5100.c
+++ b/sound/soc/codecs/wm5100.c
@@ -78,7 +78,7 @@ struct wm5100_priv {
 
 	struct wm5100_pdata pdata;
 
-#ifdef CONFIG_GPIOLIB
+#ifdef CONFIG_GPIO
 	struct gpio_chip gpio_chip;
 #endif
 };
@@ -2225,7 +2225,7 @@ static irqreturn_t wm5100_edge_irq(int irq, void *data)
 	return ret;
 }
 
-#ifdef CONFIG_GPIOLIB
+#ifdef CONFIG_GPIO
 static inline struct wm5100_priv *gpio_to_wm5100(struct gpio_chip *chip)
 {
 	return container_of(chip, struct wm5100_priv, gpio_chip);
diff --git a/sound/soc/codecs/wm8903.c b/sound/soc/codecs/wm8903.c
index 134e41c..e68fa28 100644
--- a/sound/soc/codecs/wm8903.c
+++ b/sound/soc/codecs/wm8903.c
@@ -138,7 +138,7 @@ struct wm8903_priv {
 	int mic_last_report;
 	int mic_delay;
 
-#ifdef CONFIG_GPIOLIB
+#ifdef CONFIG_GPIO
 	struct gpio_chip gpio_chip;
 #endif
 };
@@ -1774,7 +1774,7 @@ static int wm8903_resume(struct snd_soc_codec *codec)
 	return 0;
 }
 
-#ifdef CONFIG_GPIOLIB
+#ifdef CONFIG_GPIO
 static inline struct wm8903_priv *gpio_to_wm8903(struct gpio_chip *chip)
 {
 	return container_of(chip, struct wm8903_priv, gpio_chip);
diff --git a/sound/soc/codecs/wm8962.c b/sound/soc/codecs/wm8962.c
index e971028..85ee843 100644
--- a/sound/soc/codecs/wm8962.c
+++ b/sound/soc/codecs/wm8962.c
@@ -79,7 +79,7 @@ struct wm8962_priv {
 	int beep_rate;
 #endif
 
-#ifdef CONFIG_GPIOLIB
+#ifdef CONFIG_GPIO
 	struct gpio_chip gpio_chip;
 #endif
 
@@ -3264,7 +3264,7 @@ static void wm8962_set_gpio_mode(struct snd_soc_codec *codec, int gpio)
 				    mask, val);
 }
 
-#ifdef CONFIG_GPIOLIB
+#ifdef CONFIG_GPIO
 static inline struct wm8962_priv *gpio_to_wm8962(struct gpio_chip *chip)
 {
 	return container_of(chip, struct wm8962_priv, gpio_chip);
diff --git a/sound/soc/codecs/wm8996.c b/sound/soc/codecs/wm8996.c
index 46fe83d..56851dd 100644
--- a/sound/soc/codecs/wm8996.c
+++ b/sound/soc/codecs/wm8996.c
@@ -92,7 +92,7 @@ struct wm8996_priv {
 	int jack_flips;
 	wm8996_polarity_fn polarity_cb;
 
-#ifdef CONFIG_GPIOLIB
+#ifdef CONFIG_GPIO
 	struct gpio_chip gpio_chip;
 #endif
 };
@@ -2138,7 +2138,7 @@ static int wm8996_set_fll(struct snd_soc_codec *codec, int fll_id, int source,
 	return ret;
 }
 
-#ifdef CONFIG_GPIOLIB
+#ifdef CONFIG_GPIO
 static inline struct wm8996_priv *gpio_to_wm8996(struct gpio_chip *chip)
 {
 	return container_of(chip, struct wm8996_priv, gpio_chip);
diff --git a/sound/soc/soc-jack.c b/sound/soc/soc-jack.c
index 0bb5ccc..272414c 100644
--- a/sound/soc/soc-jack.c
+++ b/sound/soc/soc-jack.c
@@ -229,7 +229,7 @@ void snd_soc_jack_notifier_unregister(struct snd_soc_jack *jack,
 }
 EXPORT_SYMBOL_GPL(snd_soc_jack_notifier_unregister);
 
-#ifdef CONFIG_GPIOLIB
+#ifdef CONFIG_GPIO
 /* gpio detect */
 static void snd_soc_jack_gpio_detect(struct snd_soc_jack_gpio *gpio)
 {
@@ -376,4 +376,4 @@ void snd_soc_jack_free_gpios(struct snd_soc_jack *jack, int count,
 	}
 }
 EXPORT_SYMBOL_GPL(snd_soc_jack_free_gpios);
-#endif	/* CONFIG_GPIOLIB */
+#endif	/* CONFIG_GPIO */
-- 
1.8.2

