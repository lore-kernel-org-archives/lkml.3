Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752009AbaJSVDv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 17:03:51 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:44808 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057AbaJSVDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 17:03:47 -0400
Date: Sun, 19 Oct 2014 14:03:45 -0700
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: olof@lixom.net, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, arm@kernel.org
Subject: [GIT PULL] ARM: SoC fixes for 3.18-rc1
Message-ID: <20141019210345.GA11891@quad.lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit 0429fbc0bdc297d64188483ba029a23773ae07b0:

  Merge branch 'for-3.18-consistent-ops' of git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu (2014-10-15 07:48:18 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/arm-soc-fixes-rc1

for you to fetch changes up to 57764512cef5d67623b6ac0a966761f5bbc43aa0:

  Merge tag 'qcom-dt-for-3.18-3' of git://git.kernel.org/pub/scm/linux/kernel/git/galak/linux-qcom into fixes (2014-10-19 13:39:08 -0700)

----------------------------------------------------------------
ARM: SoC fixes for -rc1

A batch of fixes that have come in during the merge window.

Some of them are defconfig updates for things that have now landed,
some errata additions and a few general scattered fixes.

There's also a qcom DT update that adds support for SATA on AP148,
and basic support for Sony Xperia Z1 and CM-QS600 platforms that seemed
isolated enough that we could merge it even if it's late.

----------------------------------------------------------------
Bartlomiej Zolnierkiewicz (2):
      ARM: EXYNOS: Fix build with PM_SLEEP=n and ARM_EXYNOS_CPUIDLE=n
      ARM: mm: Fix ifdef around cpu_*_do_[suspend, resume] ops

Javier Martinez Canillas (3):
      ARM: exynos_defconfig: Enable Atmel maXTouch support
      ARM: exynos_defconfig: Enable Control Groups support
      ARM: exynos_defconfig: Enable SBS battery support

Krzysztof Kozlowski (1):
      ARM: exynos_defconfig: Enable Maxim 77693 and I2C GPIO drivers

Kumar Gala (1):
      ARM: dts: qcom: Add SATA support on IPQ8064/AP148

Mike Rapoport (1):
      ARM: dts: qcom: add CM-QS600 board

Olof Johansson (6):
      ARM: sunxi_defconfig: enable CONFIG_REGULATOR
      Merge tag 'fixes-for-v3.18-merge-window' of git://git.kernel.org/.../tmlind/linux-omap into fixes
      Merge tag 'samsung-fixes' of git://git.kernel.org/.../kgene/linux-samsung into fixes
      Merge tag 'samsung-defconfig' of git://git.kernel.org/.../kgene/linux-samsung into fixes
      Merge tag 'samsung-fixes-2' of git://git.kernel.org/.../kgene/linux-samsung into fixes
      Merge tag 'qcom-dt-for-3.18-3' of git://git.kernel.org/.../galak/linux-qcom into fixes

Santosh Shilimkar (1):
      MAINTAINERS: Update Santosh Shilimkar's email id

Scott Branden (1):
      MAINTAINERS: corrected bcm2835 search

Sjoerd Simons (3):
      ARM: exynos_defconfig: enable USB gadget support
      ARM: dts: Explicitly set dr_mode on exynos Peach boards
      ARM: dts: Explicitly set dr_mode on exynos5420-arndale-octa

Tim Bird (1):
      ARM: dts: qcom: Add initial DTS file for Sony Xperia Z1 phone

Tomasz Figa (2):
      ARM: dts: Fix pull setting in sd4_width8 pin group for exynos4x12
      ARM: SAMSUNG: Restore Samsung PM Debug functionality

Tony Lindgren (2):
      ARM: omap2plus_defconfig: Enable ARM erratum 430973 for omap3
      ARM: dts: Disable smc91x on n900 until bootloader dependency is removed

Vivek Gautam (1):
      ARM: exynos_defconfig: Enable MAX77802

 .../devicetree/bindings/vendor-prefixes.txt        |  1 +
 MAINTAINERS                                        | 23 ++++-----
 arch/arm/boot/dts/Makefile                         |  4 +-
 arch/arm/boot/dts/exynos4x12-pinctrl.dtsi          |  2 +-
 arch/arm/boot/dts/exynos5420-arndale-octa.dts      |  4 ++
 arch/arm/boot/dts/exynos5420-peach-pit.dts         |  8 +++
 arch/arm/boot/dts/exynos5420.dtsi                  |  4 +-
 arch/arm/boot/dts/exynos5800-peach-pi.dts          |  8 +++
 arch/arm/boot/dts/omap3-n900.dts                   |  3 ++
 arch/arm/boot/dts/qcom-apq8064-cm-qs600.dts        | 59 ++++++++++++++++++++++
 arch/arm/boot/dts/qcom-ipq8064-ap148.dts           |  8 +++
 arch/arm/boot/dts/qcom-ipq8064.dtsi                | 33 ++++++++++++
 .../boot/dts/qcom-msm8974-sony-xperia-honami.dts   | 17 +++++++
 arch/arm/configs/exynos_defconfig                  | 10 ++++
 arch/arm/configs/omap2plus_defconfig               |  1 +
 arch/arm/configs/sunxi_defconfig                   |  1 +
 arch/arm/mach-exynos/exynos.c                      |  2 +
 arch/arm/mm/proc-macros.S                          |  2 +-
 arch/arm/plat-samsung/Kconfig                      |  5 +-
 arch/arm/plat-samsung/pm-debug.c                   |  1 +
 20 files changed, 176 insertions(+), 20 deletions(-)
 create mode 100644 arch/arm/boot/dts/qcom-apq8064-cm-qs600.dts
 create mode 100644 arch/arm/boot/dts/qcom-msm8974-sony-xperia-honami.dts

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
index c7bb11be15a3..723999d73744 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.txt
+++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
@@ -140,6 +140,7 @@ sitronix	Sitronix Technology Corporation
 smsc	Standard Microsystems Corporation
 snps 	Synopsys, Inc.
 solidrun	SolidRun
+sony	Sony Corporation
 spansion	Spansion Inc.
 st	STMicroelectronics
 ste	ST-Ericsson
diff --git a/MAINTAINERS b/MAINTAINERS
index b0f17d59078e..fc1ddec408fd 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1088,33 +1088,33 @@ L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 
 ARM/TEXAS INSTRUMENT KEYSTONE ARCHITECTURE
-M:	Santosh Shilimkar <santosh.shilimkar@ti.com>
+M:	Santosh Shilimkar <ssantosh@kernel.org>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 F:	arch/arm/mach-keystone/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/ssantosh/linux-keystone.git
 
 ARM/TEXAS INSTRUMENT KEYSTONE CLOCK FRAMEWORK
-M:	Santosh Shilimkar <santosh.shilimkar@ti.com>
+M:	Santosh Shilimkar <ssantosh@kernel.org>
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	drivers/clk/keystone/
 
 ARM/TEXAS INSTRUMENT KEYSTONE ClOCKSOURCE
-M:	Santosh Shilimkar <santosh.shilimkar@ti.com>
+M:	Santosh Shilimkar <ssantosh@kernel.org>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	drivers/clocksource/timer-keystone.c
 
 ARM/TEXAS INSTRUMENT KEYSTONE RESET DRIVER
-M:	Santosh Shilimkar <santosh.shilimkar@ti.com>
+M:	Santosh Shilimkar <ssantosh@kernel.org>
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	drivers/power/reset/keystone-reset.c
 
 ARM/TEXAS INSTRUMENT AEMIF/EMIF DRIVERS
-M:	Santosh Shilimkar <santosh.shilimkar@ti.com>
+M:	Santosh Shilimkar <ssantosh@kernel.org>
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	drivers/memory/*emif*
@@ -2062,17 +2062,14 @@ F:	arch/arm/configs/bcm_defconfig
 F:	drivers/mmc/host/sdhci-bcm-kona.c
 F:	drivers/clocksource/bcm_kona_timer.c
 
-BROADCOM BCM2835 ARM ARCHICTURE
+BROADCOM BCM2835 ARM ARCHITECTURE
 M:	Stephen Warren <swarren@wwwdotorg.org>
 L:	linux-rpi-kernel@lists.infradead.org (moderated for non-subscribers)
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/swarren/linux-rpi.git
 S:	Maintained
-F:	arch/arm/mach-bcm/board_bcm2835.c
-F:	arch/arm/boot/dts/bcm2835*
-F:	arch/arm/configs/bcm2835_defconfig
-F:	drivers/*/*bcm2835*
+N:	bcm2835
 
-BROADCOM BCM5301X ARM ARCHICTURE
+BROADCOM BCM5301X ARM ARCHITECTURE
 M:	Hauke Mehrtens <hauke@hauke-m.de>
 L:	linux-arm-kernel@lists.infradead.org
 S:	Maintained
@@ -6686,7 +6683,7 @@ F:	arch/arm/*omap*/usb*
 
 OMAP GPIO DRIVER
 M:	Javier Martinez Canillas <javier@dowhile0.org>
-M:	Santosh Shilimkar <santosh.shilimkar@ti.com>
+M:	Santosh Shilimkar <ssantosh@kernel.org>
 M:	Kevin Hilman <khilman@deeprootsystems.com>
 L:	linux-omap@vger.kernel.org
 S:	Maintained
@@ -9273,7 +9270,7 @@ F:	drivers/mmc/host/tifm_sd.c
 F:	include/linux/tifm.h
 
 TI KEYSTONE MULTICORE NAVIGATOR DRIVERS
-M:	Santosh Shilimkar <santosh.shilimkar@ti.com>
+M:	Santosh Shilimkar <ssantosh@kernel.org>
 L:	linux-kernel@vger.kernel.org
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index 7c80af906897..38c89cafa1ab 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -354,13 +354,15 @@ dtb-$(CONFIG_ARCH_ORION5X) += orion5x-lacie-d2-network.dtb \
 	orion5x-rd88f5182-nas.dtb
 dtb-$(CONFIG_ARCH_PRIMA2) += prima2-evb.dtb
 dtb-$(CONFIG_ARCH_QCOM) += \
+	qcom-apq8064-cm-qs600.dtb \
 	qcom-apq8064-ifc6410.dtb \
 	qcom-apq8074-dragonboard.dtb \
 	qcom-apq8084-ifc6540.dtb \
 	qcom-apq8084-mtp.dtb \
 	qcom-ipq8064-ap148.dtb \
 	qcom-msm8660-surf.dtb \
-	qcom-msm8960-cdp.dtb
+	qcom-msm8960-cdp.dtb \
+	qcom-msm8974-sony-xperia-honami.dtb
 dtb-$(CONFIG_ARCH_ROCKCHIP) += \
 	rk3066a-bqcurie2.dtb \
 	rk3188-radxarock.dtb \
diff --git a/arch/arm/boot/dts/exynos4x12-pinctrl.dtsi b/arch/arm/boot/dts/exynos4x12-pinctrl.dtsi
index 99b26df8dbc7..0865a2e33f97 100644
--- a/arch/arm/boot/dts/exynos4x12-pinctrl.dtsi
+++ b/arch/arm/boot/dts/exynos4x12-pinctrl.dtsi
@@ -675,7 +675,7 @@
 		sd4_bus8: sd4-bus-width8 {
 			samsung,pins = "gpk1-3", "gpk1-4", "gpk1-5", "gpk1-6";
 			samsung,pin-function = <4>;
-			samsung,pin-pud = <4>;
+			samsung,pin-pud = <3>;
 			samsung,pin-drv = <3>;
 		};
 
diff --git a/arch/arm/boot/dts/exynos5420-arndale-octa.dts b/arch/arm/boot/dts/exynos5420-arndale-octa.dts
index 4f2df61c1cfc..aa7a7d727a7e 100644
--- a/arch/arm/boot/dts/exynos5420-arndale-octa.dts
+++ b/arch/arm/boot/dts/exynos5420-arndale-octa.dts
@@ -368,3 +368,7 @@
 		};
 	};
 };
