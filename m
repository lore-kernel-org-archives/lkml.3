Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711Ab3IYSue (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 14:50:34 -0400
Received: from co1ehsobe002.messaging.microsoft.com ([216.32.180.185]:20357
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751242Ab3IYSuc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 14:50:32 -0400
X-Forefront-Antispam-Report: CIP:66.35.236.232;KIP:(null);UIP:(null);IPV:NLI;H:SJ-ITEXEDGE02.altera.priv.altera.com;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz1432I1447Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzzz2fh2a8h839h93fhd24hd2bhf0ah107ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1e23h1fe8h1ff5h1155h)
Message-ID: <1380135024.4810.8.camel@atx-linux-37>
Subject: Re: [RFC PATCH] fpga: Introduce new fpga subsystem
From: Alan Tull <atull@altera.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Michal Simek <monstr@monstr.eu>, Pavel Machek <pavel@denx.de>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Michal Simek <michal.simek@xilinx.com>, <linux-kernel@vger.kernel.org>,
        Dinh Nguyen <dinguyen@altera.com>,
        Philip Balister <philip@balister.org>,
        Alessandro Rubini <rubini@gnudd.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cesar Eduardo Barros <cesarb@cesarb.net>,
        Joe Perches <joe@perches.com>, "David S. Miller" <davem@davemloft.net>,
        Stephen Warren <swarren@nvidia.com>, Arnd Bergmann <arnd@arndb.de>,
        David Brown <davidb@codeaurora.org>, Dom Cobley <popcornmix@gmail.com>
Date: Wed, 25 Sep 2013 13:50:24 -0500
In-Reply-To: <20130924221802.GC3837@kroah.com>
References: <cb9a12ae95bc39626a745c2487ffd0e47e9c7b34.1379519753.git.michal.simek@xilinx.com>
	 <20130918191517.GQ19937@titan.lakedaemon.net>
	 <20130918203247.GA11181@obsidianresearch.com>
	 <1379539063.31417.23.camel@atx-linux-37>
	 <20130919100833.GC19346@amd.pavel.ucw.cz> <523AD9C5.8060006@monstr.eu>
	 <1379710523.21515.4.camel@atx-linux-37>
	 <1380038126.13235.12.camel@atx-linux-37> <5241B6BC.1010301@monstr.eu>
	 <1380039774.14129.6.camel@atx-linux-37> <20130924221802.GC3837@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-OriginatorOrg: altera.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 
> >  * Add this udev rule:
> >    SUBSYSTEM=="firmware", ACTION=="add", RUN+="/lib/udev/hotplug-script"
> > 
> >  * Check that there aren't other 'firmware' udev rules to get in the
> > way.
> 
> Hm, don't do that, all "modern" distros will not do firmware loading
> through udev anymore, so please don't try to add it back in.  The kernel
> handles the loading of the firmware directly, with no need to call any
> usermodehelper program at all.
> 
> >  * Add your firmware files to /usr/lib/hotplug/firmware/ or change that
> >    path in hotplug-script to point to where your firmware files.
> > 
> > The default hotplug-script doesn't do anything special (that the kernel
> > couldn't do by itself).  What's great is that it could call another
> > script that adds headers or does whatever other special un-gzipping or
> > other massaging that the firmware image needs before it gets loaded.
> 
> Only if you need to do something "special" like this could it justify
> not using the in-kernel firmware loader.  Also note that I think future
> versions of udev will have the udev firmware loader removed entirely, so
> watch out for that.
> 

Hi Greg,

Thanks for the heads-up on the direction the firmware class is taking.
Well, that's kind of disappointing.  I was just getting excited about
how flexible the firmware class currently is.  In the simpler fpga use
cases, using the in-kernel loader to load static raw images would be
great.  But we are really excited about exploiting the possibilities
that fpga's give in terms of reconfiguration and partial reconfiguration
on the fly, so we will be needing to do 'special' things (unpacking
images, stripping headers, lots of stuff that userspace would better for
and that we wouldn't want to put into the kernel).  I hope that we can
arrive at a framework with a unified interface that suites this.

Alan

