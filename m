Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935785Ab3BOMdL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 07:33:11 -0500
Received: from mout.gmx.net ([212.227.17.21]:57496 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935752Ab3BOMdK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 07:33:10 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/jkb5As4HjKdsSzB97z4aEzEpGY4p8TQRcU/OTGV
	DKtClAAdS2SxNj
Message-ID: <1360931579.4736.29.camel@marge.simpson.net>
Subject: Re: [RFC] sched: The removal of idle_balance()
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Paul Turner <pjt@google.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Clark Williams <clark@redhat.com>,
        Andrew Theurer <habanero@us.ibm.com>
Date: Fri, 15 Feb 2013 13:32:59 +0100
In-Reply-To: <1360930908.2739.1.camel@laptop>
References: <1360908819.23152.97.camel@gandalf.local.home>
	 <1360913172.4736.20.camel@marge.simpson.net>
	 <1360930908.2739.1.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-02-15 at 13:21 +0100, Peter Zijlstra wrote: 
> On Fri, 2013-02-15 at 08:26 +0100, Mike Galbraith wrote:
> > 
> > (the throttle is supposed to keep idle_balance() from doing severe
> > damage, that may want a peek/tweak)
> 
> Right, as it stands idle_balance() can do a lot of work and if the avg
> idle time is less than the time we spend looking for a suitable task we
> loose.
> 
> I've wanted to make this smarter by having the cpufreq/cpuidle avg idle
> time guestimator in the scheduler core so we actually know how log we
> expect to be idle and couple that with a cache refresh cost per sched
> domain (something we used to have pre 2.6.21 or so) so we can auto-limit
> the domain traversal for idle_balance.
> 
> So far that's all fantasy though..
> 
> Related, I wanted to use the idle time guestimate to 'optimize' the idle
> loop, currently that stuff is stupid expensive and pokes at timer
> hardware etc.. if we know we won't be idle longer than it takes to poke
> at timer hardware, don't go into nohz mode etc.

Yup.  My trees have nohz throttled too, it's too expensive for fast
switchers scheduling cross core.

-Mike

