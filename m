Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754950Ab3F1JAb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 05:00:31 -0400
Received: from mail-ea0-f180.google.com ([209.85.215.180]:35564 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754829Ab3F1JA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 05:00:26 -0400
Date: Fri, 28 Jun 2013 11:00:21 +0200
From: Ingo Molnar <mingo@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Mike Galbraith <efault@gmx.de>
Subject: Re: deadlock in scheduler enabling HRTICK feature
Message-ID: <20130628090021.GA25431@gmail.com>
References: <51CA0622.8010105@gmail.com>
 <20130625211713.GA18796@laptop.programming.kicks-ass.net>
 <51CA0980.8010409@gmail.com>
 <20130626070533.GA3601@dyad.programming.kicks-ass.net>
 <51CB1AE9.5090709@gmail.com>
 <20130627104309.GQ28407@twins.programming.kicks-ass.net>
 <51CCBCA9.1000200@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51CCBCA9.1000200@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Ahern <dsahern@gmail.com> wrote:

> On 6/27/13 4:43 AM, Peter Zijlstra wrote:
> >On Wed, Jun 26, 2013 at 10:46:33AM -0600, David Ahern wrote:
> >>On 6/26/13 1:05 AM, Peter Zijlstra wrote:
> >>>>What is the expectation that the feature provides? not a whole lot of
> >>>>documentation on it. I walked down the path wondering if it solved an odd
> >>>>problem we are seeing with the CFS in 2.6.27 kernel.
> >>>
> >>>Its supposed to use hrtimers for slice expiry instead of the regular tick.
> >>
> >>So theoretically CPU bound tasks would get preempted sooner? That was my
> >>guess/hope anyways.
> >
> >Doth the below worketh?
> 
> It doth.
> 
> Usually make -j 8 for a kernel build in a VM would lock it up pretty
> quickly. With the patch I was able to run full builds multiple
> times.
> 
> As for the solution you are avoiding the nesting by not waking up
> the softirq daemon.

I guess we could merge this fix?

Thanks,

	Ingo
