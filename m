Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933788Ab3GENv6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 09:51:58 -0400
Received: from www.linutronix.de ([62.245.132.108]:45392 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582Ab3GENv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 09:51:58 -0400
Date: Fri, 5 Jul 2013 15:51:57 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: David Vrabel <david.vrabel@citrix.com>
cc: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        LKML <linux-kernel@vger.kernel.org>, konrad.wilk@oracle.com,
        john.stultz@linaro.org, xen-devel@lists.xen.org,
        Artem Savkov <artem.savkov@gmail.com>
Subject: Re: [tip:timers/core] hrtimers: Support resuming with two or more
 CPUs online (but stopped)
In-Reply-To: <51D6CE19.1050503@citrix.com>
Message-ID: <alpine.DEB.2.02.1307051551260.32106@ionos.tec.linutronix.de>
References: <1372329348-20841-2-git-send-email-david.vrabel@citrix.com> <tip-7c4c3a0f18ba57ea2a2985034532303d2929902a@git.kernel.org> <20130705093003.GA4033@cpv436-motbuntu> <51D69ACF.9020001@citrix.com> <alpine.DEB.2.02.1307051225060.11637@ionos.tec.linutronix.de>
 <51D6CE19.1050503@citrix.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Jul 2013, David Vrabel wrote:
> On 05/07/13 11:25, Thomas Gleixner wrote:
> > On Fri, 5 Jul 2013, David Vrabel wrote:
> > 
> > You failed to CC Artem :(
> > 
> >> On 05/07/13 10:30, Artem Savkov wrote:
> >>> This commit brings up a warning about a potential deadlock in
> >>> smp_call_function_many() discussed previously:
> >>> https://lkml.org/lkml/2013/4/18/546
> >>
> >> Can we just avoid the wait in clock_was_set()?  Something like this?
> >>
> >> 8<------------------------------------------------------
> >> hrtimers: do not wait for other CPUs in clock_was_set()
> >>
> >> Calling on_each_cpu() and waiting in a softirq causes a WARNing about
> >> a potential deadlock.
> >>
> >> Because hrtimers are per-CPU, it is sufficient to ensure that all
> >> other CPUs' timers are reprogrammed as soon as possible and before the
> >> next softirq on that CPU.  There is no need to wait for this to be
> >> complete on all CPUs.
> 
> Unfortunately this doesn't look sufficient.  on_each_cpu(..., 0) may
> still wait for other calls to complete before queuing the calls due to
> the use of a single set of per-CPU csd data.

Hrmpf. I'll fix it in the non elegant way :(

Thanks,

	tglx
