Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934420AbaFIWxw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 18:53:52 -0400
Received: from mout.perfora.net ([74.208.4.195]:51505 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932275AbaFIWxu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 18:53:50 -0400
From: Marcel Ziswiler <marcel@ziswiler.com>
To: swarren@wwwdotorg.org, thierry.reding@gmail.com
Cc: linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, stefan@agner.ch,
        Marcel Ziswiler <marcel@ziswiler.com>
Subject: [PATCH v2 2/3] arm: tegra: enable igb, stmpe, i2c chardev, lm95245, pwm leds
Date: Tue, 10 Jun 2014 00:52:45 +0200
Message-Id: <dadd07f9ed693d6bcf541764b62a2caf4cc38630.1402353627.git.marcel@ziswiler.com>
X-Mailer: git-send-email 1.7.9.5
X-Provags-ID: V02:K0:Kx/UqcKbj7uLVqtP+BvhD/POXF2kWEM1jr9fugNGCYs
 R5tiVCnz/eJ3hb94ejOMV1pywfOneagG6iMbqjAqzqEMvhdUMj
 hhsbjC9ubAwrIDfD7CRYo2hFqvBPFX/rRHykGGUMXFu7P13AyX
 Llv292pr84VjLoXDIxYL0QdCttVUcnA1iz2EvtnmiT+WwNWsNP
 p4GAftswaHzI6ig9O4iDFDhg++vi4EjKH38LwDX301eQeGEeqJ
 OqE6O4gkTDe0d1rVFD5BeOnCwrXh+6VCPQ6NEO4vQeUJxrsegV
 eks38mb1XRW6ptcIdcMW6Kyn7NXEcyc4bZQxMxEBJsSDboYGNC
 jqL43y6MHqbOuwfpfUzr08Ivtq876tY94ycYNnwEr/idHziN2I
 yCzTCkm7mo4IgHNOy+VFRXA0Cg9Tjf7CjN6lv122hfyx8Z1tW+
 J+TZ5JywoeZ044M4XDq9WqALxQg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The NVIDIA Tegra 3 based Apalis T30 module contains an Intel i210 resp.
i211 gigabit Ethernet controller, an STMPE811 ADC/touch controller, I2C
buses and PWM LEDs generically accessible from user space and an
LM95245 temperature sensor chip. The later four can also be found on
the Colibri T30 module.

While at it move the PCA953x GPIO entry down to its proper place to
have it all nicely ordered again.

Signed-off-by: Marcel Ziswiler <marcel@ziswiler.com>
---
Changes since v1:
- Forget about spidev for now.

 arch/arm/configs/tegra_defconfig |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/arm/configs/tegra_defconfig b/arch/arm/configs/tegra_defconfig
index fb25e29..d05eec8 100644
--- a/arch/arm/configs/tegra_defconfig
+++ b/arch/arm/configs/tegra_defconfig
@@ -23,7 +23,6 @@ CONFIG_MODULE_FORCE_UNLOAD=y
 CONFIG_PARTITION_ADVANCED=y
 # CONFIG_IOSCHED_DEADLINE is not set
 # CONFIG_IOSCHED_CFQ is not set
-CONFIG_GPIO_PCA953X=y
 CONFIG_ARCH_TEGRA=y
 CONFIG_ARCH_TEGRA_2x_SOC=y
 CONFIG_ARCH_TEGRA_3x_SOC=y
@@ -111,6 +110,7 @@ CONFIG_SCSI_MULTI_LUN=y
 # CONFIG_SCSI_LOWLEVEL is not set
 CONFIG_NETDEVICES=y
 CONFIG_DUMMY=y
+CONFIG_IGB=y
 CONFIG_R8169=y
 CONFIG_USB_PEGASUS=y
 CONFIG_USB_USBNET=y
@@ -125,6 +125,8 @@ CONFIG_KEYBOARD_GPIO=y
 CONFIG_KEYBOARD_TEGRA=y
 CONFIG_KEYBOARD_CROS_EC=y
 CONFIG_MOUSE_PS2_ELANTECH=y
+CONFIG_INPUT_TOUCHSCREEN=y
+CONFIG_TOUCHSCREEN_STMPE=y
 CONFIG_INPUT_MISC=y
 CONFIG_INPUT_MPU3050=y
 # CONFIG_LEGACY_PTYS is not set
@@ -135,6 +137,7 @@ CONFIG_SERIAL_TEGRA=y
 CONFIG_SERIAL_OF_PLATFORM=y
 # CONFIG_HW_RANDOM is not set
 # CONFIG_I2C_COMPAT is not set
+CONFIG_I2C_CHARDEV=y
 CONFIG_I2C_MUX_PCA954x=y
 CONFIG_I2C_MUX_PINCTRL=y
 CONFIG_I2C_TEGRA=y
@@ -144,6 +147,7 @@ CONFIG_SPI_TEGRA20_SFLASH=y
 CONFIG_SPI_TEGRA20_SLINK=y
 CONFIG_PINCTRL_AS3722=y
 CONFIG_PINCTRL_PALMAS=y
+CONFIG_GPIO_PCA953X=y
 CONFIG_GPIO_PCA953X_IRQ=y
 CONFIG_GPIO_PALMAS=y
 CONFIG_GPIO_TPS6586X=y
@@ -155,10 +159,12 @@ CONFIG_POWER_RESET=y
 CONFIG_POWER_RESET_AS3722=y
 CONFIG_POWER_RESET_GPIO=y
 CONFIG_SENSORS_LM90=y
+CONFIG_SENSORS_LM95245=y
 CONFIG_MFD_AS3722=y
 CONFIG_MFD_CROS_EC=y
 CONFIG_MFD_CROS_EC_SPI=y
 CONFIG_MFD_MAX8907=y
+CONFIG_MFD_STMPE=y
 CONFIG_MFD_PALMAS=y
 CONFIG_MFD_TPS65090=y
 CONFIG_MFD_TPS6586X=y
@@ -221,6 +227,7 @@ CONFIG_MMC_SDHCI_TEGRA=y
 CONFIG_NEW_LEDS=y
 CONFIG_LEDS_CLASS=y
 CONFIG_LEDS_GPIO=y
+CONFIG_LEDS_PWM=y
 CONFIG_LEDS_TRIGGERS=y
 CONFIG_LEDS_TRIGGER_TIMER=y
 CONFIG_LEDS_TRIGGER_ONESHOT=y
-- 
1.7.9.5

