Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752411AbaFFIxT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 04:53:19 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:62855 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751658AbaFFIxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 04:53:17 -0400
Date: Fri, 6 Jun 2014 04:53:14 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Brad Mouring <bmouring@ni.com>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Clark Williams <williams@redhat.com>
Subject: Re: [PATCH 1/1] rtmutex: Handle when top lock owner changes
Message-ID: <20140606045314.03829996@gandalf.local.home>
In-Reply-To: <alpine.DEB.2.10.1406060739030.23174@nanos>
References: <1400855410-14773-1-git-send-email-brad.mouring@ni.com>
	<1400855410-14773-2-git-send-email-brad.mouring@ni.com>
	<20140603210609.62de6451@gandalf.local.home>
	<alpine.DEB.2.10.1406041623170.3319@nanos>
	<20140605231940.1fc277a4@gandalf.local.home>
	<alpine.DEB.2.10.1406060739030.23174@nanos>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jun 2014 07:40:10 +0200 (CEST)
Thomas Gleixner <tglx@linutronix.de> wrote:

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
> 

Ah, the lock can be freed (out of memory that is). Why didn't you say
so in the first place ;-)

-- Steve