+
+&usbdrd_dwc3_1 {
+	dr_mode = "host";
+};
diff --git a/arch/arm/boot/dts/exynos5420-peach-pit.dts b/arch/arm/boot/dts/exynos5420-peach-pit.dts
index 9a233828539c..82cdb74484cc 100644
--- a/arch/arm/boot/dts/exynos5420-peach-pit.dts
+++ b/arch/arm/boot/dts/exynos5420-peach-pit.dts
@@ -838,6 +838,14 @@
 	status = "okay";
 };
 
+&usbdrd_dwc3_0 {
+	dr_mode = "host";
+};
+
+&usbdrd_dwc3_1 {
+	dr_mode = "host";
+};
+
 &usbdrd_phy0 {
 	vbus-supply = <&usb300_vbus_reg>;
 };
diff --git a/arch/arm/boot/dts/exynos5420.dtsi b/arch/arm/boot/dts/exynos5420.dtsi
index bfe056d9148c..8617a031cbc0 100644
--- a/arch/arm/boot/dts/exynos5420.dtsi
+++ b/arch/arm/boot/dts/exynos5420.dtsi
@@ -815,7 +815,7 @@
 		#size-cells = <1>;
 		ranges;
 
-		dwc3 {
+		usbdrd_dwc3_0: dwc3 {
 			compatible = "snps,dwc3";
 			reg = <0x12000000 0x10000>;
 			interrupts = <0 72 0>;
@@ -841,7 +841,7 @@
 		#size-cells = <1>;
 		ranges;
 
-		dwc3 {
+		usbdrd_dwc3_1: dwc3 {
 			compatible = "snps,dwc3";
 			reg = <0x12400000 0x10000>;
 			interrupts = <0 73 0>;
diff --git a/arch/arm/boot/dts/exynos5800-peach-pi.dts b/arch/arm/boot/dts/exynos5800-peach-pi.dts
index 1d31c8132558..7bb1c8dd42dd 100644
--- a/arch/arm/boot/dts/exynos5800-peach-pi.dts
+++ b/arch/arm/boot/dts/exynos5800-peach-pi.dts
@@ -826,6 +826,14 @@
 	status = "okay";
 };
 
+&usbdrd_dwc3_0 {
+	dr_mode = "host";
+};
+
+&usbdrd_dwc3_1 {
+	dr_mode = "host";
+};
+
 &usbdrd_phy0 {
 	vbus-supply = <&usb300_vbus_reg>;
 };
diff --git a/arch/arm/boot/dts/omap3-n900.dts b/arch/arm/boot/dts/omap3-n900.dts
index 9b0494a8ab45..739fcf29c643 100644
--- a/arch/arm/boot/dts/omap3-n900.dts
+++ b/arch/arm/boot/dts/omap3-n900.dts
@@ -659,6 +659,9 @@
 
 	ethernet@gpmc {
 		compatible = "smsc,lan91c94";
+
+		status = "disabled";
+
 		interrupt-parent = <&gpio2>;
 		interrupts = <22 IRQ_TYPE_LEVEL_HIGH>;	/* gpio54 */
 		reg = <1 0x300 0xf>;		/* 16 byte IO range at offset 0x300 */
diff --git a/arch/arm/boot/dts/qcom-apq8064-cm-qs600.dts b/arch/arm/boot/dts/qcom-apq8064-cm-qs600.dts
new file mode 100644
index 000000000000..5d75666f7f6c
--- /dev/null
+++ b/arch/arm/boot/dts/qcom-apq8064-cm-qs600.dts
@@ -0,0 +1,59 @@
+#include "qcom-apq8064-v2.0.dtsi"
+
+/ {
+	model = "CompuLab CM-QS600";
+	compatible = "qcom,apq8064-cm-qs600", "qcom,apq8064";
+
+	soc {
+		pinctrl@800000 {
+			i2c1_pins: i2c1 {
+				mux {
+					pins = "gpio20", "gpio21";
+					function = "gsbi1";
+				};
+			};
+		};
+
+		gsbi@12440000 {
+			status = "okay";
+			qcom,mode = <GSBI_PROT_I2C>;
+
+			i2c@12460000 {
+				status = "okay";
+				clock-frequency = <200000>;
+				pinctrl-0 = <&i2c1_pins>;
+				pinctrl-names = "default";
+
+				eeprom: eeprom@50 {
+					compatible = "24c02";
+					reg = <0x50>;
+					pagesize = <32>;
+				};
+			};
+		};
+
+		gsbi@16600000 {
+			status = "ok";
+			qcom,mode = <GSBI_PROT_I2C_UART>;
+			serial@16640000 {
+				status = "ok";
+			};
+		};
+
+		amba {
+			/* eMMC */
+			sdcc1: sdcc@12400000 {
+				status = "okay";
+			};
+
+			/* External micro SD card */
+			sdcc3: sdcc@12180000 {
+				status = "okay";
+			};
+			/* WLAN */
+			sdcc4: sdcc@121c0000 {
+				status = "okay";
+			};
+		};
+	};
+};
diff --git a/arch/arm/boot/dts/qcom-ipq8064-ap148.dts b/arch/arm/boot/dts/qcom-ipq8064-ap148.dts
index 95e64955fb8e..55b2910efd87 100644
--- a/arch/arm/boot/dts/qcom-ipq8064-ap148.dts
+++ b/arch/arm/boot/dts/qcom-ipq8064-ap148.dts
@@ -81,5 +81,13 @@
 				};
 			};
 		};
+
+		sata-phy@1b400000 {
+			status = "ok";
+		};
+
+		sata@29000000 {
+			status = "ok";
+		};
 	};
 };
