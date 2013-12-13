Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139Ab3LMQjR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 11:39:17 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:39197 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753029Ab3LMQjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 11:39:11 -0500
X-AuditID: cbfee61a-b7f7e6d000005936-f5-52ab382efab0
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
        linux-samsung-soc@vger.kernel.org
Subject: [PATCH v11 4/7] cpufreq:exynos:Extend Exynos cpufreq driver to support
 boost framework
Date: Fri, 13 Dec 2013 17:38:34 +0100
Message-id: <1386952717-30947-5-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1386952717-30947-1-git-send-email-l.majewski@samsung.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1386952717-30947-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrALMWRmVeSWpSXmKPExsVy+t9jQV09i9VBBt++CVpsnLGe1eJp0w92
	i76fV5gt1uz/yWTRefYJs8WbR9wWbx5uZrS4vGsOm8Xn3iOMFjPO72OyuN24gs3izOlLrBZP
	HvaxWWz86uHA57F4z0smjzvX9rB5rJv2ltljy9V2Fo++LasYPY7f2M7k8XmTXAB7FJdNSmpO
	Zllqkb5dAlfGxA3d7AWz+CsefS9sYLzI08XIySEhYCLx+MxWdghbTOLCvfVsXYxcHEIC0xkl
	br3cwQLhdDFJrLm9FqyKTUBP4vPdp0wgCRGBJYwSr5sWsII4zAIbmSV2znwL1M/BISyQKPHl
	UgFIA4uAqsSjqSBhTg5eATeJrienmSDWKUp0P5sAFucUcJeYtmkVI8S2JkaJ51fuM05g5F3A
	yLCKUTS1ILmgOCk911CvODG3uDQvXS85P3cTIzhcn0ntYFzZYHGIUYCDUYmH16N3VZAQa2JZ
	cWXuIUYJDmYlEd4Q1dVBQrwpiZVVqUX58UWlOanFhxilOViUxHkPtFoHCgmkJ5akZqemFqQW
	wWSZODilGhibVkmYu4Wmf05+/f+C4bZNb9aarZX96BP2OyDPLHLX/WdM11Q8Xt6a9f/8NnnG
	ulnrZk84YZDDnWuZz/nbQv1sK5vaocm8br9Clun2PZ5fsineoGOZ5mKP7Qn/C/fxHJ2YzuC3
	LTZdOoJ3ZX35RZaMueaXSs6c+ngt4K7KBT8NlXVOrV63k1yVWIozEg21mIuKEwHfUdfRUwIA	AA==
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

