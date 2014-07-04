Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760108AbaGDRwy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 13:52:54 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:14618 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759521AbaGDRtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 13:49:04 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-2f-53b6e90b65f0
From: Tomasz Figa <t.figa@samsung.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mark Brown <broonie@kernel.org>,
        =?UTF-8?q?Heiko=20St=C3=BCbner?= <heiko@sntech.de>,
        Tomasz Figa <tomasz.figa@gmail.com>
Subject: [PATCH 11/19] ARM: S5PV210: Remove support for board files
Date: Fri, 04 Jul 2014 19:48:11 +0200
Message-id: <1404496099-26708-12-git-send-email-t.figa@samsung.com>
X-Mailer: git-send-email 1.9.3
In-reply-to: <1404496099-26708-1-git-send-email-t.figa@samsung.com>
References: <1404496099-26708-1-git-send-email-t.figa@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprILMWRmVeSWpSXmKPExsVy+t/xy7rcL7cFG/yaL2rxd9IxdoupD5+w
	Wfx/9JrVonfBVTaLTY+vsVpc3jWHzWLG+X1MFmuP3GW3OHX9M5vFql1/GB24PH7/msTosXPW
	XXaPTas62Tw2L6n3uHKiidWjb8sqRo/t1+Yxe3zeJBfAEcVlk5Kak1mWWqRvl8CVsXH1HaaC
	jqyKFydamBoYT0V2MXJySAiYSFy+94odwhaTuHBvPVsXIxeHkMBSRonnfbtYQRJCAn1MEo+O
	qoLYbAJqEp8bHrGB2CICqhKf2xYANXNwMAvcZpJoFQYJCws4S/zufcUIYrMAlZx495IZxOYF
	irf9vs8MsUtOonfbGzCbEyg+cd0FJohVThJ//s9nmcDIu4CRYRWjaGppckFxUnquoV5xYm5x
	aV66XnJ+7iZGSDB+2cG4+JjVIUYBDkYlHt7GFRuChVgTy4orcw8xSnAwK4nw/lm1LViINyWx
	siq1KD++qDQntfgQIxMHp1QD45wFL5za/zKoO9tMOi184+ep+BVXLvftbdz/qYct6LDnYpeb
	Ibn/5yz6cK7snfTSezM+6XqfWN0vl/tLZYLlK913aywUtNSE3J4q3JvdXrC96+Rre44vifIC
	sh9+3Wl8+6BJ+r5W8qHmnQf/RLHtfbJ2zZQt26Z42ppNfqofJrr7uoL6/zqtSypKLMUZiYZa
	zEXFiQALxKQSJAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since all in-tree boards have been moved to device tree, we can now drop
legacy code and make mach-s5pv210 DT-only. This patch does it.

Signed-off-by: Tomasz Figa <t.figa@samsung.com>
---
 arch/arm/mach-s5pv210/Kconfig            | 173 ------
 arch/arm/mach-s5pv210/Makefile           |  19 -
 arch/arm/mach-s5pv210/common.c           | 281 ----------
 arch/arm/mach-s5pv210/common.h           |  17 -
 arch/arm/mach-s5pv210/dev-audio.c        | 246 ---------
 arch/arm/mach-s5pv210/dma.c              | 130 -----
 arch/arm/mach-s5pv210/mach-aquila.c      | 687 -----------------------
 arch/arm/mach-s5pv210/mach-goni.c        | 915 -------------------------------
 arch/arm/mach-s5pv210/mach-smdkc110.c    | 159 ------
 arch/arm/mach-s5pv210/mach-smdkv210.c    | 336 ------------
 arch/arm/mach-s5pv210/mach-torbreck.c    | 135 -----
 arch/arm/mach-s5pv210/pm.c               |  24 +-
 arch/arm/mach-s5pv210/setup-fb-24bpp.c   |  49 --
 arch/arm/mach-s5pv210/setup-fimc.c       |  43 --
 arch/arm/mach-s5pv210/setup-i2c0.c       |   6 +-
 arch/arm/mach-s5pv210/setup-i2c1.c       |  28 -
 arch/arm/mach-s5pv210/setup-i2c2.c       |  28 -
 arch/arm/mach-s5pv210/setup-ide.c        |  39 --
 arch/arm/mach-s5pv210/setup-keypad.c     |  24 -
 arch/arm/mach-s5pv210/setup-sdhci-gpio.c | 103 ----
 arch/arm/mach-s5pv210/setup-spi.c        |  34 --
 arch/arm/mach-s5pv210/setup-usb-phy.c    |  95 ----
 arch/arm/plat-samsung/include/plat/cpu.h |   1 -
 23 files changed, 8 insertions(+), 3564 deletions(-)
 delete mode 100644 arch/arm/mach-s5pv210/common.c
 delete mode 100644 arch/arm/mach-s5pv210/dev-audio.c
 delete mode 100644 arch/arm/mach-s5pv210/dma.c
 delete mode 100644 arch/arm/mach-s5pv210/mach-aquila.c
 delete mode 100644 arch/arm/mach-s5pv210/mach-goni.c
 delete mode 100644 arch/arm/mach-s5pv210/mach-smdkc110.c
 delete mode 100644 arch/arm/mach-s5pv210/mach-smdkv210.c
 delete mode 100644 arch/arm/mach-s5pv210/mach-torbreck.c
 delete mode 100644 arch/arm/mach-s5pv210/setup-fb-24bpp.c
 delete mode 100644 arch/arm/mach-s5pv210/setup-fimc.c
 delete mode 100644 arch/arm/mach-s5pv210/setup-i2c1.c
 delete mode 100644 arch/arm/mach-s5pv210/setup-i2c2.c
 delete mode 100644 arch/arm/mach-s5pv210/setup-ide.c
 delete mode 100644 arch/arm/mach-s5pv210/setup-keypad.c
 delete mode 100644 arch/arm/mach-s5pv210/setup-sdhci-gpio.c
 delete mode 100644 arch/arm/mach-s5pv210/setup-spi.c
 delete mode 100644 arch/arm/mach-s5pv210/setup-usb-phy.c

