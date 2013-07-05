Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752247Ab3GEF6w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 01:58:52 -0400
Received: from www.linutronix.de ([62.245.132.108]:43189 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130Ab3GEF6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 01:58:51 -0400
Date: Fri, 5 Jul 2013 07:58:49 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Alex Shi <alex.shi@intel.com>
cc: Davidlohr Bueso <davidlohr.bueso@hp.com>, hpa@linux.intel.com,
        tim.c.chen@linux.intel.com, linux-kernel@vger.kernel.org,
        andi.kleen@intel.com, a.p.zijlstra@chello.nl, mingo@elte.hu
Subject: Re: [URGENT rfc patch 0/3] tsc clocksource bug fix
In-Reply-To: <51D61D97.8060904@intel.com>
Message-ID: <alpine.DEB.2.02.1307050742020.11637@ionos.tec.linutronix.de>
References: <1372916056-24301-1-git-send-email-alex.shi@intel.com>  <alpine.DEB.2.02.1307041300020.11637@ionos.tec.linutronix.de> <1372961512.8728.32.camel@buesod1.americas.hpqcorp.net> <alpine.DEB.2.02.1307042214090.11637@ionos.tec.linutronix.de>
 <51D61D97.8060904@intel.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Jul 2013, Alex Shi wrote:
> On 07/05/2013 04:27 AM, Thomas Gleixner wrote:
> >>>> We find some benchmarks drop a lot on tip/sched/core on many Intel boxes,
> > And that branch does NOT have that commit included. So how can you see
> > a regression on a branch caused by a commit NOT included into that
> > branch?
> > 
> > The offending commit is in tip timers/core and not in tip
> > sched/core. What I'm wanted to say is, that we need a proper
> > description of problems and not some random association.
> > 
> > It tricked you to assume, that I'm not able to figure it out myself :)
> > 
> > See? These things are complex and subtle, so we need precise
> > descriptions and not some sloppy semi correct data.
> > 
> > I'm well aware of the issue and with Peters help I got a reasonable
> > explanation for it. A proper fix is about to be sent out.
> > 
> 
> Ingo had merged your branch into sched/core. :)
> 
> commit f9bed7021710a3e45c331f7d7781de914cc1b939
> Merge: 7e76057 67dd331
> Author: Ingo Molnar <mingo@kernel.org>
> Date:   Wed May 29 11:21:59 2013 +0200
> 
>     Merge branch 'timers/urgent'

Not really.

tip$ git branch --contains f9bed70217
* master

tip$ git branch --contains 5d33b883ae
* master
  timers/core

So you are testing tip/master not tip/sched/core.

Thanks,

	tglx
