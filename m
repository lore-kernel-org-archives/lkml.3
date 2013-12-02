Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974Ab3LBMUr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 07:20:47 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:57453 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753894Ab3LBMUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 07:20:03 -0500
X-AuditID: cbfee61a-b7f316d000007e34-d0-529c7af0fd0e
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
Subject: [PATCH RESEND v10 6/7] cpufreq:exynos4x12: Change L0 driver data to
 CPUFREQ_BOOST_FREQ
Date: Mon, 02 Dec 2013 13:19:20 +0100
Message-id: <1385986761-17934-7-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1385986761-17934-1-git-send-email-l.majewski@samsung.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1385986761-17934-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrELMWRmVeSWpSXmKPExsVy+t9jQd0PVXOCDM5tNrPYOGM9q8XTph/s
	Fn0/rzBbrNn/k8mi8+wTZos3j7gt3jzczGhxedccNovPvUcYLWac38dkcbtxBZvFmdOXWC2e
	POxjs9j41cOBz2PxnpdMHneu7WHzWDftLbPHlqvtLB59W1Yxehy/sZ3J4/MmuQD2KC6blNSc
	zLLUIn27BK6MDTfnMRb85qj43jSFqYFxHXsXIyeHhICJxNXXs5ghbDGJC/fWs3UxcnEICUxn
	lNi59CsjhNPFJLFmzUuwDjYBPYnPd58ygSREBJYwSrxuWsAK4jALbGSW2DnzLRtIlbBAosTu
	/ldMIDaLgKpE88MjYDt4BdwkzuyZyQKxT17i6f0+sHpOAXeJvtdPoNY1MUpsXryXaQIj7wJG
	hlWMoqkFyQXFSem5hnrFibnFpXnpesn5uZsYwSH7TGoH48oGi0OMAhyMSjy8F4XnBAmxJpYV
	V+YeYpTgYFYS4X2ZCBTiTUmsrEotyo8vKs1JLT7EKM3BoiTOe6DVOlBIID2xJDU7NbUgtQgm
	y8TBKdXAKOqi6dmwkZPhhM8q47SjO1uatBNfvWFjXbNEO/jUr3unD4Tq1G5uWOGXYHiLjf2X
	q/ysSjdf4Ya5t5P+RT/YXM/z5lGhnkRtULNLavGfJwLbbUv+aTwyUT754OHbzrsTNqa5TS9J
	0bP+3Bea3hyparErwfe/W3XFhDmh5o5bXbS5VFbVmS9UYinOSDTUYi4qTgQAaymNc1UCAAA=
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
Changes for v10:
- None

Changes for v9:
- None

Changes for v8:
- None

Changes for v7:
- None

Changes for v6:
- New patch

 drivers/cpufreq/exynos4x12-cpufreq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpufreq/exynos4x12-cpufreq.c b/drivers/cpufreq/exynos4x12-cpufreq.c
index efad5e6..77ae129 100644
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

