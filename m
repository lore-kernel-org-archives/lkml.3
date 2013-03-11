Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752994Ab3CKHOP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 03:14:15 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:26245 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403Ab3CKHOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 03:14:11 -0400
Message-ID: <513D8433.8000806@huawei.com>
Date: Mon, 11 Mar 2013 15:13:55 +0800
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: [PATCH 06/13] tracing: remove dump_ran check in __ftrace_dump
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.66.58.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's reasonable to call __ftrace_dump function not only once,
so remove the dump_ran variable checking.

Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
---
 kernel/trace/trace.c |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 090eddb..4cec7b8 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -5106,17 +5106,12 @@ __ftrace_dump(bool disable_tracing, enum ftrace_dump_mode oops_dump_mode)
 	/* use static because iter can be a bit big for the stack */
 	static struct trace_iterator iter;
 	unsigned int old_userobj;
-	static int dump_ran;
 	unsigned long flags;
 	int cnt = 0, cpu;

 	/* only one dump */
 	local_irq_save(flags);
 	arch_spin_lock(&ftrace_dump_lock);
-	if (dump_ran)
-		goto out;
-
-	dump_ran = 1;

 	tracing_off();

@@ -5206,7 +5201,6 @@ __ftrace_dump(bool disable_tracing, enum ftrace_dump_mode oops_dump_mode)
 		tracing_on();
 	}

- out:
 	arch_spin_unlock(&ftrace_dump_lock);
 	local_irq_restore(flags);
 }
-- 
1.7.9.7


