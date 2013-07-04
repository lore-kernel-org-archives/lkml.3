Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754351Ab3GDK10 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 06:27:26 -0400
Received: from www.linutronix.de ([62.245.132.108]:40335 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769Ab3GDK10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 06:27:26 -0400
Date: Thu, 4 Jul 2013 12:27:28 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Alex Shi <alex.shi@intel.com>
cc: hpa@linux.intel.com, tim.c.chen@linux.intel.com,
        linux-kernel@vger.kernel.org, andi.kleen@intel.com,
        a.p.zijlstra@chello.nl, mingo@elte.hu
Subject: Re: [PATCH 1/3] clocksource: clean up clocksource_select
In-Reply-To: <51D54CBD.1010400@intel.com>
Message-ID: <alpine.DEB.2.02.1307041224000.11637@ionos.tec.linutronix.de>
References: <1372916056-24301-1-git-send-email-alex.shi@intel.com> <1372916056-24301-2-git-send-email-alex.shi@intel.com> <alpine.DEB.2.02.1307041151170.11637@ionos.tec.linutronix.de> <51D54CBD.1010400@intel.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Jul 2013, Alex Shi wrote:
> > We need this check and it is completely unrelated to the problem
> > you're trying to solve.
> > 
> > Assume the following:
> > 
> >        System boots with clocksource A and switches into highres mode.
> >        Now clocksource B gets registered and B is not highres capable.
> > 
> >        clocksource_find_best() selects again A, but we have
> >        clocksource=B on the kernel command line to override the kernel
> >        decision.
> > 
> > By removing the check, you install he non highres capable clocksource
> > B and kill the machine.
> > 
> 
> You'r right. my bad, Sorry!
> 
> BTW, why we allow user override a second best clocksource? I mean user
> can override the tsc with hpet. because undetected unstable tsc?

The user can decide to override with clocksource=jiffies if he wants
for testing purposes. That wont switch into highres ever if done from
the kernel command line. Now we have a sysfs interface, so we need to
sanity check the user override against highres.

The override is quite useful to test hpet, pmtimer on a machine which
would always select TSC.

Thanks,

	tglx
