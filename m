Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753158AbaFAXiy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 19:38:54 -0400
Received: from mout.perfora.net ([74.208.4.194]:50854 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752472AbaFAXiw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 19:38:52 -0400
From: Marcel Ziswiler <marcel@ziswiler.com>
To: swarren@wwwdotorg.org, thierry.reding@gmail.com
Cc: linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, stefan@agner.ch, marcel@ziswiler.com
Subject: [PATCH 2/3] arm: tegra: enable igb, stmpe, i2c chardev, spidev, lm95245, pwm leds
Date: Mon,  2 Jun 2014 01:37:17 +0200
Message-Id: <39a8704a4c8170d6b0620a1e5e44042eae6d8810.1401665237.git.marcel@ziswiler.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <c5522b0efcbfc7690dcde6aaf78b9dd568f99604.1401665237.git.marcel@ziswiler.com>
References: <c5522b0efcbfc7690dcde6aaf78b9dd568f99604.1401665237.git.marcel@ziswiler.com>
X-Provags-ID: V02:K0:8pZD2LOfB3cECZRowxyALN9Va1Yzttsjyhc/n16eTPm
 7mPqhfdX7kFAYhB005tIS3Po/SQ9bkE0r0blhwJ+veKyNoeFgV
 5kLfqGRvT0SSH6tJEjpTCiRrq2lIGIEctHJEv2aR9MNzZG3f2j
 tq9HVoseDTqGUcg9UNKmXBX1xjhdIIlV1vNFCpox1msgnsr0jc
 YFw/N3QE9UDAL6jUfUsSZqfGRojM/mjxfp3psCLjqXYYCvopI7
 NuJ2B2UuX0J2JycfG80XeMUSAplXWMr00nk6tHZky3zdqJHnkx
 T8SWiCd7mp1oErlZmMsxKeXyVkmC2zwWos9cuzkYdwo1wTsiWg
 UKsaIZZ4KV7xBOA9WY44auJZvOrXXoq6JFXTwletVVCHeWWn8n
 2xrbX2Vb1uzD4bd5sgdJtcFAE8xz2dtxGUrAGjiHyfeAD+HZ5Y
 N7a3sfeM2M9l2jKk+K2ymcjy2gw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The NVIDIA Tegra 3 based Apalis T30 module contains an Intel i210 resp.
i211 gigabit Ethernet controller, an STMPE811 ADC/touch controller, I2C
as well as SPI buses and PWM LEDs generically accessible from user
space and an LM95245 temperature sensor chip. The later five can also
be found on the Colibri T30 module.

While at it move the PCA953x GPIO entry down to its proper place to
have it all nicely ordered again.

Signed-off-by: Marcel Ziswiler <marcel@ziswiler.com>
---
BTW: How about MTD_SPI_NOR, PROC_DEVICETREE and CRYPTO_DEV_TEGRA_AES
which I haven't found any mentioning anywhere?

 arch/arm/configs/tegra_defconfig |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/arm/configs/tegra_defconfig b/arch/arm/configs/tegra_defconfig
index fb25e29..4ed82f9 100644
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
@@ -142,8 +145,10 @@ CONFIG_SPI=y
 CONFIG_SPI_TEGRA114=y
 CONFIG_SPI_TEGRA20_SFLASH=y
 CONFIG_SPI_TEGRA20_SLINK=y
+CONFIG_SPI_SPIDEV=y
 CONFIG_PINCTRL_AS3722=y
 CONFIG_PINCTRL_PALMAS=y
+CONFIG_GPIO_PCA953X=y
 CONFIG_GPIO_PCA953X_IRQ=y
 CONFIG_GPIO_PALMAS=y
 CONFIG_GPIO_TPS6586X=y
@@ -155,10 +160,12 @@ CONFIG_POWER_RESET=y
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
@@ -221,6 +228,7 @@ CONFIG_MMC_SDHCI_TEGRA=y
 CONFIG_NEW_LEDS=y
 CONFIG_LEDS_CLASS=y
 CONFIG_LEDS_GPIO=y
+CONFIG_LEDS_PWM=y
 CONFIG_LEDS_TRIGGERS=y
 CONFIG_LEDS_TRIGGER_TIMER=y
 CONFIG_LEDS_TRIGGER_ONESHOT=y
-- 
1.7.9.5

