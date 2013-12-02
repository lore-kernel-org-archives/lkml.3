Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012Ab3LBMV0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 07:21:26 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:53507 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753869Ab3LBMTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 07:19:52 -0500
X-AuditID: cbfee61a-b7f316d000007e34-b5-529c7ae7aa7c
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
Subject: [PATCH RESEND v10 4/7] cpufreq:exynos:Extend Exynos cpufreq driver to
 support boost framework
Date: Mon, 02 Dec 2013 13:19:18 +0100
Message-id: <1385986761-17934-5-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1385986761-17934-1-git-send-email-l.majewski@samsung.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1385986761-17934-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrILMWRmVeSWpSXmKPExsVy+t9jQd3nVXOCDA4vl7LYOGM9q8XTph/s
	Fn0/rzBbrNn/k8mi8+wTZos3j7gt3jzczGhxedccNovPvUcYLWac38dkcbtxBZvFmdOXWC2e
	POxjs9j41cOBz2PxnpdMHneu7WHzWDftLbPHlqvtLB59W1Yxehy/sZ3J4/MmuQD2KC6blNSc
	zLLUIn27BK6Mp6v+MBf846u4Ou0fWwPjPp4uRk4OCQETiWX7brNB2GISF+6tB7K5OIQEpjNK
	7J/zlx3C6WKS+HW7jx2kik1AT+Lz3adMIAkRgSWMEq+bFrCCOMwCG5klds58CzZLWCBD4snV
	3UAJDg4WAVWJ271cIGFeATeJn/1z2CHWyUs8vd8HVs4p4C7R9/oJI8S2JkaJzYv3Mk1g5F3A
	yLCKUTS1ILmgOCk911CvODG3uDQvXS85P3cTIzhgn0ntYFzZYHGIUYCDUYmH96LwnCAh1sSy
	4srcQ4wSHMxKIrwvE4FCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeQ+0WgcKCaQnlqRmp6YWpBbB
	ZJk4OKUaGOO8H0XomQtw3nNc/CHosLnZfJPD9VpG5gqrq38zzr3H7jI36ArfGzuGzvQ3+hlf
	xD821OyS8PzSbMJ7KEHieJ+1rGq/sZB/ctIlzlr+1RqxZdvDb6tGyhre81QxPDh1VxbT1l0i
	Nzq2CIff5sz7Iy0Y8vhaantnwEUt8TNHfhgaO5eY/YtVYinOSDTUYi4qTgQA0Pq1tVQCAAA=
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

