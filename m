Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754346AbaLHJcS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 04:32:18 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:57254 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670AbaLHJcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 04:32:16 -0500
Date: Mon, 8 Dec 2014 10:32:47 +0100
From: Ludovic Desroches <ludovic.desroches@atmel.com>
To: Vinod Koul <vinod.koul@intel.com>
CC: Maxime Ripard <maxime.ripard@free-electrons.com>,
        <dmaengine@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Antoine =?iso-8859-1?Q?T=E9nart?= <antoine@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>, <lars@metafoo.de>
Subject: Re: [PATCH v5 00/61] dmaengine: Implement generic slave capabilities
 retrieval
Message-ID: <20141208093246.GB27228@ldesroches-Latitude-E6320>
Mail-Followup-To: Vinod Koul <vinod.koul@intel.com>,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Antoine =?iso-8859-1?Q?T=E9nart?= <antoine@free-electrons.com>,
	Russell King <linux@arm.linux.org.uk>, lars@metafoo.de
References: <1416231775-31252-1-git-send-email-maxime.ripard@free-electrons.com>
 <20141208061746.GD16827@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20141208061746.GD16827@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 08, 2014 at 11:47:46AM +0530, Vinod Koul wrote:
> On Mon, Nov 17, 2014 at 02:41:54PM +0100, Maxime Ripard wrote:
> > Hi,
> > 
> > As we discussed a couple of weeks ago, this is the third attempt at
> > creating a generic behaviour for slave capabilities retrieval so that
> > generic layers using dmaengine can actually rely on that.
> > 
> > That has been done mostly through two steps: by moving out the
> > sub-commands of the device_control callback, so that the dmaengine
> > core can then infer from that wether a sub-command is implemented, and
> > then by moving the slave properties, such as the supported buswidth,
> > to the structure dma_device itself.
> 
> Okay managed to get this done. Apart from the two issues identified didn't
> find anything so applied and pushed to a branch
> "topic/slave_caps_device_control_fix"
> 
> Today did some compile tests and found few warnings, were trivial but I
> am worried about the testing of this code. Has anyone tested this, if so
> which platforms are covered Since I pushed base branch last night, Feng's
> bot covered it and all was OK. Looks like Feng's bot doesn't have wide
> coverage of arm platforms, wasn't there one run by arm guys which tries to
> test and boot, if so can we get this tested there please.

Tested with your branch on sama5d3 and sama5d4 so at_hdmac and at xdmac.

I have also sent some patches based on Maxime's series for at_xdmac.

Ludovic

> 
> So bit sceptical for merging now. I will send the patches which I have
> applied on top of this
> 
> Thanks
> -- 
> ~Vinod
> 
> --
> To unsubscribe from this list: send the line "unsubscribe dmaengine" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
