Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937221Ab3DIQxQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 12:53:16 -0400
Received: from mail-bk0-f52.google.com ([209.85.214.52]:58275 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936277Ab3DIQxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 12:53:15 -0400
MIME-Version: 1.0
In-Reply-To: <1365513508.30071.4.camel@laptop>
References: <1365266760-24725-1-git-send-email-fweisbec@gmail.com>
	<1365266760-24725-4-git-send-email-fweisbec@gmail.com>
	<1365513508.30071.4.camel@laptop>
Date: Tue, 9 Apr 2013 18:53:13 +0200
Message-ID: <CAFTL4hzx5ctiEDh2Q77D+09XuQsZkajbf_bN4BJKdwgBkmCLZw@mail.gmail.com>
Subject: Re: [PATCH 3/7] sched: Update rq clock on tickless CPUs before
 calling check_preempt_curr()
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>,
        Mike Galbraith <efault@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/4/9 Peter Zijlstra <peterz@infradead.org>:
> On Sat, 2013-04-06 at 18:45 +0200, Frederic Weisbecker wrote:
>> check_preempt_wakeup() of fair class needs an uptodate sched clock
>> value to update runtime stats of the current task.
>>
>> When a task is woken up, activate_task() is usually called right
>> before
>> ttwu_do_wakeup() unless the task is still in the runqueue. In this
>> case we need to update the rq clock manually in case the CPU runs
>> tickless because ttwu_do_wakeup() calls check_preempt_wakeup().
>
> again, same story.. I think the entire nohz specific clock update stuff
> is completely broken and you're finding sites that are simply missing
> clock updates.
>

Agreed!
