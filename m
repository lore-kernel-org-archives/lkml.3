Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757408Ab3HMKJY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 06:09:24 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:11050 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754613Ab3HMKJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 06:09:19 -0400
X-AuditID: cbfee61a-b7f196d000007dfa-d1-520a05cd5c76
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
Subject: [PATCH v7 7/7] cpufreq:exynos4x12: Change L0 driver data to
 CPUFREQ_BOOST_FREQ
Date: Tue, 13 Aug 2013 12:08:25 +0200
Message-id: <1376388505-30233-8-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1376388505-30233-1-git-send-email-l.majewski@samsung.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1376388505-30233-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCLMWRmVeSWpSXmKPExsVy+t9jAd1zrFxBBqvWMVtsnLGe1eJp0w92
	i3mfZS36fl5htliz/yeTRefZJ8wWvQuuslm8ecRt8ebhZkaLy7vmsFl87j3CaHG7cQWbRf/C
	XiaLJw/72Cw2fvVw4PdYvOclk8eda3vYPNZNe8vs0bdlFaPHo8UtjB7Hb2xn8vi8SS6APYrL
	JiU1J7MstUjfLoEr49aDDqaC7+wV03p7WBoYT7F1MXJySAiYSNw5fQLKFpO4cG89kM3FISSw
	iFFix5Q3rBBOF5PEwekb2UGq2AT0JD7ffcoEYosIzGGUuHPUHaSIWeABs8Ti718Yuxg5OIQF
	IiXuHzIDqWERUJU42bkObAOvgJvE20d7GSG2yUs8vd8HFucUcJdY/b8FanMTo0THscNsExh5
	FzAyrGIUTS1ILihOSs811CtOzC0uzUvXS87P3cQIDttnUjsYVzZYHGIU4GBU4uEVeM8RJMSa
	WFZcmXuIUYKDWUmEN46RK0iINyWxsiq1KD++qDQntfgQozQHi5I474FW60AhgfTEktTs1NSC
	1CKYLBMHp1QDo1TSxTn7r1mn3KmYenCRjUDdGcWl+jMX5z1/sf1L+6bQe8/7TuzlSF7hvGb3
	Fp2nB4LF3Pzf8AVzSrknLfka09u72Seeb4nFhfgvu54cE61MsslZ7Sigmvjy2FcxX564r3ul
	3ywUtlOPlFmvOeHb2rNdPPdcKzeVWDpzZnTmb98enWKc3TrTXImlOCPRUIu5qDgRAAAyCy5X	AgAA
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

