Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386AbaICHm4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 03:42:56 -0400
Received: from top.free-electrons.com ([176.31.233.9]:43209 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751042AbaICHmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 03:42:54 -0400
Date: Wed, 3 Sep 2014 09:42:50 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: "Nicolas Ferre" <nicolas.ferre@atmel.com>,
        "Jean-Christophe Plagniol-Villard" <plagnioj@jcrosoft.com>,
        "Alexandre Belloni" <alexandre.belloni@free-electrons.com>,
        "Andrew Victor" <linux@maxim.org.za>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clk: at91: fix num_parents test in at91sam9260 slow clk
 implementation
Message-ID: <20140903094250.0a5b5154@bbrezillon>
In-Reply-To: <20140902214506.5251.1412@quantum>
References: <1409671671-13544-1-git-send-email-boris.brezillon@free-electrons.com>
	<20140902214506.5251.1412@quantum>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 02 Sep 2014 14:45:06 -0700
Mike Turquette <mturquette@linaro.org> wrote:

> Quoting Boris BREZILLON (2014-09-02 08:27:51)
> > The slow clk block provided by at91sam9260 and derived SoCs should always
> > have 2 parents.
> > 
> > Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
> > ---
> > 
> > Hello Mike,
> > 
> > Could you take this fix for the next 3.17 rc ?
> > Without this fix you won't be able to use programmable clks (the slow
> > clk is one of the parents of prog clks), and these prog clks are used,
> > among other things, to provide clks to external audio chips.
> > 
> > No need to backport this fix to previous stable releases, as CCF support
> > for at91sam9260 (and derived) SoCs only appeared in 3.17.
> 
> Pulled into clk-fixes.

Thanks!

> 
> Regards,
> Mike
> 
> > 
> > Best Regards,
> > 
> > Boris
> > 
> >  drivers/clk/at91/clk-slow.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/clk/at91/clk-slow.c b/drivers/clk/at91/clk-slow.c
> > index 0300c46..32f7c1b 100644
> > --- a/drivers/clk/at91/clk-slow.c
> > +++ b/drivers/clk/at91/clk-slow.c
> > @@ -447,7 +447,7 @@ void __init of_at91sam9260_clk_slow_setup(struct device_node *np,
> >         int i;
> >  
> >         num_parents = of_count_phandle_with_args(np, "clocks", "#clock-cells");
> > -       if (num_parents <= 0 || num_parents > 1)
> > +       if (num_parents != 2)
> >                 return;
> >  
> >         for (i = 0; i < num_parents; ++i) {
> > -- 
> > 1.9.1
> > 



-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
