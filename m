Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376Ab3IWRKr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 13:10:47 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:42008 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752448Ab3IWRKp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 13:10:45 -0400
Date: Mon, 23 Sep 2013 11:10:29 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Michal Simek <monstr@monstr.eu>
Cc: Yves Vandervennet <rocket.yvanderv@gmail.com>,
        Alan Tull <atull@altera.com>, Jason Cooper <jason@lakedaemon.net>,
        Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dinh Nguyen <dinguyen@altera.com>,
        Philip Balister <philip@balister.org>,
        Alessandro Rubini <rubini@gnudd.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cesar Eduardo Barros <cesarb@cesarb.net>,
        Joe Perches <joe@perches.com>, "David S. Miller" <davem@davemloft.net>,
        Stephen Warren <swarren@nvidia.com>, Arnd Bergmann <arnd@arndb.de>,
        David Brown <davidb@codeaurora.org>, Dom Cobley <popcornmix@gmail.com>
Subject: Re: [RFC PATCH] fpga: Introduce new fpga subsystem
Message-ID: <20130923171029.GA29429@obsidianresearch.com>
References: <cover.1379519753.git.michal.simek@xilinx.com>
 <cb9a12ae95bc39626a745c2487ffd0e47e9c7b34.1379519753.git.michal.simek@xilinx.com>
 <20130918191517.GQ19937@titan.lakedaemon.net>
 <20130918203247.GA11181@obsidianresearch.com>
 <1379539063.31417.23.camel@atx-linux-37>
 <523AD814.1060406@monstr.eu>
 <CADuitaCjNv2HFCg_y2qpkvXmUmO-jKUVQ2Ra8ACOne1hwAmKJA@mail.gmail.com>
 <20130919172814.GA3855@obsidianresearch.com>
 <52403DB3.1080902@monstr.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52403DB3.1080902@monstr.eu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 23, 2013 at 03:10:11PM +0200, Michal Simek wrote:

> > 1) The driver doesn't know what firmware to request. It just knows
> >    how to send it to a FPGA.
> 
> But dts property in the manager driver which uses this as end driver
> can know that.

I think the device tree maintainers would push back on this since it
is not "describing the hardware"
 
> > 2) Telling the kernel a filename via sysfs and then having it go
> >    around the long way via request_firwmare to get the data is silly.
> >    Just give the kernel the actual data instead of a file name
> 
> Firmware interface is valid way how to pass bitstream to the kernel.
> If you don't like just don't use it. For example you can add
> firmware blob directly to the kernel and load this at bootup phase
> without user-space access.

I'm not against using request firmware for what it is ment for: having
the kernel autonomously load firmware.

I am against the sysfs API in the core code where userspace writes a
file name that is then used to request_firwmare. That is a goofy API
for the reasons I outlined.

It is appropriate to use request firmware at the driver level where
the driver somehow knows what FPGA to request.

> and there will be this option. But don't try to restrict others
> if they want to do it just in the kernel in early phase.

Doing the load in kernel early phase doesn't involve the user space
sysfs interface.

Jason
