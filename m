Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623AbaCFRes (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 12:34:48 -0500
Received: from mail-ie0-f171.google.com ([209.85.223.171]:40350 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015AbaCFReq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 12:34:46 -0500
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH] cpufreq: Reformat printk() statement
Date: Thu,  6 Mar 2014 09:34:39 -0800
Message-Id: <1394127279-29871-1-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.9.0.1.g4196000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reformat a printk statement to:
 - use pr_warn
 - bring the whole string into a single line in favor of being able to
   grep for the message (ignoring the 80 char limit)

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
 drivers/cpufreq/cpufreq.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index cb003a6b72c8..534c2df608ed 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1874,11 +1874,8 @@ static int __cpufreq_governor(struct cpufreq_policy *policy,
 		if (!gov)
 			return -EINVAL;
 		else {
-			printk(KERN_WARNING "%s governor failed, too long"
-			       " transition latency of HW, fallback"
-			       " to %s governor\n",
-			       policy->governor->name,
-			       gov->name);
+			pr_warn("%s governor failed, too long transition latency of HW, fallback to %s governor\n",
+					policy->governor->name, gov->name);
 			policy->governor = gov;
 		}
 	}
-- 
1.9.0.1.g4196000

