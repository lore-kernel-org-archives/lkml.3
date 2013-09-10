Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735Ab3IJG76 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 02:59:58 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:34115 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754134Ab3IJG75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 02:59:57 -0400
MIME-Version: 1.0
X-Originating-IP: [212.179.42.66]
In-Reply-To: <1378795659.6046.41.camel@marge.simpson.net>
References: <00000140efbcb701-c26320b3-f434-4538-bc80-8e92fed6f303-000000@email.amazonses.com>
	<CAOtvUMe=jcAHXNJU_rTAAokaE4KZNUTFsHVVTTxgFW_xj8ONxg@mail.gmail.com>
	<1378795659.6046.41.camel@marge.simpson.net>
Date: Tue, 10 Sep 2013 09:59:55 +0300
Message-ID: <CAOtvUMfhLQYK95uPm8idG_vYv-9yG2-KSkScjMBCSuvtffW1Dg@mail.gmail.com>
Subject: Re: [RFC] Restrict kernel spawning of threads to a specified set of cpus.
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: Mike Galbraith <bitbucket@online.de>
Cc: Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Frysinger <vapier@gentoo.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


On Tue, Sep 10, 2013 at 9:47 AM, Mike Galbraith <bitbucket@online.de> wrote:
>
> On Tue, 2013-09-10 at 09:05 +0300, Gilad Ben-Yossef wrote:
> > Hi,
> >
> > On Thu, Sep 5, 2013 at 11:07 PM, Christoph Lameter <cl@linux.com> wrote:
> > > I am not sure how to call this kernel option but we need something like
> > > that. I see drivers and the kernel spawning processes on the nohz cores.
> > > The name kthread is not really catching the purpose.
> > >
> > > os_cpus=? highlatency_cpus=?
> > >
> >
> > First off, thank you for doing this. It is very useful :-)
> >
> > Currently if one wishes to run a single task on an isolated CPU with
> > as little interference as possible, one needs to pass
> > rcu_nocbs, isolcpus, nohz_full parameters and now kthread parameter,
> > all pretty much with the same values
> >
> > I know some people won't like this, but can we perhaps fold all these
> > into a single parameter, perhaps even the existing isolcpus?
>
> isolcpus is supposed to go away, as cpusets can isolate CPUs, and can
> turn off load balancing.
>

And I'm all for that. I think cpusets is a much more elegant solution.

But... AFAIK currently cpusets cannot migrate timers that were registered on
a cpu prior to it being isolated via cpuset, designate RCU off loaded CPUs or
sets cpus as full nohz capable, or - it seems from this patch, keep off certain
kernel thread off a cpu.

This is no fault of cpusets, but it still means there are work loads
that it can't
support at this time.

So long as we must  have a kernel boot option, I prefer to have one
and not four of
them. Think of it this way - when we put all these capabilities into
cpusets, we'll have
just one kernel option to kill and not four.

Does that makes sense?

Gilad

>
> -Mike
>



-- 
Gilad Ben-Yossef
Chief Coffee Drinker
gilad@benyossef.com
Israel Cell: +972-52-8260388
US Cell: +1-973-8260388
http://benyossef.com

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
