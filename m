Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751887Ab3KRObA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 09:31:00 -0500
Received: from mga01.intel.com ([192.55.52.88]:60885 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751236Ab3KROay (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 09:30:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,724,1378882800"; 
   d="scan'208";a="429648733"
Message-ID: <1384785017.14845.214.camel@smile>
Subject: Re: [PATCHv7] dmaengine: Add support for BCM2835
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Florian Meier <florian.meier@koalo.de>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        "Koul, Vinod" <vinod.koul@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        devicetree <devicetree@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>,
        linux-rpi-kernel <linux-rpi-kernel@lists.infradead.org>,
        dmaengine <dmaengine@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Mon, 18 Nov 2013 16:30:17 +0200
In-Reply-To: <528A051A.7000703@koalo.de>
References: <5288E327.8050809@koalo.de> <1384768816.14845.186.camel@smile>
	 <528A051A.7000703@koalo.de>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-11-18 at 13:16 +0100, Florian Meier wrote:
> Thank you! Few comments below.

See my answers below.

> >> +static enum dma_status bcm2835_dma_tx_status(struct dma_chan *chan,
> >> +	dma_cookie_t cookie, struct dma_tx_state *txstate)
> >> +{
> > 
> > []
> > 
> >> +	} else {
> >> +		txstate->residue = 0;
> > 
> > Useless assignment since dmaengine will do this for you in
> > dma_cookie_status.
> 
> I agree that it is useless, but I think otherwise it might be concealed
> that there is a third case left that uses a residue of 0. Do you think a
> comment is better? E.g.:
> 
> +	} else {
> +		/* residue = 0 per default */

I think like in many other DMA drivers either you have separate function
to get residue, which returns 0, or just not include this case.

> >> +static int bcm2835_dma_probe(struct platform_device *pdev)
> >> +{

> >> +	uint32_t chans_available;
> > 
> > Why uint32_t?
> 
> Because it is a bit mask of fixed length that directly comes from the
> firmware.

Like one already told you in your i2s patch, please, change that to
corresponding u* value, namely u32.

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy

