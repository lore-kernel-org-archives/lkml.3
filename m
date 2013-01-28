Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756515Ab3A1P4L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 10:56:11 -0500
Received: from mout.gmx.net ([212.227.15.18]:56206 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755739Ab3A1P4H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 10:56:07 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18n6ZxOg6snua4yhU1IUFM48JcK8K6YhdwkNyPcpn
	mri8Q6Cl+l/1de
Message-ID: <1359388558.5783.171.camel@marge.simpson.net>
Subject: Re: [patch v4 0/18] sched: simplified fork, release load avg and
 power awareness scheduling
From: Mike Galbraith <efault@gmx.de>
To: Borislav Petkov <bp@alien8.de>
Cc: Alex Shi <alex.shi@intel.com>, torvalds@linux-foundation.org,
        mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, pjt@google.com,
        namhyung@kernel.org, vincent.guittot@linaro.org,
        gregkh@linuxfoundation.org, preeti@linux.vnet.ibm.com,
        viresh.kumar@linaro.org, linux-kernel@vger.kernel.org
Date: Mon, 28 Jan 2013 16:55:58 +0100
In-Reply-To: <20130128152241.GC6109@pd.tnic>
References: <1359261385.5803.46.camel@marge.simpson.net>
	 <20130127103508.GB8894@pd.tnic> <51052ACB.3070703@intel.com>
	 <1359301903.5805.11.camel@marge.simpson.net>
	 <1359350266.5783.39.camel@marge.simpson.net>
	 <20130128095501.GB6109@pd.tnic>
	 <1359369884.5783.117.camel@marge.simpson.net>
	 <20130128112922.GA29384@pd.tnic>
	 <1359372743.5783.136.camel@marge.simpson.net>
	 <1359373246.5783.138.camel@marge.simpson.net>
	 <20130128152241.GC6109@pd.tnic>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-01-28 at 16:22 +0100, Borislav Petkov wrote: 
> On Mon, Jan 28, 2013 at 12:40:46PM +0100, Mike Galbraith wrote:
> > > No no, that's not restricted to one node.  It's just overloaded because
> > > I turned balancing off at the NODE domain level.
> > 
> > Which shows only that I was multitasking, and in a rush.  Boy was that
> > dumb.  Hohum.
> 
> Ok, let's take a step back and slow it down a bit so that people like me
> can understand it: you want to try it with disabled load balancing on
> the node level, AFAICT. But with that many tasks, perf will suck anyway,
> no? Unless you want to benchmark the numa-aware aspect and see whether
> load balancing on the node level feels differently, perf-wise?

The broken thought was, since it's not wakeup path, stop node balance..
but killing all of it killed FORK/EXEC balance, oops.

I think I'm done with this thing though.  See mail I just sent.   There
are better things to do than letting box jerk my chain endlessly ;-)

-Mike

