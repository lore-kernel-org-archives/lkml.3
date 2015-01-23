Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755583AbbAWOXJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 09:23:09 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:59740 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755565AbbAWOXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 09:23:05 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-ae-54c258b50fb3
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Russell King <linux@arm.linux.org.uk>, Kukjin Kim <kgene@kernel.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH] ARM: exynos_defconfig: Enable PMIC and MUIC drivers for Gears
 and Trats2
Date: Fri, 23 Jan 2015 15:22:46 +0100
Message-id: <1422022966-15897-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPJMWRmVeSWpSXmKPExsVy+t/xa7pbIw6FGJx/Zm6xccZ6Voujvwss
	Xr8wtOh//JrZ4mzTG3aLTY+vsVpc3jWHzWLG+X1MFrcv81qsPXKX3YHLo6W5h83j7/PrLB6b
	VnWyeWxeUu/Rt2UVo8fnTXIBbFFcNimpOZllqUX6dglcGV+/v2Yr2MJb0bz5OEsD42XuLkZO
	DgkBE4nbUy6yQdhiEhfurQeyuTiEBJYySjzpPcoK4fQxSby8+JIZpIpNwFhi8/IlYB0iAh8Z
	JTa9sAEpYhY4yihxY9ZdJpCEsEC0xOP3J1lBbBYBVYmJ9zazgNi8Au4Sh97OhlonJ3Hy2GTW
	CYzcCxgZVjGKppYmFxQnpeca6hUn5haX5qXrJefnbmKEBNKXHYyLj1kdYhTgYFTi4d3x9GCI
	EGtiWXFl7iFGCQ5mJRFea81DIUK8KYmVValF+fFFpTmpxYcYmTg4pRoYdfb5Bt7kesogPLFS
	LVo2eXum69NPSaw9Weucj2pPKevS7Rd39tj4ZUus8I8b3uVnC3PzM2bb55nwsacyrvVWfmOu
	sfvZXceVKS//th61nWwsZyLyiOusPVfIw9yOY7oidrNDKx6FP7mb42bw5Gs6I/Mi87RXsmUv
	uS9mr7imIv/f10Vuw0UlluKMREMt5qLiRABLJvqwAgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable drivers for PMICs and MUICs present on Exynos-based devices:
 - max14577: charger, extcon, fuel gauge (max17040), regulator,
   used on: Gear 1, Gear 2,
 - max77693: charger, extcon, fuel gauge (max17042),
   used on: Trats2,

This allows full usage of charging stack on these devices along with
extcon connector.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 arch/arm/configs/exynos_defconfig | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm/configs/exynos_defconfig b/arch/arm/configs/exynos_defconfig
index 3d0c5d65c741..01758378a1b1 100644
--- a/arch/arm/configs/exynos_defconfig
+++ b/arch/arm/configs/exynos_defconfig
@@ -83,6 +83,10 @@ CONFIG_I2C_S3C2410=y
 CONFIG_DEBUG_GPIO=y
 CONFIG_POWER_SUPPLY=y
 CONFIG_BATTERY_SBS=y
+CONFIG_BATTERY_MAX17040=y
+CONFIG_BATTERY_MAX17042=y
+CONFIG_CHARGER_MAX14577=y
+CONFIG_CHARGER_MAX77693=y
 CONFIG_CHARGER_TPS65090=y
 CONFIG_HWMON=y
 CONFIG_SENSORS_LM90=y
@@ -94,6 +98,7 @@ CONFIG_S3C2410_WATCHDOG=y
 CONFIG_MFD_CROS_EC=y
 CONFIG_MFD_CROS_EC_I2C=y
 CONFIG_MFD_CROS_EC_SPI=y
+CONFIG_MFD_MAX14577=y
 CONFIG_MFD_MAX77686=y
 CONFIG_MFD_MAX77693=y
 CONFIG_MFD_MAX8997=y
@@ -102,6 +107,7 @@ CONFIG_MFD_TPS65090=y
 CONFIG_REGULATOR=y
 CONFIG_REGULATOR_FIXED_VOLTAGE=y
 CONFIG_REGULATOR_GPIO=y
+CONFIG_REGULATOR_MAX14577=y
 CONFIG_REGULATOR_MAX8997=y
 CONFIG_REGULATOR_MAX77686=y
 CONFIG_REGULATOR_MAX77802=y
@@ -168,6 +174,9 @@ CONFIG_COMMON_CLK_MAX77686=y
 CONFIG_COMMON_CLK_MAX77802=y
 CONFIG_COMMON_CLK_S2MPS11=y
 CONFIG_EXYNOS_IOMMU=y
+CONFIG_EXTCON=y
+CONFIG_EXTCON_MAX14577=y
+CONFIG_EXTCON_MAX77693=y
 CONFIG_IIO=y
 CONFIG_EXYNOS_ADC=y
 CONFIG_PWM=y
-- 
1.9.1

