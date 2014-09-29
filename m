Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850AbaI2WnI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 18:43:08 -0400
Received: from www.linutronix.de ([62.245.132.108]:54459 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbaI2WnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 18:43:06 -0400
Date: Tue, 30 Sep 2014 00:43:37 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
cc: Dmitry Torokhov <dtor@google.com>, Eric Caruso <ejcaruso@google.com>,
        linux-kernel@vger.kernel.org, Benson Leung <bleung@google.com>
Subject: Re: irq mask swapping during suspend/resume
In-Reply-To: <2213339.XxHo9Gxm0z@vostro.rjw.lan>
Message-ID: <alpine.DEB.2.02.1409300042000.22082@ionos.tec.linutronix.de>
References: <CAA9CXT07f01KW4UeoPPy4k1NM6qfxdtsOQXXSPjTKx7mG_v7Rw@mail.gmail.com> <30052021.2q1IqLHYpU@dtor-glaptop> <alpine.DEB.2.10.1409181326140.4206@nanos> <2213339.XxHo9Gxm0z@vostro.rjw.lan>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Sep 2014, Rafael J. Wysocki wrote:
> So I'd rather put that into the struct wakeup_source pointed to by
> the wakeup pointer in struct dev_pm_info.  That would give us a mapping
> between wakeup source objects and wakeup interrupts and which would make
> a fair amount of sense in my view.
> 
> Then, we could simply walk the list of wakeup source objects before
> suspend_device_irqs() and call enable_irq_wake() etc. for all of the
> interrupts in question without drivers having to worry about that.
> We also could save the current IRQ type for them at that point and
> restore it during resume.
> 
> Of course, that would require some changes to wakeup_source_create()
> and friends, but is probably worth doing.
> 
> Still, before we start making those changes, here's a bunch of questions
> to answer:
> 
> (1) Say a wakeup interrupt is shared between two drivers and one of them
>     asks for a different "IRQ type for sleep" than the other one.  How are
>     we going to resolve such conflicts?

Not at all. There is no solution to that problem other than aborting
and yelling about it.
 
> (2) Can platforms place restrictions on the IRQ type to be used with a given
>     line?  If so, how do we handle situations in which the requested
>     "IRQ type for sleep" is different from what the given line can use?
>     Do we need to resolve that at the struct wakeup_source creation time or
>     can we do that later (during suspend?) and how?

If the type request fails, bail out and be done with it. Same as #1

Thanks,

	tglx
