Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619AbaJ0LHh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 07:07:37 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:31377 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191AbaJ0LGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 07:06:03 -0400
X-AuditID: cbfec7f5-b7f956d000005ed7-00-544e2718f2c2
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, lauraa@codeaurora.org,
        linux-omap@vger.kernel.org, linus.walleij@linaro.org,
        santosh.shilimkar@ti.com, tony@atomide.com, drake@endlessm.com,
        loeliger@gmail.com, Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH v6 7/7] ARM: dts: exynos4: Add nodes for L2 cache controller
Date: Mon, 27 Oct 2014 12:05:50 +0100
Message-id: <1414407950-3029-8-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.9.2
In-reply-to: <1414407950-3029-1-git-send-email-m.szyprowski@samsung.com>
References: <1414407950-3029-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDLMWRmVeSWpSXmKPExsVy+t/xK7oS6n4hBqumCls8mv+Y2aJ3wVU2
	i7NNb9gttnfOYLeY8mc5k8Wmx9dYLS7vmsNmMXtJP4vFjPP7mCxuX+a1OLd9C4vF2iN32S2W
	Xr/IZPG6bw2zxapdfxgt9l/xchDwWDNvDaNHS3MPm8e3r5NYPC739TJ5LPqe5bFz1l12jzvX
	9rB5bF5S79G3ZRWjx/Eb25k8Pm+SC+CO4rJJSc3JLEst0rdL4MpYsXo9a8Fu3oq+L9kNjL3c
	XYwcHBICJhItf9y7GDmBTDGJC/fWs3UxcnEICSxllPjWcIMZwuljkvjUtIMRpIpNwFCi620X
	G4gtIpAt8ePbZBaQImaBVcwSUw6sYwVJCAv4SLzYPgesgUVAVWLnzNNgNq+Au0TLxtnMEOvk
	JP6/XMEEYnMKeEhMbpkJZgsB1az6sJdxAiPvAkaGVYyiqaXJBcVJ6blGesWJucWleel6yfm5
	mxghIf51B+PSY1aHGAU4GJV4eCcU+4YIsSaWFVfmHmKU4GBWEuF1/AkU4k1JrKxKLcqPLyrN
	SS0+xMjEwSnVwCiYNkFV+f23YwdDpwl7S+rel7Fwlr1SmTfp3C/3Fvndsmtbzl+wkKjIqWXv
	YlQ64WCdtkd4z1dltf5t97Z/nvP/waN5Pd43+j1zjZ3WOusdD3KdeTBa6NCXwgy5HYH8b16v
	lkq8kXsge93tLs8nEWzOv/3ersyXDOVJ9Vlt+qA9e11SbvPTOUosxRmJhlrMRcWJAIxYbANP	AgAA
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

