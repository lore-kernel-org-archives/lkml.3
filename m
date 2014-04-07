Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728AbaDGFE6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 01:04:58 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:54855 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbaDGFEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 01:04:54 -0400
Message-ID: <1396847090.5218.9.camel@marge.simpson.net>
Subject: Re: [PATCH V2 0/8] cpusets: Isolate CPUs via sysfs using cpusets
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Linaro Networking <linaro-networking@linaro.org>,
        Arvind Chauhan <Arvind.Chauhan@arm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>
Date: Mon, 07 Apr 2014 07:04:50 +0200
In-Reply-To: <CAKohpomW3jpQEqFxD3m_br8GchJyq9-KSxW2x7JLCRqDgf4SAg@mail.gmail.com>
References: <cover.1396599474.git.viresh.kumar@linaro.org>
	 <1396773020.11763.17.camel@marge.simpson.net>
	 <CAKohpomW3jpQEqFxD3m_br8GchJyq9-KSxW2x7JLCRqDgf4SAg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-04-07 at 09:41 +0530, Viresh Kumar wrote: 
> Hi Mike,
> 
> On 6 April 2014 14:00, Mike Galbraith <umgwanakikbuti@gmail.com> wrote:
> > I wonder if adding a quiesce switch is really necessary.
> >
> > Seems to me that if you don't have load balancing turned off, you can't
> > be very concerned about perturbation, so this should be tied into the
> > load balancing on/off switch as an extension to isolating cores from the
> > #1 perturbation source, the scheduler.
> 
> Its more about not doing any background activities on these CPU which can
> be avoided. So, even if a add_timer() is issued from these isolated CPUs, it
> should goto the set chosen for doing background activity, unless add_timer_on()
> has been issued, in which case user wants that code to execute on the
> isolated core.
> 
> Probably, yes, people would be disabling load_balancing between these
> cpusets to avoid migration of tasks to isolated core as well.. Atleast we
> are using it :)

Yes, that's the whole point I'm trying to make.  If you do not have
cores isolated, there's no point to quiesce, as timers and whatnot are
the least of your worries.  Conversely, why would you bother isolating
cores if you didn't want a nice quiet environment.  Seems to me full
isolation ala killing sched domains implies that your goal is bare
metal.. or as close as you can get to that anyway.

> > I also didn't notice a check for is_cpu_exclusive() at a glance, which
> > would be a bug, but one that would go away if this additional isolation
> > were coupled to the existing isolation switch.
> 
> Yeah, there is no check for that. But I didn't got your point completely.
> Why do I need to check for exclusivity on the isolated CPUs? So, that
> same CPU isn't isolated as well as non-isolated on two separate sets?

Yes, both on and off is kinda hard to do per cpu :)

-Mike

