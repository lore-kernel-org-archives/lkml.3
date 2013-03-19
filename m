Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755005Ab3CSFPg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 01:15:36 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:43280 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757379Ab3CSFPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 01:15:34 -0400
MIME-Version: 1.0
In-Reply-To: <fb2e721fc43fbc3517a7ebb905aa573b12bb83a5.1363617402.git.viresh.kumar@linaro.org>
References: <cover.1363617402.git.viresh.kumar@linaro.org>
	<fb2e721fc43fbc3517a7ebb905aa573b12bb83a5.1363617402.git.viresh.kumar@linaro.org>
Date: Tue, 19 Mar 2013 10:45:33 +0530
Message-ID: <CAKohpo=BL_MOijb2k6cC44jv2R-7gv_BpnJ0N2mEkJ3rmAxzAQ@mail.gmail.com>
Subject: Re: [PATCH V3 3/7] workqueue: Add helpers to schedule work on any cpu
From: Viresh Kumar <viresh.kumar@linaro.org>
To: pjt@google.com, paul.mckenney@linaro.org, tglx@linutronix.de,
        tj@kernel.org, suresh.b.siddha@intel.com, venki@google.com,
        mingo@redhat.com, peterz@infradead.org, rostedt@goodmis.org
Cc: linaro-kernel@lists.linaro.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, Arvind.Chauhan@arm.com,
        linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18 March 2013 20:53, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> queue_work() queues work on current cpu. This may wake up an idle CPU, which is
> actually not required.
>
> Some of these works can be processed by any CPU and so we must select a non-idle
> CPU here. The initial idea was to modify implementation of queue_work(), but
> that may end up breaking lots of kernel code that would be a nightmare to debug.
>
> So, we finalized to adding new workqueue interfaces, for works that don't depend
> on a cpu to execute them.

Fixup:

commit 6e5b6fac3353f5e4e5490931b3eb6d3fd7864ca0
Author: Viresh Kumar <viresh.kumar@linaro.org>
Date:   Tue Mar 19 10:34:20 2013 +0530

    fixup! workqueue: Add helpers to schedule work on any cpu
---
 kernel/workqueue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index cf9c570..68daf50 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1242,7 +1242,7 @@ retry:
        if (!(wq->flags & WQ_UNBOUND)) {
                if (cpu == WORK_CPU_UNBOUND) {
                        if (on_any_cpu)
-                               cpu = sched_select_cpu(0);
+                               cpu = sched_select_non_idle_cpu(0);
                        else
                                cpu = raw_smp_processor_id();
                }
