Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892Ab3IYTVu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 15:21:50 -0400
Received: from co1ehsobe002.messaging.microsoft.com ([216.32.180.185]:25413
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750992Ab3IYTVt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 15:21:49 -0400
X-Forefront-Antispam-Report: CIP:66.35.236.232;KIP:(null);UIP:(null);IPV:NLI;H:SJ-ITEXEDGE02.altera.priv.altera.com;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz1b0bI1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de097hz2fh2a8h839h93fhd24hd2bhf0ah107ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1e23h1fe8h1ff5h1155h)
Message-ID: <1380136900.4810.22.camel@atx-linux-37>
Subject: Re: [RFC PATCH] fpga: Introduce new fpga subsystem
From: Alan Tull <atull@altera.com>
To: Michal Simek <monstr@monstr.eu>
CC: Philip Balister <philip@balister.org>, Pavel Machek <pavel@denx.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Michal Simek <michal.simek@xilinx.com>, <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dinh Nguyen <dinguyen@altera.com>,
        Alessandro Rubini <rubini@gnudd.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cesar Eduardo Barros <cesarb@cesarb.net>,
        Joe Perches <joe@perches.com>, "David S. Miller" <davem@davemloft.net>,
        Stephen Warren <swarren@nvidia.com>, Arnd Bergmann <arnd@arndb.de>,
        David Brown <davidb@codeaurora.org>, Dom Cobley <popcornmix@gmail.com>
Date: Wed, 25 Sep 2013 14:21:40 -0500
In-Reply-To: <5242F695.2070506@monstr.eu>
References: <cover.1379519753.git.michal.simek@xilinx.com>
	 <cb9a12ae95bc39626a745c2487ffd0e47e9c7b34.1379519753.git.michal.simek@xilinx.com>
	 <20130918191517.GQ19937@titan.lakedaemon.net>
	 <20130918203247.GA11181@obsidianresearch.com>
	 <1379539063.31417.23.camel@atx-linux-37>
	 <20130919100833.GC19346@amd.pavel.ucw.cz> <52421829.4050708@zytor.com>
	 <20130925120052.GD9690@amd.pavel.ucw.cz> <5242F2EF.2050900@balister.org>
	 <5242F695.2070506@monstr.eu>
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
> > For the Zynq based product I am working on, we encourage the end user to
> > create their own bitstreams to customize their application. So we need
> > an easy way for the user to load a bitstream. cat foo.bin > /dev/xdevcfg
> > works well for us.
> 
> You probably don't care if this will be
> cat foo.bin > /sys/fpga/fpga0/<whatever>
> (for zynq case you can also run)
> cat foo.bit > /sys/fpga/fpga0/<whatever>
> 
> FYI: Current driver in xilinx repo supports bit format too.
> 

Michal,

So your low level driver has a back door to avoid having to use the
firmware class?  I thought the point of this exercise was to have a
framework with a unified interface.

My original framework supported the interface you mention here.

If we are going to have a framework, we should spec in in such a way
that vendors won't be required to add back doors to their drivers in
order to support the use cases they are interested in.

If the firmware interface isn't going to work all the fpga use cases,
then why upstream this patch?  In that case we should go back to the
original implementation and have a unified interface that supports
cat'ing the bitstreams to /sys instead.

My current opinion about the firmware class is that we can use it (and
it is best to use existing interfaces), but it is not really suited for
all the fpga use cases.

The other thing the original fpga framework had was a transport layer.
The intent was to eventually support the same driver (such as a bitbang
driver) no matter what type of gpio lines it was attached to.  It wasn't
really necessary for the fpga manager that is bolted onto a soc, but it
will be needed if you have an fpga that gets programmed from another
fpga that is connected to a soc.  Otherwise you have to write separate
drivers depending on how the fpga is connected.

Alan

