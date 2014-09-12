Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754540AbaILMEN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 08:04:13 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:43546 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754395AbaILMEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 08:04:11 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-41-5412e13705fc
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Russell King <linux@arm.linux.org.uk>, Kukjin Kim <kgene.kim@samsung.com>,
        Sachin Kamat <sachin.kamat@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tushar Behera <tushar.behera@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>
Subject: [PATCH] ARM: exynos_defconfig: Enable Maxim 77693 and I2C GPIO drivers
Date: Fri, 12 Sep 2014 14:03:54 +0200
Message-id: <1410523434-10645-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJJMWRmVeSWpSXmKPExsVy+t/xy7rmD4VCDBreW1tsnLGe1eL1C0OL
	3gVX2SzONr1ht9j0+BqrxeVdc9gsZpzfx2Rx+zKvxdojd9ktrlw6xWaxatcfRov2v3vZHHg8
	Wpp72Dx2zrrL7nHn2h42j81L6j36tqxi9Pi8SS6ALYrLJiU1J7MstUjfLoEro3PnM8aCRp6K
	HVdvsDUwruLqYuTkkBAwkTjeNJsdwhaTuHBvPVsXIxeHkMBSRon37f1MIAkhgT4miX+LXEFs
	NgFjic3Ll4AViQgsZZZYcbsdrJtZIExi5fa9zCC2sIC/xIGXy1lAbBYBVYnpkyeDxXkF3CWm
	3G5mgdgmJ3Hy2GTWCYzcCxgZVjGKppYmFxQnpeca6RUn5haX5qXrJefnbmKEBNfXHYxLj1kd
	YhTgYFTi4f2QKxgixJpYVlyZe4hRgoNZSYR31x2hECHelMTKqtSi/Pii0pzU4kOMTBycUg2M
	8x7ZTnTdWqG6apLKryUadgdOvDZZsfywuej7a/6bmHZ6zZEu/nsz68hxlYJJWqpN/z62qbuu
	mCovvddGTEWgbn7CwS0+i41NPS2Zp+kItfo3LLpwtp3vv8GHHsHde/ZOja54+K7o9pq/si9b
	Xp+96yr6Qcrk/LKzZf1tDMb3Z+3o3u7y0iLorRJLcUaioRZzUXEiAFBEB4wMAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Exynos System-on-Chips have ~7 distinctive I2C IO ports (exact
number depends on chip). However some integrated circuits on board, also
using I2C protocol for communication, can be connected to the SoC by
other GPIO. Enabling the I2C GPIO driver allows using such additional
integrated circuits.

An example of such chip using I2C and connected over GPIO to SoC is
Maxim 77693 MUIC on Trats2 board. The regulator driver of Maxim
77693 offers charger and safeout LDO (necessary for USB OTG).

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 arch/arm/configs/exynos_defconfig | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/configs/exynos_defconfig b/arch/arm/configs/exynos_defconfig
index fc7d1683bf67..6dd5252f73f4 100644
--- a/arch/arm/configs/exynos_defconfig
+++ b/arch/arm/configs/exynos_defconfig
@@ -71,6 +71,7 @@ CONFIG_I2C=y
 CONFIG_I2C_MUX=y
 CONFIG_I2C_ARB_GPIO_CHALLENGE=y
 CONFIG_I2C_EXYNOS5=y
+CONFIG_I2C_GPIO=y
 CONFIG_I2C_CROS_EC_TUNNEL=y
 CONFIG_SPI=y
 CONFIG_SPI_S3C64XX=y
@@ -88,6 +89,7 @@ CONFIG_MFD_CROS_EC=y
 CONFIG_MFD_CROS_EC_I2C=y
 CONFIG_MFD_CROS_EC_SPI=y
 CONFIG_MFD_MAX77686=y
+CONFIG_MFD_MAX77693=y
 CONFIG_MFD_MAX8997=y
 CONFIG_MFD_SEC_CORE=y
 CONFIG_MFD_TPS65090=y
@@ -96,6 +98,7 @@ CONFIG_REGULATOR_FIXED_VOLTAGE=y
 CONFIG_REGULATOR_GPIO=y
 CONFIG_REGULATOR_MAX8997=y
 CONFIG_REGULATOR_MAX77686=y
+CONFIG_REGULATOR_MAX77693=y
 CONFIG_REGULATOR_S2MPA01=y
 CONFIG_REGULATOR_S2MPS11=y
 CONFIG_REGULATOR_S5M8767=y
-- 
1.9.1

