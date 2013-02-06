Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758813Ab3BFV72 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 16:59:28 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:24863 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758628Ab3BFV7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 16:59:17 -0500
X-Authority-Analysis: v=2.0 cv=C91rOHz+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=I1Lxt5DHJtgA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=ODFuIiu7x74A:10 a=VwQbUJbxAAAA:8 a=N7qOFoEoz-0NaNUCvowA:9 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130206215915.359912024@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 06 Feb 2013 16:58:21 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>, <stable-rt@vger.kernel.org>
Subject: [PATCH RT 3/6] sched: Init idle->on_rq in init_idle()
References: <20130206215818.969089606@goodmis.org>
Content-Disposition: inline; filename=0003-sched-Init-idle-on_rq-in-init_idle.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

Cc: stable-rt@vger.kernel.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/sched/core.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index fec5603..e979551 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5264,6 +5264,7 @@ void __cpuinit init_idle(struct task_struct *idle, int cpu)
 	rcu_read_unlock();
 
 	rq->curr = rq->idle = idle;
+	idle->on_rq = 1;
 #if defined(CONFIG_SMP)
 	idle->on_cpu = 1;
 #endif
-- 
1.7.10.4


