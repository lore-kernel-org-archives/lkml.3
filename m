Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815AbaKZOYu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 09:24:50 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:44757 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752554AbaKZOYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 09:24:45 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-13-5475e2a94710
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Mike Turquette <mturquette@linaro.org>, Kukjin Kim <kgene@kernel.org>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>, linux-gpio@vger.kernel.org,
        devicetree@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Kevin Hilman <khilman@kernel.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v2 4/5] ARM: dts: exynos5420: Add clock for audss pinctrl
Date: Wed, 26 Nov 2014 15:24:16 +0100
Message-id: <1417011857-10419-5-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1417011857-10419-1-git-send-email-k.kozlowski@samsung.com>
References: <1417011857-10419-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLLMWRmVeSWpSXmKPExsVy+t/xK7orH5WGGMxsYbfYOGM9q8X8I+dY
	LdquHGS3OPq7wOL1C0OL/sevmS2ebn7MZHG26Q27xZQ/y5ksNj2+xmqxef4fRovLu+awWcw4
	v4/J4vZlXou1R+6yWzydcJHN4vCbdlaLYzOWMFqs2vWH0UHYo6W5h83j7/PrLB47Z91l99i0
	qpPN4861PWwem5fUe/RtWcXo8XmTXABHFJdNSmpOZllqkb5dAlfGgWPX2AtOsVbsfTmVpYHx
	IksXIyeHhICJxNG+CUwQtpjEhXvr2UBsIYGljBL3b4d3MXIB2X1MEpua/rKCJNgEjCU2L1/C
	BpIQEVjBIrFr0S9mEIdZ4B2jxPoz68HGCgt4SryeOJEZxGYRUJVo29kO1MHBwSvgLrFuQwrE
	NjmJk8cmgw3lFPCQaHt/nhlis7vE932HGScw8i5gZFjFKJpamlxQnJSea6RXnJhbXJqXrpec
	n7uJERLkX3cwLj1mdYhRgINRiYf3RlxJiBBrYllxZe4hRgkOZiUR3tQ7pSFCvCmJlVWpRfnx
	RaU5qcWHGJk4OKUaGJU8/A+oTtf67aC1PuPGihnRMxqPTNu0LOLJr4NhOly1G9gFsziddr+9
	9/4a5wSpvL3zfnIUX3ugrbtE7Gt9UXCufkreduuDdVXOdor/3/2sOfEx5pqV8bPjS5/MO/sq
	y4WnbtM/WU5Hk8BVV5W+vBdeXPcg0S9YP5ipUvjji7wwOw+fgimLjZRYijMSDbWYi4oTARo7
	VddQAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pinctrl for audio subsystem needs 'mau_epll' clock to be enabled in
order to properly access memory during GPIO setup.

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

