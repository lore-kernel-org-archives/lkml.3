Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752887AbaE0UxP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 16:53:15 -0400
Received: from www.linutronix.de ([62.245.132.108]:58212 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575AbaE0UxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 16:53:14 -0400
Date: Tue, 27 May 2014 22:53:24 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Libo Chen <libo.chen@huawei.com>
cc: Mike Galbraith <umgwanakikbuti@gmail.com>, mingo@elte.hu,
        LKML <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>, Li Zefan <lizefan@huawei.com>,
        peterz@infradead.org
Subject: Re: balance storm
In-Reply-To: <53848A2C.5010209@huawei.com>
Message-ID: <alpine.DEB.2.02.1405272245050.21720@ionos.tec.linutronix.de>
References: <5382AF2E.1040407@huawei.com>  <1401081082.5339.41.camel@marge.simpson.net> <538330B7.5070503@huawei.com>  <1401113960.23186.41.camel@marge.simpson.net> <53844510.1040502@huawei.com> <1401184553.5134.115.camel@marge.simpson.net>
 <53848A2C.5010209@huawei.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 May 2014, Libo Chen wrote:
> On 2014/5/27 17:55, Mike Galbraith wrote:
> > On Tue, 2014-05-27 at 15:56 +0800, Libo Chen wrote: 
> >> > On 2014/5/26 22:19, Mike Galbraith wrote:
> >>> > > On Mon, 2014-05-26 at 20:16 +0800, Libo Chen wrote: 
> >>>> > >> On 2014/5/26 13:11, Mike Galbraith wrote:
> >>> > > 
> >>>>> > >>> Your synthetic test is the absolute worst case scenario.  There has to
> >>>>> > >>> be work between wakeups for select_idle_sibling() to have any chance
> >>>>> > >>> whatsoever of turning in a win.  At 0 work, it becomes 100% overhead.
> >>>> > >>
> >>>> > >> not synthetic, it is a real problem in our product. under no load, waste
> >>>> > >> much cpu time.
> >>> > > 
> >>> > > What happens in your product if you apply the commit I pointed out?
> >> > 
> >> > under no load, cpu usage is up to 60%, but the same apps cost 10% on
> >> > susp sp1.  The apps use a lot of timer.
> > Something is rotten.  3.14-rt contains that commit, I ran your test with
> > 256 threads on 64 core box, saw ~4%.
> > 
> > Putting master/nopreempt config on box and doing the same test, box is
> > chewing up truckloads of CPU, but not from migrations. 
> > 
> > perf top -g --sort=symbol
> in my box:
> 
> perf top -g --sort=symbol
> 
> Events: 3K cycles
>  73.27%  [k] read_hpet

Why is that machine using read_hpet() ?

Please provide the output of 

# dmesg | grep -i tsc

and

# cat /sys/devices/system/clocksource/clocksource0/available_clocksource

and

# cat /sys/devices/system/clocksource/clocksource0/current_clocksource

Thanks,

	tglx
