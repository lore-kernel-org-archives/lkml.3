Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758628Ab3DYNoL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 09:44:11 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:64520 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758003Ab3DYNoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 09:44:08 -0400
Date: Thu, 25 Apr 2013 14:44:02 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Andreas Westin <andreas.westin@stericsson.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        magnus.p.persson@stericsson.com
Subject: Re: [PATCH 6/9] crypto: ux500/cryp - Set DMA configuration though
 dma_slave_config()
Message-ID: <20130425134402.GN4623@gmail.com>
References: <1366280825-31136-1-git-send-email-lee.jones@linaro.org>
 <1366280825-31136-7-git-send-email-lee.jones@linaro.org>
 <CACRpkdbFgW6bGYt59WtN4r2izuN09AJw4J1cqir82uzFsuMmWQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdbFgW6bGYt59WtN4r2izuN09AJw4J1cqir82uzFsuMmWQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Apr 2013, Linus Walleij wrote:

> On Thu, Apr 18, 2013 at 12:27 PM, Lee Jones <lee.jones@linaro.org> wrote:
> 
> > The DMA controller currently takes configuration information from
> > information passed though dma_channel_request(), but it shouldn't.
> > Using the API, the DMA channel should only be configured during
> > a dma_slave_config() call.
> >
> > Cc: Herbert Xu <herbert@gondor.apana.org.au>
> > Cc: David S. Miller <davem@davemloft.net>
> > Cc: Andreas Westin <andreas.westin@stericsson.com>
> > Cc: linux-crypto@vger.kernel.org
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> 
> (...)
> >  /* Cryp DMA interface */
> > +#define HASH_DMA_TX_FIFO       0x08
> > +#define HASH_DMA_RX_FIFO       0x10
> 
> Yes, this is nice address notation :-)
> 
> >  /**
> >   * struct cryp_device_data - structure for a cryp device.
> > - * @base: Pointer to the hardware base address.
> > + * @base: Pointer to virtual base address of the cryp device.
> > + * @phybase: Pointer to physical memory location of the cryp device.
> >   * @dev: Pointer to the devices dev structure.
> >   * @clk: Pointer to the device's clock control.
> >   * @pwr_regulator: Pointer to the device's power control.
> > @@ -232,6 +236,7 @@ struct cryp_dma {
> >   */
> >  struct cryp_device_data {
> >         struct cryp_register __iomem *base;
> > +       phys_addr_t phybase;
> 
> Use dma_addr_t. Maybe "phybase" is misleading,
> "dmabase" is probably better. (Also applies to the
> cryp patch).

Accept it's not the dmabase.

It's the phybase (U8500_CRYP1_BASE) i.e. the physical base address of
the device's regs.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
