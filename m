Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752205Ab3HUKOz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 06:14:55 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:47006 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626Ab3HUKOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 06:14:54 -0400
Date: Wed, 21 Aug 2013 11:14:48 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>,
        Mike Turquette <mturquette@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH 21/33] clk: ux500: Add Device Tree support for the PRCC
 Kernel clock
Message-ID: <20130821101448.GJ29850@lee--X1>
References: <1370521041-32318-1-git-send-email-lee.jones@linaro.org>
 <1370521041-32318-22-git-send-email-lee.jones@linaro.org>
 <CACRpkdY2KOxX=oA7i9GUnzpwRKiK2rXqTBPVpg+zW082f2TJdg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdY2KOxX=oA7i9GUnzpwRKiK2rXqTBPVpg+zW082f2TJdg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Aug 2013, Linus Walleij wrote:

> On Thu, Jun 6, 2013 at 2:17 PM, Lee Jones <lee.jones@linaro.org> wrote:
> 
> > This patch enables clocks to be specified from Device Tree via phandles
> > to the "prcc-kernel-clock" node.
> >
> > Cc: Mike Turquette <mturquette@linaro.org>
> > Cc: Ulf Hansson <ulf.hansson@linaro.org>
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> (...)
> >  static struct clk *prcmu_clk[PRCMU_NUM_CLKS];
> >  static struct clk *prcc_pclk[(PRCC_NUM_PERIPH_CLUSTERS + 1) * PRCC_PERIPHS_PER_CLUSTER];
> > +static struct clk *prcc_kclk[(PRCC_NUM_PERIPH_CLUSTERS + 1) * PRCC_PERIPHS_PER_CLUSTER];
> >
> >  #define PRCC_SHOW(clk, base, bit) \
> >         clk[(base * PRCC_PERIPHS_PER_CLUSTER) + bit]
> > @@ -540,110 +541,136 @@ void u8500_clk_init(u32 clkrst1_base, u32 clkrst2_base, u32 clkrst3_base,
> >         clk = clk_reg_prcc_kclk("p1_uart0_kclk", "uartclk",
> >                         clkrst1_base, BIT(0), CLK_SET_RATE_GATE);
> >         clk_register_clkdev(clk, NULL, "uart0");
> > +       PRCC_KCLK_STORE(clk, 1, 0);
> >
> >         clk = clk_reg_prcc_kclk("p1_uart1_kclk", "uartclk",
> >                         clkrst1_base, BIT(1), CLK_SET_RATE_GATE);
> >         clk_register_clkdev(clk, NULL, "uart1");
> > +       PRCC_KCLK_STORE(clk, 1, 1);
> 
> (etc)
> 
> On device tree boots, clk_register_clkdev() is obviously pointless,
> as you're later deleting the AUXDATA connecting that device name
> to the clock.
> 
> This should not be called at all on the DT boot path.
> 
> However this looks cluttered as well:
> 
> if (dt_probe)
>   clk_register_clkdev(clk, NULL, "uart0");
> else
>   PRCC_KCLK_STORE(clk, 1, 0);
> 
> Isn't it possible to fork a function u8500_clk_init_dt() to add all the
> clocks in the DT probe path and keep this function
> u8500_clk_init() as it is?

Yes, we probably could do that, but as we're ripping out ATAG booting
support from the ux500 platform, I'll just remove the
clk_register_clkdev()s during the process.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
