Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859AbbAEMTm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 07:19:42 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:44743 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753694AbbAEMTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 07:19:25 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-9d-54aa814c073d
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
Subject: [PATCH v11 9/9] ARM: dts: exynos4: Add nodes for L2 cache controller
Date: Mon, 05 Jan 2015 13:19:08 +0100
Message-id: <1420460348-20302-10-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.9.2
In-reply-to: <1420460348-20302-1-git-send-email-m.szyprowski@samsung.com>
References: <1420460348-20302-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOLMWRmVeSWpSXmKPExsVy+t/xK7o+jatCDPYvVLf4O+kYu8Wj+Y+Z
	LXoXXGWz+Hp4BaPF2aY37BbbO2ewW0z5s5zJYtPja6wWl3fNYbOYvaSfxWLG+X1MFrcv81qc
	276FxWLtkbvsFkuvX2SyePPjLJPFqeuf2SxW7frDaLH/ipeDsMeaeWsYPVqae9g8fv+axOjx
	7eskFo/Lfb1MHou+Z3nsnHWX3ePOtT1sHpuX1HtcOdHE6tG3ZRWjx/Eb25k8Pm+SC+CN4rJJ
	Sc3JLEst0rdL4Mq4u+wge8Ekvoo7n1qZGhhvcXcxcnJICJhILPjynxHCFpO4cG89WxcjF4eQ
	wFJGiZ4Pv5kgnD4miak3fjGBVLEJGEp0ve1iA7FFBNwk/q07BNbBLDCNRWLTkfPMIAlhAV+J
	tiNHwIpYBFQlOmdMAmvmFfCU2PnzCivEOjmJ/y9XgMU5geJL9+5jB7GFBDwkztxayz6BkXcB
	I8MqRtHU0uSC4qT0XCO94sTc4tK8dL3k/NxNjJDI+LqDcekxq0OMAhyMSjy8HidWhgixJpYV
	V+YeYpTgYFYS4X2VvipEiDclsbIqtSg/vqg0J7X4ECMTB6dUA2P+y/lLH66oC/H4fLv1/2nL
	Cb1BpuHbzeuq5rBu5pPwlFyYvfftndUzu3T3nr32f8VMtVd1k1ZPevSmLnVmhnx6sUfC2gAF
	6WuOSjq33lTcNJ5admIuw/5/iXZn2DXL5q9nrPi/YdGvlUvOHi9jOi6w4EuEX0eYZo/a0v9N
	Zb6O6/ab1Vvly2cpsRRnJBpqMRcVJwIASCspoWoCAAA=
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

