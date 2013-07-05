Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757460Ab3GETrh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 15:47:37 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:49423 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752162Ab3GETrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 15:47:36 -0400
From: Mark Brown <broonie@kernel.org>
To: Liam Girdwood <lgirdwood@gmail.com>
Cc: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        Mark Brown <broonie@linaro.org>, Mark Brown <broonie@kernel.org>
Date: Fri,  5 Jul 2013 20:47:08 +0100
Message-Id: <1373053628-19831-1-git-send-email-broonie@kernel.org>
X-Mailer: git-send-email 1.8.3.2
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH] regulator: build: Sort Kconfig
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@linaro.org>

Reduces merge issues if nothing else.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 drivers/regulator/Kconfig  | 244 ++++++++++++++++++++++-----------------------
 drivers/regulator/Makefile |   2 +-
 2 files changed, 123 insertions(+), 123 deletions(-)

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index f1e6ad9..759b601 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -64,15 +64,11 @@ config REGULATOR_USERSPACE_CONSUMER
 
 	  If unsure, say no.
 
-config REGULATOR_GPIO
-	tristate "GPIO regulator support"
-	depends on GPIOLIB
+config REGULATOR_88PM8607
+	bool "Marvell 88PM8607 Power regulators"
+	depends on MFD_88PM860X=y
 	help
-	  This driver provides support for regulators that can be
-	  controlled via gpios.
-	  It is capable of supporting current and voltage regulators
-	  and the platform has to provide a mapping of GPIO-states
-	  to target volts/amps.
+	  This driver supports 88PM8607 voltage regulator chips.
 
 config REGULATOR_AD5398
 	tristate "Analog Devices AD5398/AD5821 regulators"
@@ -81,6 +77,14 @@ config REGULATOR_AD5398
 	  This driver supports AD5398 and AD5821 current regulator chips.
 	  If building into module, its name is ad5398.ko.
 
+config REGULATOR_ANATOP
+	tristate "Freescale i.MX on-chip ANATOP LDO regulators"
+	depends on MFD_SYSCON
+	help
+	  Say y here to support Freescale i.MX on-chip ANATOP LDOs
+	  regulators. It is recommended that this option be
+	  enabled on i.MX6 platform.
+
 config REGULATOR_AAT2870
 	tristate "AnalogicTech AAT2870 Regulators"
 	depends on MFD_AAT2870_CORE
@@ -88,6 +92,22 @@ config REGULATOR_AAT2870
 	  If you have a AnalogicTech AAT2870 say Y to enable the
 	  regulator driver.
 
+config REGULATOR_AB3100
+	tristate "ST-Ericsson AB3100 Regulator functions"
+	depends on AB3100_CORE
+	default y if AB3100_CORE
+	help
+	 These regulators correspond to functionality in the
+	 AB3100 analog baseband dealing with power regulators
+	 for the system.
+
+config REGULATOR_AB8500
+	bool "ST-Ericsson AB8500 Power Regulators"
+	depends on AB8500_CORE
+	help
+	  This driver supports the regulators found on the ST-Ericsson mixed
+	  signal AB8500 PMIC
+
 config REGULATOR_ARIZONA
 	tristate "Wolfson Arizona class devices"
 	depends on MFD_ARIZONA
@@ -96,6 +116,13 @@ config REGULATOR_ARIZONA
 	  Support for the regulators found on Wolfson Arizona class
 	  devices.
 
+config REGULATOR_AS3711
+	tristate "AS3711 PMIC"
+	depends on MFD_AS3711
+	help
+	  This driver provides support for the voltage regulators on the
+	  AS3711 PMIC
+
 config REGULATOR_DA903X
 	tristate "Dialog Semiconductor DA9030/DA9034 regulators"
 	depends on PMIC_DA903X
@@ -120,6 +147,17 @@ config REGULATOR_DA9055
 	  This driver can also be built as a module. If so, the module
 	  will be called da9055-regulator.
 
