Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206AbaDPJhF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 05:37:05 -0400
Received: from merlin.infradead.org ([205.233.59.134]:56688 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755027AbaDPJhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 05:37:00 -0400
Date: Wed, 16 Apr 2014 11:36:37 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org,
        Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Denys Vlasenko <vda.linux@googlemail.com>, stable@vger.kernel.org
Subject: Re: [PATCH 2/2] nohz: use delayed iowait accounting to avoid race on
 idle time stats
Message-ID: <20140416093637.GR11182@twins.programming.kicks-ass.net>
References: <53465F54.708@jp.fujitsu.com>
 <534660D2.1080505@jp.fujitsu.com>
 <20140415101910.GN11096@twins.programming.kicks-ass.net>
 <534E2422.1040706@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <534E2422.1040706@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2014 at 03:33:06PM +0900, Hidetoshi Seto wrote:
> I hope I can clarify my idea and thoughts in the following sentence...
> 
> 
> [1] : should we make a change on a /proc/stat field semantic? 
> 
> As Frederic stated in previous mail:
> <quote>
> > So what we can do for example is to account it per task and update stats
> > on the CPU where the blocking task wakes up. This way we guarantee
> > that we only account locally, which is good for scalability.
> > 
> > This is going to be an ABI change on a /proc/stat field semantic.
> > We usually can not do that as it can break userspace. But I think
> > we have a reasonable exception here:
> > 
> > 1) On a performance POV we don't have the choice.
> > 
> > 2) It has always been a buggy stat on SMP. Given the possible fast iowait update
> > rate, I doubt it has ever dumped correct stats. So I guess that few user apps
> > have ever correctly relied on it. 
> </quote>
> 
> Basically I agree with this idea if we maintain only latest upstream in
> development. But in case if target kernel is in family of stables or
> some kind of distributor's kernel, I suppose this idea is not acceptable
> because keeping semantics are very important for such environment.
> 
> For example, you may propose that "hey, per-cpu iowait is completely
> crap! so how about making this field in /proc/stat to stick to 0?"
> It would be OK for latest upstream, as interim measure till new
> iowait accounting mechanism is invented. But for stable kernels,
> it will bring new regression report so it will not be any help.
> 
> So we need 2 operations:
>   a) remove regression

What regression; there's never been talk about a regression, just a bug
found. AFAICT this 'regression' is ever since we introduced NOHZ or
somesuch, which is very long ago indeed.

And since its basically been broken forever, there's no rush what so
ever.

>   b) implement new iowait accounting mechanism
> 
> What Frederic mentioned is that we don't need a) once if we invent
> the solution for b). But I doubt it because a) is still required
> for stable environment including some distributor's kernel.
> It is clear that patches for b) will not be backportable.
> 
> Still the b) is disease that has no known cure. There is no reason
> to wait works on b) before starting works for a).

As stated, there is no a). Its been forever broken. There is no urgency.
