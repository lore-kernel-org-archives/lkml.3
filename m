Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934405AbaKMWqg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 17:46:36 -0500
Received: from www.linutronix.de ([62.245.132.108]:49615 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933065AbaKMWqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 17:46:34 -0500
Date: Thu, 13 Nov 2014 23:46:28 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Anatol Pomozov <anatol.pomozov@gmail.com>
cc: Thierry Reding <thierry.reding@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>, Mark Rutland <mark.rutland@arm.com>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH] timekeeping: Move persistent clock registration code
 from ARM to kernel
In-Reply-To: <CAOMFOmXpAm5iKCLFyorTW+n9YmgZMmrDGGe736tJX8C6BYQv-A@mail.gmail.com>
Message-ID: <alpine.DEB.2.11.1411132334400.3935@nanos>
References: <1415388855-35074-1-git-send-email-anatol.pomozov@gmail.com> <20141110095325.GC12126@ulmo> <CAOMFOmXpAm5iKCLFyorTW+n9YmgZMmrDGGe736tJX8C6BYQv-A@mail.gmail.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Nov 2014, Anatol Pomozov wrote:
> On Mon, Nov 10, 2014 at 1:53 AM, Thierry Reding
> <thierry.reding@gmail.com> wrote:
> > On Fri, Nov 07, 2014 at 11:34:15AM -0800, Anatol Pomozov wrote:
> >> ARM timekeeping functionality allows to register persistent/boot clock dynamically.
> >> This code is arch-independent and can be useful on other plaforms as well.
> >>
> >> As a byproduct of this change, tegra20_timer becomes ARM64 compatible.
> >>
> >> Tested: backported the change to chromeos-3.14 kernel ran on tegra 64bit
> >> board, made sure high-resolution clock works.
> >
> > Using this on an upstream kernel doesn't work, though, because 64-bit
> > ARM doesn't implement struct delay_timer which the driver needs since
> > v3.17.
> >
> > But I suppose the delay timer infrastructure could be moved into the
> > core similar to the persistent and boot clock as this patch does.
> 
> Thanks. It makes sense, I will send it in a separate patch, once this
> one will be reviewed. On our kernel I haven't seen this issue as we
> still use 3.14.

That's why you should test/compile your stuff on latest greatest and
not on a year old conglomorate of unknown provenance. :)

Aside of that I really wonder why we need that persistent_clock stuff
at all. We already have mechanisms to register persistent clocks AKA
RTCs after the early boot process and update the wall clock time
before we actually need it. Nothing in early boot depends on correct
wall clock at all.

So instead of adding more extra persistent clock nonsense, can we just
move all of that to the place where it belongs, i.e. RTC?

Thanks,

	tglx

