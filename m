Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751764Ab3EPKR1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 06:17:27 -0400
Received: from mga02.intel.com ([134.134.136.20]:1205 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750713Ab3EPKR0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 06:17:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,683,1363158000"; 
   d="scan'208";a="338220821"
Date: Thu, 16 May 2013 15:11:57 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        balbi@ti.com, linux-usb@vger.kernel.org, linux-crypto@vger.kernel.org,
        davem@davemloft.net, herbert@gondor.hengli.com.au, arnd@arndb.de,
        linus.walleij@stericsson.com, srinidhi.kasagar@stericsson.com,
        Dan Williams <djbw@fb.com>, Per Forlin <per.forlin@stericsson.com>,
        Rabin Vincent <rabin@rab.in>
Subject: Re: [PATCH 34/39] dmaengine: ste_dma40: Convert data_width from
 register bit format to value
Message-ID: <20130516094157.GK14863@intel.com>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
 <1368611522-9984-35-git-send-email-lee.jones@linaro.org>
 <20130516063244.GA14863@intel.com>
 <20130516073553.GF3269@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130516073553.GF3269@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 16, 2013 at 08:35:53AM +0100, Lee Jones wrote:
> On Thu, 16 May 2013, Vinod Koul wrote:
> 
> > On Wed, May 15, 2013 at 10:51:57AM +0100, Lee Jones wrote:
> > > +u8 d40_width_to_bits(enum dma_slave_buswidth width)
> > > +{
> > > +	if (width == DMA_SLAVE_BUSWIDTH_1_BYTE)
> > > +		return STEDMA40_ESIZE_8_BIT;
> > > +	else if (width == DMA_SLAVE_BUSWIDTH_2_BYTES)
> > > +		return STEDMA40_ESIZE_16_BIT;
> > > +	else if (width == DMA_SLAVE_BUSWIDTH_8_BYTES)
> > > +		return STEDMA40_ESIZE_64_BIT;
> > > +	else
> > > +		return STEDMA40_ESIZE_32_BIT;
> > > +}
> > > +
> > Switch looks better for this and how about
> > 	return fls(width);
> > 
> > as your defines are 0...3 and dmaengine define 1,2,..8 for same thing
> > then you can also get rid of STEDMA40_XXX_WIDTH macros!
> 
> I like it.
> 
> Will you let me do it as a follow-up patch?
Okay...

--
~Vinod
