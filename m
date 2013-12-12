Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751975Ab3LLCJL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 21:09:11 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:7128 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751374Ab3LLCJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 21:09:08 -0500
Date: Wed, 11 Dec 2013 21:09:03 -0500
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
Message-ID: <20131211210903.1e44ba39@gandalf.local.home>
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


> --- /dev/null
> +++ b/kernel/swait.c
> @@ -0,0 +1,118 @@
> +/*
> + * Simple waitqueues without fancy flags and callbacks

We should probably have a more detailed description of when to use
simple wait queues verses normal wait queues. These are obviously much
lighter wait, and should be the preferred method unless you need a
feature of the more heavy weight wait queues.

-- Steve

"weight wait" Ha! Don't get to use that very often ;-)


> + *
> + * (C) 2011 Thomas Gleixner <tglx@linutronix.de>
> + *
> + * Based on kernel/wait.c
> + *
> + * For licencing details see kernel-base/COPYING
> + */
> +#include <linux/init.h>
> +#include <linux/export.h>
> +#include <linux/sched.h>
> +#include <linux/swait.h>
