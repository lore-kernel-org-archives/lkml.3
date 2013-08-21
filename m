Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751978Ab3HUKKu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 06:10:50 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:47306 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484Ab3HUKKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 06:10:48 -0400
Date: Wed, 21 Aug 2013 11:10:43 +0100
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
Subject: Re: [PATCH 19/33] clk: ux500: Add Device Tree support for the PRCMU
 clock
Message-ID: <20130821101043.GI29850@lee--X1>
References: <1370521041-32318-1-git-send-email-lee.jones@linaro.org>
 <1370521041-32318-20-git-send-email-lee.jones@linaro.org>
 <CACRpkdar9oOWQ9xuQnKvvAOw-eQS1-FkDSDD8BwQT3WDE8YzBA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdar9oOWQ9xuQnKvvAOw-eQS1-FkDSDD8BwQT3WDE8YzBA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Aug 2013, Linus Walleij wrote:

> On Thu, Jun 6, 2013 at 2:17 PM, Lee Jones <lee.jones@linaro.org> wrote:
> 
> > This patch enables clocks to be specified from Device Tree via phandles
> > to the "prcmu-clock" node.
> (..)
> > @@ -52,14 +54,17 @@ void u8500_clk_init(u32 clkrst1_base, u32 clkrst2_base, u32 clkrst3_base,
> >         clk = clk_reg_prcmu_gate("soc0_pll", NULL, PRCMU_PLLSOC0,
> >                                 CLK_IS_ROOT|CLK_IGNORE_UNUSED);
> >         clk_register_clkdev(clk, "soc0_pll", NULL);
> > +       prcmu_clk[PRCMU_PLLSOC0] = clk;
> 
> Same comment on all these.
> 
> No clk_register_clkdev() on the DT boot path please.

I'll fix this during my ATAG removal patch-set.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
