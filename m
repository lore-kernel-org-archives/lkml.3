Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932112AbbAWOYk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 09:24:40 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:59819 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932070AbbAWOYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 09:24:36 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-19-54c259110d39
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH] ARM: multi_v7_defconfig: Enable PMIC and MUIC drivers for
 Exynos boards
Date: Fri, 23 Jan 2015 15:24:24 +0100
Message-id: <1422023064-15990-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFJMWRmVeSWpSXmKPExsVy+t/xy7qCkYdCDHbcELb4O+kYu8XGGetZ
	LY7+LrB4/cLQ4mzTG3aLTY+vsVpc3jWHzWLG+X1MFrcv81qsPXKX3eLU9c9sDtweLc09bB6/
	f01i9Pj7/DqLx+Yl9R5XTjSxevRtWcXo8XmTXAB7FJdNSmpOZllqkb5dAlfG4d+HWQv2iVac
	+NXF1MB4SaiLkZNDQsBEYlfDNUYIW0ziwr31bF2MXBxCAksZJbZvv8MM4fQxSdw/voEFpIpN
	wFhi8/IlYFUiApOYJN5uOsUO4jALHGWUeNu7lgmkSlggSqLn4BewuSwCqhLnvvUzg9i8Au4S
	i5c1s0Hsk5M4eWwy6wRG7gWMDKsYRVNLkwuKk9JzDfWKE3OLS/PS9ZLzczcxQsLryw7Gxces
	DjEKcDAq8fDueHowRIg1say4MvcQowQHs5IIr7XmoRAh3pTEyqrUovz4otKc1OJDjEwcnFIN
	jPERM8odeZ8rKoUEv3ujZ7+tJLidqdqwJlN9idXRr/2ZVhfkmzXCFhz5kHjOTutc4CIRpUYP
	nXSrWOsKwz/e/fLTvI1WOK+6eOSD8flIMROrgh+v5nKq3v8qqctlP3nuGf+X8pnLpQRCl/hY
	BYU1xBw7uuhxQMRTvpUcc0OPObmoib6ZYSCkxFKckWioxVxUnAgALx1YKw0CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable drivers for PMICs and MUICs present on Exynos-based devices:
 - max14577: charger, extcon, fuel gauge (max17040), regulator,
   used on: Gear 1, Gear 2,
 - max77693: charger, extcon, fuel gauge (max17042),
   used on: Trats2,
 - s5m8767 and s2mps11: RTC, clock,
   used on: Arndale, Arndale Octa, Gear 1, Gear 2

This allows full usage of charging stack on these devices along with
extcon connector, RTC and 32 kHz clocks.

The I2C_GPIO is necessary for max77693 on Trats2 because the device is
wired to Exynos System-on-Chip over GPIO.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 arch/arm/configs/multi_v7_defconfig | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/arm/configs/multi_v7_defconfig b/arch/arm/configs/multi_v7_defconfig
index adb362bdedd6..5eb69aa59165 100644
--- a/arch/arm/configs/multi_v7_defconfig
+++ b/arch/arm/configs/multi_v7_defconfig
@@ -233,6 +233,7 @@ CONFIG_I2C_MUX_PINCTRL=y
 CONFIG_I2C_CADENCE=y
 CONFIG_I2C_DESIGNWARE_PLATFORM=y
 CONFIG_I2C_EXYNOS5=y
+CONFIG_I2C_GPIO=y
 CONFIG_I2C_MV64XXX=y
 CONFIG_I2C_S3C2410=y
 CONFIG_I2C_SIRF=y
@@ -270,7 +271,11 @@ CONFIG_GPIO_SYSCON=y
 CONFIG_GPIO_TPS6586X=y
 CONFIG_GPIO_TPS65910=y
 CONFIG_BATTERY_SBS=y
+CONFIG_BATTERY_MAX17040=y
+CONFIG_BATTERY_MAX17042=y
+CONFIG_CHARGER_MAX14577=y
 CONFIG_CHARGER_TPS65090=y
+CONFIG_CHARGER_MAX77693=y
 CONFIG_POWER_RESET_AS3722=y
 CONFIG_POWER_RESET_GPIO=y
 CONFIG_POWER_RESET_KEYSTONE=y
@@ -294,8 +299,10 @@ CONFIG_MFD_BCM590XX=y
 CONFIG_MFD_AXP20X=y
 CONFIG_MFD_CROS_EC=y
 CONFIG_MFD_CROS_EC_SPI=y
+CONFIG_MFD_MAX14577=y
 CONFIG_MFD_MAX77686=y
 CONFIG_MFD_MAX8907=y
+CONFIG_MFD_MAX77693=y
 CONFIG_MFD_SEC_CORE=y
 CONFIG_MFD_STMPE=y
 CONFIG_MFD_PALMAS=y
@@ -309,8 +316,10 @@ CONFIG_REGULATOR_BCM590XX=y
 CONFIG_REGULATOR_GPIO=y
 CONFIG_MFD_SYSCON=y
 CONFIG_POWER_RESET_SYSCON=y
+CONFIG_REGULATOR_MAX14577=y
 CONFIG_REGULATOR_MAX8907=y
 CONFIG_REGULATOR_MAX77686=y
+CONFIG_REGULATOR_MAX77693=y
 CONFIG_REGULATOR_PALMAS=y
 CONFIG_REGULATOR_S2MPS11=y
 CONFIG_REGULATOR_S5M8767=y
@@ -431,6 +440,7 @@ CONFIG_RTC_DRV_SUN6I=y
 CONFIG_RTC_DRV_SUNXI=y
 CONFIG_RTC_DRV_MV=y
 CONFIG_RTC_DRV_TEGRA=y
+CONFIG_RTC_DRV_S5M=y
 CONFIG_DMADEVICES=y
 CONFIG_DW_DMAC=y
 CONFIG_MV_XOR=y
@@ -455,12 +465,16 @@ CONFIG_NVEC_PAZ00=y
 CONFIG_QCOM_GSBI=y
 CONFIG_COMMON_CLK_QCOM=y
 CONFIG_COMMON_CLK_MAX77686=y
+CONFIG_COMMON_CLK_S2MPS11=y
 CONFIG_APQ_MMCC_8084=y
 CONFIG_MSM_GCC_8660=y
 CONFIG_MSM_MMCC_8960=y
 CONFIG_MSM_MMCC_8974=y
 CONFIG_TEGRA_IOMMU_GART=y
 CONFIG_TEGRA_IOMMU_SMMU=y
+CONFIG_EXTCON=y
+CONFIG_EXTCON_MAX14577=y
+CONFIG_EXTCON_MAX77693=y
 CONFIG_MEMORY=y
 CONFIG_TI_AEMIF=y
 CONFIG_IIO=y
-- 
1.9.1

