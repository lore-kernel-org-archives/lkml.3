Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758177Ab3IBHX3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 03:23:29 -0400
Received: from mga09.intel.com ([134.134.136.24]:32162 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754488Ab3IBHX2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 03:23:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,1005,1367996400"; 
   d="scan'208";a="389827072"
Date: Mon, 2 Sep 2013 12:07:21 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Lu Jingchang-B35083 <B35083@freescale.com>
Cc: "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v4 3/3] dma: Add Freescale eDMA engine driver support
Message-ID: <20130902063721.GK7376@intel.com>
References: <1376633274-17850-1-git-send-email-b35083@freescale.com>
 <20130828081742.GC11414@intel.com>
 <B56CDBE15CE27145A4B77D2D24263E8520A8C7@039-SN1MPN1-003.039d.mgd.msft.net>
 <20130902045050.GE7376@intel.com>
 <B56CDBE15CE27145A4B77D2D24263E8520D0D4@039-SN1MPN1-004.039d.mgd.msft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B56CDBE15CE27145A4B77D2D24263E8520D0D4@039-SN1MPN1-004.039d.mgd.msft.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 02, 2013 at 07:10:53AM +0000, Lu Jingchang-B35083 wrote:
> > -----Original Message-----
> > From: Vinod Koul [mailto:vinod.koul@intel.com]
> > Sent: Monday, September 02, 2013 12:51 PM
> > To: Lu Jingchang-B35083
> > Cc: shawn.guo@linaro.org; linux-kernel@vger.kernel.org; linux-arm-
> > kernel@lists.infradead.org; devicetree@vger.kernel.org
> > Subject: Re: [PATCH v4 3/3] dma: Add Freescale eDMA engine driver support
> > 
> > On Thu, Aug 29, 2013 at 03:32:04AM +0000, Lu Jingchang-B35083 wrote:
> > 
> > Please use a right MUA and wrap your lines at 80chars...

> > > [Lu Jingchang]
> > No need to put your name :)
> [Lu Jingchang-b35083] 
> Aha, the Microsoft Outlook adds this automatically with default option.
You can change that!!

> > 
> > > Ok, if it is needed, I will add residue calculation in the next version.
> > Yes this is needed
> > 
> > > > > +static bool fsl_edma_filter_fn(struct dma_chan *chan, void
> > *fn_param)
> > > > > +{
> > > > > +	struct fsl_edma_filter_param *fparam = fn_param;
> > > > > +	struct fsl_edma_chan *fsl_chan = to_fsl_edma_chan(chan);
> > > > > +
> > > > > +	if (fsl_chan->edmamux->mux_id != fparam->mux_id)
> > > > > +		return false;
> > > > > +
> > > > > +	fsl_chan->slot_id = fparam->slot_id;
> > > > > +	chan->private = fn_param;
> > > > why do you need to use chan->private?
> > > [Lu Jingchang]
> > > The private used here is to store the slot_id information, which must
> > be used
> > > by the DMAMUX in alloc_chan_resources function. Thanks.
> > Why dont you pass this in struct dma_slave_config memeber slave_id for
> > this.
> [Lu Jingchang-b35083] 
> I will drop this private and setup the slave_id directly in the filter function.
why in filter? before calling prepare function you can set the slave config

~Vinod
