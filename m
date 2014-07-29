Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934AbaG2QWP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 12:22:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17927 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751048AbaG2QWO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 12:22:14 -0400
Date: Tue, 29 Jul 2014 18:19:28 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Kirill Tkhai <ktkhai@parallels.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Kirill Tkhai <tkhai@yandex.ru>,
        linux-kernel@vger.kernel.org, nicolas.pitre@linaro.org, pjt@google.com,
        rostedt@goodmis.org, umgwanakikbuti@gmail.com,
        tim.c.chen@linux.intel.com, mingo@kernel.org
Subject: Re: [PATCH v2 2/5] sched: Teach scheduler to understand
	ONRQ_MIGRATING state
Message-ID: <20140729161928.GA31298@redhat.com>
References: <20140726145508.6308.69121.stgit@localhost> <20140726145912.6308.32554.stgit@localhost> <20140728080122.GL6758@twins.programming.kicks-ass.net> <1406538338.23175.12.camel@tkhai> <1406627582.3600.9.camel@tkhai>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406627582.3600.9.camel@tkhai>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29, Kirill Tkhai wrote:
>
> How about this? Everything is inside task_rq_lock() now. The patch
> became much less.

And with this change task_migrating() is not possible under
task_rq_lock() or __task_rq_lock(). This means that 1/5 can be simplified
too.

__migrate_swap_task() is probably the notable exception...

Off-topic, but it takes 2 ->pi_lock's. This means it can deadlock with
try_to_wake_up_local() (if a 3rd process does ttwu() and waits for
->on_cpu == 0). But I guess __migrate_swap_task() should not play with
PF_WQ_WORKER threads.

Oleg.

