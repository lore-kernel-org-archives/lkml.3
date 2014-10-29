Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756525AbaJ2JXx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 05:23:53 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:62599 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756404AbaJ2JXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 05:23:20 -0400
X-AuditID: cbfec7f4-b7f6c6d00000120b-f1-5450b2019e2c
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, lauraa@codeaurora.org,
        linux-omap@vger.kernel.org, linus.walleij@linaro.org, tony@atomide.com,
        drake@endlessm.com, loeliger@gmail.com,
        Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH v7 8/8] ARM: dts: exynos4: Add nodes for L2 cache controller
Date: Wed, 29 Oct 2014 10:23:01 +0100
Message-id: <1414574581-2320-9-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.9.2
In-reply-to: <1414574581-2320-1-git-send-email-m.szyprowski@samsung.com>
References: <1414574581-2320-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrILMWRmVeSWpSXmKPExsVy+t/xy7qMmwJCDG591LB4NP8xs0Xvgqts
	Fmeb3rBbbO+cwW4x5c9yJotNj6+xWlzeNYfNYvaSfhaLGef3MVncvsxrcW77FhaLtUfuslss
	vX6RyWLVrj+MFvuveDnwe6yZt4bRo6W5h83j29dJLB6X+3qZPBZ9z/LYOesuu8eda3vYPDYv
	qffo27KK0ePzJrkArigum5TUnMyy1CJ9uwSujBWr17MW7Oat6PuS3cDYy93FyMkhIWAise7Y
	PRYIW0ziwr31bF2MXBxCAksZJRZd+sEEkhAS6GOSuNbqD2KzCRhKdL3tYgOxRQSyJX58m8wC
	0sAs0McscX56D3MXIweHsICPxJVZXiA1LAKqEhMXf2IFsXkF3CV2LjnLBrFMTuL/yxVg8zkF
	PCRWX1jCBrHLXWLj4W62CYy8CxgZVjGKppYmFxQnpeca6hUn5haX5qXrJefnbmKEBPOXHYyL
	j1kdYhTgYFTi4dXY7R8ixJpYVlyZe4hRgoNZSYR3h3lAiBBvSmJlVWpRfnxRaU5q8SFGJg5O
	qQbG+N2pzccfPmphlYiz3fR7v0pP8GS2pu9uEw0/SPdqy1k9OjY9um5/f5Wa8H9xtdubuNZF
	b95acEF31cIvskdOS+rLXa8+/fJUo8e7FfsmnWKwu1Gw4GjYYlW3+AkJPXtmXT/9+li5Xuvi
	7lO39/TN3BexzMKxkeWWXlNZ08/KWXpfMoxYhfnYlViKMxINtZiLihMBTPUUykQCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tomasz Figa <t.figa@samsung.com>

This patch adds device tree nodes for L2 cache controller present on
Exynos4 SoCs.

Signed-off-by: Tomasz Figa <t.figa@samsung.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 arch/arm/boot/dts/exynos4210.dtsi |  9 +++++++++
 arch/arm/boot/dts/exynos4x12.dtsi | 14 ++++++++++++++
 2 files changed, 23 insertions(+)

diff --git a/arch/arm/boot/dts/exynos4210.dtsi b/arch/arm/boot/dts/exynos4210.dtsi
index 536a747a8632..8b97f10f0926 100644
--- a/arch/arm/boot/dts/exynos4210.dtsi
+++ b/arch/arm/boot/dts/exynos4210.dtsi
@@ -64,6 +64,15 @@
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
index 50b3c3f51e90..3e806d63e8bb 100644
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

