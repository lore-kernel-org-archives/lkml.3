Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757190Ab3FGU5X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 16:57:23 -0400
Received: from www.linutronix.de ([62.245.132.108]:48601 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754831Ab3FGU5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 16:57:22 -0400
Date: Fri, 7 Jun 2013 22:57:18 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Tobias Waldekranz <tobias@waldekranz.com>
cc: LKML <linux-kernel@vger.kernel.org>, John Stultz <john.stultz@linaro.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] timekeeping: handle epoch roll-over (2038) on 32-bit
 systems
In-Reply-To: <20130604065947.GA10895@gmail.com>
Message-ID: <alpine.LFD.2.02.1306072248430.24812@ionos>
References: <CAFaRD2FP0rrQstV1GszP_URO+cZZuQdyRxOYUEmA+5BvopUAvQ@mail.gmail.com> <alpine.LFD.2.02.1306031622520.2905@ionos> <20130604065947.GA10895@gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tobias,

On Tue, 4 Jun 2013, Tobias Waldekranz wrote:
> On Mon, Jun 03, 2013 at 04:34:25PM +0200, Thomas Gleixner wrote:
> > Just "fixing" some random parts of the code in a "make it work
> > somehow" way is a pointless exercise IMO.
> > 
> Now hold on, it is hardly random. On an ARM system, the kernel will
> completely hang. I would think that many users would like to avoid
> that. In addition this behavior is rather new, hrtimer_interrupt used
> to source its time from ktime_get which avoids this issue. The change
> was introduced in:
> 
> 5baefd6d84163443215f4a99f6a20f054ef11236
> 
> I understand that you would like a solution to the broader issue. But
> for some users (embedded especially) having a system that continues to
> operate 25 years from now is an issue today.
> 
> As for "make it work somehow", modifying the current time calculation
> to work in the same way as in ktime_get does seem to be a reasonable
> way to go IMO.

No, it's not. You are "fixing" something which is not fixable by
definition. There is no rule to prevent similar borkage tomorrow.

You are just band aiding a singular instance of a massive problem
which has an already known root cause.

If you really care about your system working in 25 years from now with
the kernel of today then you rather should sit down and fix it proper.

Your "fix" merily allows the system to boot, but its broken beyond
repair aside of that. So what's the point?

If we do not tackle the underlying issues, then your machine will be
rendered completely useless with or without your patch. It's that
simple. So don't try to sell me a bandaid hack as a reasonable way to
go.

Thanks,

	tglx


