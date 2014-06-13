Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752973AbaFMTqT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 15:46:19 -0400
Received: from www.linutronix.de ([62.245.132.108]:50255 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190AbaFMTqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 15:46:18 -0400
Date: Fri, 13 Jun 2014 21:46:15 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [patch V4 10/10] rtmutex: Avoid pointless requeueing in the
 deadlock detection chain walk
In-Reply-To: <20140613132810.3d59fdc0@gandalf.local.home>
Message-ID: <alpine.DEB.2.10.1406132143480.5170@nanos>
References: <20140611182944.108526809@linutronix.de> <20140611183853.734541303@linutronix.de> <20140613132810.3d59fdc0@gandalf.local.home>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jun 2014, Steven Rostedt wrote:
> On Wed, 11 Jun 2014 18:44:09 -0000
> Thomas Gleixner <tglx@linutronix.de> wrote:
> Nit pick, but we should be consistent.
> 
> The requeue path does:
> 
>         next_lock = task_blocked_on_lock(task);
>         /*
>          * Store the top waiter of @lock for the end of chain walk
>          * decision below.
>          */
>         top_waiter = rt_mutex_top_waiter(lock);
> 
> I know the order is not important, but we should keep the two the same,
> helps in review and making sure changes to one implementation still
> make it to the other, without confusing those making the changes
> (like you in a few years ;)

The timespan for forgetting about that is measured in weeks, if at
all. No sane brain will keep itself exposed to this longer than
absolutely necessary.
