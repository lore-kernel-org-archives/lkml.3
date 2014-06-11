Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932951AbaFKPba (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 11:31:30 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:52789 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755748AbaFKPag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 11:30:36 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-3e-53987619f6dc
From: Tomasz Figa <t.figa@samsung.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        Laura Abbott <lauraa@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>, Robin Holt <holt@sgi.com>,
        Russell King <linux@arm.linux.org.uk>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Tony Lindgren <tony@atomide.com>, Tomasz Figa <tomasz.figa@gmail.com>,
        Tomasz Figa <t.figa@samsung.com>
Subject: [PATCH 5/5] ARM: dts: exynos4: Add nodes for L2 cache controller
Date: Wed, 11 Jun 2014 17:30:12 +0200
Message-id: <1402500612-4778-6-git-send-email-t.figa@samsung.com>
X-Mailer: git-send-email 1.9.3
In-reply-to: <1402500612-4778-1-git-send-email-t.figa@samsung.com>
References: <1402500612-4778-1-git-send-email-t.figa@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBLMWRmVeSWpSXmKPExsVy+t/xy7qSZTOCDZp+Klv0T+tgtehdcJXN
	YnvnDHaLKX+WM1lsenyN1eLyrjlsFrOX9LNYzDi/j8ni9mVei9d9a5gt1s94zWKxatcfRov9
	V7wceD1amnvYPL59ncTicbmvl8lj56y77B53ru1h89i8pN6jb8sqRo+7118yeRy/sZ3J4/Mm
	uQCuKC6blNSczLLUIn27BK6MRTNYC6ZzV0yfc5yxgXEKZxcjJ4eEgInEjrsb2CBsMYkL99aD
	2UICSxklth017mLkArL7mCQaLj9mAUmwCahJfG54BFYkIqAq8bltATtIEbPAXmaJMzNuMIIk
	hAU8JZZd3cEEYrMAFU3fMR+omYODV8BRom1TEMQyOYnebW+YQWxOASeJp5d7GSEWO0qsWn+R
	eQIj7wJGhlWMoqmlyQXFSem5RnrFibnFpXnpesn5uZsYIaH7dQfj0mNWhxgFOBiVeHgN/KcF
	C7EmlhVX5h5ilOBgVhLhLSicESzEm5JYWZValB9fVJqTWnyIkYmDU6qBcdOaXVYKW1duMDiZ
	tJDr6knjNBvLLyU/iyKWJkjzRobn/O1nXed3rMdp6cNDmzwulUe6VJysKrz6OPtUypo0YdOQ
	jn6G5qeblA2Mo/aX2203iu1Zkbruoubbi7vjbIT+963Z0q4myCvybnpQlcxpuV+8BteCNjae
	zj4/S4bthH5DbHRb5MpLSizFGYmGWsxFxYkAU+6iUDsCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds device tree nodes for L2 cache controller present on
Exynos4 SoCs.

Signed-off-by: Tomasz Figa <t.figa@samsung.com>
---
 arch/arm/boot/dts/exynos4210.dtsi | 9 +++++++++
 arch/arm/boot/dts/exynos4x12.dtsi | 9 +++++++++
 2 files changed, 18 insertions(+)

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
index c5a943d..9487f9c 100644
--- a/arch/arm/boot/dts/exynos4x12.dtsi
+++ b/arch/arm/boot/dts/exynos4x12.dtsi
@@ -60,6 +60,15 @@
 		reg = <0x10023CA0 0x20>;
 	};
 
+	l2c: l2-cache-controller@10502000 {
+		compatible = "arm,pl310-cache";
+		reg = <0x10502000 0x1000>;
+		cache-unified;
+		cache-level = <2>;
+		arm,tag-latency = <2 2 1>;
+		arm,data-latency = <3 2 1>;
+	};
+
 	clock: clock-controller@10030000 {
 		compatible = "samsung,exynos4412-clock";
 		reg = <0x10030000 0x20000>;
-- 
1.9.3

