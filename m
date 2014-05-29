Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757927AbaE2QYW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 12:24:22 -0400
Received: from qmta02.emeryville.ca.mail.comcast.net ([76.96.30.24]:47871 "EHLO
	qmta02.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757491AbaE2QYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 12:24:20 -0400
Date: Thu, 29 May 2014 11:24:15 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
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
In-Reply-To: <20140529142602.GA20258@localhost.localdomain>
Message-ID: <alpine.DEB.2.10.1405291121400.12545@gentwo.org>
References: <alpine.DEB.2.10.1405121317270.29911@gentwo.org> <20140528152107.GB6507@localhost.localdomain> <alpine.DEB.2.10.1405281110210.22514@gentwo.org> <20140529003609.GG6507@localhost.localdomain> <alpine.DEB.2.10.1405290902180.11514@gentwo.org>
 <20140529142602.GA20258@localhost.localdomain>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 May 2014, Frederic Weisbecker wrote:

> > Well yes and I am tying directly into that scheme there in cpu.c to
> > display the active vmstat threads in sysfs. so its the same.
>
> I don't think so. Or is there something in vmstat that cpumask_var_t
> definition depends upon?

This patch definitely ties the vmstat cpumask into the scheme in cpu.c

> > I would like to have some way to display the activities on cpus in /sysfs
> > like I have done here with the active vmstat workers.
> >
> > What I think we need is display cpumasks for
> >
> > 1. Cpus where the tick is currently off
> > 2. Cpus that have dynticks enabled.
> > 3. Cpus that are idle
>
> You should find all that in /proc/timer_list

True. I could actually drop the vmstat cpumask support.

> Now for CPUs that have full dynticks enabled, we probably need something
> in sysfs. We could dump the nohz cpumask somewhere. For now you can only grep
> the dmesg

There is a nohz mode in /proc/timer_list right?

> > 4. Cpus that are used for RCU.
>
> So, you mean those that aren't in extended grace period (between rcu_user_enter()/exit
> or rcu_idle_enter/exit)?

No I mean cpus that have their RCU processing directed to another
processor.

