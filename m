Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933069Ab3GDSL6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 14:11:58 -0400
Received: from g6t0187.atlanta.hp.com ([15.193.32.64]:24822 "EHLO
	g6t0187.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932532Ab3GDSL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 14:11:57 -0400
Message-ID: <1372961512.8728.32.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [URGENT rfc patch 0/3] tsc clocksource bug fix
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Alex Shi <alex.shi@intel.com>, hpa@linux.intel.com,
        tim.c.chen@linux.intel.com, linux-kernel@vger.kernel.org,
        andi.kleen@intel.com, a.p.zijlstra@chello.nl, mingo@elte.hu
Date: Thu, 04 Jul 2013 11:11:52 -0700
In-Reply-To: <alpine.DEB.2.02.1307041300020.11637@ionos.tec.linutronix.de>
References: <1372916056-24301-1-git-send-email-alex.shi@intel.com>
	 <alpine.DEB.2.02.1307041300020.11637@ionos.tec.linutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-07-04 at 13:00 +0200, Thomas Gleixner wrote:
> On Thu, 4 Jul 2013, Alex Shi wrote:
> 
> > We find some benchmarks drop a lot on tip/sched/core on many Intel boxes,
> > like oltp, tbench, hackbench etc. and bisected the commit 5d33b883ae
> > cause this regression. Due to this commit, the clocksource was changed
> > to hpet from tsc even tsc will be set CLOCK_SOURCE_VALID_FOR_HRES later
> > in clocksource_watchdog. 
> 
> 5d33b883ae is not in tip/sched/core. So what are you testing and
> bisecting?

I think he's referring to:

commit 5d33b883aed81c6fbcd09c6f7c3619eee850a7e2
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Thu Apr 25 20:31:43 2013 +0000

    clocksource: Always verify highres capability
    
    If a clocksource has a (wrong) high rating, but can't be used as a
    timebase for oneshot tick mode, it is unconditionally selected even
    when the system is already in oneshot tick mode. This causes full
    system failure.
    
    Verify the clocksource selection against the oneshot mode.
    
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
    Acked-by: John Stultz <john.stultz@linaro.org>
    Cc: Magnus Damm <magnus.damm@gmail.com>
    Link: http://lkml.kernel.org/r/20130425143435.635040849@linutronix.de
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>


