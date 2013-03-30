Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245Ab3C3KGI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 06:06:08 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:48500 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754599Ab3C3KGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 06:06:06 -0400
Date: Sat, 30 Mar 2013 10:04:08 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Ning Jiang <ning.n.jiang@gmail.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>, kgene.kim@samsung.com,
        davidb@codeaurora.org, dwalker@fifo99.com, bryanh@codeaurora.org,
        john.stultz@linaro.org, tglx@linutronix.de, linus.walleij@linaro.org,
        shawn.guo@linaro.org, rob.herring@calxeda.com, arnd@arndb.de,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH] ARM: timer: Shutdown clock event device when stopping
	local timer
Message-ID: <20130330100408.GA17995@n2100.arm.linux.org.uk>
References: <1364549049-29278-1-git-send-email-ning.n.jiang@gmail.com> <5155DE43.4000601@codeaurora.org> <CAH3Oq6QA0DCEDc-Yh+k=3bgUH7xzKxHSC1aWSoL4NzaYCZZHbg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH3Oq6QA0DCEDc-Yh+k=3bgUH7xzKxHSC1aWSoL4NzaYCZZHbg@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 30, 2013 at 05:57:38PM +0800, Ning Jiang wrote:
> 2013/3/30 Stephen Boyd <sboyd@codeaurora.org>:
> > On 03/29/13 02:24, ning.n.jiang@gmail.com wrote:
> >> From: Ning Jiang <ning.n.jiang@gmail.com>
> >>
> >> Currently there are two problems when we try to stop local timer.
> >> First, it calls set_mode function directly so mode state is not
> >> updated for the clock event device. Second, it makes the device
> >> unused instead of shutdown.
> >
> > What device is this a problem on? I believe this only matters to drivers
> > which enable their timer in their set_next_event() callback? But even
> > then, does anything actually happen because the interrupt should have
> > been disabled in the local timer stop callback.
> >
> 
> Right. Drivers which enable timer in set_next_event() will have this problem.
> It will not have functional problem in my case. But my device cannot enter
> low power mode with a pending interrupt even if it is disabled.

You're not telling us what you have discovered.  How does set_next_event()
get called after we've set the mode to UNUSED in the current code?
