Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933317AbaDINmi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 09:42:38 -0400
Received: from merlin.infradead.org ([205.233.59.134]:42485 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932826AbaDINmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 09:42:36 -0400
Date: Wed, 9 Apr 2014 15:42:13 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/2] nohz: use seqlock to avoid race on idle time stats v2
Message-ID: <20140409134213.GB10526@twins.programming.kicks-ass.net>
References: <5338CC86.9080602@jp.fujitsu.com>
 <5338CE0B.1050100@jp.fujitsu.com>
 <CAK1hOcMmmq=5EVLBrAd44HC+EHrnztABU48gd9BgK+LUNBJSOQ@mail.gmail.com>
 <20140404160328.GA10042@localhost.localdomain>
 <CAK1hOcMZPDhUzvJk0Q0rkkBh1tS=O+HU9ufEmX7VwnjhsSgQeA@mail.gmail.com>
 <20140405100813.GA16696@localhost.localdomain>
 <CAK1hOcO2X7juCSkKrd85q8_i8Xv4vhZg2YKtzybwmWukoCEyow@mail.gmail.com>
 <20140407181736.GA4106@localhost.localdomain>
 <CAK1hOcPjTxUaUjKYngpgsxY0yN-xNnGH7CVxPqjB4jb8r=Z74w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK1hOcPjTxUaUjKYngpgsxY0yN-xNnGH7CVxPqjB4jb8r=Z74w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 09, 2014 at 02:49:55PM +0200, Denys Vlasenko wrote:
> > I doubt that users are interested in such random accounting. They want
> > to know either:
> >
> > 1) how much time was spent waiting on IO by the whole system
> 
> Hmm, I think I just said the same thing :)
> 
> > 2) how much time was spent waiting on IO per task

I think we already have enough cruft to measure that. We have delayacct
measuring this and schedstat also seems to measure this.

> > 3) how much time was spent waiting on IO per CPU that initiated
> >    IOs, or per CPU which ran task completing IOs. In order to have
> >    an overview on where these mostly happened.

I'm not entirely sure this makes sense in general. It only makes sense
in the specific case where tasks are affine to a single CPU and that cpu
is not part of any balance domain.

I think this is a specific enough case (exclusive cpusets in general)
that we can ignore it. After all, we do not have per cpuset load numbers
at all, so why bother with this one.

At which point I think Denys makes a fair argument.
