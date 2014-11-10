Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707AbaKJLbk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 06:31:40 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:50466 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752316AbaKJLbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 06:31:39 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>,
        Luis Henriques <luis.henriques@canonical.com>,
        kernel-team@lists.ubuntu.com
Subject: [3.16.y-ckt extended stable] Patch "MIPS: loongson2_cpufreq: Fix CPU clock rate setting mismerge" has been added to staging queue
Date: Mon, 10 Nov 2014 11:31:35 +0000
Message-Id: <1415619095-8286-1-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a note to let you know that I have just added a patch titled

    MIPS: loongson2_cpufreq: Fix CPU clock rate setting mismerge

to the linux-3.16.y-queue branch of the 3.16.y-ckt extended stable tree 
which can be found at:

 http://kernel.ubuntu.com/git?p=ubuntu/linux.git;a=shortlog;h=refs/heads/linux-3.16.y-queue

This patch is scheduled to be released in version 3.16.7-ckt1.

If you, or anyone else, feels it should not be added to this tree, please 
reply to this email.

For more information about the 3.16.y-ckt tree, see
https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable

Thanks.
-Luis

------

>From f563a83bc7161702ce438b7a1164d67ddb3bca05 Mon Sep 17 00:00:00 2001
From: Aaro Koskinen <aaro.koskinen@iki.fi>
Date: Sun, 21 Sep 2014 15:38:43 +0300
Subject: MIPS: loongson2_cpufreq: Fix CPU clock rate setting mismerge

commit aa08ed55442ac6f9810c055e1474be34e785e556 upstream.

During 3.16 merge window, parts of the commit 8e8acb32960f
(MIPS/loongson2_cpufreq: Fix CPU clock rate setting) seem to have
been deleted probably due to a mismerge, and as a result cpufreq
is broken again on Loongson2 boards in 3.16 and newer kernels.
Fix by repeating the fix.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: linux-mips@linux-mips.org
Cc: linux-kernel@vger.kernel.org
Patchwork: https://patchwork.linux-mips.org/patch/7835/
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/mips/loongson/lemote-2f/clock.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/mips/loongson/lemote-2f/clock.c b/arch/mips/loongson/lemote-2f/clock.c
index 1eed38e28b1e..ebfb9cd71ca1 100644
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

