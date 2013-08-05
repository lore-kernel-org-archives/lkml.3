Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666Ab3HEGhC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 02:37:02 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:28987 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753593Ab3HEGhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 02:37:00 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+I/elBQROU+t12VuNspCux
Date: Sun, 4 Aug 2013 23:36:55 -0700
From: Tony Lindgren <tony@atomide.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Greg KH <greg@kroah.com>, ksummit-2013-discuss@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [Ksummit-2013-discuss] [ATTEND] [ARM ATTEND] kernel data bloat
 and how to avoid it
Message-ID: <20130805063654.GM7656@atomide.com>
References: <20130731073802.GT7656@atomide.com>
 <20130731123351.GA30474@kroah.com>
 <20130802075352.GY7656@atomide.com>
 <20130802195730.6450.84988@quantum>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130802195730.6450.84988@quantum>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mike Turquette <mturquette@linaro.org> [130802 13:04]:
> Quoting Tony Lindgren (2013-08-02 00:53:53)
> > People are unnecessarily defining registers in kernel for similar devices
> > over and over again for each new SoC at the arch level and now more and
> > more at the driver level.
> > 
> > One example of that are device tree based drivers that don't describe
> > the actual hardware, but instead have a binding that points to an index
> > of defined registers in the driver.
> 
> Apologies for possibly hijacking this thread, but this issue keeps me up
> at night. People use DT for different things and have different ideas
> about its Purpose In The World.
> 
> Tony wants to move data out of the kernel, which was the impetus behind
> the OMAP DT clock patches that describes every single clock in a DT node
> (around 250 clocks). This create very large dts, but reduces the clock
> drivers to pure logic, no data.

Yes that should eventually allow "booting new hardware with old
kernels".. But ideally with clocks we should support any combination of
DT defined clocks and /lib/firmware defined clocks should be allowed to
avoid bloating the DT files. We should be able to boot to user space
with a pretty minimal set of clocks, and deal with the PM related settings
based on SoC specific data from /lib/firmware.
 
> Other folks are motivated only to get rid of board files and platform
> data hacks. They keep all of the clock data in the clock driver and
> instead use DT only as a way to hook up clocks to devices via a simple
> mapping, thus describing how individual boards or SoC variants are set
> up outside of the kernel source. dts remains small, essentially just an
> array to map bindings but all of the clock data remains in the kernel.

Right, that just moves the real problem to drivers and then it will
eventually suck up all your maintainer time with constant churn to patch
that data for various SoC revisions :)
 
> Both approaches have their merits and drawbacks. Is it possible to
> gather consensus on selecting a single approach? For the clock subsystem
> I've accepted drivers and DT bindings which do either. I simply do not
> have the DT experience or sensibilities to draw a line in the sand...
> and maybe I should not draw a line in the sand and just let people pick
> whichever approach they prefer (which maintains the status quo).
> 
> If the ARM Summit figures out all the answers then please let me know
> what they are :-)

Well I think it's been discussed many times earlier and it should be
clear that Linus wants this kind of data out of the kernel. So maybe
we could establish some kind of set of standards for the maintainers
to follow.

Regards,

Tony
