Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122Ab3HEQ0v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 12:26:51 -0400
Received: from mga09.intel.com ([134.134.136.24]:24094 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752706Ab3HEQ0s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 12:26:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,819,1367996400"; 
   d="scan'208";a="357809803"
Date: Mon, 5 Aug 2013 21:15:51 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Lothar =?iso-8859-1?Q?Wa=DFmann?= <LW@KARO-electronics.de>
Cc: Jingchang Lu <b35083@freescale.com>, Xiaochun Li <b41219@freescale.com>,
        Alison Wang <b18965@freescale.com>, linux-kernel@vger.kernel.org,
        djbw@fb.com, shawn.guo@linaro.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 3/3] dma: Add Freescale eDMA engine driver support
Message-ID: <20130805154551.GP29095@intel.com>
References: <1375682824-11443-1-git-send-email-b35083@freescale.com>
 <1375682824-11443-2-git-send-email-b35083@freescale.com>
 <20991.23049.78707.457046@ipc1.ka-ro>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20991.23049.78707.457046@ipc1.ka-ro>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 05, 2013 at 09:53:45AM +0200, Lothar Waßmann wrote:
> Hi,
> 
> Jingchang Lu writes:
> > Add Freescale enhanced direct memory(eDMA) controller support.
> > The eDMA controller deploys DMAMUXs routing DMA request sources(slot)
> > to eDMA channels.
> > This module can be found on Vybrid and LS-1 SoCs.
> > 
> [...]
> > +static struct fsl_edma_desc *fsl_edma_alloc_desc(struct fsl_edma_chan *fsl_chan,
> > +		int sg_len)
> > +{
> > +	struct fsl_edma_desc *fsl_desc;
> > +	int size, i;
> > +
> > +	size = sizeof(struct fsl_edma_desc);
> > +	size += sizeof(struct fsl_edma_sw_tcd) * sg_len;
> > +	fsl_desc = kzalloc(size, GFP_KERNEL);
> > +	if (!fsl_desc)
> > +		return NULL;
> > +
> > +	fsl_desc->echan = fsl_chan;
> > +	fsl_desc->n_tcds = sg_len;
> > +	for (i = 0; i < sg_len; i++) {
> > +		fsl_desc->tcd[i].vtcd = dma_pool_alloc(fsl_chan->tcd_pool,
> > +					GFP_ATOMIC, &fsl_desc->tcd[i].ptcd);
> >
> Why is this called with GFP_ATOMIC while fsl_desc above is being
> allocated with GFP_KERNEL?
Both need to be GFP_ATOMIC, better they need to be GFP_NOWAIT.

~Vinod
