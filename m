Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759184Ab3EOQF6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 12:05:58 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:40602 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754581Ab3EOQF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 12:05:57 -0400
Date: Wed, 15 May 2013 18:05:48 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Mike Galbraith <bitbucket@online.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: dynticks: CONFIG_VIRT_CPU_ACCOUNTING +  CONFIG_CONTEXT_TRACKING
 breaks accounting on core2 CPUs only
Message-ID: <20130515160546.GD24004@somewhere>
References: <1368346669.5998.13.camel@marge.simpson.net>
 <20130514005744.GA12749@somewhere>
 <1368540440.6275.32.camel@marge.simpson.net>
 <20130515002646.GA24004@somewhere>
 <1368590955.5957.7.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368590955.5957.7.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 15, 2013 at 06:09:15AM +0200, Mike Galbraith wrote:
> On Wed, 2013-05-15 at 02:26 +0200, Frederic Weisbecker wrote: 
> > On Tue, May 14, 2013 at 04:07:20PM +0200, Mike Galbraith wrote:
> > > On Tue, 2013-05-14 at 02:57 +0200, Frederic Weisbecker wrote: 
> > > > On Sun, May 12, 2013 at 10:17:49AM +0200, Mike Galbraith wrote:
> > > > > Greetings,
> > > > > 
> > > > > Turning on new NO_HZ feature on my Q6600 box in master, I see that tasks
> > > > > accrue zero utime/stime.  However, the same exact kernel on E5620 box
> > > > > works fine, so it would appear there's a CPU dependency somewhere.
> > > > 
> > > > Ah indeed, I just managed to reproduce the same issue.
> > > > 
> > > > > 
> > > > > Is core2 expected to go dysfunctional with context tracking enabled?
> > > > > CONFIG_VIRT_CPU_ACCOUNTING alone works fine in 3.9-stable, turn on
> > > > > CONFIG_CONTEXT_TRACKING_FORCE, and CPU accounting stops working on core2
> > > > > boxen only, same exact kernel continues to work just fine on E5620
> > > > > (Westmere) box.
> > > > 
> > > > There was no known issue with core2. The box where I'm seeing the it
> > > > is a Phenom quad core that had NR_CPUS=2. May be the issue is more
> > > > likely to happen with this low number. I don't know.
> > > > 
> > > > I'm investigating further.
> > > 
> > > So with CONFIG_HAVE_UNSTABLE_SCHED_CLOCK, you can't mix sched_clock()
> > > (pure tsc) with local_clock()/sched_clock_cpu(cpu).  The former is
> > > always quite a bit ahead of the later, so mixing clocks is a nogo on
> > > crusty old (but beloved) core2 box.
> > 
> > Right I have the same issue. So let's use local_clock() everywhere here,
> > it takes care of unstable tsc.
> > 
> > Does the following fix the issue for you?
> 
> Yeah, both can use sched_clock_cpu() instead though.

Right, given that irqs are already disabled. I'm preparing the patch.

Thanks!
