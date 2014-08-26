Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758325AbaHZOKx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 10:10:53 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:25683 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755310AbaHZOKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 10:10:48 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-38-53fc95656cfc
From: Tomasz Figa <t.figa@samsung.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, Arnd Bergmann <arnd@arndb.de>,
        swarren@nvidia.com, acourbot@nvidia.com,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Olof Johansson <olof@lixom.net>,
        drake@endlessm.com, tomeu@tomeuvizoso.net,
        Tomasz Figa <t.figa@samsung.com>
Subject: [PATCH v3 5/5] ARM: dts: exynos4412-trats2: Add sleep mode pin
 configuration
Date: Tue, 26 Aug 2014 16:10:28 +0200
Message-id: <1409062228-14690-6-git-send-email-t.figa@samsung.com>
X-Mailer: git-send-email 2.0.4
In-reply-to: <1409062228-14690-1-git-send-email-t.figa@samsung.com>
References: <1409062228-14690-1-git-send-email-t.figa@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDLMWRmVeSWpSXmKPExsVy+t/xq7qpU/8EG0x6rmTx/eEpVou/k46x
	Wzya/5jZonfBVTaLTY+vsVpc3jWHzWLG+X1MFrcv81qsPXKX3eLU9c9sFjemt7BarJ/xmsVi
	1a4/jBaXG80c+DxamnvYPH7/msToseh7lsfOWXfZPTYvqfe4cqKJ1aO3+R2bR9+WVYweR/+y
	eXzeJBfAFcVlk5Kak1mWWqRvl8CV0dDVxVSwwqei7Uo7SwPjMrsuRg4OCQETiTvT9LsYOYFM
	MYkL99azdTFycQgJLGWUOHm6HcrpY5K4sPQJE0gVm4CaxOeGR2wgtoiAqsTntgXsIEXMAhuZ
	JX78ncAOMlVYIFyi6UkSSA0LUM3v4y9ZQWxeASeJbWdeMENsk5NYtXEf2ExOAWeJn0+2gtUI
	AdXsfbiadQIj7wJGhlWMoqmlyQXFSem5hnrFibnFpXnpesn5uZsYISH8ZQfj4mNWhxgFOBiV
	eHg/lPwOFmJNLCuuzD3EKMHBrCTC+yPpT7AQb0piZVVqUX58UWlOavEhRiYOTqkGxvYDy+oU
	+Nds2vlGZNvt+HDVOf2vVXadz9gseUn9iXCbXTXful1e3M9K/ibNcHc+edTG9+rt69MOach1
	/dEMFA+X8lpyP33bQ4GpYa4MZzri+7kbQi/xy9o4Zd47ele7L7h6XnyG8+WJMyJaL+iuv23q
	bbF5w2tfvd9zZ3g+fpR9U+6FB//Dq0osxRmJhlrMRcWJAMGuXJo/AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds sleep mode pin configuration using pin control hog
mechanism to configure states of GPIO pins in sleep mode. This is
required to reduce leakage current in sleep mode and prevent glitching
of components on the board.

Signed-off-by: Tomasz Figa <t.figa@samsung.com>
---
 arch/arm/boot/dts/exynos4412-trats2.dts | 316 ++++++++++++++++++++++++++++++++
 1 file changed, 316 insertions(+)

diff --git a/arch/arm/boot/dts/exynos4412-trats2.dts b/arch/arm/boot/dts/exynos4412-trats2.dts
index a75034c..61e59eb 100644
--- a/arch/arm/boot/dts/exynos4412-trats2.dts
+++ b/arch/arm/boot/dts/exynos4412-trats2.dts
@@ -778,3 +778,319 @@
 		io-channels = <&adc 2>;  /* Battery temperature */
 	};
 };
