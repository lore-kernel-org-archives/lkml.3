Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130AbaAMQHX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:07:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64552 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752631AbaAMQHR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:07:17 -0500
Date: Mon, 13 Jan 2014 17:07:05 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: check && lockdep_no_validate (Was: lockdep: Introduce
	wait-type checks)
Message-ID: <20140113160705.GA7616@redhat.com>
References: <20140109111516.GE7572@laptop.programming.kicks-ass.net> <20140109163120.GA8038@redhat.com> <20140109170823.GF7572@laptop.programming.kicks-ass.net> <20140109175448.GA17673@redhat.com> <20140112205814.GP7572@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140112205814.GP7572@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12, Peter Zijlstra wrote:
>
> On Thu, Jan 09, 2014 at 06:54:48PM +0100, Oleg Nesterov wrote:
> >
> > --- a/kernel/locking/lockdep.c
> > +++ b/kernel/locking/lockdep.c
> > @@ -1939,7 +1939,8 @@ check_prevs_add(struct task_struct *curr, struct held_lock *next)
> >  		 * Only non-recursive-read entries get new dependencies
> >  		 * added:
> >  		 */
> > -		if (hlock->read != 2) {
> > +		if (hlock->read != 2 &&
> > +		    hlock->instance->key != &__lockdep_no_validate__) {
> >  			if (!check_prev_add(curr, hlock, next,
> >  						distance, trylock_loop))
> >  				return 0;
> >
>
> Hmm, you are quite right indeed;

Thanks!

> although I would write it like:
>
>   if (hlock->read != 2 && hlock->check == 2)
>
> because the __lockdep_no_validate__ thing forces the ->check value to 1.

Agreed, hlock->check == 2 looks better. But this connects to another
patch I sent which removes hlock->check...

OK, I'll wait for review on that patch, then resend this one with
->check or __lockdep_no_validate__ depending on the result.

Oleg.

