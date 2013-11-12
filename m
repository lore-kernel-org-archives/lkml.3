Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932Ab3KLE4g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 23:56:36 -0500
Received: from mga09.intel.com ([134.134.136.24]:49270 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751931Ab3KLE4Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 23:56:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="407261909"
Date: Tue, 12 Nov 2013 09:30:39 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Olof Johansson <olof@lixom.net>
Cc: Joel Fernandes <joelf@ti.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Dan Williams <dan.j.williams@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Sekhar Nori <nsekhar@ti.com>, Matt Porter <matt.porter@linaro.org>,
        broonie@kernel.org, Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [PATCH 01/28] dmaengine: use DMA_COMPLETE for dma completion
 status
Message-ID: <20131112040039.GE8834@intel.com>
References: <20131017142755.GA4477@breakpoint.cc>
 <20131017134846.GG14013@intel.com>
 <Pine.LNX.4.64.1310242326500.2900@axis700.grange>
 <20131025042310.GC21230@intel.com>
 <Pine.LNX.4.64.1310250813370.6186@axis700.grange>
 <20131025054321.GD21230@intel.com>
 <Pine.LNX.4.64.1310250840350.6186@axis700.grange>
 <CAOesGMivD_3zSL503R0OaqyGv4Rj8qJqnbM2TdmjtxR2U63ztw@mail.gmail.com>
 <20131030130325.GA18788@intel.com>
 <20131111191339.GA10328@quad.lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131111191339.GA10328@quad.lixom.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 11, 2013 at 11:13:39AM -0800, Olof Johansson wrote:
> On Wed, Oct 30, 2013 at 06:33:25PM +0530, Vinod Koul wrote:
> > On Tue, Oct 29, 2013 at 09:47:55AM -0700, Olof Johansson wrote:
> > > This patch broke some TI platforms (using edma) due to namespace
> > > conflicts. The error is:
> > > 
> > > ../../include/linux/dmaengine.h:54:2: error: expected identifier
> > > before numeric constant   (for DMA_COMPLETE)
> > > 
> > > .. it's because they define DMA_COMPLETE in include/platform_data/edma.h.
> > > 
> > > The edma driver seems to overall lack prefixes and thus pollutes
> > > global namespaces, so it should be fixed up.
> > Yup this needs some work.
> > 
> > I fixed up the error with below, can you pls verify. Pls note this is compile
> > tested only!
> > 
> > -----><8---------------------------
> > 
> > From: Vinod Koul <vinod.koul@intel.com>
> > Date: Wed, 30 Oct 2013 18:22:30 +0530
> > Subject: [PATCH] dmanengine: fix edma driver to not define DMA_COMPLETE
> > 
> > edma header defines DMA_COMPLETE, this causes issues as commit adfedd9a32e4 move
> > DMA_SUCCESS to DMA_COMPLETE. edma should properly namespace its defines and
> > needs a future fix
> > 
> > Reported-by: Olof Johansson <olof@lixom.net>
> > Signed-off-by: Vinod Koul <vinod.koul@intel.com>
> 
> Thanks, I've applied this to fixes together with the follow-up from
> Sebastian. Cc:ing Mark since it touches drivers/soc.
I had applied this a while back and pushed only thing remaining was Sebastian's
patch.  Since this is dependent on the series I am sending to Linus in a day ro
two, would prefer things to go thru this tree only.

Let me know if you are okay and will apply Sebastian fix on my next

--
~Vinod