diff --git a/arch/arm/mach-s5pv210/Kconfig b/arch/arm/mach-s5pv210/Kconfig
index ed492cf..d6d0f92 100644
--- a/arch/arm/mach-s5pv210/Kconfig
+++ b/arch/arm/mach-s5pv210/Kconfig
@@ -19,181 +19,8 @@ config CPU_S5PV210
 	help
 	  Enable S5PV210 CPU support
 
-config S5PV210_SETUP_I2C1
-	bool
-	help
-	  Common setup code for i2c bus 1.
-
-config S5PV210_SETUP_I2C2
-	bool
-	help
-	  Common setup code for i2c bus 2.
-
-config S5PV210_SETUP_IDE
-	bool
-	help
-	  Common setup code for S5PV210 IDE GPIO configurations
-
-config S5PV210_SETUP_FB_24BPP
-	bool
-	help
-          Common setup code for S5PV210 with an 24bpp RGB display helper.
-
-config S5PV210_SETUP_KEYPAD
-	bool
-	help
-	  Common setup code for keypad.
-
-config S5PV210_SETUP_SDHCI
-        bool
-        select S5PV210_SETUP_SDHCI_GPIO
-        help
-          Internal helper functions for S5PV210 based SDHCI systems
-
-config S5PV210_SETUP_SDHCI_GPIO
-	bool
-	help
-	  Common setup code for SDHCI gpio.
-
-config S5PV210_SETUP_FIMC
-	bool
-	help
-	  Common setup code for the camera interfaces.
-
-config S5PV210_SETUP_SPI
-	bool
-	help
-	  Common setup code for SPI GPIO configurations.
-
-config S5PV210_SETUP_USB_PHY
-	bool
-	help
-	  Common setup code for USB PHY controller
-
-menu "S5PC110 Machines"
-
-config MACH_AQUILA
-	bool "Aquila"
-	select CPU_S5PV210
-	select S3C_DEV_FB
-	select S3C_DEV_HSMMC
-	select S3C_DEV_HSMMC1
-	select S3C_DEV_HSMMC2
-	select S5PV210_SETUP_FB_24BPP
-	select S5PV210_SETUP_SDHCI
-	select S5PV210_SETUP_USB_PHY
-	select S5P_DEV_FIMC0
-	select S5P_DEV_FIMC1
-	select S5P_DEV_FIMC2
-	select S5P_DEV_ONENAND
-	help
-	  Machine support for the Samsung Aquila target based on S5PC110 SoC
-
-config MACH_GONI
-	bool "GONI"
-	select CPU_S5PV210
-	select S3C_DEV_FB
-	select S3C_DEV_HSMMC
-	select S3C_DEV_HSMMC1
-	select S3C_DEV_HSMMC2
-	select S3C_DEV_I2C1
-	select S3C_DEV_I2C2
-	select S3C_DEV_USB_HSOTG
-	select S5PV210_SETUP_FB_24BPP
-	select S5PV210_SETUP_FIMC
-	select S5PV210_SETUP_I2C1
-	select S5PV210_SETUP_I2C2
-	select S5PV210_SETUP_KEYPAD
-	select S5PV210_SETUP_SDHCI
-	select S5PV210_SETUP_USB_PHY
-	select S5P_DEV_FIMC0
-	select S5P_DEV_FIMC1
-	select S5P_DEV_FIMC2
-	select S5P_DEV_MFC
-	select S5P_DEV_ONENAND
-	select S5P_DEV_TV
-	select S5P_GPIO_INT
-	select SAMSUNG_DEV_KEYPAD
-	help
-	  Machine support for Samsung GONI board
-	  S5PC110(MCP) is one of package option of S5PV210
-
-config MACH_SMDKC110
-	bool "SMDKC110"
-	select CPU_S5PV210
-	select S3C_DEV_I2C1
-	select S3C_DEV_I2C2
-	select S3C_DEV_RTC
-	select S3C_DEV_WDT
-	select S5PV210_SETUP_I2C1
-	select S5PV210_SETUP_I2C2
-	select S5PV210_SETUP_IDE
-	select S5P_DEV_FIMC0
-	select S5P_DEV_FIMC1
-	select S5P_DEV_FIMC2
-	select S5P_DEV_MFC
-	select SAMSUNG_DEV_IDE
-	help
-	  Machine support for Samsung SMDKC110
-	  S5PC110(MCP) is one of package option of S5PV210
-
-endmenu
-
 menu "S5PV210 Machines"
 
