Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199Ab3HBNYi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 09:24:38 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39916 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407Ab3HBNYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 09:24:37 -0400
Date: Fri, 2 Aug 2013 14:24:19 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Tony Lindgren <tony@atomide.com>
Cc: Greg KH <greg@kroah.com>, ksummit-2013-discuss@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [Ksummit-2013-discuss] [ATTEND] [ARM ATTEND] kernel data bloat
	and how to avoid it
Message-ID: <20130802132419.GO23006@n2100.arm.linux.org.uk>
References: <20130731073802.GT7656@atomide.com> <20130731123351.GA30474@kroah.com> <20130802075352.GY7656@atomide.com> <20130802124130.GI7656@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130802124130.GI7656@atomide.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 02, 2013 at 05:41:31AM -0700, Tony Lindgren wrote:
> Oh and thinking about it a bit more, this issue is mostly with the
> device drivers implementing frameworks, not the device drivers
> using the frameworks. Things like clocks, regulators, muxes etc where
> an almost similar instance is repeated tens or hundreds of times for
> each SoC.

That is where it helps to have a strong maintainer for a subsystem who
has the guts to refuse to accept stuff which is similar to existing
implementations and insist that existing implementations are either
adapted or reused.

It's all very well someone coming along and writing a "generic" set of
implementations (like tglx did for the IRQ subsystem) but unless there's
a motivation for people to use the generic stuff (such as... you won't
get your code in if you don't use the provided generics unless you can
provide a very good reasoned argument) then people are just going to
write their own code time and time again.

It's just like how the clocksources have gone.  We now have multiple
implementations of how to read a counter which ticks at a specific
rate.  You wouldn't think that I wrote drivers/clocksource/mmio.c which
can handle all of these simple 32-bit/16-bit up/down counter cases.
Again, the problem is there is no strong reviewer there who looks over
every addition and says "no, use the generic stuff".

That's the basic problem here: the review, and people saying "no" to
new stuff doing the same as generic stuff.
