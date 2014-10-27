Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318AbaJ0OgY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 10:36:24 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:49653 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753014AbaJ0OgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 10:36:21 -0400
X-AuditID: cbfec7f4-b7f6c6d00000120b-b7-544e58625ac7
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
Subject: [PATCH] ARM: dts: exynos4412-trats: Add micro SD card SDHCI node
Date: Mon, 27 Oct 2014 15:35:58 +0100
Message-id: <1414420558-5376-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrIJMWRmVeSWpSXmKPExsVy+t/xy7pJEX4hBvcvGFhsnLGe1WLSugNM
	FvOPnGO1eP3C0KJ3wVU2i7NNb9gtNj2+xmpxedccNosZ5/cxWdy+zGux9shddgduj5bmHjaP
	v6teMHtsXlLv0bdlFaPH501yAaxRXDYpqTmZZalF+nYJXBmP3v9jLvjJXrF88gW2Bsa9bF2M
	nBwSAiYSS84+g7LFJC7cWw9kc3EICSxllLj96QcThNPHJHH541dGkCo2AWOJzcuXgFWJCHxn
	lNg05SEjiMMscJRRYnrvWyaQKmEBT4mHJ3vZQWwWAVWJhg2LmUFsXgE3ibc919gh9slJnDw2
	mXUCI/cCRoZVjKKppckFxUnpuYZ6xYm5xaV56XrJ+bmbGCHB9GUH4+JjVocYBTgYlXh4d0zz
	DRFiTSwrrsw9xCjBwawkwnsqwC9EiDclsbIqtSg/vqg0J7X4ECMTB6dUA+P8U9krRW/f9Fsu
	LcuwPvXVnq0FF687y204nKbfzPelw/VwTsOxta5Hjs84fFOry8nkzI2t/LFXfntPYX72dfLr
	+d/LNpa0JAnOnNPRwXPw1EynR1OThDZ9jnwfELVgzWljnSgvwYi29Gr3+05vQwV8AzinK8RP
	nmWee+ec7G/T/XKMP4+vsX6rxFKckWioxVxUnAgACYKecwQCAAA=
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
 arch/arm/boot/dts/exynos4412-trats2.dts | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm/boot/dts/exynos4412-trats2.dts b/arch/arm/boot/dts/exynos4412-trats2.dts
index a5aa52bba72c..2e5d0fdf8362 100644
--- a/arch/arm/boot/dts/exynos4412-trats2.dts
+++ b/arch/arm/boot/dts/exynos4412-trats2.dts
@@ -603,6 +603,17 @@
 		cap-mmc-highspeed;
 	};
 
+	/* FIXME: suspend fails... */
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

