Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751423AbaK1CoY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 21:44:24 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:13763 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981AbaK1Cnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 21:43:52 -0500
From: Wang Weidong <wangweidong1@huawei.com>
To: <rjw@rjwysocki.net>, <viresh.kumar@linaro.org>
CC: <wangweidong1@huawei.com>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <guohanjun@huawei.com>
Subject: [PATCH 2/2] cpufreq: show the real avail freqs with the freq_table
Date: Fri, 28 Nov 2014 10:43:39 +0800
Message-ID: <1417142619-14548-3-git-send-email-wangweidong1@huawei.com>
X-Mailer: git-send-email 1.8.1.msysgit.1
In-Reply-To: <1417142619-14548-1-git-send-email-wangweidong1@huawei.com>
References: <1417142619-14548-1-git-send-email-wangweidong1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.177.18.75]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020201.5477E165.019F,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 5e1a001e067a56bdf4231c4d9a981d18
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some time, the policy's max_freq and min_freq will change, so
the avail freqs is not from the cpuinfo_min to cpuinfo_max.
Just add the check for the freq_table.

Signed-off-by: Wang Weidong <wangweidong1@huawei.com>
---
 drivers/cpufreq/freq_table.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/cpufreq/freq_table.c b/drivers/cpufreq/freq_table.c
index df14766..4f86010 100644
--- a/drivers/cpufreq/freq_table.c
+++ b/drivers/cpufreq/freq_table.c
@@ -237,7 +237,9 @@ static ssize_t show_available_freqs(struct cpufreq_policy *policy, char *buf,
 		 * show_boost = false and driver_data != BOOST freq
 		 * display NON BOOST freqs
 		 */
-		if (show_boost ^ (pos->flags & CPUFREQ_BOOST_FREQ))
+		if (pos->frequency < policy->min ||
+		    pos->frequency > policy->max ||
+		    show_boost ^ (pos->flags & CPUFREQ_BOOST_FREQ))
 			continue;
 
 		count += sprintf(&buf[count], "%d ", pos->frequency);
-- 
1.7.12


