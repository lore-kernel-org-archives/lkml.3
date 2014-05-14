Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150AbaENWeY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 18:34:24 -0400
Received: from mail-qg0-f42.google.com ([209.85.192.42]:62243 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370AbaENWdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 18:33:07 -0400
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
Subject: [RFC PATCH 1/5] cpufreq: stats: Allow small rounding errors
Date: Wed, 14 May 2014 15:30:51 -0700
Message-Id: <1400106655-22465-2-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.9.3.1.ga73a6ad
In-Reply-To: <1400106655-22465-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1400106655-22465-1-git-send-email-soren.brinkmann@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When matching a frequency against the freq_table, allow small deviances to
allow rounding errors. Rounding errors are likely to occur due to the
differenct frequency resolutions used in the common clock vs cpufreq
frameworks.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---

 drivers/cpufreq/cpufreq_stats.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpufreq/cpufreq_stats.c b/drivers/cpufreq/cpufreq_stats.c
index ecaaebf969fc..37a34178ab3a 100644
--- a/drivers/cpufreq/cpufreq_stats.c
+++ b/drivers/cpufreq/cpufreq_stats.c
@@ -146,7 +146,7 @@ static int freq_table_get_index(struct cpufreq_stats *stat, unsigned int freq)
 {
 	int index;
 	for (index = 0; index < stat->max_state; index++)
-		if (stat->freq_table[index] == freq)
+		if (abs(stat->freq_table[index] - freq) < 2)
 			return index;
 	return -1;
 }
-- 
1.9.3.1.ga73a6ad

