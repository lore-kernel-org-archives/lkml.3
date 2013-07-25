Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756713Ab3GYQe4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 12:34:56 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:58635 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756659Ab3GYQeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 12:34:37 -0400
X-AuditID: cbfee61a-b7f196d000007dfa-b3-51f1539b2d55
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
Subject: [PATCH v6 8/8] cpufreq:exynos4x12: Change L0 driver data to
 CPUFREQ_BOOST_FREQ
Date: Thu, 25 Jul 2013 18:33:31 +0200
Message-id: <1374770011-22171-9-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1374770011-22171-1-git-send-email-l.majewski@samsung.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1374770011-22171-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCLMWRmVeSWpSXmKPExsVy+t9jQd05wR8DDTYeZ7fYOGM9q8XTph/s
	FvM+y1r0/bzCbLFm/08mi86zT5gtehdcZbN484jb4s3DzYwWl3fNYbP43HuE0eJ24wo2i/6F
	vUwWTx72sVls/OrhwO+xeM9LJo871/aweayb9pbZo2/LKkaPR4tbGD2O39jO5PF5k1wAexSX
	TUpqTmZZapG+XQJXRuczu4I77BW3/q1iamDcwdbFyMkhIWAiMXfGAmYIW0ziwr31QHEuDiGB
	6YwSa2ctZ4JwupgkFqycC1bFJqAn8fnuUyYQW0RgDqPEnaPuIEXMAg+YJRZ//8IIkhAWiJQ4
	sGolO4jNIqAqcfpXGwuIzSvgJnH42g9WiHXyEk/v94GdwSngLjFh8hRGiG1NjBL/btxlnsDI
	u4CRYRWjaGpBckFxUnquoV5xYm5xaV66XnJ+7iZGcNg+k9rBuLLB4hCjAAejEg+vgtPHQCHW
	xLLiytxDjBIczEoivOaWQCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8B1qtA4UE0hNLUrNTUwtS
	i2CyTBycUg2MCbF+iwUk9T+8KWKNKd7JyFE0UaZCnXnRor3vg6dn+Ux7ctxnupDHnP3LmPfP
	3zpv4rEpDmJ3z4naC19I1otSsg99sefovGvzdgSr/bTrtCxd7nO7b+4utzc2nSGHNS4Z+U02
	8r/sybhSO3BNl19sW+4m1pjbJvEMyZFrjkdMnXS7yC36XCOHEktxRqKhFnNRcSIAZo3y4lcC	AAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Special driver data flag (CPUFREQ_BOOST_FREQ) has been added to indicate
frequency, which can be only enabled for BOOST mode.
This frequency shall be used only for limited time, since it might cause
target device to overheat.

Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>

---
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

