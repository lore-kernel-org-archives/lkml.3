Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752438Ab3ATQgq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 11:36:46 -0500
Received: from mail-qa0-f51.google.com ([209.85.216.51]:57453 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752385Ab3ATQgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 11:36:44 -0500
Date: Sun, 20 Jan 2013 11:41:53 -0500
From: Matt Porter <mporter@ti.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <djbw@fb.com>, Chris Ball <cjb@laptop.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] dmaengine: add dma_get_channel_caps()
Message-ID: <20130120164153.GD21407@beef>
References: <1357844826-30746-1-git-send-email-mporter@ti.com>
 <1357844826-30746-2-git-send-email-mporter@ti.com>
 <a5337a28bf454c3ca73e28ffb530ac40@DLEE74.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a5337a28bf454c3ca73e28ffb530ac40@DLEE74.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 20, 2013 at 12:52:43PM +0000, Vinod Koul wrote:
> On Thu, Jan 10, 2013 at 02:07:04PM -0500, Matt Porter wrote:
> > +/* struct dmaengine_chan_caps - expose capability of a channel
> > + * Note: each channel can have same or different capabilities
> > + *
> > + * This primarily classifies capabilities into
> > + * a) APIs/ops supported
> > + * b) channel physical capabilities
> > + *
> > + * @cap_mask: api/ops capability (DMA_INTERRUPT and DMA_PRIVATE
> > + *	       are invalid api/ops and will never be set)
> > + * @seg_nr: maximum number of SG segments supported on a SG/SLAVE
> > + *	    channel (0 for no maximum or not a SG/SLAVE channel)
> > + * @seg_len: maximum length of SG segments supported on a SG/SLAVE
> > + *	     channel (0 for no maximum or not a SG/SLAVE channel)
> > + */
> > +struct dmaengine_chan_caps {
> > +	dma_cap_mask_t cap_mask;
> > +	int seg_nr;
> > +	int seg_len;
> > +};
> Now am really unclear why we would need direction as argument.

Best explanation is my reply to your comments on 0/3. In summary, the
direction allows the edma driver to select the src vs dst addr_width and
maxburst fields to be used to calculate the max segment size that can
be handled.

> Also, I would add the channel physical capablities like direction, widths,
> lengths etc supported.

Ok, I can take a stab at this...I didn't bother initially as I don't
have user for that info at this point. Though, I suppose we don't have
an immediate user for the cap_mask either.

> > +/**
> > + * dma_get_channel_caps - flush pending transactions to HW
> flush pending... ???

ugh, c&p fail...will fix.

> 
> > + * driver does not implement per channel capbilities then
> > + * NULL is returned.
> > + */
> > +static inline struct dmaengine_chan_caps
> > +*dma_get_channel_caps(struct dma_chan *chan, enum dma_transfer_direction dir)
> you need to add this for when CONFIG_DMA_ENGINE is not defined as well.

ok, will fix.

> > +{
> > +	if (chan->device->device_channel_caps)
> > +		return chan->device->device_channel_caps(chan, dir);
> > +	return NULL;
> > +}
> > +
> >  enum dma_status dma_sync_wait(struct dma_chan *chan, dma_cookie_t cookie);
> >  #ifdef CONFIG_DMA_ENGINE
> >  enum dma_status dma_wait_for_async_tx(struct dma_async_tx_descriptor *tx);
> --
> ~Vinod
