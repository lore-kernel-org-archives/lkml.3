Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339Ab3ISR2h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 13:28:37 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:56694 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752866Ab3ISR21 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 13:28:27 -0400
Date: Thu, 19 Sep 2013 11:28:14 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Yves Vandervennet <rocket.yvanderv@gmail.com>
Cc: monstr@monstr.eu, Alan Tull <atull@altera.com>,
        Jason Cooper <jason@lakedaemon.net>,
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
Message-ID: <20130919172814.GA3855@obsidianresearch.com>
References: <cover.1379519753.git.michal.simek@xilinx.com>
 <cb9a12ae95bc39626a745c2487ffd0e47e9c7b34.1379519753.git.michal.simek@xilinx.com>
 <20130918191517.GQ19937@titan.lakedaemon.net>
 <20130918203247.GA11181@obsidianresearch.com>
 <1379539063.31417.23.camel@atx-linux-37>
 <523AD814.1060406@monstr.eu>
 <CADuitaCjNv2HFCg_y2qpkvXmUmO-jKUVQ2Ra8ACOne1hwAmKJA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADuitaCjNv2HFCg_y2qpkvXmUmO-jKUVQ2Ra8ACOne1hwAmKJA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 19, 2013 at 10:18:03AM -0500, Yves Vandervennet wrote:
> On Thu, Sep 19, 2013 at 5:55 AM, Michal Simek <monstr@monstr.eu> wrote:
> 
> >> Is there some way a per-device userspace helper can be added that can
> >> handle adding the headers?  Such that different fpga types get different
> >> helpers?
> >
> > What do you exactly mean by that? Any example what do you want to achieve?
> Bit streams may not be in raw format, so using 'cat' is not possible.
> Xilinx and Altera have their own bit stream "richer" format, that need
> to be processed before they are presented to the driver(s). So, a
> hotplug helper per manufacturer/FPGA is required. Assuming 'cat' will
> be used is too limiting.
> Does it make sense to you?

IMHO it doesn't make sense to use request firmware for this, in
general.

1) The driver doesn't know what firmware to request. It just knows
   how to send it to a FPGA.
2) Telling the kernel a filename via sysfs and then having it go
   around the long way via request_firwmare to get the data is silly.
   Just give the kernel the actual data instead of a file name
3) It is hard to use, when userspace writes the file name the kernel
   doesn't return until request_firmware completes, which means you
   need multiple threads in user space to make this work.
4) Converting an input file into bitstreamable format should be done
   in userspace. This doesn't require request_firmware. If you want
   to make it automatic then a program invoked via udev is the way
   to go.

Jason
