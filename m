Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422813Ab3LTOZi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 09:25:38 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:64390 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422787Ab3LTOZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 09:25:33 -0500
X-AuditID: cbfee61a-b7fb26d00000724f-ac-52b4535b0c8d
From: Lukasz Majewski <l.majewski@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Cc: "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>, durgadoss.r@intel.com,
        Zhang Rui <rui.zhang@intel.com>, linux-samsung-soc@vger.kernel.org
Subject: [PATCH v12 4/7] cpufreq:exynos:Extend Exynos cpufreq driver to support
 boost framework
Date: Fri, 20 Dec 2013 15:24:52 +0100
Message-id: <1387549495-809-5-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1387549495-809-1-git-send-email-l.majewski@samsung.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1387549495-809-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrALMWRmVeSWpSXmKPExsVy+t9jQd3o4C1BBmsnWllsnLGe1eJp0w92
	i76fV5gt1uz/yWTRefYJs8WbR9wWbx5uZrS4vGsOm8Xn3iOMFjPO72OyuN24gs3izOlLrBZP
	HvaxWWz86uHA57F4z0smjzvX9rB5rJv2ltljy9V2Fo++LasYPY7f2M7k8XmTXAB7FJdNSmpO
	Zllqkb5dAldG55o5jAXb+Ct+7jzP0sD4hKeLkZNDQsBEYv7Ft8wQtpjEhXvr2boYuTiEBKYz
	SiyZ/ooRwuliktj86gc7SBWbgJ7E57tPmUBsEYFmRolbz/1AipgFLjFLdCy9CjZKWCBR4u6J
	FlYQm0VAVWL20iVgzbwCLhKTH5+HWqco0f1sAhuIzSngKrF67R1GEFtIoIFRommj6gRG3gWM
	DKsYRVMLkguKk9JzDfWKE3OLS/PS9ZLzczcxgsP1mdQOxpUNFocYBTgYlXh4G2w3BwmxJpYV
	V+YeYpTgYFYS4f3ssyVIiDclsbIqtSg/vqg0J7X4EKM0B4uSOO+BVutAIYH0xJLU7NTUgtQi
	mCwTB6dUA2P3JPP93RvnuO/89ad4hsdn2bUdQikmy2e79hn+fm35eJpQ1dM7c35kSgccFuLM
	FWZY5xg328WW/8u0CT0PXp+59tln9b81gZJLD5/5zde1JoT5oW5wyKqlD+/XzGnf06fv91Vq
	29dHC817JPclKtfl+MasEmucM7HnfsjVVtWGQzvnhNj2rtysxFKckWioxVxUnAgAeVPWeFMC	AAA=
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
Changes for v12:
- None

Changes for v11:
- None

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
index f3c2287..3cd6d2e 100644
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

