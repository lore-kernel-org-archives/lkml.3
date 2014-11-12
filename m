Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965143AbaKLDqj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 22:46:39 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59096 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932556AbaKLB2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:28:41 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-mips@linux-mips.org, Ralf Baechle <ralf@linux-mips.org>
Subject: [PATCH 3.17 145/319] MIPS: loongson2_cpufreq: Fix CPU clock rate setting mismerge
Date: Wed, 12 Nov 2014 10:14:43 +0900
Message-Id: <20141112011016.476993126@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaro Koskinen <aaro.koskinen@iki.fi>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/loongson/lemote-2f/clock.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/arch/mips/loongson/lemote-2f/clock.c
+++ b/arch/mips/loongson/lemote-2f/clock.c
@@ -91,6 +91,7 @@ EXPORT_SYMBOL(clk_put);
 
 int clk_set_rate(struct clk *clk, unsigned long rate)
 {
+	unsigned int rate_khz = rate / 1000;
 	struct cpufreq_frequency_table *pos;
 	int ret = 0;
 	int regval;
@@ -107,9 +108,9 @@ int clk_set_rate(struct clk *clk, unsign
 		propagate_rate(clk);
 
 	cpufreq_for_each_valid_entry(pos, loongson2_clockmod_table)
-		if (rate == pos->frequency)
+		if (rate_khz == pos->frequency)
 			break;
-	if (rate != pos->frequency)
+	if (rate_khz != pos->frequency)
 		return -ENOTSUPP;
 
 	clk->rate = rate;


