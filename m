Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753697AbaFBJon (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 05:44:43 -0400
Received: from mout.perfora.net ([74.208.4.194]:50082 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752843AbaFBJol (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 05:44:41 -0400
From: Marcel Ziswiler <marcel@ziswiler.com>
To: swarren@wwwdotorg.org, thierry.reding@gmail.com
Cc: arm@kernel.org, linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, stefan@agner.ch, marcel@ziswiler.com
Subject: [PATCH 1/3] arm: multi_v7: enable igb, stmpe, spidev, lm95245, pwm leds
Date: Mon,  2 Jun 2014 11:43:50 +0200
Message-Id: <cc612cd3f24f01cfc8fd3e81b1027ff94862e8b4.1401700579.git.marcel@ziswiler.com>
X-Mailer: git-send-email 1.7.9.5
X-Provags-ID: V02:K0:pQT8e2eUIdIRSUZzjtdxnf8rU8HogvgcSmMIuKDyTCk
 AqoUlF8iydpVmB0myLLIPIv1C6lvuCaxCoeRQN9Fy3X2IePrwa
 zxzQPNylRPVCJiVXNx2fTxrCqq614Lbgvuen3YX+8oS8RBGy9l
 Kksy7ngB3f/1DeVcHrmJPMT+xL7RA/di0Bk7AUR30TG3V0ksds
 G+PUYLQDgugEeB7e7AtmZk2CIPnNuAmn2b2+I2FmM94F6UBa/u
 bc2r9O5Zh8xeh2Dmh+gzoezfNHzOUlDMzu7FBNJihhJ9HPjsj/
 HkYVDcElxGJQLsuBfUPsOOfjNewqo0uyYQ7CeI5kx21owCmXdc
 Y9ra161X47eK4EEHisQPRw9M1p5FUTh8jHPgcPg/nKOWzDLKH4
 7NoJdPCNxc6PGjX18Cz/Ufimr7xbFfhahiLtdoNz4a0jyt8tfE
 0U2ZMgbv7yay40Srmlw+njqEGGA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The NVIDIA Tegra 3 based Apalis T30 module contains an Intel i210 resp.
i211 gigabit Ethernet controller, an STMPE811 ADC/touch controller,
SPI bus and PWM LEDs generically accessible from user space and an
LM95245 temperature sensor chip. The later four can also be found on
the Colibri T30 module.

While at it move the NEON entry down to its proper place to have it all
nicely ordered again.

Signed-off-by: Marcel Ziswiler <marcel@ziswiler.com>
---
BTW: How about TEGRA_EMC_SCALING_ENABLE, MACH_UX500_DT, OMAP_USB3 and
MMC_SUNXI which I haven't found any mentioning anywhere, MTD_M25P80
which depends on MTD_SPI_NOR or DOVE_THERMAL which depends on the
legacy ARCH_DOVE (besides USE_OF of course) being not much of multi
compatible?

 arch/arm/configs/multi_v7_defconfig |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/arm/configs/multi_v7_defconfig b/arch/arm/configs/multi_v7_defconfig
index 7f4645c..7cfc176 100644
--- a/arch/arm/configs/multi_v7_defconfig
+++ b/arch/arm/configs/multi_v7_defconfig
@@ -65,7 +65,6 @@ CONFIG_ARCH_VEXPRESS=y
 CONFIG_ARCH_VEXPRESS_CA9X4=y
 CONFIG_ARCH_WM8850=y
 CONFIG_ARCH_ZYNQ=y
-CONFIG_NEON=y
 CONFIG_TRUSTED_FOUNDATIONS=y
 CONFIG_PCI=y
 CONFIG_PCI_MSI=y
@@ -81,6 +80,7 @@ CONFIG_CPU_FREQ=y
 CONFIG_CPU_FREQ_STAT_DETAILS=y
 CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
 CONFIG_CPU_IDLE=y
+CONFIG_NEON=y
 CONFIG_NET=y
 CONFIG_PACKET=y
 CONFIG_UNIX=y
@@ -132,6 +132,7 @@ CONFIG_NETDEVICES=y
 CONFIG_SUN4I_EMAC=y
 CONFIG_MACB=y
 CONFIG_NET_CALXEDA_XGMAC=y
+CONFIG_IGB=y
 CONFIG_MV643XX_ETH=y
 CONFIG_MVNETA=y
 CONFIG_KS8851=y
@@ -155,6 +156,8 @@ CONFIG_KEYBOARD_TEGRA=y
 CONFIG_KEYBOARD_SPEAR=y
 CONFIG_KEYBOARD_CROS_EC=y
 CONFIG_MOUSE_PS2_ELANTECH=y
+CONFIG_INPUT_TOUCHSCREEN=y
+CONFIG_TOUCHSCREEN_STMPE=y
 CONFIG_INPUT_MISC=y
 CONFIG_INPUT_MPU3050=y
 CONFIG_SERIO_AMBAKMI=y
@@ -200,6 +203,7 @@ CONFIG_SPI_SUN6I=y
 CONFIG_SPI_TEGRA114=y
 CONFIG_SPI_TEGRA20_SFLASH=y
 CONFIG_SPI_TEGRA20_SLINK=y
+CONFIG_SPI_SPIDEV=y
 CONFIG_PINCTRL_AS3722=y
 CONFIG_PINCTRL_PALMAS=y
 CONFIG_GPIO_SYSFS=y
@@ -217,6 +221,7 @@ CONFIG_POWER_RESET_AS3722=y
 CONFIG_POWER_RESET_GPIO=y
 CONFIG_POWER_RESET_SUN6I=y
 CONFIG_SENSORS_LM90=y
+CONFIG_SENSORS_LM95245=y
 CONFIG_THERMAL=y
 CONFIG_DOVE_THERMAL=y
 CONFIG_ARMADA_THERMAL=y
@@ -227,6 +232,7 @@ CONFIG_MFD_AS3722=y
 CONFIG_MFD_CROS_EC=y
 CONFIG_MFD_CROS_EC_SPI=y
 CONFIG_MFD_MAX8907=y
+CONFIG_MFD_STMPE=y
 CONFIG_MFD_PALMAS=y
 CONFIG_MFD_TPS65090=y
 CONFIG_MFD_TPS6586X=y
@@ -303,6 +309,9 @@ CONFIG_MMC_OMAP=y
 CONFIG_MMC_OMAP_HS=y
 CONFIG_MMC_MVSDIO=y
 CONFIG_MMC_SUNXI=y
+CONFIG_NEW_LEDS=y
+CONFIG_LEDS_CLASS=y
+CONFIG_LEDS_PWM=y
 CONFIG_EDAC=y
 CONFIG_EDAC_MM_EDAC=y
 CONFIG_EDAC_HIGHBANK_MC=y
-- 
1.7.9.5

