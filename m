Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756406Ab3JNMTg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 08:19:36 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:21340 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756069Ab3JNMTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 08:19:11 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-f8-525be13d2f2e
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
Subject: [PATCH v9 7/7] cpufreq:exynos4x12: Change L0 driver data to
 CPUFREQ_BOOST_FREQ
Date: Mon, 14 Oct 2013 14:17:50 +0200
Message-id: <1381753070-2853-8-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1381753070-2853-1-git-send-email-l.majewski@samsung.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1381753070-2853-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDLMWRmVeSWpSXmKPExsVy+t9jAV27h9FBBr+62Cw2zljPavG06Qe7
	Rd/PK8wWa/b/ZLLoPPuE2eLNI26LNw83M1pc3jWHzeJz7xFGi9uNK9gszpy+xGrx5GEfUOtX
	Dwdej8V7XjJ53Lm2h81j3bS3zB5brrazePRtWcXocfzGdiaPz5vkAtijuGxSUnMyy1KL9O0S
	uDLOPn7LUnCfo+LcVsUGxtnsXYycHBICJhLL9k1nhrDFJC7cW8/WxcjFISSwiFHiZucUVgin
	i0li2q0LjCBVbAJ6Ep/vPmUCSYgILGGUeN20AKyKWaCHWeL49e1sIFXCApES7U/WgNksAqoS
	izdeArN5BVwltt2dzwixT17i6f0+sDingJvEqW0bmCHWNTJKbDu3gXUCI+8CRoZVjKKpBckF
	xUnpuYZ6xYm5xaV56XrJ+bmbGMFh+kxqB+PKBotDjAIcjEo8vAJO0UFCrIllxZW5hxglOJiV
	RHg/XgUK8aYkVlalFuXHF5XmpBYfYpTmYFES5z3Qah0oJJCeWJKanZpakFoEk2Xi4JRqYBTx
	6G3c49j7u//zr0N6rT2Lf/KotHSXyIf76pkKip1cubHV5che5foLNgvLDa9cfuf3yelETMIk
	kZAJ81X27tJIavOeqrKOrTPadjGnRn5cQOOZBZzv1u2NXGUeqf82LGvlrHedVvcYN8tJfbj3
	7j2XkYlXytL/PoeZ58W/vn7G8bYLX7eNvRJLcUaioRZzUXEiALVdL1VPAgAA
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
index 08b7477..178ab4b 100644
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

