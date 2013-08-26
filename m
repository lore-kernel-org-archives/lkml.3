Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757225Ab3HZPwm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 11:52:42 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:24122 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757173Ab3HZPwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 11:52:07 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-9c-521b79a5b811
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
Subject: [PATCH v8 7/7] cpufreq:exynos4x12: Change L0 driver data to
 CPUFREQ_BOOST_FREQ
Date: Mon, 26 Aug 2013 17:50:43 +0200
Message-id: <1377532243-17076-8-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1377532243-17076-1-git-send-email-l.majewski@samsung.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1377532243-17076-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMLMWRmVeSWpSXmKPExsVy+t9jQd1lldJBBtOXM1tsnLGe1eJp0w92
	i3mfZS36fl5htliz/yeTRefZJ8wWvQuuslm8ecRt8ebhZkaLy7vmsFl87j3CaHG7cQWbRf/C
	XiaLJw/72Cw2fvVw4PdYvOclk8eda3vYPNZNe8vs0bdlFaPHo8UtjB7Hb2xn8vi8SS6APYrL
	JiU1J7MstUjfLoEr48yX9IIjHBVPJ81kbGDsZO9i5OSQEDCRaL/7mxXCFpO4cG89WxcjF4eQ
	wHRGibfn77BAOF1MErvav4J1sAnoSXy++5QJxBYRmMMoceeoO0gRs8ADZonF378wgiSEBSIl
	Pl0+wQZiswioSjybtBOsmVfATaJt0l9miHXyEk/v94HVcAq4S5zqewsWFxJoYpToXy8zgZF3
	ASPDKkbR1ILkguKk9FwjveLE3OLSvHS95PzcTYzgoH0mvYNxVYPFIUYBDkYlHt4ANukgIdbE
	suLK3EOMEhzMSiK8HKlAId6UxMqq1KL8+KLSnNTiQ4zSHCxK4rwHW60DhQTSE0tSs1NTC1KL
	YLJMHJxSDYzpa3zNs2Z5XMvp+rr1nMaLpW4Vz473peh0vzc6sfnlx/nux06eq/qScURr288v
	E1ZE3s09Z6hq5Mz6zmLhh1CLFWv1rzF7f9TjDp68oHKFkq9Wttsm77/J6w9onk9aw9A65czH
	nMOyUmalV9RLs38el5VlTFadcdzLcl9HX8v+A2tWV9/9NDdSiaU4I9FQi7moOBEAV75PBVYC	AAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Special driver data flag (CPUFREQ_BOOST_FREQ) has been added to indicate
frequency, which can be only enabled for BOOST mode.
This frequency shall be used only for limited time, since it might cause
target device to overheat.

Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

---
Changes for v8:
- None

Changes for v7:
- None

Changes for v6:
- New patch

 drivers/cpufreq/exynos4x12-cpufreq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpufreq/exynos4x12-cpufreq.c b/drivers/cpufreq/exynos4x12-cpufreq.c
index e270b42..367f600 100644
--- a/drivers/cpufreq/exynos4x12-cpufreq.c
+++ b/drivers/cpufreq/exynos4x12-cpufreq.c
@@ -32,7 +32,7 @@ static unsigned int exynos4x12_volt_table[] = {
 };
 
 static struct cpufreq_frequency_table exynos4x12_freq_table[] = {
-	{L0, CPUFREQ_ENTRY_INVALID},
+	{CPUFREQ_BOOST_FREQ, 1500 * 1000},
 	{L1, 1400 * 1000},
 	{L2, 1300 * 1000},
 	{L3, 1200 * 1000},
-- 
1.7.10.4