+config REGULATOR_DBX500_PRCMU
+	bool
+
+config REGULATOR_DB8500_PRCMU
+	bool "ST-Ericsson DB8500 Voltage Domain Regulators"
+	depends on MFD_DB8500_PRCMU
+	select REGULATOR_DBX500_PRCMU
+	help
+	  This driver supports the voltage domain regulators controlled by the
+	  DB8500 PRCMU
+
 config REGULATOR_FAN53555
 	tristate "Fairchild FAN53555 Regulator"
 	depends on I2C
@@ -131,44 +169,57 @@ config REGULATOR_FAN53555
 	  input voltage supply of 2.5V to 5.5V. The output voltage is
 	  programmed through an I2C interface.
 
-config REGULATOR_ANATOP
-	tristate "Freescale i.MX on-chip ANATOP LDO regulators"
-	depends on MFD_SYSCON
+config REGULATOR_GPIO
+	tristate "GPIO regulator support"
+	depends on GPIOLIB
 	help
-	  Say y here to support Freescale i.MX on-chip ANATOP LDOs
-	  regulators. It is recommended that this option be
-	  enabled on i.MX6 platform.
+	  This driver provides support for regulators that can be
+	  controlled via gpios.
+	  It is capable of supporting current and voltage regulators
+	  and the platform has to provide a mapping of GPIO-states
+	  to target volts/amps.
 
-config REGULATOR_MC13XXX_CORE
-	tristate
+config REGULATOR_ISL6271A
+	tristate "Intersil ISL6271A Power regulator"
+	depends on I2C
+	help
+	  This driver supports ISL6271A voltage regulator chip.
 
-config REGULATOR_MC13783
-	tristate "Freescale MC13783 regulator driver"
-	depends on MFD_MC13783
-	select REGULATOR_MC13XXX_CORE
+config REGULATOR_LP3971
+	tristate "National Semiconductors LP3971 PMIC regulator driver"
+	depends on I2C
 	help
-	  Say y here to support the regulators found on the Freescale MC13783
-	  PMIC.
+	 Say Y here to support the voltage regulators and convertors
+	 on National Semiconductors LP3971 PMIC
 
-config REGULATOR_MC13892
-	tristate "Freescale MC13892 regulator driver"
-	depends on MFD_MC13XXX
-	select REGULATOR_MC13XXX_CORE
+config REGULATOR_LP3972
+	tristate "National Semiconductors LP3972 PMIC regulator driver"
+	depends on I2C
 	help
-	  Say y here to support the regulators found on the Freescale MC13892
-	  PMIC.
+	 Say Y here to support the voltage regulators and convertors
+	 on National Semiconductors LP3972 PMIC
 
-config REGULATOR_ISL6271A
-	tristate "Intersil ISL6271A Power regulator"
+config REGULATOR_LP872X
+	bool "TI/National Semiconductor LP8720/LP8725 voltage regulators"
+	depends on I2C=y
+	select REGMAP_I2C
+	help
+	  This driver supports LP8720/LP8725 PMIC
+
+config REGULATOR_LP8755
+	tristate "TI LP8755 High Performance PMU driver"
 	depends on I2C
+	select REGMAP_I2C
 	help
-	  This driver supports ISL6271A voltage regulator chip.
+	  This driver supports LP8755 High Performance PMU driver. This
+	  chip contains six step-down DC/DC converters which can support
+	  9 mode multiphase configuration.
 
-config REGULATOR_88PM8607
-	bool "Marvell 88PM8607 Power regulators"
-	depends on MFD_88PM860X=y
+config REGULATOR_LP8788
+	bool "TI LP8788 Power Regulators"
+	depends on MFD_LP8788
 	help
-	  This driver supports 88PM8607 voltage regulator chips.
+	  This driver supports LP8788 voltage regulator chip.
 
 config REGULATOR_MAX1586
 	tristate "Maxim 1586/1587 voltage regulator"
@@ -259,48 +310,43 @@ config REGULATOR_MAX77693
 	  and one current regulator 'CHARGER'. This is suitable for
 	  Exynos-4x12 chips.
 
