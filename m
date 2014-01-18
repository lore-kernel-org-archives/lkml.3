Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467AbaARDZV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 22:25:21 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:55968 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041AbaARDZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 22:25:17 -0500
Message-ID: <1390015514.5444.46.camel@marge.simpson.net>
Subject: Re: [PATCH] rcu: Eliminate softirq processing from rcutree
From: Mike Galbraith <bitbucket@online.de>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: paulmck@linux.vnet.ibm.com, linux-rt-users@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Date: Sat, 18 Jan 2014 04:25:14 +0100
In-Reply-To: <20140117171441.GG5785@linutronix.de>
References: <20131221193900.GA8427@linutronix.de>
	 <1387681647.5412.25.camel@marge.simpson.net>
	 <1387702631.5412.101.camel@marge.simpson.net>
	 <1387773533.5369.16.camel@marge.simpson.net>
	 <20131224193636.GD19211@linux.vnet.ibm.com>
	 <1387940854.5373.8.camel@marge.simpson.net>
	 <20131225075544.GE19211@linux.vnet.ibm.com>
	 <1387993057.5346.17.camel@marge.simpson.net>
	 <20140117171441.GG5785@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:WmfpzX3sLdshzZZiBbCwMHbio87rDrIfnsfAtdnKdIc
 83R/cSkCR6UQ53tsqNtEOBNidWvI3oOg25Uamjju6v6Iv/EYAo
 79Lr9Mj4cdP1jwRlg8LlrM4NQpuSnbBjEFx9LukN6BUWwMVAh6
 TH3tDMJhkYKEuoCqdzQYFf0PXs9DHdnljMNGoNSQnmwh/BudIh
 p8uB8BlhJQLH6WkZsH4RLX1MsLKniD8bhV6B0mbNxS8Ge1WRp9
 ZXqjzk9XeB68WrXxYo+0Ji8XEtKDMYO/J+e0n5gwLM50z6/Grl
 3N/1wRbIg5hnTGZHv413Hlb1MXwHXGsy9Vz+hyz7cKLqcHcDrk
 AR6RVArzlFH+rA18o7xyRrR5sS8gZRTAJJTXQ0TsLmDHREZsEQ
 GMNzJ1o9g+/YQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-01-17 at 18:14 +0100, Sebastian Andrzej Siewior wrote: 
> * Mike Galbraith | 2013-12-25 18:37:37 [+0100]:
> 
> >On Tue, 2013-12-24 at 23:55 -0800, Paul E. McKenney wrote: 
> >> On Wed, Dec 25, 2013 at 04:07:34AM +0100, Mike Galbraith wrote:
> >
> >Having sufficiently recovered from turkey overdose to be able to slither
> >upstairs (bump bump bump) to check on the box, commenting..
> >
> ># timers-do-not-raise-softirq-unconditionally.patch
> ># rtmutex-use-a-trylock-for-waiter-lock-in-trylock.patch
> >
> >..those two out does seem to have stabilized the thing.
> 
> timers-do-not-raise-softirq-unconditionally.patch is on its way out.
> 
> rtmutex-use-a-trylock-for-waiter-lock-in-trylock.patch confues me.
> Didn't you report once that your box deadlocks without this patch? Now
> your 64way box on the other hand does not work with it?

If 'do not raise' is applied, 'use a trylock' won't save you.  If 'do
not raise' is not applied, _and_ you wisely do not try to turn on very
expensive nohz_full, things work fine without 'use a trylock'.

-Mike

