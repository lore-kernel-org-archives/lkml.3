Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756054AbaAVUQZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 15:16:25 -0500
Received: from merlin.infradead.org ([205.233.59.134]:41394 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711AbaAVUQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 15:16:23 -0500
Date: Wed, 22 Jan 2014 21:16:05 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Sasha Levin <sasha.levin@oracle.com>,
        Arjan van de Ven <arjan@linux.intel.com>, lenb@kernel.org,
        rjw@rjwysocki.net, Eliezer Tamir <eliezer.tamir@linux.intel.com>,
        rui.zhang@intel.com, jacob.jun.pan@linux.intel.com,
        Mike Galbraith <bitbucket@online.de>, Ingo Molnar <mingo@kernel.org>,
        hpa@zytor.com, paulmck@linux.vnet.ibm.com,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>,
        Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org,
        dyoung@redhat.com
Subject: Re: [PATCH 13/15] sched: Use a static_key for sched_clock_stable
Message-ID: <20140122201605.GU11314@laptop.programming.kicks-ass.net>
References: <20140122120048.GB389@x4>
 <20140122120757.GL31570@twins.programming.kicks-ass.net>
 <20140122122609.GA392@x4>
 <20140122123022.GN31570@twins.programming.kicks-ass.net>
 <20140122131456.GA389@x4>
 <52DFD50E.800@oracle.com>
 <20140122183538.GA389@x4>
 <20140122184253.GN30183@twins.programming.kicks-ass.net>
 <20140122190905.GA391@x4>
 <20140122191254.GA390@x4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140122191254.GA390@x4>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 22, 2014 at 08:12:54PM +0100, Markus Trippelsdorf wrote:
> On 2014.01.22 at 20:09 +0100, Markus Trippelsdorf wrote:
> > On 2014.01.22 at 19:42 +0100, Peter Zijlstra wrote:
> > > On Wed, Jan 22, 2014 at 07:35:38PM +0100, Markus Trippelsdorf wrote:
> > > 
> > > > >FYI it happens on real hardware on my machine:
> > > 
> > > > >[   60.375384] process: using AMD E400 aware idle routine
> > > 
> > > > But this is a different issue. I've bisected it to:
> > > > 
> > > > commit 20d1c86a57762f0a33a78988e3fc8818316badd4
> > > > Author: Peter Zijlstra <peterz@infradead.org>
> > > > Date:   Fri Nov 29 15:40:29 2013 +0100
> > > > 
> > > >     sched/clock, x86: Rewrite cyc2ns() to avoid the need to disable IRQs
> > > > 
> > > > Reverting the commit "fixes" the issue:
> > > 
> > > Hurm..
> > 
> > Turns out the fix is simple:
> 
> No. It isn't. I've tested the wrong kernel. Please ignore.

I think its the right region to look through. My current suspect is the
linear continuity fit with the initial 'random' multiplier.

That initial 'random' multiplier can get us quite high, and we'll fit
the function to match that but continue at a sane rate.

I'll try and prod a little more later this evening as time permits.


