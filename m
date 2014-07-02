Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756183AbaGBQi5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 12:38:57 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:48634 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491AbaGBQi4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 12:38:56 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Boris BREZILLON <boris.brezillon@free-electrons.com>,
        "Alexandre Belloni" <alexandre.belloni@free-electrons.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <20140702101811.2f2a507e@bbrezillon>
Cc: "Nicolas Ferre" <nicolas.ferre@atmel.com>,
        "Jean-Christophe Plagniol-Villard" <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1404223962-30471-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1404223962-30471-4-git-send-email-alexandre.belloni@free-electrons.com>
 <20140702101811.2f2a507e@bbrezillon>
Message-ID: <20140702163842.7440.73162@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH 03/33] clk: at91: main: warn when the main crystal frequency is
 not set
Date: Wed, 02 Jul 2014 09:38:42 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Boris BREZILLON (2014-07-02 01:18:11)
> On Tue,  1 Jul 2014 16:12:12 +0200
> Alexandre Belloni <alexandre.belloni@free-electrons.com> wrote:
> 
> > When the main crystal frequency is not set, the main clock is
> > approximated using the MAINF value in the CKGR_MCFR register. Warn
> > the user in that case.
> > 
> > Signed-off-by: Alexandre Belloni
> > <alexandre.belloni@free-electrons.com> ---
> 
> Acked-by: Boris BREZILLON <boris.brezillon@overkiz.com>
> 
> Mike, do you want me to take this patch and send you a pull request, or
> should I let you take this one directly ?

I've picked it up since it is just the one patch.

Regards,
Mike

> 
> Best Regards,
> 
> Boris
> 
> >  drivers/clk/at91/clk-main.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/drivers/clk/at91/clk-main.c b/drivers/clk/at91/clk-main.c
> > index 733306131b99..59fa3cc96c9e 100644
> > --- a/drivers/clk/at91/clk-main.c
> > +++ b/drivers/clk/at91/clk-main.c
> > @@ -388,6 +388,7 @@ static unsigned long clk_main_recalc_rate(struct
> > at91_pmc *pmc, if (parent_rate)
> >               return parent_rate;
> >  
> > +     pr_warn("Main crystal frequency not set, using approximate
> > value\n"); tmp = pmc_read(pmc, AT91_CKGR_MCFR);
> >       if (!(tmp & AT91_PMC_MAINRDY))
> >               return 0;
> 
> 
> 
> -- 
> Boris Brezillon, Free Electrons
> Embedded Linux and Kernel engineering
> http://free-electrons.com
