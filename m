Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751865Ab3B1Fic (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 00:38:32 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:61760 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897Ab3B1FiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 00:38:10 -0500
X-AuditID: 9c930197-b7c43ae0000006e1-ea-512eed3ef5f5
From: Namhyung Kim <namhyung@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH -next 3/3] cpufreq: conservative: Fix relation when decreasing frequency
Date: Thu, 28 Feb 2013 14:38:02 +0900
Message-Id: <1362029882-28993-3-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1362029882-28993-1-git-send-email-namhyung@kernel.org>
References: <1362029882-28993-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The relation should be CPUFREQ_RELATION_L to find optimal frequency
when decreasing.

Cc: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 drivers/cpufreq/cpufreq_conservative.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpufreq/cpufreq_conservative.c b/drivers/cpufreq/cpufreq_conservative.c
index dd2fd9094819..0d582811d66c 100644
--- a/drivers/cpufreq/cpufreq_conservative.c
+++ b/drivers/cpufreq/cpufreq_conservative.c
@@ -106,7 +106,7 @@ static void cs_check_cpu(int cpu, unsigned int load)
 			dbs_info->requested_freq = policy->min;
 
 		__cpufreq_driver_target(policy, dbs_info->requested_freq,
-				CPUFREQ_RELATION_H);
+				CPUFREQ_RELATION_L);
 		return;
 	}
 }
-- 
1.7.11.7

