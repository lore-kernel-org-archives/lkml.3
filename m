Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760637Ab3D3NMY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 09:12:24 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:47911 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760348Ab3D3NMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 09:12:22 -0400
Date: Tue, 30 Apr 2013 14:12:15 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Russell King <linux@arm.linux.org.uk>, Chris Ball <cjb@laptop.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>
Subject: Re: [PATCH] mmc: mmci: Allow MMCI to request channels with
 information acquired from DT
Message-ID: <20130430131215.GA25256@gmail.com>
References: <1366801122-13302-1-git-send-email-lee.jones@linaro.org>
 <CACRpkdY+WtjnJGhVOCk3OZW+Z1maO0ru+Fc2wPR7OzWe+RMuJg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdY+WtjnJGhVOCk3OZW+Z1maO0ru+Fc2wPR7OzWe+RMuJg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Apr 2013, Linus Walleij wrote:

> On Wed, Apr 24, 2013 at 12:58 PM, Lee Jones <lee.jones@linaro.org> wrote:
> 
> > Currently, if DMA information isn't passed from platform data, then DMA
> > will not be used. This patch allows DMA information obtained though Device
> > Tree to be used as well.
> >
> > Cc: Russell King <linux@arm.linux.org.uk>
> > Cc: Chris Ball <cjb@laptop.org>
> > Cc: linux-mmc@vger.kernel.org
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> (...)
> 
> I tried to test this patch, but:
>   CC      drivers/mmc/host/mmci.o
> /drivers/mmc/host/mmci.c: In function 'mmci_dma_setup':
> /drivers/mmc/host/mmci.c:307:51: error: 'dev' undeclared (first use in
> this function)
> /drivers/mmc/host/mmci.c:307:51: note: each undeclared identifier is
> reported only once for each function it appears in
> make[5]: *** [drivers/mmc/host/mmci.o] Error 1
> make[4]: *** [drivers/mmc/host] Error 2
> make[3]: *** [drivers/mmc] Error 2
> 
> Due to:
> 
> > @@ -304,10 +304,8 @@ static void mmci_dma_setup(struct mmci_host *host)
> >         const char *rxname, *txname;
> >         dma_cap_mask_t mask;
> >
> > -       if (!plat || !plat->dma_filter) {
> > -               dev_info(mmc_dev(host->mmc), "no DMA platform data\n");
> > -               return;
> > -       }
> > +       host->dma_rx_channel = dma_request_slave_channel(dev, "rx");
> > +       host->dma_tx_channel = dma_request_slave_channel(dev, "tx");
> 
> There is no "dev" here.

You've missed v2 again dude.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
