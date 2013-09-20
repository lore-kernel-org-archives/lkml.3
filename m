Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752936Ab3ITQCM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 12:02:12 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:25913 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752909Ab3ITQCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 12:02:09 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-dc-523c71801530
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
        Myungjoo Ham <myungjoo.ham@samsung.com>, durgadoss.r@intel.com
Subject: [PATCH RESEND v8 7/7] cpufreq:exynos4x12: Change L0 driver data to
 CPUFREQ_BOOST_FREQ
Date: Fri, 20 Sep 2013 18:01:04 +0200
Message-id: <1379692864-4954-8-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1379692864-4954-1-git-send-email-l.majewski@samsung.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1379692864-4954-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLLMWRmVeSWpSXmKPExsVy+t9jAd2GQpsgg+v3RS02zljPavG06Qe7
	xbzPshZ9P68wW6zZ/5PJovPsE2aLN4+4Ld483MxocXnXHDaLz71HGC1uN65gs+hf2Mtk8eRh
	H5vFxq8eDnwei/e8ZPK4c20Pm8e6aW+ZPfq2rGL0eLS4hdHj+I3tTB6fN8kFsEdx2aSk5mSW
	pRbp2yVwZZz5kl5whKPi6aSZjA2MnexdjJwcEgImEnNPTWeGsMUkLtxbzwZiCwksYpSYOUW/
	i5ELyO5ikjj/bg0TSIJNQE/i892nYLaIwBxGiTtH3UFsZoFdzBKXLumC2MICCRKXz1xnBbFZ
	BFQlfl9sZwSxeQVcJZ79Xgy1WF7i6f0+sGWcAm4Sjz/PY4FY1sgo8XbWItYJjLwLGBlWMYqm
	FiQXFCel5xrpFSfmFpfmpesl5+duYgQH6jPpHYyrGiwOMQpwMCrx8D4IsQkSYk0sK67MPcQo
	wcGsJMJbWwAU4k1JrKxKLcqPLyrNSS0+xCjNwaIkznuw1TpQSCA9sSQ1OzW1ILUIJsvEwSnV
	wFjKPHHqFRmuJOlC2e3bhMOWTrvX1sV+pr9n/iPFNZkTX3XMTGZwmf95w2WNLYu554kuv+32
	NHX6gtU3Vq1dV/BRJejnmvTpGcd0FLzjNSq+B90xPGAZGSv879AC1c1fX1l78//RrjLX93hZ
	FTbprNEudfOax0Wve4XS+xQ3Sym4HuhhldL7q6fEUpyRaKjFXFScCAAYg/CGUAIAAA==
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

