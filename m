Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932713AbaJ2LhF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 07:37:05 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:35779 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932461AbaJ2LhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 07:37:03 -0400
Date: Wed, 29 Oct 2014 12:36:55 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Mike Galbraith <umgwanakikbuti@gmail.com>, mingo@kernel.org,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        ilya.dryomov@inktank.com, linux-kernel@vger.kernel.org,
        Eric Paris <eparis@redhat.com>, rafael.j.wysocki@intel.com
Subject: Re: [PATCH 00/11] nested sleeps, fixes and debug infrastructure
Message-ID: <20141029113655.GD10476@twins.programming.kicks-ass.net>
References: <20140925090619.GA5430@worktop>
 <20140925091556.GB5430@worktop>
 <20141002102251.GA6324@worktop.programming.kicks-ass.net>
 <20141002121553.GB6324@worktop.programming.kicks-ass.net>
 <20141027134103.GA10476@twins.programming.kicks-ass.net>
 <20141028000703.GA22964@redhat.com>
 <20141028082335.GM3337@twins.programming.kicks-ass.net>
 <20141029000055.GA12107@redhat.com>
 <20141029093503.GX3337@twins.programming.kicks-ass.net>
 <20141029113103.GC10476@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141029113103.GC10476@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 12:31:03PM +0100, Peter Zijlstra wrote:
> On Wed, Oct 29, 2014 at 10:35:03AM +0100, Peter Zijlstra wrote:
> > On Wed, Oct 29, 2014 at 01:00:56AM +0100, Oleg Nesterov wrote:
> 
> > > But what if it calls try_to_freeze() and another thread (which should
> > > be frozen too) sleeps in kthread_stop() ?
> > 
> > Fair point indeed. Now I had a look at __refrigerator() and is there any
> > reason we should not remove that .check_kthr_stop argument and replace
> > it with an unconditional (current->flags & PF_KTHREAD) ?
> 
> Hmm, doesn't kthread_freezable_should_stop() suffer the same problem? It
> should not refrigerate when should_stop.

Oh never you mind, i've got my head on backwards it seems, it uses
__refrigerator(.check_kthr_stop = true), which does another should_stop
test.
