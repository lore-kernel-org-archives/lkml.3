Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713AbaJ0PAJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 11:00:09 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:29732 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907AbaJ0PAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 11:00:06 -0400
X-AuditID: cbfec7f5-b7f956d000005ed7-4e-544e5df34b23
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v2] ARM: dts: exynos4412-trats: Add micro SD card SDHCI node
Date: Mon, 27 Oct 2014 15:59:55 +0100
Message-id: <1414421995-22618-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrIJMWRmVeSWpSXmKPExsVy+t/xa7qfY/1CDPq6ZC02zljPajFp3QEm
	i/lHzrFavH5haNG74CqbxdmmN+wWmx5fY7W4vGsOm8WM8/uYLG5f5rVYe+QuuwO3R0tzD5vH
	31UvmD02L6n36NuyitHj8ya5ANYoLpuU1JzMstQifbsEroxrs14yFqzmqNj0cRN7A+Njti5G
	Tg4JAROJN6c6mSBsMYkL99YDxbk4hASWMkpcuNTJCuH0MUl0vVwI1sEmYCyxefkSsCoRge+M
	EpumPGQEcZgFjjJKTO99CzZLWMBH4l/HHlYQm0VAVWJFYysjiM0r4C6xbcY2qH1yEiePTWad
	wMi9gJFhFaNoamlyQXFSeq6RXnFibnFpXrpecn7uJkZIMH3dwbj0mNUhRgEORiUe3gnFviFC
	rIllxZW5hxglOJiVRHhPBfiFCPGmJFZWpRblxxeV5qQWH2Jk4uCUamCsDkr1/5T68F+v/q5v
	4b9uZfxdnVN+5TrP2egp7qETv/zuf154sXbGoeYQxUrjhUrdokaSBd/WGeX9eJ3IOteFfVoK
	5+atOfmKS5xVl3eLb39ftibBzXmmUX32Tbu7e2pa+yusjYu2BFws+mPEosyoL350heizKi2X
	mxorT95WSdwY0P3tZZYSS3FGoqEWc1FxIgC12vIDBAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add SDHCI node for supporting the micro SD card. On Trats2 board the
SDHCI does not use sd2_cd pins (gpk2-2) for card detect but gpx3-4
instead.

Power is supplied from LDO21 regulator which in off state is controlled
by external GPIO pin.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

---

Changes since v1:
1. Drop FIXME comment (about findings during testing).
---
 arch/arm/boot/dts/exynos4412-trats2.dts | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm/boot/dts/exynos4412-trats2.dts b/arch/arm/boot/dts/exynos4412-trats2.dts
index a5aa52bba72c..7a68e0832cd6 100644
--- a/arch/arm/boot/dts/exynos4412-trats2.dts
+++ b/arch/arm/boot/dts/exynos4412-trats2.dts
@@ -603,6 +603,16 @@
 		cap-mmc-highspeed;
 	};
 
+	sdhci@12530000 {
+		bus-width = <4>;
+		cd-gpios = <&gpx3 4 0>;
+		cd-inverted;
+		pinctrl-0 = <&sd2_clk &sd2_cmd &sd2_bus4>;
+		pinctrl-names = "default";
+		vmmc-supply = <&ldo21_reg>;
+		status = "okay";
+	};
+
 	serial@13800000 {
 		status = "okay";
 	};
-- 
1.9.1