-config REGULATOR_PCAP
-	tristate "Motorola PCAP2 regulator driver"
-	depends on EZX_PCAP
-	help
-	 This driver provides support for the voltage regulators of the
-	 PCAP2 PMIC.
+config REGULATOR_MC13XXX_CORE
+	tristate
 
-config REGULATOR_LP3971
-	tristate "National Semiconductors LP3971 PMIC regulator driver"
-	depends on I2C
+config REGULATOR_MC13783
+	tristate "Freescale MC13783 regulator driver"
+	depends on MFD_MC13783
+	select REGULATOR_MC13XXX_CORE
 	help
-	 Say Y here to support the voltage regulators and convertors
-	 on National Semiconductors LP3971 PMIC
+	  Say y here to support the regulators found on the Freescale MC13783
+	  PMIC.
 
-config REGULATOR_LP3972
-	tristate "National Semiconductors LP3972 PMIC regulator driver"
-	depends on I2C
+config REGULATOR_MC13892
+	tristate "Freescale MC13892 regulator driver"
+	depends on MFD_MC13XXX
+	select REGULATOR_MC13XXX_CORE
 	help
-	 Say Y here to support the voltage regulators and convertors
-	 on National Semiconductors LP3972 PMIC
+	  Say y here to support the regulators found on the Freescale MC13892
+	  PMIC.
 
-config REGULATOR_LP872X
-	bool "TI/National Semiconductor LP8720/LP8725 voltage regulators"
-	depends on I2C=y
-	select REGMAP_I2C
+config REGULATOR_PALMAS
+	tristate "TI Palmas PMIC Regulators"
+	depends on MFD_PALMAS
 	help
-	  This driver supports LP8720/LP8725 PMIC
+	  If you wish to control the regulators on the Palmas series of
+	  chips say Y here. This will enable support for all the software
+	  controllable SMPS/LDO regulators.
 
-config REGULATOR_LP8755
-	tristate "TI LP8755 High Performance PMU driver"
-	depends on I2C
-	select REGMAP_I2C
-	help
-	  This driver supports LP8755 High Performance PMU driver. This
-	  chip contains six step-down DC/DC converters which can support
-	  9 mode multiphase configuration.
+	  The regulators available on Palmas series chips vary depending
+	  on the muxing. This is handled automatically in the driver by
+	  reading the mux info from OTP.
 
-config REGULATOR_LP8788
-	bool "TI LP8788 Power Regulators"
-	depends on MFD_LP8788
+config REGULATOR_PCAP
+	tristate "Motorola PCAP2 regulator driver"
+	depends on EZX_PCAP
 	help
-	  This driver supports LP8788 voltage regulator chip.
+	 This driver provides support for the voltage regulators of the
+	 PCAP2 PMIC.
 
 config REGULATOR_PCF50633
 	tristate "NXP PCF50633 regulator driver"
@@ -335,44 +381,15 @@ config REGULATOR_S5M8767
 	 via I2C bus. S5M8767A have 9 Bucks and 28 LDOs output and
 	 supports DVS mode with 8bits of output voltage control.
 
-config REGULATOR_AB3100
-	tristate "ST-Ericsson AB3100 Regulator functions"
-	depends on AB3100_CORE
-	default y if AB3100_CORE
-	help
-	 These regulators correspond to functionality in the
-	 AB3100 analog baseband dealing with power regulators
-	 for the system.
-
-config REGULATOR_AB8500
-	bool "ST-Ericsson AB8500 Power Regulators"
-	depends on AB8500_CORE
-	help
-	  This driver supports the regulators found on the ST-Ericsson mixed
-	  signal AB8500 PMIC
-
-config REGULATOR_DBX500_PRCMU
-	bool
-
-config REGULATOR_DB8500_PRCMU
-	bool "ST-Ericsson DB8500 Voltage Domain Regulators"
-	depends on MFD_DB8500_PRCMU
-	select REGULATOR_DBX500_PRCMU
-	help
-	  This driver supports the voltage domain regulators controlled by the
-	  DB8500 PRCMU
-
-config REGULATOR_PALMAS
-	tristate "TI Palmas PMIC Regulators"
-	depends on MFD_PALMAS
+config REGULATOR_TI_ABB
+	bool "TI Adaptive Body Bias on-chip LDO"
+	depends on ARCH_OMAP
 	help