+
+&pinctrl_0 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&sleep0>;
+
+	sleep0: sleep-states {
+		PIN_SLP(gpa0-0, INPUT, NONE);
+		PIN_SLP(gpa0-1, OUT0, NONE);
+		PIN_SLP(gpa0-2, INPUT, NONE);
+		PIN_SLP(gpa0-3, INPUT, UP);
+		PIN_SLP(gpa0-4, INPUT, NONE);
+		PIN_SLP(gpa0-5, INPUT, DOWN);
+		PIN_SLP(gpa0-6, INPUT, DOWN);
+		PIN_SLP(gpa0-7, INPUT, UP);
+
+		PIN_SLP(gpa1-0, INPUT, DOWN);
+		PIN_SLP(gpa1-1, INPUT, DOWN);
+		PIN_SLP(gpa1-2, INPUT, DOWN);
+		PIN_SLP(gpa1-3, INPUT, DOWN);
+		PIN_SLP(gpa1-4, INPUT, DOWN);
+		PIN_SLP(gpa1-5, INPUT, DOWN);
+
+		PIN_SLP(gpb-0, INPUT, NONE);
+		PIN_SLP(gpb-1, INPUT, NONE);
+		PIN_SLP(gpb-2, INPUT, NONE);
+		PIN_SLP(gpb-3, INPUT, NONE);
+		PIN_SLP(gpb-4, INPUT, DOWN);
+		PIN_SLP(gpb-5, INPUT, UP);
+		PIN_SLP(gpb-6, INPUT, DOWN);
+		PIN_SLP(gpb-7, INPUT, DOWN);
+
+		PIN_SLP(gpc0-0, INPUT, DOWN);
+		PIN_SLP(gpc0-1, INPUT, DOWN);
+		PIN_SLP(gpc0-2, INPUT, DOWN);
+		PIN_SLP(gpc0-3, INPUT, DOWN);
+		PIN_SLP(gpc0-4, INPUT, DOWN);
+
+		PIN_SLP(gpc1-0, INPUT, NONE);
+		PIN_SLP(gpc1-1, PREV, NONE);
+		PIN_SLP(gpc1-2, INPUT, NONE);
+		PIN_SLP(gpc1-3, INPUT, NONE);
+		PIN_SLP(gpc1-4, INPUT, NONE);
+
+		PIN_SLP(gpd0-0, INPUT, DOWN);
+		PIN_SLP(gpd0-1, INPUT, DOWN);
+		PIN_SLP(gpd0-2, INPUT, NONE);
+		PIN_SLP(gpd0-3, INPUT, NONE);
+
+		PIN_SLP(gpd1-0, INPUT, DOWN);
+		PIN_SLP(gpd1-1, INPUT, DOWN);
+		PIN_SLP(gpd1-2, INPUT, NONE);
+		PIN_SLP(gpd1-3, INPUT, NONE);
+
+		PIN_SLP(gpf0-0, INPUT, NONE);
+		PIN_SLP(gpf0-1, INPUT, NONE);
+		PIN_SLP(gpf0-2, INPUT, DOWN);
+		PIN_SLP(gpf0-3, INPUT, DOWN);
+		PIN_SLP(gpf0-4, INPUT, NONE);
+		PIN_SLP(gpf0-5, INPUT, DOWN);
+		PIN_SLP(gpf0-6, INPUT, NONE);
+		PIN_SLP(gpf0-7, INPUT, DOWN);
+
+		PIN_SLP(gpf1-0, INPUT, DOWN);
+		PIN_SLP(gpf1-1, INPUT, DOWN);
+		PIN_SLP(gpf1-2, INPUT, DOWN);
+		PIN_SLP(gpf1-3, INPUT, DOWN);
+		PIN_SLP(gpf1-4, INPUT, NONE);
+		PIN_SLP(gpf1-5, INPUT, NONE);
+		PIN_SLP(gpf1-6, INPUT, DOWN);
+		PIN_SLP(gpf1-7, PREV, NONE);
+
+		PIN_SLP(gpf2-0, PREV, NONE);
+		PIN_SLP(gpf2-1, INPUT, DOWN);
+		PIN_SLP(gpf2-2, INPUT, DOWN);
+		PIN_SLP(gpf2-3, INPUT, DOWN);
+		PIN_SLP(gpf2-4, INPUT, DOWN);
+		PIN_SLP(gpf2-5, INPUT, DOWN);
+		PIN_SLP(gpf2-6, INPUT, NONE);
+		PIN_SLP(gpf2-7, INPUT, NONE);
+
+		PIN_SLP(gpf3-0, INPUT, NONE);
+		PIN_SLP(gpf3-1, PREV, NONE);
+		PIN_SLP(gpf3-2, PREV, NONE);
+		PIN_SLP(gpf3-3, PREV, NONE);
+		PIN_SLP(gpf3-4, OUT1, NONE);
+		PIN_SLP(gpf3-5, INPUT, DOWN);
+
+		PIN_SLP(gpj0-0, PREV, NONE);
+		PIN_SLP(gpj0-1, PREV, NONE);
+		PIN_SLP(gpj0-2, PREV, NONE);
+		PIN_SLP(gpj0-3, INPUT, DOWN);
+		PIN_SLP(gpj0-4, PREV, NONE);
+		PIN_SLP(gpj0-5, PREV, NONE);
+		PIN_SLP(gpj0-6, INPUT, DOWN);
+		PIN_SLP(gpj0-7, INPUT, DOWN);
+
+		PIN_SLP(gpj1-0, INPUT, DOWN);
+		PIN_SLP(gpj1-1, PREV, NONE);
+		PIN_SLP(gpj1-2, PREV, NONE);
+		PIN_SLP(gpj1-3, INPUT, DOWN);
+		PIN_SLP(gpj1-4, INPUT, DOWN);
+	};
+};
+
+&pinctrl_1 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&sleep1>;
+
+	sleep1: sleep-states {
+		PIN_SLP(gpk0-0, PREV, NONE);
+		PIN_SLP(gpk0-1, PREV, NONE);
+		PIN_SLP(gpk0-2, OUT0, NONE);
+		PIN_SLP(gpk0-3, PREV, NONE);
+		PIN_SLP(gpk0-4, PREV, NONE);
+		PIN_SLP(gpk0-5, PREV, NONE);
+		PIN_SLP(gpk0-6, PREV, NONE);
+
+		PIN_SLP(gpk1-0, INPUT, DOWN);
+		PIN_SLP(gpk1-1, INPUT, DOWN);
+		PIN_SLP(gpk1-2, INPUT, DOWN);
+		PIN_SLP(gpk1-3, PREV, NONE);
+		PIN_SLP(gpk1-4, PREV, NONE);
+		PIN_SLP(gpk1-5, PREV, NONE);
+		PIN_SLP(gpk1-6, PREV, NONE);
+
+		PIN_SLP(gpk2-0, INPUT, DOWN);
+		PIN_SLP(gpk2-1, INPUT, DOWN);
+		PIN_SLP(gpk2-2, INPUT, DOWN);
+		PIN_SLP(gpk2-3, INPUT, DOWN);
+		PIN_SLP(gpk2-4, INPUT, DOWN);
+		PIN_SLP(gpk2-5, INPUT, DOWN);
+		PIN_SLP(gpk2-6, INPUT, DOWN);
+
+		PIN_SLP(gpk3-0, OUT0, NONE);
+		PIN_SLP(gpk3-1, INPUT, NONE);
+		PIN_SLP(gpk3-2, INPUT, DOWN);
+		PIN_SLP(gpk3-3, INPUT, NONE);
+		PIN_SLP(gpk3-4, INPUT, NONE);
+		PIN_SLP(gpk3-5, INPUT, NONE);
+		PIN_SLP(gpk3-6, INPUT, NONE);
+
+		PIN_SLP(gpl0-0, INPUT, DOWN);
+		PIN_SLP(gpl0-1, INPUT, DOWN);
+		PIN_SLP(gpl0-2, INPUT, DOWN);
+		PIN_SLP(gpl0-3, INPUT, DOWN);
+		PIN_SLP(gpl0-4, PREV, NONE);
+		PIN_SLP(gpl0-6, PREV, NONE);
+
+		PIN_SLP(gpl1-0, INPUT, DOWN);
+		PIN_SLP(gpl1-1, INPUT, DOWN);
+		PIN_SLP(gpl2-0, INPUT, DOWN);
+		PIN_SLP(gpl2-1, INPUT, DOWN);
+		PIN_SLP(gpl2-2, INPUT, DOWN);
+		PIN_SLP(gpl2-3, INPUT, DOWN);
+		PIN_SLP(gpl2-4, INPUT, DOWN);
+		PIN_SLP(gpl2-5, INPUT, DOWN);
+		PIN_SLP(gpl2-6, PREV, NONE);
+		PIN_SLP(gpl2-7, INPUT, DOWN);
+
+		PIN_SLP(gpm0-0, INPUT, DOWN);
+		PIN_SLP(gpm0-1, INPUT, DOWN);
+		PIN_SLP(gpm0-2, INPUT, DOWN);
+		PIN_SLP(gpm0-3, INPUT, DOWN);
+		PIN_SLP(gpm0-4, INPUT, DOWN);
+		PIN_SLP(gpm0-5, INPUT, DOWN);
+		PIN_SLP(gpm0-6, INPUT, DOWN);
+		PIN_SLP(gpm0-7, INPUT, DOWN);
+
+		PIN_SLP(gpm1-0, INPUT, DOWN);
+		PIN_SLP(gpm1-1, INPUT, DOWN);
+		PIN_SLP(gpm1-2, INPUT, NONE);
+		PIN_SLP(gpm1-3, INPUT, NONE);
+		PIN_SLP(gpm1-4, INPUT, NONE);
+		PIN_SLP(gpm1-5, INPUT, NONE);
+		PIN_SLP(gpm1-6, INPUT, DOWN);
+
+		PIN_SLP(gpm2-0, INPUT, NONE);
+		PIN_SLP(gpm2-1, INPUT, NONE);
+		PIN_SLP(gpm2-2, INPUT, DOWN);
+		PIN_SLP(gpm2-3, INPUT, DOWN);
+		PIN_SLP(gpm2-4, INPUT, DOWN);
+
+		PIN_SLP(gpm3-0, PREV, NONE);
+		PIN_SLP(gpm3-1, PREV, NONE);
+		PIN_SLP(gpm3-2, PREV, NONE);
+		PIN_SLP(gpm3-3, OUT1, NONE);
+		PIN_SLP(gpm3-4, INPUT, DOWN);
+		PIN_SLP(gpm3-5, INPUT, DOWN);
+		PIN_SLP(gpm3-6, INPUT, DOWN);
+		PIN_SLP(gpm3-7, INPUT, DOWN);
+
+		PIN_SLP(gpm4-0, INPUT, DOWN);
+		PIN_SLP(gpm4-1, INPUT, DOWN);
+		PIN_SLP(gpm4-2, INPUT, DOWN);
+		PIN_SLP(gpm4-3, INPUT, DOWN);
+		PIN_SLP(gpm4-4, INPUT, DOWN);
+		PIN_SLP(gpm4-5, INPUT, DOWN);
+		PIN_SLP(gpm4-6, INPUT, DOWN);
+		PIN_SLP(gpm4-7, INPUT, DOWN);
+
+		PIN_SLP(gpy0-0, INPUT, DOWN);
+		PIN_SLP(gpy0-1, INPUT, DOWN);
+		PIN_SLP(gpy0-2, INPUT, DOWN);
+		PIN_SLP(gpy0-3, INPUT, DOWN);
+		PIN_SLP(gpy0-4, INPUT, DOWN);
+		PIN_SLP(gpy0-5, INPUT, DOWN);
+
+		PIN_SLP(gpy1-0, INPUT, DOWN);
+		PIN_SLP(gpy1-1, INPUT, DOWN);
+		PIN_SLP(gpy1-2, INPUT, DOWN);
+		PIN_SLP(gpy1-3, INPUT, DOWN);
+
+		PIN_SLP(gpy2-0, PREV, NONE);
+		PIN_SLP(gpy2-1, INPUT, DOWN);
+		PIN_SLP(gpy2-2, INPUT, NONE);
+		PIN_SLP(gpy2-3, INPUT, NONE);
+		PIN_SLP(gpy2-4, INPUT, NONE);
+		PIN_SLP(gpy2-5, INPUT, NONE);
+
+		PIN_SLP(gpy3-0, INPUT, DOWN);
+		PIN_SLP(gpy3-1, INPUT, DOWN);
+		PIN_SLP(gpy3-2, INPUT, DOWN);
+		PIN_SLP(gpy3-3, INPUT, DOWN);
+		PIN_SLP(gpy3-4, INPUT, DOWN);
+		PIN_SLP(gpy3-5, INPUT, DOWN);
+		PIN_SLP(gpy3-6, INPUT, DOWN);
+		PIN_SLP(gpy3-7, INPUT, DOWN);
+
+		PIN_SLP(gpy4-0, INPUT, DOWN);
+		PIN_SLP(gpy4-1, INPUT, DOWN);
+		PIN_SLP(gpy4-2, INPUT, DOWN);
+		PIN_SLP(gpy4-3, INPUT, DOWN);
+		PIN_SLP(gpy4-4, INPUT, DOWN);
+		PIN_SLP(gpy4-5, INPUT, DOWN);
+		PIN_SLP(gpy4-6, INPUT, DOWN);
+		PIN_SLP(gpy4-7, INPUT, DOWN);
+
+		PIN_SLP(gpy5-0, INPUT, DOWN);
+		PIN_SLP(gpy5-1, INPUT, DOWN);
+		PIN_SLP(gpy5-2, INPUT, DOWN);
+		PIN_SLP(gpy5-3, INPUT, DOWN);
+		PIN_SLP(gpy5-4, INPUT, DOWN);
+		PIN_SLP(gpy5-5, INPUT, DOWN);
+		PIN_SLP(gpy5-6, INPUT, DOWN);
+		PIN_SLP(gpy5-7, INPUT, DOWN);
+
+		PIN_SLP(gpy6-0, INPUT, DOWN);
+		PIN_SLP(gpy6-1, INPUT, DOWN);
+		PIN_SLP(gpy6-2, INPUT, DOWN);
+		PIN_SLP(gpy6-3, INPUT, DOWN);
+		PIN_SLP(gpy6-4, INPUT, DOWN);
+		PIN_SLP(gpy6-5, INPUT, DOWN);
+		PIN_SLP(gpy6-6, INPUT, DOWN);
+		PIN_SLP(gpy6-7, INPUT, DOWN);
+	};
+};
+
+&pinctrl_2 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&sleep2>;
+
+	sleep2: sleep-states {
+		PIN_SLP(gpz-0, INPUT, DOWN);
+		PIN_SLP(gpz-1, INPUT, DOWN);
+		PIN_SLP(gpz-2, INPUT, DOWN);
+		PIN_SLP(gpz-3, INPUT, DOWN);
+		PIN_SLP(gpz-4, INPUT, DOWN);
+		PIN_SLP(gpz-5, INPUT, DOWN);
+		PIN_SLP(gpz-6, INPUT, DOWN);
+	};
+};
+
+&pinctrl_3 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&sleep3>;
+
+	sleep3: sleep-states {
+		PIN_SLP(gpv0-0, INPUT, DOWN);
+		PIN_SLP(gpv0-1, INPUT, DOWN);
+		PIN_SLP(gpv0-2, INPUT, DOWN);
+		PIN_SLP(gpv0-3, INPUT, DOWN);
+		PIN_SLP(gpv0-4, INPUT, DOWN);
+		PIN_SLP(gpv0-5, INPUT, DOWN);
+		PIN_SLP(gpv0-6, INPUT, DOWN);
+		PIN_SLP(gpv0-7, INPUT, DOWN);
+
+		PIN_SLP(gpv1-0, INPUT, DOWN);
+		PIN_SLP(gpv1-1, INPUT, DOWN);
+		PIN_SLP(gpv1-2, INPUT, DOWN);
+		PIN_SLP(gpv1-3, INPUT, DOWN);
+		PIN_SLP(gpv1-4, INPUT, DOWN);
+		PIN_SLP(gpv1-5, INPUT, DOWN);
+		PIN_SLP(gpv1-6, INPUT, DOWN);
+		PIN_SLP(gpv1-7, INPUT, DOWN);
+
+		PIN_SLP(gpv2-0, INPUT, DOWN);
+		PIN_SLP(gpv2-1, INPUT, DOWN);
+		PIN_SLP(gpv2-2, INPUT, DOWN);
+		PIN_SLP(gpv2-3, INPUT, DOWN);
+		PIN_SLP(gpv2-4, INPUT, DOWN);
+		PIN_SLP(gpv2-5, INPUT, DOWN);
+		PIN_SLP(gpv2-6, INPUT, DOWN);
+		PIN_SLP(gpv2-7, INPUT, DOWN);
+
+		PIN_SLP(gpv3-0, INPUT, DOWN);
+		PIN_SLP(gpv3-1, INPUT, DOWN);
+		PIN_SLP(gpv3-2, INPUT, DOWN);
+		PIN_SLP(gpv3-3, INPUT, DOWN);
+		PIN_SLP(gpv3-4, INPUT, DOWN);
+		PIN_SLP(gpv3-5, INPUT, DOWN);
+		PIN_SLP(gpv3-6, INPUT, DOWN);
+		PIN_SLP(gpv3-7, INPUT, DOWN);
+
+		PIN_SLP(gpv4-0, INPUT, DOWN);
+	};
+};
-- 
2.0.4

