Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757155Ab3HZPv7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 11:51:59 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:24103 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757127Ab3HZPv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 11:51:56 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-8a-521b799ad027
From: Lukasz Majewski <l.majewski@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Cc: "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>, durgadoss.r@intel.com
Subject: [PATCH v8 5/7] cpufreq:exynos:Extend Exynos cpufreq driver to support
 boost framework
Date: Mon, 26 Aug 2013 17:50:41 +0200
Message-id: <1377532243-17076-6-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1377532243-17076-1-git-send-email-l.majewski@samsung.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1377532243-17076-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMLMWRmVeSWpSXmKPExsVy+t9jQd1ZldJBBp87bCw2zljPavG06Qe7
	xbzPshZ9P68wW6zZ/5PJovPsE2aL3gVX2SzePOK2ePNwM6PF5V1z2Cw+9x5htLjduILNon9h
	L5PFk4d9bBYbv3o48Hss3vOSyePOtT1sHuumvWX26NuyitHj0eIWRo/jN7YzeXzeJBfAHsVl
	k5Kak1mWWqRvl8CVMbv3BWPBXf6KmU0PmRsYZ/J2MXJySAiYSGxrPMwGYYtJXLi3Hsjm4hAS
	mM4o8eLcFlYIp4tJ4uzek8wgVWwCehKf7z5lArFFBOYwStw56g5SxCzwgFli8fcvjCAJYYEE
	iaezpwPZHBwsAqoSR/clg4R5Bdwklpw+CbVNXuLp/T4wm1PAXeJU31uw+UICTYwS/etlJjDy
	LmBkWMUomlqQXFCclJ5rpFecmFtcmpeul5yfu4kRHLTPpHcwrmqwOMQowMGoxMMbwCYdJMSa
	WFZcmXuIUYKDWUmElyMVKMSbklhZlVqUH19UmpNafIhRmoNFSZz3YKt1oJBAemJJanZqakFq
	EUyWiYNTqoGRy+TI4lcV18qL9J++Tk1nnPI49PmnMpkNP6a/dnkxb86tu1Z1q55ksvoIOBw5
	n2zbss7Rqs9x1qLjVednfHuQcX/BSbYzWwwNt7ApLW9n/Rfw07jH9OC0vx3WnIcKL7y7LXrg
	15G3KqVf0mRm5pgbM+xdV3xW6k9jW827+rZ8jgV8h1MLDgapKrEUZyQaajEXFScCAD0R3IVW	AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cpufreq_driver's boost_supported flag is true only when boost
support is explicitly enabled. Boost related attributes are exported only
under the same condition.

Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

---
Changes for v8:
- None

Changes for v7:
- Replace CONFIG_CPU_FREQ_BOOST_SW with CONFIG_ARM_EXYNOS_CPU_FREQ_BOOST_SW
- Move boost_supported initialization to struct cpufreq_driver exynos_driver

Changes for v6:
- Replace exynos_driver.boost_supported = 1 to = true
- Protect boost attributes export with CONFIG_CPU_FREQ_BOOST_SW

Changes for v5:
- None

Changes for v4:
- None

Changes for v3:
- Remove low level boost code
- Move boost management code to cpufreq core code
- Use boost_supported flag to indicate if driver supports over clocking

Changes for v2:
- Removal of struct cpufreq_boost
- Removal of the CONFIG_CPU_FREQ_BOOST flag
- low_level_boost with valid address when boost is supported

 drivers/cpufreq/exynos-cpufreq.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/cpufreq/exynos-cpufreq.c b/drivers/cpufreq/exynos-cpufreq.c
index b9f9aee..2786aba 100644
--- a/drivers/cpufreq/exynos-cpufreq.c
+++ b/drivers/cpufreq/exynos-cpufreq.c
@@ -270,6 +270,9 @@ static int exynos_cpufreq_cpu_exit(struct cpufreq_policy *policy)
 
 static struct freq_attr *exynos_cpufreq_attr[] = {
 	&cpufreq_freq_attr_scaling_available_freqs,
+#ifdef CONFIG_ARM_EXYNOS_CPU_FREQ_BOOST_SW
+	&cpufreq_freq_attr_scaling_boost_freqs,
+#endif
 	NULL,
 };
 
@@ -282,6 +285,9 @@ static struct cpufreq_driver exynos_driver = {
 	.exit		= exynos_cpufreq_cpu_exit,
 	.name		= "exynos_cpufreq",
 	.attr		= exynos_cpufreq_attr,
+#ifdef CONFIG_ARM_EXYNOS_CPU_FREQ_BOOST_SW
+	.boost_supported = true,
+#endif
 #ifdef CONFIG_PM
 	.suspend	= exynos_cpufreq_suspend,
 	.resume		= exynos_cpufreq_resume,
-- 
1.7.10.4

