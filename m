Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709Ab3HEGaf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 02:30:35 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:19056 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754217Ab3HEGaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 02:30:20 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19MuCwOtKbH/s6XdrSQ8UnU
Date: Sun, 4 Aug 2013 23:30:13 -0700
From: Tony Lindgren <tony@atomide.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Greg KH <greg@kroah.com>, ksummit-2013-discuss@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [Ksummit-2013-discuss] [ATTEND] [ARM ATTEND] kernel data bloat
 and how to avoid it
Message-ID: <20130805063013.GL7656@atomide.com>
References: <20130731073802.GT7656@atomide.com>
 <20130731123351.GA30474@kroah.com>
 <20130802075352.GY7656@atomide.com>
 <20130802124130.GI7656@atomide.com>
 <20130802132419.GO23006@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130802132419.GO23006@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Russell King - ARM Linux <linux@arm.linux.org.uk> [130802 06:31]:
> On Fri, Aug 02, 2013 at 05:41:31AM -0700, Tony Lindgren wrote:
> > Oh and thinking about it a bit more, this issue is mostly with the
> > device drivers implementing frameworks, not the device drivers
> > using the frameworks. Things like clocks, regulators, muxes etc where
> > an almost similar instance is repeated tens or hundreds of times for
> > each SoC.
> 
> That is where it helps to have a strong maintainer for a subsystem who
> has the guts to refuse to accept stuff which is similar to existing
> implementations and insist that existing implementations are either
> adapted or reused.
> 
> It's all very well someone coming along and writing a "generic" set of
> implementations (like tglx did for the IRQ subsystem) but unless there's
> a motivation for people to use the generic stuff (such as... you won't
> get your code in if you don't use the provided generics unless you can
> provide a very good reasoned argument) then people are just going to
> write their own code time and time again.
> 
> It's just like how the clocksources have gone.  We now have multiple
> implementations of how to read a counter which ticks at a specific
> rate.  You wouldn't think that I wrote drivers/clocksource/mmio.c which
> can handle all of these simple 32-bit/16-bit up/down counter cases.
> Again, the problem is there is no strong reviewer there who looks over
> every addition and says "no, use the generic stuff".
> 
> That's the basic problem here: the review, and people saying "no" to
> new stuff doing the same as generic stuff.

Right, but to make all that easier I was thinking that we can possibly
provide some generic guidelines and tools for maintainers to avoid some
of these issues.

The data issues should be pretty easy to spot based on the size of the
driver, or looking at the object file with size command for the data to
text ratio etc.

Regards,

Tony
