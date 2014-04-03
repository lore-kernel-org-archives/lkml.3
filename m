Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162544AbaDCHhT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 03:37:19 -0400
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:16999
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1162390AbaDCHhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 03:37:16 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1f42h2148h1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6h208chzzz2dh87h2a8h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h16a6h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h2438h2461h2487h24ach24d7h2516h2545h255eh25cch25f6h2605h262fh268bh26d3h1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Thu, 3 Apr 2014 15:37:03 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Marek Vasut <marex@denx.de>
CC: Yao Yuan <yao.yuan@freescale.com>, "wsa@the-dreams.de" <wsa@the-dreams.de>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>
Subject: Re: [PATCH v3 1/2] i2c: add DMA support for freescale i2c driver
Message-ID: <20140403073701.GL2801@dragon>
References: <1394675277-24913-1-git-send-email-yao.yuan@freescale.com>
 <201403260726.36812.marex@denx.de>
 <8984936f9e914442995d79039543cb58@BL2PR03MB338.namprd03.prod.outlook.com>
 <201403260826.28114.marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <201403260826.28114.marex@denx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 26, 2014 at 08:26:27AM +0100, Marek Vasut wrote:
> > > I think we disconnected here, sorry. Why can you not use (i2c_imx->dma !=
> > > NULL) instead of (i2c_imx->use_dma == true) please ?
> > 
> > But there are two judge conditions. But only the "i2c_imx->dma", but also
> > whether "i2c_imx_dma_request" success.
> > 
> > "i2c_imx->use_dma == true" be equivalent to "i2c_imx->dma != NULL &&
> > !i2c_imx_dma_request()"
> 
> +       /* Init DMA config if support*/
> +       i2c_imx->dma = devm_kzalloc(&pdev->dev, sizeof(struct imx_i2c_dma),
> +                                       GFP_KERNEL);
> +       if (!i2c_imx->dma) {
> +               dev_info(&pdev->dev,
> +                               "can't allocate dma struct faild use dma.\n");
> +               i2c_imx->use_dma = false;
> +       } else if (i2c_imx_dma_request(i2c_imx, (dma_addr_t)phy_addr)) {
> +               dev_info(&pdev->dev,
> +                               "can't request dma chan, faild use dma.\n");
> +               i2c_imx->use_dma = false;
> +       } else {
> +               i2c_imx->use_dma = true;
> +       }
> 
> OK, looking at this one more time, why don't you wrap the allocation of i2c_imx-
> >dma into i2c_imx_dma_request() ? Even better, you can allocate *dma as a local 
> variable in i2c_imx_dma_request() and then assign it into i2c_imx->dma only at 
> the end of the i2c_imx_dma_request() function , at the point where you are sure 
> nothing failed. Then you can check i2c_imx->dma != NULL throughout the code to 
> check if the DMA is available, no ?
> 
> Shawn, Wolfram, am I talking nonsense or am I just not connecting ?

I'm with you, Marek.

Shawn