-config MACH_SMDKV210
-	bool "SMDKV210"
-	select CPU_S5PV210
-	select S3C_DEV_FB
-	select S3C_DEV_HSMMC
-	select S3C_DEV_HSMMC1
-	select S3C_DEV_HSMMC2
-	select S3C_DEV_HSMMC3
-	select S3C_DEV_I2C1
-	select S3C_DEV_I2C2
-	select S3C_DEV_RTC
-	select S3C_DEV_USB_HSOTG
-	select S3C_DEV_WDT
-	select S5PV210_SETUP_FB_24BPP
-	select S5PV210_SETUP_I2C1
-	select S5PV210_SETUP_I2C2
-	select S5PV210_SETUP_IDE
-	select S5PV210_SETUP_KEYPAD
-	select S5PV210_SETUP_SDHCI
-	select S5PV210_SETUP_USB_PHY
-	select S5P_DEV_FIMC0
-	select S5P_DEV_FIMC1
-	select S5P_DEV_FIMC2
-	select S5P_DEV_JPEG
-	select S5P_DEV_MFC
-	select SAMSUNG_DEV_ADC
-	select SAMSUNG_DEV_BACKLIGHT
-	select SAMSUNG_DEV_IDE
-	select SAMSUNG_DEV_KEYPAD
-	select SAMSUNG_DEV_PWM
-	select SAMSUNG_DEV_TS
-	help
-	  Machine support for Samsung SMDKV210
-
-config MACH_TORBRECK
-	bool "Torbreck"
-	select ARCH_SPARSEMEM_ENABLE
-	select CPU_S5PV210
-	select S3C_DEV_HSMMC
-	select S3C_DEV_HSMMC1
-	select S3C_DEV_HSMMC2
-	select S3C_DEV_HSMMC3
-	select S3C_DEV_I2C1
-	select S3C_DEV_I2C2
-	select S3C_DEV_RTC
-	select S3C_DEV_WDT
-	select S5PV210_SETUP_I2C1
-	select S5PV210_SETUP_I2C2
-	select S5PV210_SETUP_SDHCI
-	select SAMSUNG_DEV_IDE
-	help
-	  Machine support for aESOP Torbreck
-
 config MACH_S5PV210_DT
 	bool "Samsung S5PV210/S5PC110 machine using Device Tree"
 	select CLKSRC_OF
diff --git a/arch/arm/mach-s5pv210/Makefile b/arch/arm/mach-s5pv210/Makefile
index 8d87b10..83993fc 100644
--- a/arch/arm/mach-s5pv210/Makefile
+++ b/arch/arm/mach-s5pv210/Makefile
@@ -12,30 +12,11 @@ obj-				:=
 
 # Core
 
-obj-y				+= common.o
 obj-$(CONFIG_PM)		+= pm.o
 
-obj-y				+= dma.o
-
 # machine support
 
