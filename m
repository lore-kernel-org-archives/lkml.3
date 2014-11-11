Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752052AbaKKRk0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 12:40:26 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:51907 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564AbaKKRjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 12:39:14 -0500
Date: Tue, 11 Nov 2014 09:39:08 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Christoph Lameter <cl@linux.com>, Viresh Kumar <viresh.kumar@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>, Tejun Heo <tj@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Mike Frysinger <vapier@gentoo.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Hakan Akkan <hakanakkan@gmail.com>,
        Max Krasnyansky <maxk@qti.qualcomm.com>,
        Hugh Dickins <hughd@google.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Kevin Hilman <khilman@linaro.org>
Subject: Re: Future of NOHZ full/isolation development (was Re: [NOHZ] Remove
 scheduler_tick_max_deferment)
Message-ID: <20141111173908.GY4901@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <alpine.DEB.2.11.1410311058500.32582@gentwo.org>
 <alpine.DEB.2.11.1411012003390.5308@nanos>
 <alpine.DEB.2.11.1411011646280.7732@gentwo.org>
 <alpine.DEB.2.11.1411012313320.5308@nanos>
 <alpine.DEB.2.11.1411061057470.5591@gentwo.org>
 <CAKohpokE8pQUwTuMbnooAd3TsTgmrQWP4RtoJdwhJ5zps+O2zA@mail.gmail.com>
 <20141110153147.GK4901@linux.vnet.ibm.com>
 <alpine.DEB.2.11.1411101226310.12918@gentwo.org>
 <20141111171526.GC3216@lerouge>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141111171526.GC3216@lerouge>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14111117-0033-0000-0000-000002A493E2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2014 at 06:15:28PM +0100, Frederic Weisbecker wrote:
> On Mon, Nov 10, 2014 at 12:26:51PM -0600, Christoph Lameter wrote:
> > >
> > > Would it make sense for unlimited max deferment to be available as
> > > a boot parameter?  That would allow people who want tick-free execution
> > > more than accurate stats to get that easily, while keeping stats accurate
> > > for everyone else.
> > 
> > Subject: Make the maximum tick deferral for CONFIG_NO_HZ configurable
> > 
> > Add a way to configure this interval at boot and via
> > /proc/sys/vm/max_defer_tick
> > 
> > Signed-off-by: Christoph Lameter <cl@linux.com>
> 
> Sorry but that's not solving the problem. All it does is to allow the user
> to tune bugs.
> 
> Kevin Hilman proposed something similar using debugfs and I declined it as
> well. Integrating a hack like this is a good way to make sure that nobody
> will ever fix the real underlying issue.

I guess I should have remembered that before suggesting this to Christoph,
my apologies to all!

> BTW, that's a good opportunity for me to generalize this case to the full
> dynticks development general issue. I got a lot of help from people to improve
> the kernel's isolation and full dynticks: Paul has spent a lot of time to improve
> RCU, you improved vmstat, full dynticks got ported to other archs, people
> like Viresh fixed some timers internals, Gilad fixed IPIs, Peterz reviewed a
> lot, etc...
> 
> But now we reached a step where there are mostly core issues remaining that
> require some infrastrure change investments, some extensions or a bit of rethinking.
> We know we reach that step when people who want the features are stuck sending
> workarounds.
> Nothing like big rewrites is needed really, actually just a bunch of pretty
> self contained issues. And by self-contained I mean that each of these individual
> problems can be worked out seperately as they are unrelated enough altogether. Here is
> a summarized list:
> 
> * Unbound workqueues affinity (to housekeeper)
> * Unbound timers affinity (to housekeeper)
> * 1 Hz residual scheduler tick offlining to housekeeper
> * Fix some scheduler accounting that don't even work with 1 Hz: cpu load
>   accounting, rt_scale, load balancing, etc...
> * Lighten the syscall path and get rid of cputime accounting + RCU hooks
>   for people who want isolation + fast syscalls and faults.

I thought that the RCU hooks were well and truly down in the noise.
Or is that not the case without cputime accounting to hide behind?

							Thanx, Paul

> * Work on non-affinable workqueues
> * Work on non-affinable timers
> * ...
> 
> If I'm going to work alone on all that, this is going to take several years,
> honestly.
> 
> But we know what to do and how. So all we need is (at least one) more full time
> core developer to get these things done in a reasonable amount of time.
> 
> Thanks.
> 

