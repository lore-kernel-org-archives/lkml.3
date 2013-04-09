Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934578Ab3DILmv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 07:42:51 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:33194 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758134Ab3DILmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 07:42:50 -0400
X-Auth-Info: YtzQiVgCz0OvE/KdHnlcH3Eswrqhk93wW5JL2qu+5fk=
Date: Tue, 9 Apr 2013 13:42:36 +0200
From: Anatolij Gustschin <agust@denx.de>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 1/2] dmaengine: mpc512x_dma: use generic DMA DT bindings
Message-ID: <20130409134236.4d1bffa6@crub>
In-Reply-To: <5162A017.8010102@metafoo.de>
References: <1364746680-6564-1-git-send-email-agust@denx.de>
	<5162A017.8010102@metafoo.de>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 08 Apr 2013 12:46:47 +0200
Lars-Peter Clausen <lars@metafoo.de> wrote:
...
> > +static struct dma_chan *mpc_dma_xlate(struct of_phandle_args *dma_spec,
> > +						struct of_dma *ofdma)
> > +{
> > +	int count = dma_spec->args_count;
> > +	struct mpc_dma *mdma = ofdma->of_dma_data;
> > +	struct mpc_dma_filter_args fargs;
> > +	dma_cap_mask_t cap;
> > +
> > +	if (!mdma)
> > +		return NULL;
> > +
> > +	if (count != 1)
> > +		return NULL;
> > +
> > +	fargs.mdma = mdma;
> > +	fargs.chan_id = dma_spec->args[0];
> > +
> > +	dma_cap_zero(cap);
> > +	dma_cap_set(DMA_SLAVE, cap);
> > +
> > +	return dma_request_channel(cap, mpc_dma_filter, &fargs);
> > +}
> > +
> 
> This is more or less the same as the generic of_dma_xlate_by_chan_id
> function I posted about two weeks ago:
> https://patchwork.kernel.org/patch/2331091/

Thanks. I can use the generic of_dma_xlate_by_chan_id() when above patch
will be accepted.

Anatolij
