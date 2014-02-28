Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751879AbaB1MEH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 07:04:07 -0500
Received: from mail-out.m-online.net ([212.18.0.10]:54470 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021AbaB1MEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 07:04:02 -0500
X-Auth-Info: Qf3AgbCL9cjxmf8sMDZmixM+STYmlLN/8Lu3usKBUfg=
From: Marek Vasut <marex@denx.de>
To: Yao Yuan <yao.yuan@freescale.com>
Subject: Re: [PATCH 1/3] i2c: add DMA support for freescale i2c driver
Date: Fri, 28 Feb 2014 13:03:52 +0100
User-Agent: KMail/1.13.7 (Linux/3.13-trunk-amd64; KDE/4.11.3; x86_64; ; )
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "wsa@the-dreams.de" <wsa@the-dreams.de>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>
References: <1393481115-22136-1-git-send-email-yao.yuan@freescale.com> <201402281004.10238.marex@denx.de> <3d65fc9a0c5444b485c93de4087634e0@BL2PR03MB338.namprd03.prod.outlook.com>
In-Reply-To: <3d65fc9a0c5444b485c93de4087634e0@BL2PR03MB338.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201402281303.52962.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, February 28, 2014 at 12:36:01 PM, Yao Yuan wrote:
> Hi Marek,
> 
> > On Friday, February 28, 2014 at 06:19:18 AM, Yao Yuan wrote:
> > 
> > [...]
> > 
> > > > > @@ -213,6 +238,7 @@ static struct imx_i2c_hwdata vf610_i2c_hwdata
> > > > > = {
> > > > > 
> > > > >  	.ndivs			= ARRAY_SIZE(vf610_i2c_clk_div),
> > > > >  	.i2sr_clr_opcode	= I2SR_CLR_OPCODE_W1C,
> > > > >  	.i2cr_ien_opcode	= I2CR_IEN_OPCODE_0,
> > > > > 
> > > > > +	.has_dma_support	= true,
> > > > 
> > > > So why exactly don't we have a DT prop for determining whether the
> > > > controller has DMA support ?
> > > > 
> > > > What about the other controllers, do they not support DMA for some
> > > > specific reason? Please elaborate on that, thank you !
> > > 
> > > Sorry for my fault. I will modify it.
> > 
> > I would prefer if you could explain why other controllers do have DMA
> > disabled even if the hardware does support the DMA operation.
> 
> Well, Because of the I2C in I.MX hardware don't support the DMA operation.
> But here I also think has_dma_support isn't necessary.

OK, got it now. Thanks!

> > > > Also, can the DMA not do full-duplex operation ? What I see here is
> > > > just
> > > > half- duplex operations , one for RX and the other one for TX .
> > > 
> > > Yes, here have two dma channels, one for RX and the other one for TX.
> > > When we request the channel we should determine it for TX or RX.
> > 
> > Sorry, I don't quite understand this. If you have two DMA channels, can
> > you not use them both to do full-duplex SPI transfer ?
> 
> Sorry, There are also hard for me. I don't understand what is full-duplex
> for dma?

Sorry, nevermind. I was confused by this and some SPI patches review. Like 
Lothar (thanks!) pointed out, using only half-duplex operation is OK.

Best regards,
Marek Vasut
