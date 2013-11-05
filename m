Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755396Ab3KER1j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 12:27:39 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:53202 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755372Ab3KER1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 12:27:35 -0500
X-AuditID: cbfee61b-b7fd56d000001fc6-b0-52792a85d8a8
From: Lukasz Majewski <l.majewski@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Cc: "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>, durgadoss.r@intel.com,
        Amit Daniel Kachhap <amit.daniel@samsung.com>
Subject: [PATCH v10 4/7] cpufreq:exynos:Extend Exynos cpufreq driver to support
 boost framework
Date: Tue, 05 Nov 2013 18:26:48 +0100
Message-id: <1383672411-26324-5-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1383672411-26324-1-git-send-email-l.majewski@samsung.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1383672411-26324-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPLMWRmVeSWpSXmKPExsVy+t9jQd1Wrcoggw2nlSwaroZYbJyxntXi
	adMPdou+n1eYLdbs/8lk0Xn2CbPFm0fcFm8ebma0uLxrDpvF594jjBa3G1ewWZw5fYnV4snD
	PjaLjV89HPg8Fu95yeRx59oeNo91094ye2y52s7i0bdlFaPH8RvbmTw+b5ILYI/isklJzcks
	Sy3St0vgyli6dzdzwT++iu/7OtgbGPfxdDFyckgImEi8aDnFBGGLSVy4t56ti5GLQ0hgOqPE
	1tWnWUESQgJdTBLn/5qA2GwCehKf7z5lAikSEVjCKPG6aQEriMMssJdZYtKftWAdwgKJEq1L
	tgBVcXCwCKhK3HjJCRLmFXCTmPnlJQvENnmJp/f72EBsTgF3iR2z9kJtbmKUeHN7AtMERt4F
	jAyrGEVTC5ILipPSc430ihNzi0vz0vWS83M3MYKD9Zn0DsZVDRaHGAU4GJV4eBPkK4OEWBPL
	iitzDzFKcDArifAe+18RJMSbklhZlVqUH19UmpNafIhRmoNFSZz3YKt1oJBAemJJanZqakFq
	EUyWiYNTqoFR4vOcPjZHu2fdp79vLbH9FZmXyXptCePM2KmHnGbpWtWcunc+InNPGs+ZC4lM
	N1kXvOQ6K1yemNe/XYl1lt6kCRovL8Yr5O064f1r+wOV1jPZ0s4/pv1YsMNf7s+bTL33Jxes
	fsX8/XJkxC/7kyK6HSsyta7NWx3fb7R92iW/prLvgp+fPTq1QYmlOCPRUIu5qDgRAJl65AZS	AgAA
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
Changes for v10:
- None

Changes for v9:
- The exynos_cpufreq_attr[] has been replaced by generic_cpufreq_attr[],
  therefore the cpufreq_freq_attr_scaling_boost_freqs is now added at
  freq_table.c file.

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

 drivers/cpufreq/exynos-cpufreq.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/cpufreq/exynos-cpufreq.c b/drivers/cpufreq/exynos-cpufreq.c
index 7b6dc06..0c8d101 100644
--- a/drivers/cpufreq/exynos-cpufreq.c
+++ b/drivers/cpufreq/exynos-cpufreq.c
@@ -226,6 +226,9 @@ static struct cpufreq_driver exynos_driver = {
 	.exit		= cpufreq_generic_exit,
 	.name		= "exynos_cpufreq",
 	.attr		= cpufreq_generic_attr,
+#ifdef CONFIG_ARM_EXYNOS_CPU_FREQ_BOOST_SW
+	.boost_supported = true,
+#endif
 #ifdef CONFIG_PM
 	.suspend	= exynos_cpufreq_suspend,
 	.resume		= exynos_cpufreq_resume,
-- 
1.7.10.4