-	  If you wish to control the regulators on the Palmas series of
-	  chips say Y here. This will enable support for all the software
-	  controllable SMPS/LDO regulators.
-
-	  The regulators available on Palmas series chips vary depending
-	  on the muxing. This is handled automatically in the driver by
-	  reading the mux info from OTP.
+	  Select this option to support Texas Instruments' on-chip Adaptive Body
+	  Bias (ABB) LDO regulators. It is recommended that this option be
+	  enabled on required TI SoC. Certain Operating Performance Points
+	  on TI SoCs may be unstable without enabling this as it provides
+	  device specific optimized bias to allow/optimize functionality.
 
 config REGULATOR_TPS51632
 	tristate "TI TPS51632 Power Regulator"
@@ -481,16 +498,6 @@ config REGULATOR_TWL4030
 	  This driver supports the voltage regulators provided by
 	  this family of companion chips.
 
-config REGULATOR_TI_ABB
-	bool "TI Adaptive Body Bias on-chip LDO"
-	depends on ARCH_OMAP
-	help
-	  Select this option to support Texas Instruments' on-chip Adaptive Body
-	  Bias (ABB) LDO regulators. It is recommended that this option be
-	  enabled on required TI SoC. Certain Operating Performance Points
-	  on TI SoCs may be unstable without enabling this as it provides
-	  device specific optimized bias to allow/optimize functionality.
-
 config REGULATOR_VEXPRESS
 	tristate "Versatile Express regulators"
 	depends on VEXPRESS_CONFIG
@@ -526,12 +533,5 @@ config REGULATOR_WM8994
 	  This driver provides support for the voltage regulators on the
 	  WM8994 CODEC.
 
-config REGULATOR_AS3711
-	tristate "AS3711 PMIC"
-	depends on MFD_AS3711
-	help
-	  This driver provides support for the voltage regulators on the
-	  AS3711 PMIC
-
 endif
 
diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
index ba4a3cf..d240772 100644
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -52,6 +52,7 @@ obj-$(CONFIG_REGULATOR_PCF50633) += pcf50633-regulator.o
 obj-$(CONFIG_REGULATOR_RC5T583)  += rc5t583-regulator.o
 obj-$(CONFIG_REGULATOR_S2MPS11) += s2mps11.o
 obj-$(CONFIG_REGULATOR_S5M8767) += s5m8767.o
+obj-$(CONFIG_REGULATOR_TI_ABB) += ti-abb-regulator.o
 obj-$(CONFIG_REGULATOR_TPS6105X) += tps6105x-regulator.o
 obj-$(CONFIG_REGULATOR_TPS62360) += tps62360-regulator.o
 obj-$(CONFIG_REGULATOR_TPS65023) += tps65023-regulator.o
@@ -64,7 +65,6 @@ obj-$(CONFIG_REGULATOR_TPS65910) += tps65910-regulator.o
 obj-$(CONFIG_REGULATOR_TPS65912) += tps65912-regulator.o
 obj-$(CONFIG_REGULATOR_TPS80031) += tps80031-regulator.o
 obj-$(CONFIG_REGULATOR_TWL4030) += twl-regulator.o
-obj-$(CONFIG_REGULATOR_TI_ABB) += ti-abb-regulator.o
 obj-$(CONFIG_REGULATOR_VEXPRESS) += vexpress.o
 obj-$(CONFIG_REGULATOR_WM831X) += wm831x-dcdc.o
 obj-$(CONFIG_REGULATOR_WM831X) += wm831x-isink.o
-- 
1.8.3.2

