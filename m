Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713AbaHNI6N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 04:58:13 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:49838 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754946AbaHNI6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 04:58:09 -0400
Date: Thu, 14 Aug 2014 09:57:53 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Ludovic Desroches <ludovic.desroches@atmel.com>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, dmaengine@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Antoine =?iso-8859-1?Q?T=E9nart?= <antoine@free-electrons.com>,
        Thomas Petazzoni <thomas@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris Brezillon <boris@free-electrons.com>,
        Matt Porter <matt.porter@linaro.org>,
        laurent.pinchart@ideasonboard.com,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [PATCH] Documentation: dmaengine: Add a documentation for the
	dma controller API
Message-ID: <20140814085753.GS30401@n2100.arm.linux.org.uk>
References: <1406736193-26685-1-git-send-email-maxime.ripard@free-electrons.com> <20140814085301.GJ2452@ldesroches-Latitude-E6320>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140814085301.GJ2452@ldesroches-Latitude-E6320>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 14, 2014 at 10:53:01AM +0200, Ludovic Desroches wrote:
> On Wed, Jul 30, 2014 at 06:03:13PM +0200, Maxime Ripard wrote:
> > The dmaengine is neither trivial nor properly documented at the moment, which
> > means a lot of trial and error development, which is not that good for such a
> > central piece of the system.
> > 
> > Attempt at making such a documentation.
> 
> Good idea, many questions are asked when writing a new dmaengine driver.
> 
> For instance I didn't find how to use the DMA_CTRL_ACK flags.
> 
> - How this flag has to be managed? For instance, async_tx_ack is used in
> dmaengine driver but also in some devices.
> - Is it mandatory to deal with this flag? It seems some dmaengine
> drivers don't care about it.

This is one part of the DMA engine API that even I don't understand.

It's got something to do with the async engine API, and seems to be
something to do with whether a descriptor can have other transactions
added to it, and whether a descriptor can be re-used (async-tx engines
typically allocate a fixed set of descriptors and recycle them.)

I was never able to get to the bottom of what that flag meant or how
it should be used with the DMA slave API (and I suspect everyone else
just gave up trying to understand it as well.)

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
