Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751335AbaFFFo3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 01:44:29 -0400
Received: from www.linutronix.de ([62.245.132.108]:53528 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809AbaFFFo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 01:44:28 -0400
Date: Fri, 6 Jun 2014 07:44:23 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: Brad Mouring <bmouring@ni.com>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Clark Williams <williams@redhat.com>
Subject: Re: [PATCH 1/1] rtmutex: Handle when top lock owner changes
In-Reply-To: <alpine.DEB.2.10.1406060739030.23174@nanos>
Message-ID: <alpine.DEB.2.10.1406060743260.23174@nanos>
References: <1400855410-14773-1-git-send-email-brad.mouring@ni.com> <1400855410-14773-2-git-send-email-brad.mouring@ni.com> <20140603210609.62de6451@gandalf.local.home> <alpine.DEB.2.10.1406041623170.3319@nanos> <20140605231940.1fc277a4@gandalf.local.home>
 <alpine.DEB.2.10.1406060739030.23174@nanos>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jun 2014, Thomas Gleixner wrote:
> On Thu, 5 Jun 2014, Steven Rostedt wrote:
> > On Wed, 4 Jun 2014 17:32:37 +0200 (CEST)
> > Thomas Gleixner <tglx@linutronix.de> wrote:
> > +	/*
> > +	 * When we dropped the spinlocks, if the owner of the lock we
> > +	 * are currently processing changed since we chain walked
> > +	 * to that lock, we are done with the chain walk. The previous
> > +	 * owner was obviously running to release it.
> > +	 */
> > +	if (lock && rt_mutex_owner(lock) != task)
> > +		goto out_unlock_pi;
> 
> NO. You CANNOT derefernce lock after dropping the locks. It might be
> gone already.

The only information we can check is, whether @task changed the
blocked on lock, really.

Thanks,

	tglx


