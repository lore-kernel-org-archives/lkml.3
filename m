Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756753Ab3JHVt1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 17:49:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44576 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753397Ab3JHVtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 17:49:24 -0400
Date: Tue, 8 Oct 2013 14:42:21 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Alan Tull <atull@altera.com>
Cc: Michal Simek <monstr@monstr.eu>, "H. Peter Anvin" <hpa@zytor.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Pavel Machek <pavel@denx.de>, Michal Simek <michal.simek@xilinx.com>,
        linux-kernel@vger.kernel.org, Dinh Nguyen <dinguyen@altera.com>,
        Philip Balister <philip@balister.org>,
        Alessandro Rubini <rubini@gnudd.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Yves Vandervennet <rocket.yvanderv@gmail.com>,
        Kyle Teske <kyle.teske@ni.com>, Josh Cartwright <joshc@eso.teric.us>,
        Nicolas Pitre <nico@linaro.org>,
        Mark Langsdorf <mark.langsdorf@calxeda.com>,
        Felipe Balbi <balbi@ti.com>, linux-doc@vger.kernel.org,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        David Brown <davidb@codeaurora.org>, Rob Landley <rob@landley.net>,
        "David S. Miller" <davem@davemloft.net>, Joe Perches <joe@perches.com>,
        Cesar Eduardo Barros <cesarb@cesarb.net>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH v2 0/1] FPGA subsystem core
Message-ID: <20131008214221.GB11941@kroah.com>
References: <20131005051056.GA7698@obsidianresearch.com>
 <1c9db96e-7a36-4ec9-ab16-885780ce6de5@email.android.com>
 <524FB756.3040203@monstr.eu>
 <c59c68b8-2565-45c5-bfe9-574b76f3f9bc@email.android.com>
 <5252B2F4.7050600@monstr.eu>
 <ea858a91-1149-44cc-b2e1-bab1f579915e@email.android.com>
 <5252CD30.3070305@monstr.eu>
 <708b6f80-97a7-41a7-9d5c-fa8bd2a8e0c5@email.android.com>
 <52540208.3090406@monstr.eu>
 <1381250986.6062.3.camel@atx-linux-37>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381250986.6062.3.camel@atx-linux-37>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 08, 2013 at 11:49:46AM -0500, Alan Tull wrote:
> On Tue, 2013-10-08 at 15:00 +0200, Michal Simek wrote:
> > On 10/07/2013 05:07 PM, H. Peter Anvin wrote:
> > > Special soft IP presenting a PCI device to the host.
> > 
> > ok. It means that you should need just different backend for this device
> > which is able to communicate over PCI.
> > 
> > I still can't see why this case should be problematic for this fpga
> > manager.
> > As Jason pointed if this is just about JTAG emulation and your
> > data is in different format then you have to create your backend
> > which will support this configuration.
> > I will want to look at gpio jtag emulation to be able to program
> > different board. We have this support for u-boot and doing in Linux
> > should be also possible.
> > 
> > I think the question is if we can live with 2/3 user interfaces.
> > I tend to keep firmware one because it is covering a lot of common
> > use cases and it can be easily to use.
> > And then I don't have any preference if sysfs or char device
> 
> The sysfs and char device interface are equal, except I don't think it
> is right to write binary data to a sysfs attribute.

That's exactly what binary sysfs files are for :)

> The difference between these 3 options is that firmware will work for
> some fixed use cases, but either the sysfs or char interface will work
> for all the use cases.

I don't understand how one will work but the other will not, please
explain.

thanks,

greg k-h
