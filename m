Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715AbaFFFl0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 01:41:26 -0400
Received: from www.linutronix.de ([62.245.132.108]:53506 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752554AbaFFFlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 01:41:25 -0400
Date: Fri, 6 Jun 2014 07:41:19 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Brad Mouring <bmouring@ni.com>
Subject: Re: [patch 1/2] rtmutex: Handle deadlock detection smarter
In-Reply-To: <20140605211403.199fe580@gandalf.local.home>
Message-ID: <alpine.DEB.2.10.1406060740510.23174@nanos>
References: <20140605152544.641846795@linutronix.de> <20140605152801.836501969@linutronix.de> <20140605211403.199fe580@gandalf.local.home>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Jun 2014, Steven Rostedt wrote:

> On Thu, 05 Jun 2014 15:28:32 -0000
> Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> 
> > @@ -1112,7 +1134,8 @@ int rt_mutex_start_proxy_lock(struct rt_
> >  		return 1;
> >  	}
> >  
> > -	ret = task_blocks_on_rt_mutex(lock, waiter, task, detect_deadlock);
> > +	/* We enforce deadlock detection for futexes */
> > +	ret = task_blocks_on_rt_mutex(lock, waiter, task, 1);
> 
> Why bother with passing in detect_deadlock then?
> 
> Same goes for rt_mutex_finish_proxy_lock().

Because that's part of the cleanup series to remove it and I did not
want mix stuff here.

