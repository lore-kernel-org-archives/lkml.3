Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787Ab3C1SNl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 14:13:41 -0400
Received: from mail-ve0-f178.google.com ([209.85.128.178]:49058 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718Ab3C1SNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 14:13:39 -0400
Date: Thu, 28 Mar 2013 11:13:32 -0700
From: Tejun Heo <tj@kernel.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: pjt@google.com, paul.mckenney@linaro.org, tglx@linutronix.de,
        suresh.b.siddha@intel.com, venki@google.com, mingo@redhat.com,
        peterz@infradead.org, rostedt@goodmis.org,
        linaro-kernel@lists.linaro.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, Arvind.Chauhan@arm.com,
        linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 3/7] workqueue: Add helpers to schedule work on any cpu
Message-ID: <20130328181332.GD14088@htj.dyndns.org>
References: <cover.1363617402.git.viresh.kumar@linaro.org>
 <fb2e721fc43fbc3517a7ebb905aa573b12bb83a5.1363617402.git.viresh.kumar@linaro.org>
 <20130321001211.GC31256@htj.dyndns.org>
 <CAKohponKUGbwEZ_edu353Y7YVZKgFOhZunTSUi04FGYWveftkw@mail.gmail.com>
 <20130321182937.GB20500@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130321182937.GB20500@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 11:29:37AM -0700, Tejun Heo wrote:
> Yes, I actually like that part a lot although I do wish the idle check
> was inlined.
> 
> What I'm wondering is whether the kinda out-of-band decision via
> sched_select_cpu() is justified given that it can and is likely to go
> through full scheduling decision anyway.  For timer, we don't have
> that, so it makes sense.  For work items, it's a bit different.
> 
> To rephrase, *if* the scheduler can't already make proper decisions
> regarding power consumption on an idlish system, maybe it can be
> improved to do so?  It could as well be that this CPU selection is
> special enough that it's just better to keep it separate as this
> patchset proposes.  This is something up to the scheduler people.
> Peter, Ingo, what do you guys think?

Ping.  Peter, Ingo?

Viresh, would it be difficult to make another measurement of the same
workload with the said workqueues converted to unbound?  I think that
would at least provide a nice reference point.

Thanks.

-- 
tejun
