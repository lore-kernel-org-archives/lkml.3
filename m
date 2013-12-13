Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267Ab3LMQkS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 11:40:18 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:39215 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721Ab3LMQjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 11:39:20 -0500
X-AuditID: cbfee61a-b7f7e6d000005936-fe-52ab3837cee7
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
Subject: [PATCH v11 6/7] cpufreq:exynos4x12: Change L0 driver data to
 CPUFREQ_BOOST_FREQ
Date: Fri, 13 Dec 2013 17:38:36 +0100
Message-id: <1386952717-30947-7-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1386952717-30947-1-git-send-email-l.majewski@samsung.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1386952717-30947-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrALMWRmVeSWpSXmKPExsVy+t9jQV1zi9VBBtsvG1psnLGe1eJp0w92
	i76fV5gt1uz/yWTRefYJs8WbR9wWbx5uZrS4vGsOm8Xn3iOMFjPO72OyuN24gs3izOlLrBZP
	HvaxWWz86uHA57F4z0smjzvX9rB5rJv2ltljy9V2Fo++LasYPY7f2M7k8XmTXAB7FJdNSmpO
	Zllqkb5dAlfG0obzbAXTOSsOPX3H0sB4kL2LkYNDQsBEYtYq1S5GTiBTTOLCvfVsXYxcHEIC
	0xklrk06xwzhdDFJzDx/kBWkik1AT+Lz3adMIAkRgSWMEq+bFrCCOMwCG5klds58ywZSJSwQ
	JTHr7m1GEJtFQFXizcoWsHW8Am4SP9f6QaxTlOh+NgGsnFPAXWLaplWMENuaGCWeX7nPOIGR
	dwEjwypG0dSC5ILipPRcQ73ixNzi0rx0veT83E2M4HB9JrWDcWWDxSFGAQ5GJR5ej95VQUKs
	iWXFlbmHGCU4mJVEeENUVwcJ8aYkVlalFuXHF5XmpBYfYpTmYFES5z3Qah0oJJCeWJKanZpa
	kFoEk2Xi4JRqYIw5Znp34fVdQn/OR1awKO2IODn5yl8B8+2burml8w/fLXAXmsvS3fftSeN1
	sfP3RE9n/eI0uG7S+eFYuruL+8xF9Uc0Txw7fOCnjLZLflH/b4soke4mYRYbjY3hVh++rmE8
	Vx/3wybQ789Pny/rawvrLcXmFGydrHfgaqN94coPqY7CjrZvOpRYijMSDbWYi4oTAQS89u5T	AgAA
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
Changes for v11:
- None

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

