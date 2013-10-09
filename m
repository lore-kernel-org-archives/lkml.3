Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932165Ab3JIVIA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 17:08:00 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:37823 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752357Ab3JIVH6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 17:07:58 -0400
Date: Wed, 9 Oct 2013 15:07:15 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, monstr@monstr.eu,
        delicious quinoa <delicious.quinoa@gmail.com>,
        Alan Tull <atull@altera.com>, Pavel Machek <pavel@denx.de>,
        Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        Dinh Nguyen <dinguyen@altera.com>,
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
Message-ID: <20131009210715.GA17467@obsidianresearch.com>
References: <1381250986.6062.3.camel@atx-linux-37>
 <20131008214221.GB11941@kroah.com>
 <CANk1AXS9fpypVVWgvvUCZjKXDvLPpB7=kCNucwFcktgBHmV37w@mail.gmail.com>
 <20131009014027.GA17066@kroah.com>
 <5254EC8A.8060609@monstr.eu>
 <20131009055332.GA4510@kroah.com>
 <52550638.2080301@monstr.eu>
 <52556585.3050603@zytor.com>
 <20131009192439.GC18611@kroah.com>
 <5255BE71.8010801@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5255BE71.8010801@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 09, 2013 at 01:37:05PM -0700, H. Peter Anvin wrote:

> A very common use case would be where a device contains an FPGA but is
> presented to the user as a product, often having its own device driver
> to drive the programmed device and/or additional logic.  From *that*
> point of view it would be nice if the FPGA subsystem had the capability
> for the *device driver* to trigger a firmware load request which is then
> fed to the FPGA subsystem for programming.  This would be an in-kernel
> interface, in other words.

That is sort of backwards though, how does the driver know it should
load and start fpga progamming?

The way we are working driver attach today is to program the FPGA,
under control of user space, and then do a PCI rescan, which discovers
the FPGA device and triggers driver binding of the PCI FPGA driver.

Please keep in mind that loading the wrong FPGA could permanently
destroy the system. This is why we have meta-data encoded with the
bitstream. The user space loader does some sanity checks :)

Jason
