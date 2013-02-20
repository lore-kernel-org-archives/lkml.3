Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933238Ab3BTInz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 03:43:55 -0500
Received: from mout.gmx.net ([212.227.15.18]:58611 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751717Ab3BTIny (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 03:43:54 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/malwiR5HmmlZyYGw8torPE8GeLYkLOsHsF9qgIV
	M6kFb/gNr0v9Ei
Message-ID: <1361349823.5919.78.camel@marge.simpson.net>
Subject: Re: [patch v5 10/15] sched: packing transitory tasks in wake/exec
 power balancing
From: Mike Galbraith <efault@gmx.de>
To: Alex Shi <alex.shi@intel.com>
Cc: peterz@infradead.org, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        torvalds@linux-foundation.org, mingo@redhat.com, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, vincent.guittot@linaro.org,
        gregkh@linuxfoundation.org, preeti@linux.vnet.ibm.com,
        viresh.kumar@linaro.org, linux-kernel@vger.kernel.org,
        morten.rasmussen@arm.com
Date: Wed, 20 Feb 2013 09:43:43 +0100
In-Reply-To: <51248541.3030004@intel.com>
References: <1361164062-20111-1-git-send-email-alex.shi@intel.com>
	 <1361164062-20111-11-git-send-email-alex.shi@intel.com>
	 <20130218084439.GB10009@lge.com> <5121ECD9.3020300@intel.com>
	 <5124654E.8040001@intel.com> <1361346030.5919.63.camel@marge.simpson.net>
	 <51248541.3030004@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-02-20 at 16:11 +0800, Alex Shi wrote: 
> On 02/20/2013 03:40 PM, Mike Galbraith wrote:
> > On Wed, 2013-02-20 at 13:55 +0800, Alex Shi wrote:
> > 
> >> Joonsoo Kim suggests not packing exec task, since the old task utils is
> >> possibly unuseable.
> > 
> > (I'm stumbling around in rtmutex PI land, all dazed and confused, so
> > forgive me if my peripheral following of this thread is off target;)
> > 
> > Hm, possibly.  Future behavior is always undefined, trying to predict
> > always a gamble... so it looks to me like not packing on exec places a
> > bet against the user, who chose to wager that powersaving will happen
> > and it won't cost him too much, if you don't always try to pack despite
> > any risks.  The user placed a bet on powersaving, not burst performance.
> > 
> > Same for the fork, if you spread to accommodate a potential burst, you
> > bin the power wager, so maybe it's not in his best interest.. fork/exec
> > is common, if it's happening frequently, you'll bin the potential power
> > win frequently, reducing effectiveness, and silently trading power for
> > performance when the user asked to trade performance for a lower
> > electric bill.
> > 
> > Dunno, just a thought, but I'd say for powersaving policy, you have to
> > go just for broke and hope it works out.  You can't know it won't, but
> > you'll toss potential winnings every time you don't roll the dice.
> 
> 
> Sounds reasonable too.
> 
> I have no idea of the of the decision now.
> And guess many guys dislike to use a knob to let user do the choice.

Nobody likes seeing yet more knobs much, automagical is preferred.
Trouble with automagical heuristics usage is that any heuristic will
inevitably get it wrong sometimes, so giving the user control over usage
is IMHO a good thing.. and once we give the user the choice, we must
honor it, else what was the point?

Anyway, fwiw, I liked what I saw test driving the patch set..

> What's your opinions, Peter?

..but maintainer opinions carry more weight than mine, even to me ;-)

-Mike

