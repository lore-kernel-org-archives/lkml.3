Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765AbaHSOBI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 10:01:08 -0400
Received: from mga09.intel.com ([134.134.136.24]:60178 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752509AbaHSOBH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 10:01:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,894,1400050800"; 
   d="scan'208";a="590210275"
Date: Tue, 19 Aug 2014 19:15:07 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Ludovic Desroches <ludovic.desroches@atmel.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
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
Message-ID: <20140819134507.GJ13288@intel.com>
References: <1406736193-26685-1-git-send-email-maxime.ripard@free-electrons.com>
 <20140814085301.GJ2452@ldesroches-Latitude-E6320>
 <20140814085753.GS30401@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140814085753.GS30401@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 14, 2014 at 09:57:53AM +0100, Russell King - ARM Linux wrote:
> On Thu, Aug 14, 2014 at 10:53:01AM +0200, Ludovic Desroches wrote:
> > On Wed, Jul 30, 2014 at 06:03:13PM +0200, Maxime Ripard wrote:
> > > The dmaengine is neither trivial nor properly documented at the moment, which
> > > means a lot of trial and error development, which is not that good for such a
> > > central piece of the system.
> > > 
> > > Attempt at making such a documentation.
> > 
> > Good idea, many questions are asked when writing a new dmaengine driver.
> > 
> > For instance I didn't find how to use the DMA_CTRL_ACK flags.
> > 
> > - How this flag has to be managed? For instance, async_tx_ack is used in
> > dmaengine driver but also in some devices.
> > - Is it mandatory to deal with this flag? It seems some dmaengine
> > drivers don't care about it.
> This is one part of the DMA engine API that even I don't understand.
> 
> It's got something to do with the async engine API, and seems to be
> something to do with whether a descriptor can have other transactions
> added to it, and whether a descriptor can be re-used (async-tx engines
> typically allocate a fixed set of descriptors and recycle them.)
Yes this is my understanding too. Async API IIUC can reuse descriptors and
if engine doesnt support this is a way to tell them please do use that.

For slave dmanegine API we need to ignore it.
> 
> I was never able to get to the bottom of what that flag meant or how
> it should be used with the DMA slave API (and I suspect everyone else
> just gave up trying to understand it as well.)

-- 
~Vinod
