Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751958AbaB1KQA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 05:16:00 -0500
Received: from mail-out.m-online.net ([212.18.0.10]:50782 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301AbaB1KP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 05:15:56 -0500
X-Auth-Info: gjoMH5bYZZJGLrfq+SYxu5z/64YCrzxjGYL86S04kuw=
From: Marek Vasut <marex@denx.de>
To: Shawn Guo <shawn.guo@linaro.org>
Subject: Re: [PATCH 1/3] i2c: add DMA support for freescale i2c driver
Date: Fri, 28 Feb 2014 09:57:28 +0100
User-Agent: KMail/1.13.7 (Linux/3.13-trunk-amd64; KDE/4.11.3; x86_64; ; )
Cc: mark.rutland@arm.com, wsa@the-dreams.de, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Yuan Yao <yao.yuan@freescale.com>
References: <1393481115-22136-1-git-send-email-yao.yuan@freescale.com> <20140228021300.GJ13537@S2101-09.ap.freescale.net> <20140228022348.GB28660@S2101-09.ap.freescale.net>
In-Reply-To: <20140228022348.GB28660@S2101-09.ap.freescale.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201402280957.28985.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, February 28, 2014 at 03:23:52 AM, Shawn Guo wrote:
> On Fri, Feb 28, 2014 at 10:13:02AM +0800, Shawn Guo wrote:
> > On Thu, Feb 27, 2014 at 09:39:35PM +0100, Marek Vasut wrote:
> > > > @@ -193,6 +216,7 @@ static const struct imx_i2c_hwdata
> > > > imx1_i2c_hwdata  = {
> > > > 
> > > >  	.ndivs			= ARRAY_SIZE(imx_i2c_clk_div),
> > > >  	.i2sr_clr_opcode	= I2SR_CLR_OPCODE_W0C,
> > > >  	.i2cr_ien_opcode	= I2CR_IEN_OPCODE_1,
> > > > 
> > > > +	.has_dma_support	= false,
> > > > 
> > > >  };
> > > > 
> > > > @@ -203,6 +227,7 @@ static const struct imx_i2c_hwdata
> > > > imx21_i2c_hwdata  = { .ndivs			= 
ARRAY_SIZE(imx_i2c_clk_div),
> > > > 
> > > >  	.i2sr_clr_opcode	= I2SR_CLR_OPCODE_W0C,
> > > >  	.i2cr_ien_opcode	= I2CR_IEN_OPCODE_1,
> > > > 
> > > > +	.has_dma_support	= false,
> > > > 
> > > >  };
> > > > 
> > > > @@ -213,6 +238,7 @@ static struct imx_i2c_hwdata vf610_i2c_hwdata = {
> > > > 
> > > >  	.ndivs			= ARRAY_SIZE(vf610_i2c_clk_div),
> > > >  	.i2sr_clr_opcode	= I2SR_CLR_OPCODE_W1C,
> > > >  	.i2cr_ien_opcode	= I2CR_IEN_OPCODE_0,
> > > > 
> > > > +	.has_dma_support	= true,
> > > 
> > > So why exactly don't we have a DT prop for determining whether the
> > > controller has DMA support ?
> > 
> > Using DMA or PIO is a decision that should be made by driver on its own,
> > not device tree.
> 
> Sorry.  I misunderstood it.  Yes, we can look at the DT property 'dmas'
> to know if the controller has DMA capability.

You're right. Whether or not does the hardware support DMA transfers is a 
property of the hardware, that's why it should be in DT.

Best regards,
Marek Vasut
