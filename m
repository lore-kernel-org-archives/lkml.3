Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751695AbaEZDYr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 23:24:47 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:26989 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224AbaEZDXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 23:23:47 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-9e-5382b3bf813d
From: Tarek Dakhran <t.dakhran@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Mike Turquette <mturquette@linaro.org>,
        Vyacheslav Tyrtov <v.tyrtov@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Romain Naour <romain.naour@openwide.fr>,
        Chander Kashyap <chander.kashyap@linaro.org>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, Tarek Dakhran <t.dakhran@gmail.com>,
        Tarek Dakhran <t.dakhran@samsung.com>
Subject: [PATCH v11 1/3] ARM: EXYNOS: Add support for EXYNOS5410 SoC
Date: Mon, 26 May 2014 07:23:31 +0400
Message-id: <1401074613-29227-2-git-send-email-t.dakhran@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1401074613-29227-1-git-send-email-t.dakhran@samsung.com>
References: <1401074613-29227-1-git-send-email-t.dakhran@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCLMWRmVeSWpSXmKPExsVy+t/xq7r7NzcFG5w4YmUxad0BJouH62+y
	WMw/co7Vov/NQlaL/49es1qce7WS0aJ3wVU2i7NNb9gtNj2+xmqxsG0Ji8XlXXPYLGac38dk
	cfsyr8XS6xeZLJ5OuMhmMWH6WhaLdS+ns1i07j3CbrHlZwejxe+eT8wW65+fYrRYP+M1i8Wx
	GUsYLabO+MHuIOGxZt4aRo+W5h42j8t9vUwef1e9YPbYOesuu8fK5V/YPDat6mTzeLV6JqvH
	nWt72Dw2L6n3eHWNxaNvyypGj+3X5jF7fN4kF8AXxWWTkpqTWZZapG+XwJWxcdcL1oJ7IhWL
	L6xhamD8JtjFyMkhIWAi8ePkAyYIW0ziwr31bF2MXBxCAksZJdY9usEO4XQwSXRO7WLuYuTg
	YBPQltiywwukQURAQWJz7zNWkBpmgU9sEj9WNYFNEhZwkfh+vQ/MZhFQlZi27D07iM0r4CrR
	cG8f2BwJoOY5k2xAwpwCbhLrDpxjBLGFgEruHVjGOoGRdwEjwypG0dTS5ILipPRcI73ixNzi
	0rx0veT83E2MkJj6uoNx6TGrQ4wCHIxKPLwv8pqChVgTy4orcw8xSnAwK4nwXsgFCvGmJFZW
	pRblxxeV5qQWH2Jk4uCUamCcFl5hL7InhlFyxeX7NyO5Lim/WrH89UEV/0RHu39n5mc8sEif
	l+zDs3+t4YaE1ZWz/LO0G5792BQ5X3GirbbLA76uqnXyoZEH+w/7lc67xlKkzCV19LyLPnP9
	yp4A95fcL+IXLPkU2xPTW7XKrDrRupOp5ar8pMUsU6R/1P9ef+lq6NRHE7YqsRRnJBpqMRcV
	JwIA7jRAMYcCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

EXYNOS5410 is SoC in Samsung's Exynos5 SoC series.
Add initial support for this SoC.

Signed-off-by: Tarek Dakhran <t.dakhran@samsung.com>
Signed-off-by: Vyacheslav Tyrtov <v.tyrtov@samsung.com>
---
 arch/arm/mach-exynos/Kconfig  |    5 +++++
 arch/arm/mach-exynos/common.h |   12 ++++++++++--
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-exynos/Kconfig b/arch/arm/mach-exynos/Kconfig
index 15fa610..d58995c9 100644
--- a/arch/arm/mach-exynos/Kconfig
+++ b/arch/arm/mach-exynos/Kconfig
@@ -88,6 +88,11 @@ config SOC_EXYNOS5260
 	default y
 	depends on ARCH_EXYNOS5
 
+config SOC_EXYNOS5410
+	bool "SAMSUNG EXYNOS5410"
+	default y
+	depends on ARCH_EXYNOS5
+
 config SOC_EXYNOS5420
 	bool "SAMSUNG EXYNOS5420"
 	default y
diff --git a/arch/arm/mach-exynos/common.h b/arch/arm/mach-exynos/common.h
index 9eb6258..80b90e3 100644
--- a/arch/arm/mach-exynos/common.h
+++ b/arch/arm/mach-exynos/common.h
@@ -24,6 +24,7 @@
 #define EXYNOS4_CPU_MASK	0xFFFE0000
 
 #define EXYNOS5250_SOC_ID	0x43520000
+#define EXYNOS5410_SOC_ID	0xE5410000
 #define EXYNOS5420_SOC_ID	0xE5420000
 #define EXYNOS5440_SOC_ID	0xE5440000
 #define EXYNOS5800_SOC_ID	0xE5422000
@@ -42,6 +43,7 @@ IS_SAMSUNG_CPU(exynos4210, EXYNOS4210_CPU_ID, EXYNOS4_CPU_MASK)
 IS_SAMSUNG_CPU(exynos4212, EXYNOS4212_CPU_ID, EXYNOS4_CPU_MASK)
 IS_SAMSUNG_CPU(exynos4412, EXYNOS4412_CPU_ID, EXYNOS4_CPU_MASK)
 IS_SAMSUNG_CPU(exynos5250, EXYNOS5250_SOC_ID, EXYNOS5_SOC_MASK)
+IS_SAMSUNG_CPU(exynos5410, EXYNOS5410_SOC_ID, EXYNOS5_SOC_MASK)
 IS_SAMSUNG_CPU(exynos5420, EXYNOS5420_SOC_ID, EXYNOS5_SOC_MASK)
 IS_SAMSUNG_CPU(exynos5440, EXYNOS5440_SOC_ID, EXYNOS5_SOC_MASK)
 IS_SAMSUNG_CPU(exynos5800, EXYNOS5800_SOC_ID, EXYNOS5_SOC_MASK)
@@ -80,6 +82,12 @@ IS_SAMSUNG_CPU(exynos5800, EXYNOS5800_SOC_ID, EXYNOS5_SOC_MASK)
 # define soc_is_exynos5250()	0
 #endif
 
+#if defined(CONFIG_SOC_EXYNOS5410)
+# define soc_is_exynos5410()	is_samsung_exynos5410()
+#else
+# define soc_is_exynos5410()	0
+#endif
+
 #if defined(CONFIG_SOC_EXYNOS5420)
 # define soc_is_exynos5420()	is_samsung_exynos5420()
 #else
@@ -100,8 +108,8 @@ IS_SAMSUNG_CPU(exynos5800, EXYNOS5800_SOC_ID, EXYNOS5_SOC_MASK)
 
 #define soc_is_exynos4() (soc_is_exynos4210() || soc_is_exynos4212() || \
 			  soc_is_exynos4412())
-#define soc_is_exynos5() (soc_is_exynos5250() || soc_is_exynos5420() || \
-			  soc_is_exynos5800())
+#define soc_is_exynos5() (soc_is_exynos5250() || soc_is_exynos5410() || \
+			  soc_is_exynos5420() || soc_is_exynos5800())
 
 void mct_init(void __iomem *base, int irq_g0, int irq_l0, int irq_l1);
 
-- 
1.7.9.5

