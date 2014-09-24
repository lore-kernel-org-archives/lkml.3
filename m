Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549AbaIXLF7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 07:05:59 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:41349 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753417AbaIXLFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 07:05:54 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-4e-5422a58ff6e4
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
        loeliger@gmail.com
Subject: [PATCH v5 7/7] ARM: dts: exynos4: Add nodes for L2 cache controller
Date: Wed, 24 Sep 2014 13:05:41 +0200
Message-id: <1411556741-5810-8-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.9.2
In-reply-to: <1411556741-5810-1-git-send-email-m.szyprowski@samsung.com>
References: <1411556741-5810-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrILMWRmVeSWpSXmKPExsVy+t/xa7r9S5VCDKYftrB4NP8xs0Xvgqts
	Fmeb3rBbbO+cwW4x5c9yJotNj6+xWlzeNYfNYvaSfhaLGef3MVncvsxrcW77FhaLtUfuslu8
	7lvDbLFq1x9Gi/1XvBz4PVqae9g8vn2dxOJxua+XyWPR9yyPnbPusnvcubaHzWPzknqPvi2r
	GD2O39jO5PF5k1wAVxSXTUpqTmZZapG+XQJXRvsn3oLdvBUbdts2MPZydzFyckgImEgcPPmb
	FcIWk7hwbz1bFyMXh5DAUkaJ71sWQjl9TBKT3i0Cq2ITMJToetvFBmKLCGRL/Pg2mQWkiFmg
	lVni8ZNvYEXCAj4SPx9MZwaxWQRUJTr33WAHsXkF3CX+vfzABrFOTuL/yxVMIDangIfE48f/
	GLsYOYC2uUs0bXKZwMi7gJFhFaNoamlyQXFSeq6hXnFibnFpXrpecn7uJkZIMH/Zwbj4mNUh
	RgEORiUe3gniSiFCrIllxZW5hxglOJiVRHhf9QCFeFMSK6tSi/Lji0pzUosPMTJxcEo1MPq0
	zHJjOszeJZWfdkt//bVvBf58Uu9MP9zgnFAlltbcmrEtJMh1Rg3nFs2LWa9OXD+kdCZistzS
	L6IP45tO7J1YceKx/kf91b2p9QztWn/tZsnPiOLn2M7x56q7ZsD620/uf2iMNWRn9p20/lX7
	ppRljDMu3i4wL7ryr+/kQm73bW4zv9WdP6TEUpyRaKjFXFScCADxUuS5RAIAAA==
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
index b31315fc0afa..3b8e094144e6 100644
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
index 771412e7c06c..6ee773921559 100644
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

