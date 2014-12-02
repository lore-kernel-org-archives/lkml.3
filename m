Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544AbaLBIuj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 03:50:39 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:21895 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753545AbaLBIuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 03:50:11 -0500
X-AuditID: cbfee68d-f79296d000004278-14-547d7d38d1a7
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, mark.rutland@arm.com, marc.zyngier@arm.com,
        arnd@arndb.de, olof@lixom.net, catalin.marinas@arm.com,
        will.deacon@arm.com, s.nawrocki@samsung.com, tomasz.figa@gmail.com,
        kyungmin.park@samsung.com, inki.dae@samsung.com,
        chanho61.park@samsung.com, geunsik.lim@samsung.com,
        sw0312.kim@samsung.com, jh80.chung@samsung.com, cw00.choi@samsung.com,
        a.kesavan@samsung.com, pankaj.dubey@samsung.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 18/19] clocksource: exynos_mct: Add the support for Exynos
 64bit SoC
Date: Tue, 02 Dec 2014 17:49:55 +0900
Message-id: <1417510196-6714-19-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1417510196-6714-1-git-send-email-cw00.choi@samsung.com>
References: <1417510196-6714-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrEIsWRmVeSWpSXmKPExsWyRsSkRNeitjbE4PZ+OYvHaxYzWfyddIzd
	4v2yHkaLy/u1La5/ec5qMe+zrMX8I+dYLf5MaGWzmHR/AovFjV9trBa9C66yWZxtesNusenx
	NVaLy7vmsFnMOL8PaMadf2wWS69fZLI4df0zm8WirV/YLQ6/aWe1mDH5JZvF5k1TmS1W7frD
	aPHy4wkWBwmPNfPWMHr8/jWJ0WPnrLvsHneu7WHzeHfuHLvH5iX1HldONLF69G1ZxejxeZNc
	AGcUl01Kak5mWWqRvl0CV8bqf1vZCu7wVXy8fZexgXE3TxcjJ4eEgInE6e1bmSBsMYkL99az
	dTFycQgJLGWU2P1nFxtM0dzXH5ghEtMZJW5feAxV1cQksezwbHaQKjYBLYn9L26AdYgIOEs0
	TG1kAiliFjjEIrH8bztQgoNDWCBM4l+LEkgNi4CqxMJz88B6eQVcJR6seMoOsU1BYtnymawg
	NidQvOtMH1hcSMBF4lfrR3aQmRICWzgk7n+4wQIxSEDi2+RDLCDzJQRkJTYdYIaYIylxcMUN
	lgmMwgsYGVYxiqYWJBcUJ6UXGeoVJ+YWl+al6yXn525iBEbt6X/Pencw3j5gfYhRgINRiYf3
	5PmaECHWxLLiytxDjKZAGyYyS4km5wNTQ15JvKGxmZGFqYmpsZG5pZmSOK+i1M9gIYH0xJLU
	7NTUgtSi+KLSnNTiQ4xMHJxSDYwlz5rvlty90+fiJL9+Sv9128baec39bVdEDdzPb2Mw1vu/
	fZlH9s1dy39mtHkuqF2XKHixUWPe/JbpIX9crOqF/Z8tl51v0bNnW8w0JVX+bSIPt98LdTgi
	q1Q/TcaZd/K0IHe+xQ/7K3vcntgHp+y4/siDdeaG45N3srzxU9xyOcf5UeVrxedKLMUZiYZa
	zEXFiQCp3/0f1QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphleLIzCtJLcpLzFFi42I5/e+xoK5FbW2IwelXIhaP1yxmsvg76Ri7
	xftlPYwWl/drW1z/8pzVYt5nWYv5R86xWvyZ0MpmMen+BBaLG7/aWC16F1xlszjb9IbdYtPj
	a6wWl3fNYbOYcX4f0Iw7/9gsll6/yGRx6vpnNotFW7+wWxx+085qMWPySzaLzZumMlus2vWH
	0eLlxxMsDhIea+atYfT4/WsSo8fOWXfZPe5c28Pm8e7cOXaPzUvqPa6caGL16NuyitHj8ya5
	AM6oBkabjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKBv
	lRTKEnNKgUIBicXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZoIGENYwZq/9tZSu4w1fx8fZdxgbG
	3TxdjJwcEgImEnNff2CGsMUkLtxbz9bFyMUhJDCdUeL2hcdQThOTxLLDs9lBqtgEtCT2v7jB
	BmKLCDhLNExtZAIpYhY4xCKx/G87UIKDQ1ggTOJfixJIDYuAqsTCc/PAenkFXCUerHjKDrFN
	QWLZ8pmsIDYnULzrTB9YXEjAReJX60f2CYy8CxgZVjGKphYkFxQnpeca6hUn5haX5qXrJefn
	bmIEp4RnUjsYVzZYHGIU4GBU4uE9cb4mRIg1say4MvcQowQHs5II7y/j2hAh3pTEyqrUovz4
	otKc1OJDjKZAV01klhJNzgemq7ySeENjEzMjSyNzQwsjY3Mlcd4bN3NDhATSE0tSs1NTC1KL
	YPqYODilGhiz62Y7WTXtulK+x8y947X/72xGkw/sT/b3rXL9tN4isNxl8cHFMYY/G2adnay1
	pXf1ibdquf+LbjVyXM2OS/6/QWYqc3HU3MfvDywW4PLb9C+7aObfbGN20W3C/4Vu3oheH/m0
	QeCLpUujTexlwwzO0uP8qrf9RAsY/IT+rLFTV9CLU93/LV+JpTgj0VCLuag4EQDmVrPsHwMA	AA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the support for Exynos 64bit SoC. The delay_timer is only used
for Exynos 32bit SoC.

Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 drivers/clocksource/Kconfig      | 1 -
 drivers/clocksource/exynos_mct.c | 4 ++++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
index 9042060..27ef3fa 100644
--- a/drivers/clocksource/Kconfig
+++ b/drivers/clocksource/Kconfig
@@ -134,7 +134,6 @@ config CLKSRC_METAG_GENERIC
 
 config CLKSRC_EXYNOS_MCT
 	def_bool y if ARCH_EXYNOS
-	depends on !ARM64
 	help
 	  Support for Multi Core Timer controller on Exynos SoCs.
 
diff --git a/drivers/clocksource/exynos_mct.c b/drivers/clocksource/exynos_mct.c
index 9403061..b840ea1 100644
--- a/drivers/clocksource/exynos_mct.c
+++ b/drivers/clocksource/exynos_mct.c
@@ -223,6 +223,7 @@ static u64 notrace exynos4_read_sched_clock(void)
 	return exynos4_read_count_32();
 }
 
+#if defined(CONFIG_ARM)
 static struct delay_timer exynos4_delay_timer;
 
 static cycles_t exynos4_read_current_timer(void)
@@ -231,14 +232,17 @@ static cycles_t exynos4_read_current_timer(void)
 			 "cycles_t needs to move to 32-bit for ARM64 usage");
 	return exynos4_read_count_32();
 }
+#endif
 
 static void __init exynos4_clocksource_init(void)
 {
 	exynos4_mct_frc_start();
 
+#if defined(CONFIG_ARM)
 	exynos4_delay_timer.read_current_timer = &exynos4_read_current_timer;
 	exynos4_delay_timer.freq = clk_rate;
 	register_current_timer_delay(&exynos4_delay_timer);
+#endif
 
 	if (clocksource_register_hz(&mct_frc, clk_rate))
 		panic("%s: can't register clocksource\n", mct_frc.name);
-- 
1.8.5.5

