Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932082Ab3HMP4o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 11:56:44 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:60470 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758486Ab3HMP4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 11:56:41 -0400
Date: Tue, 13 Aug 2013 17:56:37 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mike Galbraith <bitbucket@online.de>, Peter Anvin <hpa@zytor.com>,
        Andi Kleen <ak@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] per-cpu preempt_count
Message-ID: <20130813155637.GA5280@gmail.com>
References: <20130812115113.GE27162@twins.programming.kicks-ass.net>
 <CA+55aFznj9WqGa_Qa0B4=5iTio2br54uJG7xkm6otN2sG2P=8w@mail.gmail.com>
 <20130812175830.GB18691@gmail.com>
 <CA+55aFw=S4xxdkKpjQdg77CehBBW6S-13N6-7tq4=-nN_cCUKA@mail.gmail.com>
 <20130813103056.GA2170@gmail.com>
 <20130813122652.GA24092@twins.programming.kicks-ass.net>
 <CA+55aFxieQGUkEi9i=LRzVK2DRvavKgF-YEvskvJhF3-5xiU2A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxieQGUkEi9i=LRzVK2DRvavKgF-YEvskvJhF3-5xiU2A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Tue, Aug 13, 2013 at 5:26 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> >
> > So we're now down to something like:
> >
> >   decl fs:preempt_count
> >   cmpl PREEMPT_NEED_RESCHED,fs:preempt_count
> >   jnz 1f
> 
> Well, this isn't worth doing unless you can make PREEMPT_NEED_RESCHED be 
> the high bit, and we can combine it into just "decl+jns". Otherwise we'd 
> be better off with the simpler two separate adjacent variables.

Definitely, the cmpl should be avoided.

PREEMPT_NEED_RESCHED could be made the high bit - or maybe an even simpler 
solution is to invert its meaning: making '0' the "it needs to resched!" 
case, so the check would be decl+jz?

Thanks,

	Ingo
