Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124AbaENWd7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 18:33:59 -0400
Received: from mail-qg0-f54.google.com ([209.85.192.54]:35161 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753802AbaENWdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 18:33:12 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Mike Turquette <mturquette@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: Michal Simek <michal.simek@xilinx.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [RFC PATCH 3/5] cpufreq: cpu0: Use clk_round_rate_nearest()
Date: Wed, 14 May 2014 15:30:53 -0700
Message-Id: <1400106655-22465-4-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.9.3.1.ga73a6ad
In-Reply-To: <1400106655-22465-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1400106655-22465-1-git-send-email-soren.brinkmann@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Round clock frequencies to the nearest possible frequency. As opposed to
the nearest that does not exceed the requested one.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---

 drivers/cpufreq/cpufreq-cpu0.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/cpufreq/cpufreq-cpu0.c b/drivers/cpufreq/cpufreq-cpu0.c
index 1bf6bbac3e03..e1de9dc46542 100644
--- a/drivers/cpufreq/cpufreq-cpu0.c
+++ b/drivers/cpufreq/cpufreq-cpu0.c
@@ -42,7 +42,8 @@ static int cpu0_set_target(struct cpufreq_policy *policy, unsigned int index)
 	long freq_Hz, freq_exact;
 	int ret;
 
-	freq_Hz = clk_round_rate(cpu_clk, freq_table[index].frequency * 1000);
+	freq_Hz = clk_round_rate_nearest(cpu_clk,
+			freq_table[index].frequency * 1000);
 	if (freq_Hz <= 0)
 		freq_Hz = freq_table[index].frequency * 1000;
 
-- 
1.9.3.1.ga73a6ad

