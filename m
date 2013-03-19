Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964976Ab3CSUsL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 16:48:11 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:46134 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757399Ab3CSUsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 16:48:09 -0400
Date: Tue, 19 Mar 2013 13:48:04 -0700
From: Tejun Heo <tj@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH REPOST v3.9-rc1] sched: replace PF_THREAD_BOUND with
 PF_NO_SETAFFINITY
Message-ID: <20130319204804.GJ3042@htj.dyndns.org>
References: <20130308204518.GR14556@mtj.dyndns.org>
 <20130314225508.GC9400@htj.dyndns.org>
 <20130318094140.GB25045@gmail.com>
 <20130318164715.GC21516@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130318164715.GC21516@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 18, 2013 at 09:47:15AM -0700, Tejun Heo wrote:
> Hello,
> 
> On Mon, Mar 18, 2013 at 10:41:40AM +0100, Ingo Molnar wrote:
> > > This patch replaces PF_THREAD_BOUND with PF_NO_SETAFFINITY.
> > > sched_setaffinity() checks the flag and return -EINVAL if set.
> > > set_cpus_allowed_ptr() is no longer affected by the flag.
> > > 
> > > This will allow simplifying workqueue worker CPU affinity management.
> > 
> > Acked-by: Ingo Molnar <mingo@kernel.org>
> > 
> > I suspect you want to carry this in the workqueue tree, to enable those 
> > extra simplifications?
> 
> Yeah, I was planning to pull from one of the -tip branches but if I
> can carry it through the workqueue tree it would be simpler.  Would
> that be okay?

Applying to wq/for-3.10 w/ the rebinding cleanup.  Holler if this
should be routed differently.

Thanks!

-- 
tejun
