Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753061AbaAGRlu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 12:41:50 -0500
Received: from mga02.intel.com ([134.134.136.20]:39664 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752310AbaAGRlm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 12:41:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,620,1384329600"; 
   d="scan'208";a="463015286"
Message-ID: <1389116450.5785.16.camel@dvhart-mobl4.amr.corp.intel.com>
Subject: Re: [PATCH v5 4/4] futex: Avoid taking hb lock if nothing to wakeup
From: Darren Hart <dvhart@linux.intel.com>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, peterz@infradead.org,
        tglx@linutronix.de, paulmck@linux.vnet.ibm.com, efault@gmx.de,
        jeffm@suse.com, torvalds@linux-foundation.org, jason.low2@hp.com,
        Waiman.Long@hp.com, tom.vaden@hp.com, scott.norton@hp.com,
        aswin@hp.com
Date: Tue, 07 Jan 2014 09:40:50 -0800
In-Reply-To: <1389065371.9937.15.camel@buesod1.americas.hpqcorp.net>
References: <1388675120-8017-1-git-send-email-davidlohr@hp.com>
	 <1388675120-8017-5-git-send-email-davidlohr@hp.com>
	 <1389041524.30730.43.camel@dvhart-mobl4.amr.corp.intel.com>
	 <1389065371.9937.15.camel@buesod1.americas.hpqcorp.net>
Organization: Intel
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-01-06 at 19:29 -0800, Davidlohr Bueso wrote:
> On Mon, 2014-01-06 at 12:52 -0800, Darren Hart wrote:
> > On Thu, 2014-01-02 at 07:05 -0800, Davidlohr Bueso wrote:

 
> > I thought someone, Peter Z?, had commented on these CONFIG_SMP bits. Are
> > they really necessary? Does smp_mb__after_atomic_inc() and smp_rmb() not
> > already just do the right thing as far as we're concerned here?
> 
> I don't think so. Thomas and I agreed that this was in fact the way to
> go. I rechecked old email and didn't notice any objections to
> CONFIG_SMP. Also for things like hb_waiters_pending we definitely need
> it.

I'll happily defer to Thomas here.
 
> > 
> > Given the subtlety of the implementation - I think it would be good to
> > explicitly annotate the get_futex_key() call site in futex_wake() as
> > providing the MB (B). 
> > 
> > Similar comment for futex_wait() and futex_requeue() for MB (A).
> > 
> > These will also raise the appropriate red flags for people looking to
> > optimize or modify these paths in the future. It would be good to have
> > it in the top level futex_* function to make the MB placement and
> > relationship explicitly clear.
> > 
> 
> Something quite similar was already there for v2 but PeterZ's feedback
> made me update the main documentation at the top of futex.c to as it is
> now...

I don't want to block this any longer - but as complicated and
non-obvious as this is, I would *MUCH* prefer we document the memory
barrier point in the top level algorithm. If Peter/Thomas/Linus/Ingo
object, so be it, but otherwise let's err on the side of overly explicit
documentation.

Peter/Thomas/Linus/Ingo: Do any of you object to adding the three memory
barrier comments to the high level functions? futex_wait, futex_wake,
futex_requeue?

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel


