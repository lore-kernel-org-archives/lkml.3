Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933074Ab3AOXxd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 18:53:33 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:44237 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932777Ab3AOXxa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 18:53:30 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <20130109085636.GB31678@gmail.com>
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Ulf Hansson <ulf.hansson@linaro.org>
References: <1355937587-31730-1-git-send-email-lee.jones@linaro.org>
 <1355937587-31730-3-git-send-email-lee.jones@linaro.org>
 <20130109085636.GB31678@gmail.com>
Message-ID: <20130115235323.23734.52234@quantum>
User-Agent: alot/0.3.3+
Subject: Re: [PATCH 3/4] clk: ux500: Provide an alias for the SMSC911x Ethernet chip
Date: Tue, 15 Jan 2013 15:53:23 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Lee Jones (2013-01-09 00:56:36)
> On Wed, 19 Dec 2012, Lee Jones wrote:
> 
> > In the case of some of the ux500 platforms, an Ethernet chip is
> > placed on an extended bus which is traditionally used as a NAND
> > flash chip placeholder. The p3_pclk0 clock is used to control it,
> > so we are required to provide and easy way to access it from the
> > SMSC911x driver. We do this using an alias provided by this patch.
> > 
> > Cc: Mike Turquette <mturquette@linaro.org>
> > Cc: Ulf Hansson <ulf.hansson@linaro.org>
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > ---
> >  drivers/clk/ux500/u8500_clk.c |    1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/drivers/clk/ux500/u8500_clk.c b/drivers/clk/ux500/u8500_clk.c
> > index a601802..9d9add1 100644
> > --- a/drivers/clk/ux500/u8500_clk.c
> > +++ b/drivers/clk/ux500/u8500_clk.c
> > @@ -325,6 +325,7 @@ void u8500_clk_init(void)
> >       clk = clk_reg_prcc_pclk("p3_pclk0", "per3clk", U8500_CLKRST3_BASE,
> >                               BIT(0), 0);
> >       clk_register_clkdev(clk, "fsmc", NULL);
> > +     clk_register_clkdev(clk, NULL, "smsc911x");
> >  
> >       clk = clk_reg_prcc_pclk("p3_pclk1", "per3clk", U8500_CLKRST3_BASE,
> >                               BIT(1), 0);
> > -- 
> > 1.7.9.5
> > 
> 
> I still need a maintiner Ack for this before I can push it.
> 
> Mike?
> 

Acked-by: Mike Turquette <mturquette@linaro.org>

> -- 
> Lee Jones
> Linaro ST-Ericsson Landing Team Lead
> Linaro.org │ Open source software for ARM SoCs
> Follow Linaro: Facebook | Twitter | Blog
