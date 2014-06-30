Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756561AbaF3Q5B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 12:57:01 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:50903 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756459AbaF3Q45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 12:56:57 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Mike Turquette <mturquette@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH 2/4] cpufreq: cpu0: Use clk_find_nearest_rate()
Date: Mon, 30 Jun 2014 09:56:34 -0700
Message-Id: <1404147396-8041-3-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 2.0.1.1.gfbfc394
In-Reply-To: <1404147396-8041-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1404147396-8041-1-git-send-email-soren.brinkmann@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Round clock frequencies to the nearest possible frequency. Since the
OPPs as specified in DT and the CCF use different a resolution for clock
frequencies, the clk_round_rate() API may return unexpected results, due
to not mandating how rounding has to happen. The clk_find_nearest_rate()
API mitigates such issues and finds the appropriate frequency for
an OPP.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---

 drivers/cpufreq/cpufreq-cpu0.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/cpufreq/cpufreq-cpu0.c b/drivers/cpufreq/cpufreq-cpu0.c
index ee1ae303a07c..1650581f85b6 100644
--- a/drivers/cpufreq/cpufreq-cpu0.c
+++ b/drivers/cpufreq/cpufreq-cpu0.c
@@ -42,7 +42,8 @@ static int cpu0_set_target(struct cpufreq_policy *policy, unsigned int index)
 	long freq_Hz, freq_exact;
 	int ret;
 
-	freq_Hz = clk_round_rate(cpu_clk, freq_table[index].frequency * 1000);
+	freq_Hz = clk_find_nearest_rate(cpu_clk,
+			freq_table[index].frequency * 1000);
 	if (freq_Hz <= 0)
 		freq_Hz = freq_table[index].frequency * 1000;
 
-- 
2.0.1.1.gfbfc394

