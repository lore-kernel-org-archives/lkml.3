Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452AbbAURhF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 12:37:05 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:39028 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017AbbAURg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 12:36:59 -0500
Date: Wed, 21 Jan 2015 09:36:21 -0800
From: Nicolin Chen <nicoleotsuka@gmail.com>
To: Zidan Wang <b50113@freescale.com>
Cc: Zidan Wang <zidan.wang@freescale.com>, timur@tabi.org, Xiubo.Lee@gmail.com,
        lgirdwood@gmail.com, broonie@kernel.org, perex@perex.cz, tiwai@suse.de,
        alsa-devel@alsa-project.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel][PATCH 1/3] SoC: fsl_sai: add sai master mode support
Message-ID: <20150121173619.GA1184@Asurada>
References: <1421756480-7055-1-git-send-email-zidan.wang@freescale.com>
 <1421756480-7055-2-git-send-email-zidan.wang@freescale.com>
 <20150121060702.GB3275@Alpha>
 <20150121092529.GA27441@b50113>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150121092529.GA27441@b50113>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2015 at 05:25:32PM +0800, Zidan Wang wrote:
> On Tue, Jan 20, 2015 at 10:07:03PM -0800, Nicolin Chen wrote:
> > On Tue, Jan 20, 2015 at 08:21:18PM +0800, Zidan Wang wrote:

> > > +	if ((tx && sai->synchronous[TX]) || (!tx && !sai->synchronous[RX])) {
> > > +		regmap_update_bits(sai->regmap, FSL_SAI_RCR2,
> > > +			FSL_SAI_CR2_MSEL_MASK, FSL_SAI_CR2_MSEL(sai->mclk_id));

> > "tx && sai->synchronous[TX]" means the playback in synchronous
> > mode (TX following RX). What if the recording has been already
> > activated with an MSEL setting at this point? Then the playback
> > stream, as a secondary stream, will overwrite MSEL of the first
> > stream -- Record. Same would happen to the DIV configuration.
> > 
> When TX following RX(or RX following TX), TX and RX works on same bit
> clock and frame clock. They will use same MCLK source, and just need set
> the bclk DIV for RX(or TX). The secondary stream will overwrite MSEL and
> bclk DIV of the first stream, but it doesn't matter.
> 
> For RX(or TX) sync:
> fsl_sai_dai.symmetric_rates = 1;
> fsl_sai_dai.symmetric_channels = 1;
> fsl_sai_dai.symmetric_samplebits = 1;

Ah, I forgot we have protection here. It's fine then.

> When TX and RX both works on async mode, TX and RX may works on
> different bit clock and frame clock. We need set MCLK source and bclk
> DIV for TX and RX. mclk_id just save a MCLK source id, so i need to define
> mclk_id[2] for differnet stream.

Yes, you need to change this part as you just realized.

And one more thing for your coding style for multi-line comment:
/*
 * Typically use this format.
 */

Thanks
Nicolin