diff --git a/arch/arm/boot/dts/qcom-ipq8064.dtsi b/arch/arm/boot/dts/qcom-ipq8064.dtsi
index 244f857f0e6f..63b2146f563b 100644
--- a/arch/arm/boot/dts/qcom-ipq8064.dtsi
+++ b/arch/arm/boot/dts/qcom-ipq8064.dtsi
@@ -234,6 +234,39 @@
 			};
 		};
 
+		sata_phy: sata-phy@1b400000 {
+			compatible = "qcom,ipq806x-sata-phy";
+			reg = <0x1b400000 0x200>;
+
+			clocks = <&gcc SATA_PHY_CFG_CLK>;
+			clock-names = "cfg";
+
+			#phy-cells = <0>;
+			status = "disabled";
+		};
+
+		sata@29000000 {
+			compatible = "qcom,ipq806x-ahci", "generic-ahci";
+			reg = <0x29000000 0x180>;
+
+			interrupts = <0 209 0x0>;
+
+			clocks = <&gcc SFAB_SATA_S_H_CLK>,
+				 <&gcc SATA_H_CLK>,
+				 <&gcc SATA_A_CLK>,
+				 <&gcc SATA_RXOOB_CLK>,
+				 <&gcc SATA_PMALIVE_CLK>;
+			clock-names = "slave_face", "iface", "core",
+					"rxoob", "pmalive";
+
+			assigned-clocks = <&gcc SATA_RXOOB_CLK>, <&gcc SATA_PMALIVE_CLK>;
+			assigned-clock-rates = <100000000>, <100000000>;
+
+			phys = <&sata_phy>;
+			phy-names = "sata-phy";
+			status = "disabled";
+		};
+
 		qcom,ssbi@500000 {
 			compatible = "qcom,ssbi";
 			reg = <0x00500000 0x1000>;
diff --git a/arch/arm/boot/dts/qcom-msm8974-sony-xperia-honami.dts b/arch/arm/boot/dts/qcom-msm8974-sony-xperia-honami.dts
new file mode 100644
index 000000000000..cccc21b7c8fd
--- /dev/null
+++ b/arch/arm/boot/dts/qcom-msm8974-sony-xperia-honami.dts
@@ -0,0 +1,17 @@
+#include "qcom-msm8974.dtsi"
+
+/ {
+	model = "Sony Xperia Z1";
+	compatible = "sony,xperia-honami", "qcom,msm8974";
+
+	memory@0 {
+		reg = <0 0x40000000>, <0x40000000 0x40000000>;
+		device_type = "memory";
+	};
+};
+
+&soc {
+	serial@f991e000 {
+		status = "ok";
+	};
+};
diff --git a/arch/arm/configs/exynos_defconfig b/arch/arm/configs/exynos_defconfig
index fc7d1683bf67..72058b8a6f4d 100644
--- a/arch/arm/configs/exynos_defconfig
+++ b/arch/arm/configs/exynos_defconfig
@@ -1,6 +1,7 @@
 CONFIG_SYSVIPC=y
 CONFIG_NO_HZ=y
 CONFIG_HIGH_RES_TIMERS=y
+CONFIG_CGROUPS=y
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_KALLSYMS_ALL=y
 CONFIG_MODULES=y
@@ -54,12 +55,14 @@ CONFIG_SMSC911X=y
 CONFIG_USB_USBNET=y
 CONFIG_USB_NET_SMSC75XX=y
 CONFIG_USB_NET_SMSC95XX=y
+CONFIG_USB_GADGET=y
 CONFIG_INPUT_EVDEV=y
 CONFIG_KEYBOARD_GPIO=y
 CONFIG_KEYBOARD_CROS_EC=y
 # CONFIG_MOUSE_PS2 is not set
 CONFIG_MOUSE_CYAPA=y
 CONFIG_INPUT_TOUCHSCREEN=y
+CONFIG_TOUCHSCREEN_ATMEL_MXT=y
 CONFIG_SERIAL_8250=y
 CONFIG_SERIAL_SAMSUNG=y
 CONFIG_SERIAL_SAMSUNG_CONSOLE=y
@@ -68,15 +71,18 @@ CONFIG_HW_RANDOM=y
 CONFIG_TCG_TPM=y
 CONFIG_TCG_TIS_I2C_INFINEON=y
 CONFIG_I2C=y
+CONFIG_I2C_CHARDEV=y
 CONFIG_I2C_MUX=y
 CONFIG_I2C_ARB_GPIO_CHALLENGE=y
 CONFIG_I2C_EXYNOS5=y
+CONFIG_I2C_GPIO=y
 CONFIG_I2C_CROS_EC_TUNNEL=y
 CONFIG_SPI=y
 CONFIG_SPI_S3C64XX=y
 CONFIG_I2C_S3C2410=y
 CONFIG_DEBUG_GPIO=y
 CONFIG_POWER_SUPPLY=y
+CONFIG_BATTERY_SBS=y
 CONFIG_CHARGER_TPS65090=y
 # CONFIG_HWMON is not set
 CONFIG_THERMAL=y
@@ -88,6 +94,7 @@ CONFIG_MFD_CROS_EC=y
 CONFIG_MFD_CROS_EC_I2C=y
 CONFIG_MFD_CROS_EC_SPI=y
 CONFIG_MFD_MAX77686=y
+CONFIG_MFD_MAX77693=y
 CONFIG_MFD_MAX8997=y
 CONFIG_MFD_SEC_CORE=y
 CONFIG_MFD_TPS65090=y
@@ -96,6 +103,8 @@ CONFIG_REGULATOR_FIXED_VOLTAGE=y
 CONFIG_REGULATOR_GPIO=y
 CONFIG_REGULATOR_MAX8997=y
 CONFIG_REGULATOR_MAX77686=y
+CONFIG_REGULATOR_MAX77802=y
+CONFIG_REGULATOR_MAX77693=y
 CONFIG_REGULATOR_S2MPA01=y
 CONFIG_REGULATOR_S2MPS11=y
 CONFIG_REGULATOR_S5M8767=y
@@ -115,6 +124,7 @@ CONFIG_SND_SOC=y
 CONFIG_SND_SOC_SAMSUNG=y
 CONFIG_SND_SOC_SNOW=y
 CONFIG_USB=y
+CONFIG_USB_ANNOUNCE_NEW_DEVICES=y
 CONFIG_USB_XHCI_HCD=y
 CONFIG_USB_EHCI_HCD=y
 CONFIG_USB_EHCI_EXYNOS=y
diff --git a/arch/arm/configs/omap2plus_defconfig b/arch/arm/configs/omap2plus_defconfig
index 69c7bed3c634..16e719c268dd 100644
--- a/arch/arm/configs/omap2plus_defconfig
+++ b/arch/arm/configs/omap2plus_defconfig
@@ -51,6 +51,7 @@ CONFIG_SOC_AM43XX=y
 CONFIG_SOC_DRA7XX=y
 CONFIG_ARM_THUMBEE=y
 CONFIG_ARM_ERRATA_411920=y
+CONFIG_ARM_ERRATA_430973=y
 CONFIG_SMP=y
 CONFIG_NR_CPUS=2
 CONFIG_CMA=y
diff --git a/arch/arm/configs/sunxi_defconfig b/arch/arm/configs/sunxi_defconfig
index c1a4ca4f6e6d..847045313101 100644
--- a/arch/arm/configs/sunxi_defconfig
+++ b/arch/arm/configs/sunxi_defconfig
@@ -75,6 +75,7 @@ CONFIG_POWER_RESET_SUN6I=y
 CONFIG_WATCHDOG=y
 CONFIG_SUNXI_WATCHDOG=y
 CONFIG_MFD_AXP20X=y
+CONFIG_REGULATOR=y
 CONFIG_REGULATOR_GPIO=y
 CONFIG_USB=y
 CONFIG_USB_EHCI_HCD=y
diff --git a/arch/arm/mach-exynos/exynos.c b/arch/arm/mach-exynos/exynos.c
index b89e5f35db84..6b283eb3202e 100644
--- a/arch/arm/mach-exynos/exynos.c
+++ b/arch/arm/mach-exynos/exynos.c
@@ -161,7 +161,9 @@ static void exynos_restart(enum reboot_mode mode, const char *cmd)
 
 static struct platform_device exynos_cpuidle = {
 	.name              = "exynos_cpuidle",
+#ifdef CONFIG_ARM_EXYNOS_CPUIDLE
 	.dev.platform_data = exynos_enter_aftr,
+#endif
 	.id                = -1,
 };
 
diff --git a/arch/arm/mm/proc-macros.S b/arch/arm/mm/proc-macros.S
index ee1d80593958..ba1196c968d8 100644
--- a/arch/arm/mm/proc-macros.S
+++ b/arch/arm/mm/proc-macros.S
@@ -279,7 +279,7 @@ ENTRY(\name\()_processor_functions)
 
 	.if \suspend
 	.word	cpu_\name\()_suspend_size
-#ifdef CONFIG_PM_SLEEP
+#ifdef CONFIG_ARM_CPU_SUSPEND
 	.word	cpu_\name\()_do_suspend
 	.word	cpu_\name\()_do_resume
 #else
diff --git a/arch/arm/plat-samsung/Kconfig b/arch/arm/plat-samsung/Kconfig
index c87aefbf3a13..9bd2776e7d05 100644
--- a/arch/arm/plat-samsung/Kconfig
+++ b/arch/arm/plat-samsung/Kconfig
@@ -268,8 +268,9 @@ config S5P_DEV_MFC
 comment "Power management"
 
 config SAMSUNG_PM_DEBUG
-	bool "S3C2410 PM Suspend debug"
-	depends on PM && DEBUG_KERNEL && DEBUG_S3C_UART
+	bool "Samsung PM Suspend debug"
+	depends on PM && DEBUG_KERNEL
+	depends on DEBUG_EXYNOS_UART || DEBUG_S3C24XX_UART || DEBUG_S3C2410_UART
 	help
 	  Say Y here if you want verbose debugging from the PM Suspend and
 	  Resume code. See <file:Documentation/arm/Samsung-S3C24XX/Suspend.txt>
diff --git a/arch/arm/plat-samsung/pm-debug.c b/arch/arm/plat-samsung/pm-debug.c
index 8f19f66388dd..39609601f407 100644
--- a/arch/arm/plat-samsung/pm-debug.c
+++ b/arch/arm/plat-samsung/pm-debug.c
@@ -14,6 +14,7 @@
  */
 
 #include <linux/serial_core.h>
+#include <linux/serial_s3c.h>
 #include <linux/io.h>
 
 #include <asm/mach/map.h>
