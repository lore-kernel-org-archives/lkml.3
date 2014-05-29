Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965227AbaE2O0O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 10:26:14 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:38175 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964888AbaE2O0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 10:26:09 -0400
Date: Thu, 29 May 2014 16:26:05 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Christoph Lameter <cl@gentwo.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>,
        John Stultz <johnstul@us.ibm.com>, Mike Frysinger <vapier@gentoo.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Hakan Akkan <hakanakkan@gmail.com>,
        Max Krasnyansky <maxk@qualcomm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, hughd@google.com,
        viresh.kumar@linaro.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org
Subject: Re: vmstat: On demand vmstat workers V5
Message-ID: <20140529142602.GA20258@localhost.localdomain>
References: <alpine.DEB.2.10.1405121317270.29911@gentwo.org>
 <20140528152107.GB6507@localhost.localdomain>
 <alpine.DEB.2.10.1405281110210.22514@gentwo.org>
 <20140529003609.GG6507@localhost.localdomain>
 <alpine.DEB.2.10.1405290902180.11514@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1405290902180.11514@gentwo.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 09:07:44AM -0500, Christoph Lameter wrote:
> On Thu, 29 May 2014, Frederic Weisbecker wrote:
> 
> > The cpumasks in cpu.c are special as they are the base of the cpumask_var_t
> > definition. They are necessary to define nr_cpu_bits which is the base of
> > cpumask_var_t allocations. As such they must stay lower level and defined
> > on top of NR_CPUS.
> >
> > But most other cases don't need that huge static bitmap. I actually haven't
> > seen any other struct cpumask than isn't based on cpumask_var_t.
> 
> Well yes and I am tying directly into that scheme there in cpu.c to
> display the active vmstat threads in sysfs. so its the same.

I don't think so. Or is there something in vmstat that cpumask_var_t
definition depends upon?

> 
> > Please post it on a new thread so it gets noticed by others.
> 
> Ok. Will do when we got agreement on the cpumask issue.
> 
> I would like to have some way to display the activities on cpus in /sysfs
> like I have done here with the active vmstat workers.
> 
> What I think we need is display cpumasks for
> 
> 1. Cpus where the tick is currently off
> 2. Cpus that have dynticks enabled.
> 3. Cpus that are idle

You should find all that in /proc/timer_list

Now for CPUs that have full dynticks enabled, we probably need something
in sysfs. We could dump the nohz cpumask somewhere. For now you can only grep
the dmesg

> 4. Cpus that are used for RCU.

So, you mean those that aren't in extended grace period (between rcu_user_enter()/exit
or rcu_idle_enter/exit)?

Paul?
