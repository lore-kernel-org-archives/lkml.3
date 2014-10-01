Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721AbaJAWVM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 18:21:12 -0400
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:49720 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720AbaJAWVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 18:21:09 -0400
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Ralf Baechle <ralf@linux-mips.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
Subject: [PATCH RESEND] MIPS/loongson2_cpufreq: Fix CPU clock rate setting mismerge
Date: Thu,  2 Oct 2014 01:21:00 +0300
Message-Id: <1412202060-2112-1-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During 3.16 merge window, parts of the commit 8e8acb32960f
(MIPS/loongson2_cpufreq: Fix CPU clock rate setting) seem to have
been deleted probably due to a mismerge, and as a result cpufreq
is broken again on Loongson2 boards in 3.16 and newer kernels.
Fix by repeating the fix.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: stable@vger.kernel.org # 3.16
---
 arch/mips/loongson/lemote-2f/clock.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/mips/loongson/lemote-2f/clock.c b/arch/mips/loongson/lemote-2f/clock.c
index a217061..462e34d 100644
--- a/arch/mips/loongson/lemote-2f/clock.c
+++ b/arch/mips/loongson/lemote-2f/clock.c
@@ -91,6 +91,7 @@ EXPORT_SYMBOL(clk_put);
 
 int clk_set_rate(struct clk *clk, unsigned long rate)
 {
+	unsigned int rate_khz = rate / 1000;
 	struct cpufreq_frequency_table *pos;
 	int ret = 0;
 	int regval;
@@ -107,9 +108,9 @@ int clk_set_rate(struct clk *clk, unsigned long rate)
 		propagate_rate(clk);
 
 	cpufreq_for_each_valid_entry(pos, loongson2_clockmod_table)
-		if (rate == pos->frequency)
+		if (rate_khz == pos->frequency)
 			break;
-	if (rate != pos->frequency)
+	if (rate_khz != pos->frequency)
 		return -ENOTSUPP;
 
 	clk->rate = rate;
-- 
2.1.0

