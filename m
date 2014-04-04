Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752170AbaDDDTd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 23:19:33 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:9649 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751999AbaDDDTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 23:19:30 -0400
From: Lei Wen <leiwen@marvell.com>
To: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>,
        Joe Perches <joe@perches.com>, Tejun Heo <tj@kernel.org>,
        Petr Mladek <pmladek@suse.cz>, <linux-kernel@vger.kernel.org>,
        <leiwen@marvell.com>
Subject: [PATCH 3/3] printk: using booting time as the timestamp
Date: Fri, 4 Apr 2014 11:18:42 +0800
Message-ID: <1396581522-3309-4-git-send-email-leiwen@marvell.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1396581522-3309-1-git-send-email-leiwen@marvell.com>
References: <1396581522-3309-1-git-send-email-leiwen@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-04-04_01:2014-04-03,2014-04-04,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1404030304
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As people may want to align the kernel log with some other processor
running over the same machine but not the same copy of linux, we
need to keep their log aligned, so that it would not make debug
process hard and confused.

Signed-off-by: Lei Wen <leiwen@marvell.com>
---
 kernel/printk/printk.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index a45b509..af96fbd 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -349,7 +349,7 @@ static void log_store(int facility, int level,
 	if (ts_nsec > 0)
 		msg->ts_nsec = ts_nsec;
 	else
-		msg->ts_nsec = local_clock();
+		msg->ts_nsec = ktime_to_ns(ktime_get_boottime());
 	memset(log_dict(msg) + dict_len, 0, pad_len);
 	msg->len = size;
 
@@ -1440,7 +1440,7 @@ static bool cont_add(int facility, int level, const char *text, size_t len)
 		cont.facility = facility;
 		cont.level = level;
 		cont.owner = current;
-		cont.ts_nsec = local_clock();
+		cont.ts_nsec = ktime_to_ns(ktime_get_boottime());
 		cont.flags = 0;
 		cont.cons = 0;
 		cont.flushed = false;
-- 
1.8.3.2

