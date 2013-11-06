Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756800Ab3KFO3J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 09:29:09 -0500
Received: from merlin.infradead.org ([205.233.59.134]:57288 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756610Ab3KFO3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 09:29:07 -0500
Date: Wed, 6 Nov 2013 15:28:40 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Vince Weaver <vince@deater.net>
Cc: mingo@kernel.org, hpa@zytor.com, anton@samba.org,
        mathieu.desnoyers@polymtl.ca, linux-kernel@vger.kernel.org,
        michael@ellerman.id.au, paulmck@linux.vnet.ibm.com,
        benh@kernel.crashing.org, fweisbec@gmail.com, VICTORK@il.ibm.com,
        tglx@linutronix.de, oleg@redhat.com, mikey@neuling.org,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] tools/perf: Add required memory barriers
Message-ID: <20131106142840.GH26785@twins.programming.kicks-ass.net>
References: <20131030104246.GH16117@laptop.programming.kicks-ass.net>
 <tip-a94d342b9cb09edfe888ea972af0883b6a8d992b@git.kernel.org>
 <alpine.DEB.2.02.1311060847340.27224@pianoman.cluster.toy>
 <20131106140011.GL10651@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131106140011.GL10651@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 06, 2013 at 03:00:11PM +0100, Peter Zijlstra wrote:
> On Wed, Nov 06, 2013 at 08:50:47AM -0500, Vince Weaver wrote:
> > On Wed, 6 Nov 2013, tip-bot for Peter Zijlstra wrote:
> > 
> > > +++ b/tools/perf/util/evlist.h
> > > @@ -177,7 +177,7 @@ int perf_evlist__strerror_open(struct perf_evlist *evlist, int err, char *buf, s
> > >  static inline unsigned int perf_mmap__read_head(struct perf_mmap *mm)
> > >  {
> > >  	struct perf_event_mmap_page *pc = mm->base;
> > > -	int head = pc->data_head;
> > > +	int head = ACCESS_ONCE(pc->data_head);
> > >  	rmb();
> > >  	return head;
> > 
> > so is this ACCESS_ONCE required now for proper access to the mmap buffer?
> 
> Pretty much; otherwise your C compiler is allowed to mess it up.
> 
> > remember that there are users trying to use this outside of the kernel 
> > where we don't necessarily have access to internal kernl macros.  Some of 
> > these users aren't necessarily GPLv2 compatible either (PAPI for example 
> > is more or less BSD licensed) so just cutting and pasting chunks of 
> > internal kernel macros isn't always the best route either.
> 
> Other license stuff is not my problem; that said I doubt there's much
> copyright to claim on a volatile cast.

Also, does PAPI actually use the buffer then? I thought that was
strictly self monitoring.
