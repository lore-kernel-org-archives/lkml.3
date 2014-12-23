Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072AbaLWKtt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 05:49:49 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:59322 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755939AbaLWKsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 05:48:52 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-a0-549948926630
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-omap@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, lauraa@codeaurora.org,
        linus.walleij@linaro.org, tony@atomide.com, drake@endlessm.com,
        loeliger@gmail.com, Mark Rutland <mark.rutland@arm.com>, nm@ti.com,
        khilman@linaro.org
Subject: [PATCH v10 8/8] ARM: dts: exynos4: Add nodes for L2 cache controller
Date: Tue, 23 Dec 2014 11:48:36 +0100
Message-id: <1419331716-8972-9-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.9.2
In-reply-to: <1419331716-8972-1-git-send-email-m.szyprowski@samsung.com>
References: <1419331716-8972-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKLMWRmVeSWpSXmKPExsVy+t/xa7qTPGaGGNx+wGjxd9IxdotH8x8z
	W/QuuMpm8fXwCkaLs01v2C22d85gt5jyZzmTxabH11gtLu+aw2Yxe0k/i8WM8/uYLG5f5rU4
	t30Li8XaI3fZLZZev8hk8ebHWSaLU9c/s1ms2vWH0WL/FS8HYY8189YwerQ097B5/P41idHj
	29dJLB6X+3qZPBZ9z/LYOesuu8eda3vYPDYvqfe4cqKJ1aNvyypGj+M3tjN5fN4kF8AbxWWT
	kpqTWZZapG+XwJVxd9lB9oJJfBV3PrUyNTDe4u5i5OSQEDCRWLtvMRuELSZx4d56MFtIYCmj
	xKlvUhB2H5PEvNeBIDabgKFE19susBoRATeJf+sOAdlcHMwC01gkNh05zwySEBbwlTi9Zgkj
	iM0ioCqx5MpDMJtXwF1i+4ddLBDL5CT+v1zBBGJzCnhInFy0mQlimbvEtqcHWSYw8i5gZFjF
	KJpamlxQnJSea6hXnJhbXJqXrpecn7uJERIVX3YwLj5mdYhRgINRiYf35PsZIUKsiWXFlbmH
	GCU4mJVEeF+KzwwR4k1JrKxKLcqPLyrNSS0+xMjEwSnVwOhydtkjbTbLOR/XTRKY4eqy5s3H
	Trapl2dP1nrNIyQZr/yS86gz80ybqgj98/E+hz7z3rS//VXY6prvBt8CmWnHbKuLOJ6y2e5p
	ez7x//TrFXX3Xth/FjXOK/i1q/x/gMvBZ5Z7A598M24Uz+VtYNCX8ncuiOQIS+i5KNpRVffX
	+Aq79fxmZyWW4oxEQy3mouJEAFwJB1doAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tomasz Figa <t.figa@samsung.com>

This patch adds device tree nodes for L2 cache controller present on
Exynos4 SoCs.

Signed-off-by: Tomasz Figa <t.figa@samsung.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Kukjin Kim <kgene.kim@samsung.com>
---
 arch/arm/boot/dts/exynos4210.dtsi |  9 +++++++++
 arch/arm/boot/dts/exynos4x12.dtsi | 14 ++++++++++++++
 2 files changed, 23 insertions(+)

diff --git a/arch/arm/boot/dts/exynos4210.dtsi b/arch/arm/boot/dts/exynos4210.dtsi
index bcc9e63c8070..8e45ea44317e 100644
--- a/arch/arm/boot/dts/exynos4210.dtsi
+++ b/arch/arm/boot/dts/exynos4210.dtsi
@@ -81,6 +81,15 @@
 		reg = <0x10023CA0 0x20>;
 	};
 
+	l2c: l2-cache-controller@10502000 {
+		compatible = "arm,pl310-cache";
+		reg = <0x10502000 0x1000>;
+		cache-unified;
+		cache-level = <2>;
+		arm,tag-latency = <2 2 1>;
+		arm,data-latency = <2 2 1>;
+	};
+
 	gic: interrupt-controller@10490000 {
 		cpu-offset = <0x8000>;
 	};
diff --git a/arch/arm/boot/dts/exynos4x12.dtsi b/arch/arm/boot/dts/exynos4x12.dtsi
index 93b70402e943..8bc97c415c9a 100644
--- a/arch/arm/boot/dts/exynos4x12.dtsi
+++ b/arch/arm/boot/dts/exynos4x12.dtsi
@@ -54,6 +54,20 @@
 		reg = <0x10023CA0 0x20>;
 	};
 
+	l2c: l2-cache-controller@10502000 {
+		compatible = "arm,pl310-cache";
+		reg = <0x10502000 0x1000>;
+		cache-unified;
+		cache-level = <2>;
+		arm,tag-latency = <2 2 1>;
+		arm,data-latency = <3 2 1>;
+		arm,double-linefill = <1>;
+		arm,double-linefill-incr = <0>;
+		arm,double-linefill-wrap = <1>;
+		arm,prefetch-drop = <1>;
+		arm,prefetch-offset = <7>;
+	};
+
 	clock: clock-controller@10030000 {
 		compatible = "samsung,exynos4412-clock";
 		reg = <0x10030000 0x20000>;
-- 
1.9.2

