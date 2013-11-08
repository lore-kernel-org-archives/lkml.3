Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752992Ab3KHFYT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 00:24:19 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:21663 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751827Ab3KHFYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 00:24:14 -0500
From: Xiaoguang Chen <chenxg@marvell.com>
To: <rjw@rjwysocki.net>, <viresh.kumar@linaro.org>, <cpufreq@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <chenxg@marvell.com>, <chenxg.marvell@gmail.com>
Subject: [PATCH 2/2] cpufreq: conservative: set requested_freq to policy max when it is over policy max
Date: Fri, 8 Nov 2013 13:23:52 +0800
Message-ID: <1383888232-27049-2-git-send-email-chenxg@marvell.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1383888232-27049-1-git-send-email-chenxg@marvell.com>
References: <1383888232-27049-1-git-send-email-chenxg@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8794,1.0.431,0.0.0000
 definitions=2013-11-07_08:2013-11-08,2013-11-07,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1311070276
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When requested_freq is over policy->max, set it to policy->max.
This can help to speed up decreasing frequency.

Signed-off-by: Xiaoguang Chen <chenxg@marvell.com>
---
 drivers/cpufreq/cpufreq_conservative.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/cpufreq/cpufreq_conservative.c b/drivers/cpufreq/cpufreq_conservative.c
index 218460f..25a70d0 100644
--- a/drivers/cpufreq/cpufreq_conservative.c
+++ b/drivers/cpufreq/cpufreq_conservative.c
@@ -68,6 +68,9 @@ static void cs_check_cpu(int cpu, unsigned int load)
 
 		dbs_info->requested_freq += get_freq_target(cs_tuners, policy);
 
+		if (dbs_info->requested_freq > policy->max)
+			dbs_info->requested_freq = policy->max;
+
 		__cpufreq_driver_target(policy, dbs_info->requested_freq,
 			CPUFREQ_RELATION_H);
 		return;
-- 
1.8.0