-obj-$(CONFIG_MACH_AQUILA)	+= mach-aquila.o
-obj-$(CONFIG_MACH_GONI)		+= mach-goni.o
-obj-$(CONFIG_MACH_SMDKC110)	+= mach-smdkc110.o
-obj-$(CONFIG_MACH_SMDKV210)	+= mach-smdkv210.o
-obj-$(CONFIG_MACH_TORBRECK)	+= mach-torbreck.o
 obj-$(CONFIG_MACH_S5PV210_DT)	+= s5pv210.o
 # device support
 
-obj-y				+= dev-audio.o
-
 obj-y					+= setup-i2c0.o
-obj-$(CONFIG_S5PV210_SETUP_FB_24BPP)	+= setup-fb-24bpp.o
-obj-$(CONFIG_S5PV210_SETUP_FIMC)	+= setup-fimc.o
-obj-$(CONFIG_S5PV210_SETUP_I2C1)	+= setup-i2c1.o
-obj-$(CONFIG_S5PV210_SETUP_I2C2)	+= setup-i2c2.o
-obj-$(CONFIG_S5PV210_SETUP_IDE)		+= setup-ide.o
-obj-$(CONFIG_S5PV210_SETUP_KEYPAD)	+= setup-keypad.o
-obj-$(CONFIG_S5PV210_SETUP_SDHCI_GPIO)	+= setup-sdhci-gpio.o
-obj-$(CONFIG_S5PV210_SETUP_SPI)		+= setup-spi.o
-obj-$(CONFIG_S5PV210_SETUP_USB_PHY) += setup-usb-phy.o
diff --git a/arch/arm/mach-s5pv210/common.c b/arch/arm/mach-s5pv210/common.c
deleted file mode 100644
index 30bd542..0000000
diff --git a/arch/arm/mach-s5pv210/common.h b/arch/arm/mach-s5pv210/common.h
index 083ffe7..0b694c7 100644
--- a/arch/arm/mach-s5pv210/common.h
+++ b/arch/arm/mach-s5pv210/common.h
@@ -12,22 +12,5 @@
 #ifndef __ARCH_ARM_MACH_S5PV210_COMMON_H
 #define __ARCH_ARM_MACH_S5PV210_COMMON_H
 
-#include <linux/reboot.h>
-
-void s5pv210_clk_init(unsigned long xxti_f, unsigned long xusbxti_f,
-		      void __iomem *reg_base);
-
-void s5pv210_init_io(struct map_desc *mach_desc, int size);
-void s5pv210_init_irq(void);
-
-void s5pv210_register_clocks(void);
-void s5pv210_setup_clocks(void);
-
-void s5pv210_restart(enum reboot_mode mode, const char *cmd);
-
-extern  int s5pv210_init(void);
-extern void s5pv210_map_io(void);
-extern void s5pv210_init_clocks(int xtal);
-extern void s5pv210_init_uarts(struct s3c2410_uartcfg *cfg, int no);
 
 #endif /* __ARCH_ARM_MACH_S5PV210_COMMON_H */
diff --git a/arch/arm/mach-s5pv210/dev-audio.c b/arch/arm/mach-s5pv210/dev-audio.c
deleted file mode 100644
index 2d67361..0000000
diff --git a/arch/arm/mach-s5pv210/dma.c b/arch/arm/mach-s5pv210/dma.c
deleted file mode 100644
index b8337e2..0000000
diff --git a/arch/arm/mach-s5pv210/mach-aquila.c b/arch/arm/mach-s5pv210/mach-aquila.c
deleted file mode 100644
index cc37eda..0000000
diff --git a/arch/arm/mach-s5pv210/mach-goni.c b/arch/arm/mach-s5pv210/mach-goni.c
deleted file mode 100644
index 315926f..0000000
diff --git a/arch/arm/mach-s5pv210/mach-smdkc110.c b/arch/arm/mach-s5pv210/mach-smdkc110.c
deleted file mode 100644
index 448e1d2..0000000
diff --git a/arch/arm/mach-s5pv210/mach-smdkv210.c b/arch/arm/mach-s5pv210/mach-smdkv210.c
deleted file mode 100644
index 6816ccd..0000000
diff --git a/arch/arm/mach-s5pv210/mach-torbreck.c b/arch/arm/mach-s5pv210/mach-torbreck.c
deleted file mode 100644
index 1578055..0000000
diff --git a/arch/arm/mach-s5pv210/pm.c b/arch/arm/mach-s5pv210/pm.c
index dd5bfec..00d1523 100644
--- a/arch/arm/mach-s5pv210/pm.c
+++ b/arch/arm/mach-s5pv210/pm.c
@@ -75,26 +75,6 @@ static void s5pv210_pm_prepare(void)
 	s3c_pm_do_save(s5pv210_core_save, ARRAY_SIZE(s5pv210_core_save));
 }
 
