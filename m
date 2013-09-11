Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756669Ab3IKFgH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 01:36:07 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:44872 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754571Ab3IKFgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 01:36:05 -0400
Date: Wed, 11 Sep 2013 07:36:01 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 3/6] tree-sweep: Include linux/sched.h for might_sleep
 users
Message-ID: <20130911053601.GA15110@gmail.com>
References: <1376687844-19857-1-git-send-email-andi@firstfloor.org>
 <1376687844-19857-4-git-send-email-andi@firstfloor.org>
 <CAMuHMdU-EJdS2epcLUKXThSdGcQd56aXyPH5TyyhGZeiDtZBxQ@mail.gmail.com>
 <20130910165212.b95be29e2816dc69c909c058@linux-foundation.org>
 <20130911045109.GE18242@two.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130911045109.GE18242@two.firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> On Tue, Sep 10, 2013 at 04:52:12PM -0700, Andrew Morton wrote:
> > On Sat, 31 Aug 2013 20:22:23 +0200 Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > 
> > > On Fri, Aug 16, 2013 at 11:17 PM, Andi Kleen <andi@firstfloor.org> wrote:
> > > > might_sleep is moving from linux/kernel.h to linux/sched.h, so any users
> > > > need to include linux/sched.h
> > > 
> > > Really? <linux/sched.h> is the worst choice w.r.t. include hell.
> > 
> > Yes.  Mechanically adding sched.h inclusions into .h files will cause
> > problems.
> > 
> > I've had decent success with this sort of thing by adding new,
> > finer-grained headers.  Maybe include/linux/might_sleep.h would be a
> > good starting point to fix whatever it was that this fixed.
> 
> Ok. I'll look into that and send new patches.
> 
> Some of it may be obsolete with Peter's recent preempt work.

The best order from a maintenance and merge POV would be to rebase your 
bits on top of Peter's preempt_count optimization work, which is the more 
comprehensive approach. That allows you to drop the obsolete bits, and 
wait for Peter to pick up your bits.

The two interact so we want to handle them together in any case, in the 
scheduler tree.

Thanks,

	Ingo
