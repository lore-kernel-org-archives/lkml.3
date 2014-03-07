Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950AbaCGXIE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 18:08:04 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:51439 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753068AbaCGXIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 18:08:02 -0500
Date: Fri, 7 Mar 2014 17:07:59 -0600
From: Andy Gross <agross@codeaurora.org>
To: Stanimir Vabanov <svarbanov@mm-sol.com>
Cc: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>,
        dmaengine@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [Patch v8 2/2] dmaengine: add Qualcomm BAM dma driver
Message-ID: <20140307230759.GC3241@qualcomm.com>
References: <1393828245-18766-1-git-send-email-agross@codeaurora.org>
 <1393828245-18766-3-git-send-email-agross@codeaurora.org>
 <531A485D.9010508@mm-sol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <531A485D.9010508@mm-sol.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 08, 2014 at 12:29:49AM +0200, Stanimir Vabanov wrote:
> > +#define BAM_IRQ_SRCS_EE(pipe)		(0x0800 + ((pipe) * 0x80))
> > +#define BAM_IRQ_SRCS_MSK_EE(pipe)	(0x0804 + ((pipe) * 0x80))
> 
> s/pipe/ee ?
> 

Ah good catch.  I'll fix that.

> > +struct bam_chan {
> > +	struct virt_dma_chan vc;
> > +
> > +	struct bam_device *bdev;
> > +
> > +	/* configuration from device tree */
> > +	u32 id;
> > +	u32 ee;
> > +
> 
> do we need per channel ee? I'm asking because failed to find references
> to it.
> 

You're right.  This is dead variable.  I had transitioned from channel to
device when I modified the bindings.  Device is where it belongs.  I'll fix
this.

<snip>
> > +
> > +/**
> > + * bam_alloc_chan - Allocate channel resources for DMA channel.
> > + * @chan: specified channel
> > + *
> > + * This function allocates the FIFO descriptor memory
> > + */
> > +static int bam_alloc_chan(struct dma_chan *chan)
> > +{
> > +	struct bam_chan *bchan = to_bam_chan(chan);
> > +	struct bam_device *bdev = bchan->bdev;
> > +
> 
> you could invert the logic and avoid extra indentation.
> 	if (bchan->fifo_virt)
> 		return 0;
> 

True.  I'll flip that.

-- 
sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
