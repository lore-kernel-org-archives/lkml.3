Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757084AbaFYNjh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 09:39:37 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:30113 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756736AbaFYNiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 09:38:20 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-5f-53aad0cbb721
From: Tomasz Figa <t.figa@samsung.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        Laura Abbott <lauraa@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Tony Lindgren <tony@atomide.com>, Tomasz Figa <tomasz.figa@gmail.com>,
        Daniel Drake <drake@endlessm.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>
Subject: [PATCH v2 6/6] ARM: dts: exynos4: Add nodes for L2 cache controller
Date: Wed, 25 Jun 2014 15:37:31 +0200
Message-id: <1403703451-12233-7-git-send-email-t.figa@samsung.com>
X-Mailer: git-send-email 1.9.3
In-reply-to: <1403703451-12233-1-git-send-email-t.figa@samsung.com>
References: <1403703451-12233-1-git-send-email-t.figa@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHLMWRmVeSWpSXmKPExsVy+t/xK7qnL6wKNjh8ndXi0fzHzBa9C66y
	WWzvnMFuMeXPciaLTY+vsVpc3jWHzWL2kn4Wixnn9zFZ3L7Ma7H2yF12i9d9a5gt1s94zWKx
	atcfRov9V7wc+DxamnvYPL59ncTicbmvl8lj0fcsj52z7rJ73Lm2h81j85J6j74tqxg9jt/Y
	zuTxeZNcAFcUl01Kak5mWWqRvl0CV8bFnk7WgoM8FdOuvGNsYJzP1cXIySEhYCJxrLmdGcIW
	k7hwbz1bFyMXh5DAUkaJSefusUA4fUwSa6/cYAOpYhNQk/jc8AjMFhFQlfjctoAdpIhZoIFF
	4krrdbCEsICPxNRdK8HGsgAVrZ09j7WLkYODV8BJouWbMMQ2OYnebW/ASjgFnCUuzPvDCmIL
	AZXMe3KEcQIj7wJGhlWMoqmlyQXFSem5hnrFibnFpXnpesn5uZsYIWH8ZQfj4mNWhxgFOBiV
	eHgDeFYFC7EmlhVX5h5ilOBgVhLhdd8PFOJNSaysSi3Kjy8qzUktPsTIxMEp1cDoZ/7I/MaG
	zRIed39NV9zkd1yxbHZmh6pLzYcXcW2/l0316k0MvSa74senTa0yIWrXWLOWzjNlO+PyxbLd
	XCGu/6pG7oJl3Wa82z+rnVz2d61BtfzraFlBuwK9az+0j9uJ3EudXPBCcemKK/Lup4wePaoW
	0J7bdyfC+tqPycyTd7AcK20zOy6jxFKckWioxVxUnAgAJlbnh0ECAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds device tree nodes for L2 cache controller present on
Exynos4 SoCs.

Signed-off-by: Tomasz Figa <t.figa@samsung.com>
---
 arch/arm/boot/dts/exynos4210.dtsi |  9 +++++++++
 arch/arm/boot/dts/exynos4x12.dtsi | 14 ++++++++++++++
 2 files changed, 23 insertions(+)

diff --git a/arch/arm/boot/dts/exynos4210.dtsi b/arch/arm/boot/dts/exynos4210.dtsi
index ee3001f..99970ab 100644
--- a/arch/arm/boot/dts/exynos4210.dtsi
+++ b/arch/arm/boot/dts/exynos4210.dtsi
@@ -54,6 +54,15 @@
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
index c5a943d..ddffefe 100644
--- a/arch/arm/boot/dts/exynos4x12.dtsi
+++ b/arch/arm/boot/dts/exynos4x12.dtsi
@@ -60,6 +60,20 @@
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
1.9.3

