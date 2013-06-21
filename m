Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946251Ab3FUXNt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 19:13:49 -0400
Received: from www.linutronix.de ([62.245.132.108]:41918 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946207Ab3FUXNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 19:13:47 -0400
Date: Sat, 22 Jun 2013 01:13:46 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Stephen Boyd <sboyd@codeaurora.org>
cc: Daniel Lezcano <daniel.lezcano@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        John Stultz <john.stultz@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Rob Herring <robherring2@gmail.com>
Subject: Re: [PATCHv3/RESEND 4/4] clocksource: arch_timer: Add support for
 memory mapped timers
In-Reply-To: <51C4DB44.7030909@codeaurora.org>
Message-ID: <alpine.DEB.2.02.1306220110110.4013@ionos.tec.linutronix.de>
References: <1371836361-20574-1-git-send-email-sboyd@codeaurora.org> <1371836361-20574-5-git-send-email-sboyd@codeaurora.org> <alpine.DEB.2.02.1306212304480.4013@ionos.tec.linutronix.de> <51C4DB44.7030909@codeaurora.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Jun 2013, Stephen Boyd wrote:
> On 06/21/13 14:18, Thomas Gleixner wrote:
> > Something in my little brain yells: function pointer
> >
> > You can't be serious about hacking nested if/else/switch constructs
> > into a hot path.
> >
> > Why not making your cpu data:
> >
> > struct arch_timer {
> >        struct clock_event_device evt;
> >        ....
> >        void (*write_ctrl)(val, timer);
> >        void (*write_tval)(val, timer);
> >        ....
> > }
> >
> > and get rid of all that conditionals?
> 
> It sounds like that's undesirable according to the comment above
> arch_timer_reg_write(). It seems that all this code was written under
> the assumption that the compiler is good enough to optimize all the code
> paths and only generate the code that is necessary. So far this seems to
> be working and the hotpath is optimized for each type of access.

That might be true for kernels which are optimized for a specific
target, but this will fall flat for any multi-platform kernel.

Thanks,
	
	tglx
