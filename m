Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896AbaLELBZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 06:01:25 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:12086 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053AbaLELBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 06:01:19 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-1a-5481907a5c57
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Mike Turquette <mturquette@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Kukjin Kim <kgene@kernel.org>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Linus Walleij <linus.walleij@linaro.org>, linux-gpio@vger.kernel.org,
        devicetree@vger.kernel.org, Vivek Gautam <gautam.vivek@samsung.com>,
        Kevin Hilman <khilman@kernel.org>
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v4 3/3] ARM: dts: exynos5420: Add clock for audss pinctrl
 (fixing GPIO setup failure)
Date: Fri, 05 Dec 2014 12:00:54 +0100
Message-id: <1417777254-26579-4-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1417777254-26579-1-git-send-email-k.kozlowski@samsung.com>
References: <1417777254-26579-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPLMWRmVeSWpSXmKPExsVy+t/xy7pVExpDDFZ3slhsnLGe1WL+kXOs
	Fm1XDrJbHP1dYPH6haFF/+PXzBZPNz9msjjb9IbdYsqf5UwWmx5fY7XYPP8Po8XlXXPYLGac
	38dksfbIXXaLpxMuslkcftPOarFq1x9GB0GPv8+vs3jsnHWX3WPTqk42jzvX9rB5bF5S79G3
	ZRWjx+dNcgHsUVw2Kak5mWWpRfp2CVwZn78cYSw4wFHxYzp/A2MHexcjJ4eEgInEpH3v2SBs
	MYkL99YD2VwcQgJLGSWaHq9kh3D6mCQuL+hnBKliEzCW2Lx8CViViMAfZon7E78ygzjMAkcZ
	Jab3vmUCqRIWSJd4tfUeWAeLgKrEpMYOZhCbV8BdYsOzx1D75CROHpvM2sXIwcEp4CHx/roA
	SFgIqKSrrZl5AiPvAkaGVYyiqaXJBcVJ6blGesWJucWleel6yfm5mxghgfx1B+PSY1aHGAU4
	GJV4eH/ENYYIsSaWFVfmHmKU4GBWEuHl7wQK8aYkVlalFuXHF5XmpBYfYmTi4JRqYDzS+ftm
	r1Xxc2/7DwF6lWnWCUCHpVpyHfv68Vp+Vtfr1F6nUoYDAhc0FYzZMgV8uv9qZK769LrM5nvm
	epvzZ+59fHbr8HLvH1oNR04WaD+xzX+o9kPh4i3lp/dSC1T+fuJUuCL0Wvqf98PI0q3slovW
	zlzr+27qqTPn2y7/CmCI4XH/xNU1U4mlOCPRUIu5qDgRADQb6BlCAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pinctrl for audio subsystem needs 'mau_epll' clock to be enabled in
order to properly access memory during GPIO setup.

After introducing runtime PM to pl330 DMA driver the 'mau_epll' was
gated, because the "amba" clock was disabled and there were no more
users of mau_epll.

This lead to system hang just before probing i2s0 because
samsung_pinmux_setup() tried to access memory from audss block which was
gated.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Tested-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---
 arch/arm/boot/dts/exynos5420-pinctrl.dtsi | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/boot/dts/exynos5420-pinctrl.dtsi b/arch/arm/boot/dts/exynos5420-pinctrl.dtsi
index ba686e40eac7..c0ca0da36ade 100644
--- a/arch/arm/boot/dts/exynos5420-pinctrl.dtsi
+++ b/arch/arm/boot/dts/exynos5420-pinctrl.dtsi
@@ -696,6 +696,9 @@
 	};
 
 	pinctrl@03860000 {
+		clocks = <&clock CLK_MAU_EPLL>;
+		clock-names = "block";
+
 		gpz: gpz {
 			gpio-controller;
 			#gpio-cells = <2>;
-- 
1.9.1

