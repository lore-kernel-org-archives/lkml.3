Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946119Ab3FUVYI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 17:24:08 -0400
Received: from www.linutronix.de ([62.245.132.108]:41592 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946078Ab3FUVYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 17:24:06 -0400
Date: Fri, 21 Jun 2013 23:24:00 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: David Vrabel <david.vrabel@citrix.com>
cc: xen-devel@lists.xen.org, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 1/4] hrtimers: provide a hrtimers_late_resume() call
In-Reply-To: <51C48DA3.4010307@citrix.com>
Message-ID: <alpine.DEB.2.02.1306212321440.4013@ionos.tec.linutronix.de>
References: <1371755792-25962-1-git-send-email-david.vrabel@citrix.com> <1371755792-25962-2-git-send-email-david.vrabel@citrix.com> <alpine.DEB.2.02.1306210947410.4013@ionos.tec.linutronix.de> <51C447E3.9030009@citrix.com> <alpine.DEB.2.02.1306211610100.4013@ionos.tec.linutronix.de>
 <51C48DA3.4010307@citrix.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Jun 2013, David Vrabel wrote:
> On 21/06/13 15:32, Thomas Gleixner wrote:
> However, since hrtimers require the use of a one-shot ticker and when
> one-shot timers are resumed they are armed to fire immediately (see
> tick_resume_oneshot()) this interrupt is sufficient to kick the require
> softirq.
> 
> So, as proposed before:
> 
> hrtimers_resume()
> {
>    /* This CPU's tick is armed to fire immediately by
>       tick_oneshot_resume(). Just need raise a softirq to program
>       the timers on all CPUs. */
>    cpu_base->clock_was_set = 1;
>    __raise_softirq_irqoff(HRTIMER_SOFTIRQ);
> }
> 
> Do you agree or disagree?

Fair enough. I did not think about that. With the comment in place it
is clear. It might be a bit more elaborate for the casual reader.

Thanks,

	tglx

