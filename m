Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001AbaILNGj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 09:06:39 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:9119 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744AbaILNGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 09:06:38 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-3c-5412efdbbedb
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, Stephen Warren <swarren@nvidia.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Lee Jones <lee.jones@linaro.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH] ARM: multi_v7_defconfig: Enable Maxim 77693 and I2C GPIO
 drivers
Date: Fri, 12 Sep 2014 15:06:27 +0200
Message-id: <1410527187-26588-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrELMWRmVeSWpSXmKPExsVy+t/xK7q33wuFGExZImbxd9IxdouNM9az
	WjQuucxi8fqFocXZpjfsFve/HmW02PT4GqvF5V1z2CxuX+a1WHvkLrvF1k17mS1OXf/MZnFj
	egurxdMHTUwWq3b9YXTg92hp7mHz+P1rEqPHk00XGT12zrrL7tFw4DyLx51re9g8Ni+p97hy
	oonVo7f5HZtH35ZVjB6fN8kFcEdx2aSk5mSWpRbp2yVwZVxetY+xoI+n4s/z7YwNjNu5uhg5
	OSQETCQuzP7NBGGLSVy4t56ti5GLQ0hgKaPE+22HWSCcPiaJyzeugVWxCRhLbF6+BKxKRKCf
	WeL4LIgqZoE3jBK9eyaygFQJCwRLdHa+B+tgEVCVOLBlAZDNwcEr4C7xZXsmxDo5iZPHJrNO
	YORewMiwilE0tTS5oDgpPddIrzgxt7g0L10vOT93EyMkXL/uYFx6zOoQowAHoxIP74dcwRAh
	1sSy4srcQ4wSHMxKIrw3XgmFCPGmJFZWpRblxxeV5qQWH2Jk4uCUamDUmhYjl7yV90i8Buvd
	v9MOX618rZ81Tb2hL4kvTfK/lJRWiNO920uOrfjw4bvRyssS4Sm9i7baP14SPeH71R479u49
	K91OM8bc+nVc4MC5Gas/K71xFd642Pn8jj0KSZOevylMemkZ9urr3jtz2a5ILlRM/fJNZ8+x
	JrUe6eQds8NDWrym8fM9VWIpzkg01GIuKk4EAHJTrLM1AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Exynos System-on-Chips have ~7 distinctive I2C IO ports (exact
number depends on chip). However some integrated circuits on board, also
using I2C protocol for communication, can be connected to the SoC by
other GPIO. Enabling the I2C GPIO driver allows using such additional
integrated circuits.

An example of such chip using I2C and connected over GPIO to SoC is
Maxim 77693 MUIC on Trats2 board. The regulator driver of Maxim 77693
offers charger and safeout LDO (necessary for USB OTG).

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 arch/arm/configs/multi_v7_defconfig | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/configs/multi_v7_defconfig b/arch/arm/configs/multi_v7_defconfig
index 5fb95fb758d9..5eb5c9e9510c 100644
--- a/arch/arm/configs/multi_v7_defconfig
+++ b/arch/arm/configs/multi_v7_defconfig
@@ -200,6 +200,7 @@ CONFIG_I2C_MUX_PINCTRL=y
 CONFIG_I2C_CADENCE=y
 CONFIG_I2C_DESIGNWARE_PLATFORM=y
 CONFIG_I2C_EXYNOS5=y
+CONFIG_I2C_GPIO=y
 CONFIG_I2C_MV64XXX=y
 CONFIG_I2C_SIRF=y
 CONFIG_I2C_TEGRA=y
@@ -244,6 +245,7 @@ CONFIG_MFD_BCM590XX=y
 CONFIG_MFD_CROS_EC=y
 CONFIG_MFD_CROS_EC_SPI=y
 CONFIG_MFD_MAX8907=y
+CONFIG_MFD_MAX77693=y
 CONFIG_MFD_SEC_CORE=y
 CONFIG_MFD_STMPE=y
 CONFIG_MFD_PALMAS=y
@@ -256,6 +258,7 @@ CONFIG_REGULATOR_AS3722=y
 CONFIG_REGULATOR_BCM590XX=y
 CONFIG_REGULATOR_GPIO=y
 CONFIG_REGULATOR_MAX8907=y
+CONFIG_REGULATOR_MAX77693=y
 CONFIG_REGULATOR_PALMAS=y
 CONFIG_REGULATOR_S2MPS11=y
 CONFIG_REGULATOR_S5M8767=y
-- 
1.9.1

