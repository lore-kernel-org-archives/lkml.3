Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754609Ab3HEF4H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 01:56:07 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:15663 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754220Ab3HEF4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 01:56:06 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Sun, 04 Aug 2013 22:54:28 -0700
Date: Mon, 5 Aug 2013 13:56:09 +0800
From: Richard Zhao <rizhao@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "djbw@fb.com" <djbw@fb.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>
Subject: Re: [PATCH] DMA: add help function to check whether dma controller
 registered
Message-ID: <20130805055607.GC31469@rizhao-lap>
References: <1375423458-6868-1-git-send-email-rizhao@nvidia.com>
 <51FC0FBF.9010107@wwwdotorg.org>
MIME-Version: 1.0
In-Reply-To: <51FC0FBF.9010107@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 03, 2013 at 03:59:59AM +0800, Stephen Warren wrote:
> On 08/02/2013 12:04 AM, Richard Zhao wrote:
> > DMA client device driver usually needs to know at probe time whether
> > dma controller has been registered to deffer probe. So add a help
> > function of_dma_check_controller.
> > 
> > DMA request channel functions can also used to check it, but they
> > are usually called at open() time.
> 
> > diff --git a/drivers/dma/of-dma.c b/drivers/dma/of-dma.c
> > index e1c4d3b..b6828c1 100644
> 
> > +int of_dma_check_controller(struct device *dev, const char *name)
> 
> 
> > +	for (i = 0; i < count; i++) {
> > +		if (of_dma_match_channel(np, name, i, &dma_spec))
> > +			continue;
> > +
> > +		mutex_lock(&of_dma_lock);
> > +		ofdma = of_dma_find_controller(&dma_spec);
> > +		mutex_unlock(&of_dma_lock);
> > +		of_node_put(dma_spec.np);
> 
> Do we need to add the following here:
> 
> if (ofdma)
> 	break
> 
> To ensure that as soon as a successful match is found, the loop exits?
> Otherwise, if there are multiple providers for that name, and the first
> N are registered but the last isn't, this function will still return
> failure.
Right. Thanks.
> 
> > +	if (ofdma)
> > +		return 0;
> > +	else
> > +		return -ENODEV;
> 
> That probably should be -EPROBE_DEFER?
> 
> Although, what about differentiating between "entry not found by
> of_dma_match_channel" and "controller not yet probed"?
I thought it might be called in non-probe functions.  If no people
against it, I'll change it to EPROBE_DEFER.

Thanks
Richard
