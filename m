Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809AbaLDKuR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 05:50:17 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:64281 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753172AbaLDKth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 05:49:37 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-51-54803c3e6d6f
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
Subject: [PATCH v3 3/3] ARM: dts: exynos5420: Add clock for audss pinctrl
 (fixing GPIO setup failure)
Date: Thu, 04 Dec 2014 11:47:55 +0100
Message-id: <1417690075-13483-4-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1417690075-13483-1-git-send-email-k.kozlowski@samsung.com>
References: <1417690075-13483-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPLMWRmVeSWpSXmKPExsVy+t/xq7p2Ng0hBh0bWSw2zljPajH/yDlW
	i7YrB9ktjv4usHj9wtCi//FrZounmx8zWZxtesNuMeXPciaLTY+vsVpsnv+H0eLyrjlsFjPO
	72OyWHvkLrvF0wkX2SwOv2lntVi16w+jg6DH3+fXWTx2zrrL7rFpVSebx51re9g8Ni+p9+jb
	sorR4/MmuQD2KC6blNSczLLUIn27BK6MkwfVC36yV5x5sZm1gfE4WxcjJ4eEgInElge/mCBs
	MYkL99aDxYUEljJKTJou3cXIBWT3MUn0vOthBUmwCRhLbF6+hA0kISLwh1ni/sSvzCAOs8BR
	RonpvW/BRgkLpEt0vd/CDGKzCKhKvP7dxQhi8wq4S0x+O5UZYp2cxMljk8Gmcgp4SPz7dZEF
	YrW7xLdle9gmMPIuYGRYxSiaWppcUJyUnmuoV5yYW1yal66XnJ+7iRESyF92MC4+ZnWIUYCD
	UYmHd8HT+hAh1sSy4srcQ4wSHMxKIryMf4FCvCmJlVWpRfnxRaU5qcWHGJk4OKUaGHsC1+lM
	fLTO2KF3R+Un7YWmBgY31Sr+336qvt7KJ9oz/fMxjQ0vX4sV3XXt+8fgp/DwvaH+LKuDJdvE
	JqhPPeTiH/51k8uSQOYWnVbmetWkEyVlPGoC+xf01VtumFgdWHjhVw2D2QzuDzGaF29pKC07
	f8SuoGOJcmnLT+7p5X5Ryi8k53pPVGIpzkg01GIuKk4EADkyOfdCAgAA
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

