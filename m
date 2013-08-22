Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753926Ab3HVHZ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 03:25:29 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:58096 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753911Ab3HVHZ2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 03:25:28 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Arnd Bergmann <arnd@arndb.de>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <201308212054.10417.arnd@arndb.de>
Cc: Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@wwwdotorg.org>
References: <1376964271-22715-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <5213C90F.9010407@wwwdotorg.org> <5213CF58.50703@gmail.com>
 <201308212054.10417.arnd@arndb.de>
Message-ID: <20130822072524.8231.37219@quantum>
User-Agent: alot/0.3.4
Subject: Re: [RFC 02/17] ARM: call clk_of_init from time_init
Date: Thu, 22 Aug 2013 00:25:24 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Arnd Bergmann (2013-08-21 11:54:10)
> On Tuesday 20 August 2013, Sebastian Hesselbarth wrote:
> > Perhaps Tegra is the common case but other SoC haven't dug deep enough?
> > IMHO from a HW point-of-view clocks are really among the essential
> > things that need to be running before you can do anything useful.
> > 
> > Just consider boot loaders that run fine without irqs but don't without
> > clocks (even if just represented by API). Maybe you are right, and we
> > should call of_clk_init(NULL) as early as possible. That would also
> > eliminate patch 1/17 as you suggest.
> 
> Timers and interrupts are also things that are required really early,
> and from my experience they tend to be needed earlier than clock
> management. Obviously you need some clocks to be enabled in order
> to do anything (including interrupt handling), but those clocks tend
> to be enabled in the boot loader, so we don't have to worry about
> reprogramming them this early.

Some timers need to know their clock rate for the timer setup. This
could be hard-coded (e.g. for some timer driven from a fixed 32Khz
source) but it could also be from a clock capable of different rates
that needs to be calculated.

I remember discussing the early clock init stuff for OMAP and there was
an idea to not rely on the clock framework for timer init and just do
some raw reads and compute the clock rate that way. Using the framework
would be better of course.

Regards,
Mike

> 
>         Arnd
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
