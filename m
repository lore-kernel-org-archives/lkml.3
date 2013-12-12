Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751749Ab3LLB6H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 20:58:07 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:50882 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751364Ab3LLB6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 20:58:03 -0500
Date: Wed, 11 Dec 2013 20:58:01 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] wait-simple: Introduce the simple waitqueue
 implementation
Message-ID: <20131211205801.68e9b7db@gandalf.local.home>
In-Reply-To: <1386810399-8973-2-git-send-email-paul.gortmaker@windriver.com>
References: <1386810399-8973-1-git-send-email-paul.gortmaker@windriver.com>
	<1386810399-8973-2-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Dec 2013 20:06:37 -0500
Paul Gortmaker <paul.gortmaker@windriver.com> wrote:

> From: Thomas Gleixner <tglx@linutronix.de>
> 
> The wait_queue is a swiss army knife and in most of the cases the
> full complexity is not needed.  Here we provide a slim version, as
> it lowers memory consumption and runtime overhead.
> 
> The concept originated from RT, where waitqueues are a constant
> source of trouble, as we can't convert the head lock to a raw
> spinlock due to fancy and long lasting callbacks.
> 
> The smp_mb() was added (by Steven Rostedt) to fix a race condition
> with swait wakeups vs. adding items to the list.

For this part, you can also add my:

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

I'll also look at these and test them a bit against mainline.

Thanks for doing this!

-- Steve

> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> [PG: carry forward from multiple v3.10-rt patches to mainline, align
>  function names with "normal" wait queue names, update commit log.]
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
> ---

