Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751498Ab3FZHGB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 03:06:01 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37636 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195Ab3FZHGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 03:06:00 -0400
Date: Wed, 26 Jun 2013 09:05:34 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: deadlock in scheduler enabling HRTICK feature
Message-ID: <20130626070533.GA3601@dyad.programming.kicks-ass.net>
References: <51CA0622.8010105@gmail.com>
 <20130625211713.GA18796@laptop.programming.kicks-ass.net>
 <51CA0980.8010409@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51CA0980.8010409@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 03:20:00PM -0600, David Ahern wrote:
> On 6/25/13 3:17 PM, Peter Zijlstra wrote:
> >On Tue, Jun 25, 2013 at 03:05:38PM -0600, David Ahern wrote:
> >>Peter/Ingo:
> >>
> >>I can reliably cause a deadlock in the scheduler by enabling the HRTICK
> >>feature. I first hit the problem with 2.6.27 but have been able to reproduce
> >>it with newer kernels. I have not tried top of Linus' tree, so perhaps this
> >>has been fixed in 3.10.
> >
> >Yeah, I know.. its been on the todo list forever but its never been
> >important. Its disabled by default and all sched debug features are for
> >those brave enough to keep the pieces ;-)
> >
> 
> Not a whole to of pieces to keep.
> 
> What is the expectation that the feature provides? not a whole lot of
> documentation on it. I walked down the path wondering if it solved an odd
> problem we are seeing with the CFS in 2.6.27 kernel.

Its supposed to use hrtimers for slice expiry instead of the regular tick.

IIRC it did work at some point but bitrotted a bit since. The good news is that
the deadline scheduler wants to use it and I'll probably have to fix it up
then.

But yes, I need to write more comments in sched/features.h