-static int s5pv210_pm_add(struct device *dev, struct subsys_interface *sif)
-{
-	pm_cpu_prep = s5pv210_pm_prepare;
-	pm_cpu_sleep = s5pv210_cpu_suspend;
-
-	return 0;
-}
-
-static struct subsys_interface s5pv210_pm_interface = {
-	.name		= "s5pv210_pm",
-	.subsys		= &s5pv210_subsys,
-	.add_dev	= s5pv210_pm_add,
-};
-
-static __init int s5pv210_pm_drvinit(void)
-{
-	return subsys_interface_register(&s5pv210_pm_interface);
-}
-arch_initcall(s5pv210_pm_drvinit);
-
 static void s5pv210_pm_resume(void)
 {
 	u32 tmp;
@@ -114,6 +94,10 @@ static struct syscore_ops s5pv210_pm_syscore_ops = {
 static __init int s5pv210_pm_syscore_init(void)
 {
 	register_syscore_ops(&s5pv210_pm_syscore_ops);
+
+	pm_cpu_prep = s5pv210_pm_prepare;
+	pm_cpu_sleep = s5pv210_cpu_suspend;
+
 	return 0;
 }
 arch_initcall(s5pv210_pm_syscore_init);
diff --git a/arch/arm/mach-s5pv210/setup-fb-24bpp.c b/arch/arm/mach-s5pv210/setup-fb-24bpp.c
deleted file mode 100644
index 55103c8..0000000
diff --git a/arch/arm/mach-s5pv210/setup-fimc.c b/arch/arm/mach-s5pv210/setup-fimc.c
deleted file mode 100644
index 54cc5b11..0000000
diff --git a/arch/arm/mach-s5pv210/setup-i2c0.c b/arch/arm/mach-s5pv210/setup-i2c0.c
index 4a15849..3658416 100644
--- a/arch/arm/mach-s5pv210/setup-i2c0.c
+++ b/arch/arm/mach-s5pv210/setup-i2c0.c
@@ -23,6 +23,8 @@ struct platform_device; /* don't need the contents */
 
 void s3c_i2c0_cfg_gpio(struct platform_device *dev)
 {
-	s3c_gpio_cfgall_range(S5PV210_GPD1(0), 2,
-			      S3C_GPIO_SFN(2), S3C_GPIO_PULL_UP);
+	/*
+	 * FIXME: Used only by legacy code that is not used anymore,
+	 * but still compiled in, until all dependencies are removed.
+	 */
 }
diff --git a/arch/arm/mach-s5pv210/setup-i2c1.c b/arch/arm/mach-s5pv210/setup-i2c1.c
deleted file mode 100644
index 4777f6b..0000000
diff --git a/arch/arm/mach-s5pv210/setup-i2c2.c b/arch/arm/mach-s5pv210/setup-i2c2.c
deleted file mode 100644
index bbce6c7..0000000
diff --git a/arch/arm/mach-s5pv210/setup-ide.c b/arch/arm/mach-s5pv210/setup-ide.c
deleted file mode 100644
index ea123d5..0000000
diff --git a/arch/arm/mach-s5pv210/setup-keypad.c b/arch/arm/mach-s5pv210/setup-keypad.c
deleted file mode 100644
index c56420a..0000000
diff --git a/arch/arm/mach-s5pv210/setup-sdhci-gpio.c b/arch/arm/mach-s5pv210/setup-sdhci-gpio.c
deleted file mode 100644
index 0512ada..0000000
diff --git a/arch/arm/mach-s5pv210/setup-spi.c b/arch/arm/mach-s5pv210/setup-spi.c
deleted file mode 100644
index 81aecc1..0000000
diff --git a/arch/arm/mach-s5pv210/setup-usb-phy.c b/arch/arm/mach-s5pv210/setup-usb-phy.c
deleted file mode 100644
index b2ee533..0000000
diff --git a/arch/arm/plat-samsung/include/plat/cpu.h b/arch/arm/plat-samsung/include/plat/cpu.h
index d1d4659..995e56e 100644
--- a/arch/arm/plat-samsung/include/plat/cpu.h
+++ b/arch/arm/plat-samsung/include/plat/cpu.h
@@ -149,7 +149,6 @@ extern struct bus_type s3c2440_subsys;
 extern struct bus_type s3c2442_subsys;
 extern struct bus_type s3c2443_subsys;
 extern struct bus_type s3c6410_subsys;
-extern struct bus_type s5pv210_subsys;
 
 extern void (*s5pc1xx_idle)(void);
 
-- 
1.9.3

