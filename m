Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756502Ab3JNMU6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 08:20:58 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:35791 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755914Ab3JNMTC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 08:19:02 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-97-525be1342a71
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
        Myungjoo Ham <myungjoo.ham@samsung.com>, durgadoss.r@intel.com
Subject: [PATCH v9 5/7] cpufreq:exynos:Extend Exynos cpufreq driver to support
 boost framework
Date: Mon, 14 Oct 2013 14:17:48 +0200
Message-id: <1381753070-2853-6-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1381753070-2853-1-git-send-email-l.majewski@samsung.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1381753070-2853-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDLMWRmVeSWpSXmKPExsVy+t9jAV2Th9FBBvs71S02zljPavG06Qe7
	Rd/PK8wWa/b/ZLLoPPuE2eLNI26LNw83M1pc3jWHzeJz7xFGi9uNK9gszpy+xGrx5GEfm8XG
	rx4OvB6L97xk8rhzbQ+bx7ppb5k9tlxtZ/Ho27KK0eP4je1MHp83yQWwR3HZpKTmZJalFunb
	JXBlXD18hLVgDl/F27ln2BsYP3B3MXJwSAiYSEz879fFyAlkiklcuLeerYuRi0NIYBGjxJyd
	x6GcLiaJbZtesYBUsQnoSXy++5QJJCEisIRR4nXTAlYQh1mgh1ni+PXtbCBVwgIJEnfvzGUE
	sVkEVCWmdM1hBbF5BVwl+pe/ZoPYJy/x9H4fmM0p4CZxatsGZoh1jYwS285tYJ3AyLuAkWEV
	o2hqQXJBcVJ6rpFecWJucWleul5yfu4mRnCYPpPewbiqweIQowAHoxIPr4BTdJAQa2JZcWXu
	IUYJDmYlEd6PV4FCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeQ+2WgcKCaQnlqRmp6YWpBbBZJk4
	OKUaGE2S57S7rU5J+cD764Bc4qq9S3sv9AkrTmO4/WLNmoPZl7UkXfgec7AsZsk71WUt+GH2
	m46l++eWdSs/uH9gcfOU4MqOVWGbtnhxaRydulJ6+7djP3ZzJ+TtyM8UuDn18svdgdZTMw7K
	rdJi8tx/8f5rp/anfxY6CW9115gne2HBnGmTCuYUXelQYinOSDTUYi4qTgQAe0U5Kk8CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cpufreq_driver's boost_supported flag is true only when boost
support is explicitly enabled.

Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

---
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
index b96fcc8..77a0aed 100644
--- a/drivers/cpufreq/exynos-cpufreq.c
+++ b/drivers/cpufreq/exynos-cpufreq.c
@@ -253,6 +253,9 @@ static struct cpufreq_driver exynos_driver = {
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

