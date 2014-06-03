Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932604AbaFCOna (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 10:43:30 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:61974 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376AbaFCOn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 10:43:27 -0400
Date: Tue, 3 Jun 2014 16:43:19 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kevin Hilman <khilman@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [GIT PULL] nohz: Move nohz kick out of scheduler IPI, v7
Message-ID: <20140603144316.GA23860@localhost.localdomain>
References: <1401806420-31018-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401806420-31018-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2014 at 04:40:15PM +0200, Frederic Weisbecker wrote:
> Hi,
> 
> This version fixes the following concerns from Peterz:
> 
> * Warn _before_ work claim on irq_work_queue_on()
> * Warn on in_nmi() while remote queueing
> * Only disabled preemption (and not irqs) on local queueing
> 
> Thanks.
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
> 	timers/nohz-irq-work-v5

Oops, wait a minute, the tree is broken, I'll do another pull request.

> 
> Thanks,
> 	Frederic
> ---
> 
> Frederic Weisbecker (5):
>       irq_work: Split raised and lazy lists
>       irq_work: Shorten a bit irq_work_needs_cpu()
>       irq_work: Implement remote queueing
>       nohz: Move full nohz kick to its own IPI
>       nohz: Use IPI implicit full barrier against rq->nr_running r/w
> 
> 
>  include/linux/irq_work.h |  2 ++
>  include/linux/tick.h     |  9 +++++-
>  kernel/irq_work.c        | 72 ++++++++++++++++++++++++++++--------------------
>  kernel/sched/core.c      | 14 ++++------
>  kernel/sched/sched.h     | 12 ++++++--
>  kernel/smp.c             |  4 +++
>  kernel/time/tick-sched.c | 10 ++++---
>  7 files changed, 77 insertions(+), 46 deletions(-)
