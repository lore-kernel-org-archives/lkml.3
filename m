Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758856Ab3BFWEk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 17:04:40 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:19917 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758454Ab3BFWCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 17:02:52 -0500
X-Authority-Analysis: v=2.0 cv=NqdTgrhJ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=F31AZanH1pAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=7Hsy0UdyXL8A:10 a=VwQbUJbxAAAA:8 a=ztMbgCvkvbRalKj1aVgA:9 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130206220251.265116935@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 06 Feb 2013 17:02:14 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>, <stable-rt@vger.kernel.org>
Subject: [PATCH RT 4/6] sched: Check for idle task in might_sleep()
References: <20130206220210.823160521@goodmis.org>
Content-Disposition: inline; filename=0004-sched-Check-for-idle-task-in-might_sleep.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

Idle is not allowed to call sleeping functions ever!

Cc: stable-rt@vger.kernel.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/sched.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 20b228f..14219ed 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -8937,7 +8937,8 @@ void __might_sleep(const char *file, int line, int preempt_offset)
 	static unsigned long prev_jiffy;	/* ratelimiting */
 
 	rcu_sleep_check(); /* WARN_ON_ONCE() by default, no rate limit reqd. */
-	if ((preempt_count_equals(preempt_offset) && !irqs_disabled()) ||
+	if ((preempt_count_equals(preempt_offset) && !irqs_disabled() &&
+	     !is_idle_task(current)) ||
 	    system_state != SYSTEM_RUNNING || oops_in_progress)
 		return;
 	if (time_before(jiffies, prev_jiffy + HZ) && prev_jiffy)
-- 
1.7.10.4


