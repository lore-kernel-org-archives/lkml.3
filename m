Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756526AbaBFQJS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 11:09:18 -0500
Received: from mail-qc0-f170.google.com ([209.85.216.170]:50133 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932AbaBFQJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 11:09:16 -0500
Date: Thu, 6 Feb 2014 16:09:08 +0000 (GMT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, linux-pm@vger.kernel.org,
        linaro-kernel@lists.linaro.org
Subject: Re: [PATCH 2/2] ARM64: powernv: remove redundant
 cpuidle_idle_call()
In-Reply-To: <52F3B17E.4040209@linux.vnet.ibm.com>
Message-ID: <alpine.LFD.2.11.1402061607290.1906@knanqh.ubzr>
References: <1391696188-14540-1-git-send-email-nicolas.pitre@linaro.org> <1391696188-14540-2-git-send-email-nicolas.pitre@linaro.org> <52F3B17E.4040209@linux.vnet.ibm.com>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Feb 2014, Preeti U Murthy wrote:

> Hi Nicolas,
> 
> powernv in the subject of the patch?

Crap.  You're right.

That's what you get when posting patches while attending a meeting.



> 
> Regards
> Preeti U Murthy
> On 02/06/2014 07:46 PM, Nicolas Pitre wrote:
> > The core idle loop now takes care of it.
> > 
> > Signed-off-by: Nicolas Pitre <nico@linaro.org>
> > ---
> >  arch/arm64/kernel/process.c | 7 ++-----
> >  1 file changed, 2 insertions(+), 5 deletions(-)
> > 
> > diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
> > index 1c0a9be2ff..9cce0098f4 100644
> > --- a/arch/arm64/kernel/process.c
> > +++ b/arch/arm64/kernel/process.c
> > @@ -33,7 +33,6 @@
> >  #include <linux/kallsyms.h>
> >  #include <linux/init.h>
> >  #include <linux/cpu.h>
> > -#include <linux/cpuidle.h>
> >  #include <linux/elfcore.h>
> >  #include <linux/pm.h>
> >  #include <linux/tick.h>
> > @@ -94,10 +93,8 @@ void arch_cpu_idle(void)
> >  	 * This should do all the clock switching and wait for interrupt
> >  	 * tricks
> >  	 */
> > -	if (cpuidle_idle_call()) {
> > -		cpu_do_idle();
> > -		local_irq_enable();
> > -	}
> > +	cpu_do_idle();
> > +	local_irq_enable();
> >  }
> > 
> >  #ifdef CONFIG_HOTPLUG_CPU
> > 
> 
