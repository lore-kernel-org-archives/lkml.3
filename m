Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934705AbaEFJl1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 05:41:27 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:51794 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934523AbaEFJlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 05:41:24 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Rob Herring <robherring2@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: Re: [PATCH v3 4/7] of: configure the platform device dma parameters
Date: Tue, 06 May 2014 11:40:38 +0200
Message-ID: <7182186.5Q53eQg77F@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <536806F4.1090904@ti.com>
References: <1398353407-2345-1-git-send-email-santosh.shilimkar@ti.com> <CAL_Jsq+nh26NZXx-9Y5FTxWZdVrG7aLTOBhC4j9P8mPPvUu2ag@mail.gmail.com> <536806F4.1090904@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:fiztjVB7DT/+GdjiM6idE41Fda6wVFHP1d337q/Ah72
 aCA1I14fFFFL3L7bQzXWXnCIpS6HeyZMzET/6koG+kv3sbUhSa
 eDwEtb5Mpdeq+7BgUjMLuag+3ISyqbSc1kk6Hc7AANaWkPrDio
 90gUfs20Gafye2y5klH+jKP4mnF7unktKQps2oabr6rYVY3Mjz
 MpL4k2Q2eJemavhhI5BWbz2DQlbh4zNoafblas5HZt/ICM1sdr
 K5sZa9A+44/exlDWS30jhoouWmawPjb/hpzsmlNZXDyx6NSTaU
 c3cLp7Jrr1fxtUWuDysKfF36s2c9wPLb0Dvudb9m3/iNiEO2Rv
 ArcDAvpd1yyQ7aZ+TTbE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 May 2014 17:47:32 Santosh Shilimkar wrote:

> +       dev->coherent_dma_mask = DMA_BIT_MASK(32);
> +       if (!dev->dma_mask)
> +               dev->dma_mask = &dev->coherent_dma_mask;
> +
> +       /*
> +        * if dma-ranges property doesn't exist - just return else
> +        * setup the dma offset
> +        */
> +       ret = of_dma_get_range(dev->of_node, &dma_addr, &paddr, &size);
> +       if (ret < 0) {
> +               dev_dbg(dev, "no dma range information to setup\n");
> +               return;
> +       }
> +
> +       /* DMA ranges found. Calculate and set dma_pfn_offset */
> +       dev->dma_pfn_offset = PFN_DOWN(paddr - dma_addr);
> +       dev_dbg(dev, "dma_pfn_offset(%#08lx)\n", dev->dma_pfn_offset);
> +}

I think there should at least be a comment about why we are computing
the correct DMA mask here and then ignore that and just use DMA_BIT_MASK(32)
instead. I understand that Russell and Rob prefer it that way and I'm not
going to argue, but I find it counterintuitive and I think it deserves
an explanation in the source code for anybody who is trying to figure
out how things fit together.

	Arnd
