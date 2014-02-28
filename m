Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752287AbaB1COT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 21:14:19 -0500
Received: from [216.32.180.12] ([216.32.180.12]:55154 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751680AbaB1COQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 21:14:16 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dIe0eah1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzzz2dh87h2a8h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h2438h2461h2487h24d7h2516h2545h255eh25cch1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Fri, 28 Feb 2014 10:13:02 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Marek Vasut <marex@denx.de>
CC: <linux-arm-kernel@lists.infradead.org>, Yuan Yao <yao.yuan@freescale.com>,
        <wsa@the-dreams.de>, <mark.rutland@arm.com>,
        <linux-kernel@vger.kernel.org>, <linux-i2c@vger.kernel.org>
Subject: Re: [PATCH 1/3] i2c: add DMA support for freescale i2c driver
Message-ID: <20140228021300.GJ13537@S2101-09.ap.freescale.net>
References: <1393481115-22136-1-git-send-email-yao.yuan@freescale.com>
 <1393481115-22136-2-git-send-email-yao.yuan@freescale.com>
 <201402272139.36076.marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <201402272139.36076.marex@denx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 09:39:35PM +0100, Marek Vasut wrote:
> > @@ -193,6 +216,7 @@ static const struct imx_i2c_hwdata imx1_i2c_hwdata  = {
> >  	.ndivs			= ARRAY_SIZE(imx_i2c_clk_div),
> >  	.i2sr_clr_opcode	= I2SR_CLR_OPCODE_W0C,
> >  	.i2cr_ien_opcode	= I2CR_IEN_OPCODE_1,
> > +	.has_dma_support	= false,
> > 
> >  };
> > 
> > @@ -203,6 +227,7 @@ static const struct imx_i2c_hwdata imx21_i2c_hwdata  =
> > { .ndivs			= ARRAY_SIZE(imx_i2c_clk_div),
> >  	.i2sr_clr_opcode	= I2SR_CLR_OPCODE_W0C,
> >  	.i2cr_ien_opcode	= I2CR_IEN_OPCODE_1,
> > +	.has_dma_support	= false,
> > 
> >  };
> > 
> > @@ -213,6 +238,7 @@ static struct imx_i2c_hwdata vf610_i2c_hwdata = {
> >  	.ndivs			= ARRAY_SIZE(vf610_i2c_clk_div),
> >  	.i2sr_clr_opcode	= I2SR_CLR_OPCODE_W1C,
> >  	.i2cr_ien_opcode	= I2CR_IEN_OPCODE_0,
> > +	.has_dma_support	= true,
> 
> So why exactly don't we have a DT prop for determining whether the controller 
> has DMA support ?

Using DMA or PIO is a decision that should be made by driver on its own,
not device tree.

Shawn

