Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758963Ab3APJ7T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 04:59:19 -0500
Received: from mail-bk0-f42.google.com ([209.85.214.42]:54771 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756483Ab3APJ7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 04:59:15 -0500
Date: Wed, 16 Jan 2013 09:59:09 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH 2/4] clk: ux500: Ensure the FMSC clock is obtainable
Message-ID: <20130116095909.GH9379@gmail.com>
References: <1355937587-31730-1-git-send-email-lee.jones@linaro.org>
 <1355937587-31730-2-git-send-email-lee.jones@linaro.org>
 <20130115235252.23734.21408@quantum>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130115235252.23734.21408@quantum>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jan 2013, Mike Turquette wrote:

> Quoting Lee Jones (2012-12-19 09:19:45)
> > The FMSC clock is traditionally used for NAND flash devices when
> > used on the ux500 series platforms. This patch makes it searchable
> > during a clock-name search.
> > 
> > Cc: Mike Turquette <mturquette@linaro.org>
> > Cc: Ulf Hansson <ulf.hansson@linaro.org>
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> 
> Acked-by: Mike Turquette <mturquette@linaro.org>
> 
> Who do you want this series to go through?

To be honest I don't really mind. I can take them through the
arm-soc tree with "[1/4] ARM ...", but I still need an Ack from
the SMSC911x maintainer for "[4/4] ...", before I can do that.

Still waiting for that. :(

> > ---
> >  drivers/clk/ux500/u8500_clk.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/clk/ux500/u8500_clk.c b/drivers/clk/ux500/u8500_clk.c
> > index 6b889a0..a601802 100644
> > --- a/drivers/clk/ux500/u8500_clk.c
> > +++ b/drivers/clk/ux500/u8500_clk.c
> > @@ -324,7 +324,7 @@ void u8500_clk_init(void)
> >  
> >         clk = clk_reg_prcc_pclk("p3_pclk0", "per3clk", U8500_CLKRST3_BASE,
> >                                 BIT(0), 0);
> > -       clk_register_clkdev(clk, NULL, "fsmc");
> > +       clk_register_clkdev(clk, "fsmc", NULL);
> >  
> >         clk = clk_reg_prcc_pclk("p3_pclk1", "per3clk", U8500_CLKRST3_BASE,
> >                                 BIT(1), 0);
> > -- 
> > 1.7.9.5

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
