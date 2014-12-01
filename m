Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950AbaLAOlh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 09:41:37 -0500
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:59854 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753812AbaLAOlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 09:41:36 -0500
Date: Mon, 1 Dec 2014 15:41:28 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Tony Luck <tony.luck@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Wu Fengguang <fengguang.wu@intel.com>, Ingo Molnar <mingo@kernel.org>,
        Rik van Riel <riel@redhat.com>
Subject: Re: [RFC PATCH 24/30] cputime: Increment kcpustat directly on
 irqtime account
Message-ID: <20141201154128.2cbe08b0@mschwide>
In-Reply-To: <1417199040-21044-25-git-send-email-fweisbec@gmail.com>
References: <1417199040-21044-1-git-send-email-fweisbec@gmail.com>
	<1417199040-21044-25-git-send-email-fweisbec@gmail.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120114-0021-0000-0000-000001F9CF4E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Nov 2014 19:23:54 +0100
Frederic Weisbecker <fweisbec@gmail.com> wrote:

> The irqtime is accounted is nsecs and stored in
> cpu_irq_time.hardirq_time and cpu_irq_time.softirq_time. Once the
> accumulated amount reaches a new jiffy, this one gets accounted to the
> kcpustat.
> 
> This was necessary when kcpustat was stored in cputime_t, which could at
> worst have a jiffies granularity. But now kcpustat is stored in nsecs
> so this whole discretization game with temporary irqtime storage has
> become unnecessary.
> 
> We can now directly account the irqtime to the kcpustat.

Isn't the issue here that two different approaches to cputime accounting
get mixed here? On the one hand a cputime_t based on jiffies and on the
other CONFIG_IRQ_TIME_ACCOUNTING which uses sched_clock_cpu() to create
the accounting deltas.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

