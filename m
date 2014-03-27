Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725AbaC0INR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 04:13:17 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:19750 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753873AbaC0INO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 04:13:14 -0400
From: Neil Zhang <zhangwm@marvell.com>
To: <john.stultz@linaro.org>, <tglx@linutronix.de>
CC: <linux-kernel@vger.kernel.org>, Neil Zhang <zhangwm@marvell.com>
Subject: [PATCH] timekeeping: check params before use them
Date: Thu, 27 Mar 2014 16:12:58 +0800
Message-ID: <1395907978-6202-1-git-send-email-zhangwm@marvell.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-03-27_02:2014-03-26,2014-03-27,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1403270007
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sometimes we won't need all the information from
get_xtime_and_monotonic_and_sleep_offset(),
so let's check the params before assign the value to them.

Signed-off-by: Neil Zhang <zhangwm@marvell.com>
---
 kernel/time/timekeeping.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 0aa4ce8..f0e8f53 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -1598,9 +1598,12 @@ void get_xtime_and_monotonic_and_sleep_offset(struct timespec *xtim,
 
 	do {
 		seq = read_seqcount_begin(&timekeeper_seq);
-		*xtim = tk_xtime(tk);
-		*wtom = tk->wall_to_monotonic;
-		*sleep = tk->total_sleep_time;
+		if (xtim)
+			*xtim = tk_xtime(tk);
+		if (wtom)
+			*wtom = tk->wall_to_monotonic;
+		if (sleep)
+			*sleep = tk->total_sleep_time;
 	} while (read_seqcount_retry(&timekeeper_seq, seq));
 }
 
-- 
1.7.9.5

