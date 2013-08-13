Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758430Ab3HMQ33 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 12:29:29 -0400
Received: from merlin.infradead.org ([205.233.59.134]:59257 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758170Ab3HMQ3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 12:29:25 -0400
Date: Tue, 13 Aug 2013 18:29:16 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Mike Galbraith <bitbucket@online.de>, Peter Anvin <hpa@zytor.com>,
        Andi Kleen <ak@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] per-cpu preempt_count
Message-ID: <20130813162916.GD24092@twins.programming.kicks-ass.net>
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
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 13, 2013 at 08:39:46AM -0700, Linus Torvalds wrote:
> Also, I think your patch is too big, and you should have aim to just
> made the "preempt_count()" helper function mask off PREEMPT_MASK, so
> that you don't change the semantics of that. I realize that there are
> a couple of users that do things like "preempt_count() += x", and you
> probably wanted to keep those working, but I think it is easier (and
> cleaner) to fix those to "preempt_count_update(x)" instead of adding
> all those explicitly PREEMPT_MASK masks.

For sure.. but I didn't want to spend time cleaning things up until
there was something half-way promising in it.

The inverted need_resched that gives decl+jnz idea from Ingo should do
it though. Not entirely sure I understand your MSB + jns suggestion:

  0x80000002 - 1 = 0x80000001

Both are very much signed and neither wants to cause a reschedule.
