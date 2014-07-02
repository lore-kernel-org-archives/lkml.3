Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751361AbaGBISR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 04:18:17 -0400
Received: from top.free-electrons.com ([176.31.233.9]:41308 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750796AbaGBISP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 04:18:15 -0400
Date: Wed, 2 Jul 2014 10:18:11 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Mike Turquette <mturquette@linaro.org>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/33] clk: at91: main: warn when the main crystal
 frequency is not set
Message-ID: <20140702101811.2f2a507e@bbrezillon>
In-Reply-To: <1404223962-30471-4-git-send-email-alexandre.belloni@free-electrons.com>
References: <1404223962-30471-1-git-send-email-alexandre.belloni@free-electrons.com>
	<1404223962-30471-4-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  1 Jul 2014 16:12:12 +0200
Alexandre Belloni <alexandre.belloni@free-electrons.com> wrote:

> When the main crystal frequency is not set, the main clock is
> approximated using the MAINF value in the CKGR_MCFR register. Warn
> the user in that case.
> 
> Signed-off-by: Alexandre Belloni
> <alexandre.belloni@free-electrons.com> ---

Acked-by: Boris BREZILLON <boris.brezillon@overkiz.com>

Mike, do you want me to take this patch and send you a pull request, or
should I let you take this one directly ?

Best Regards,

Boris

>  drivers/clk/at91/clk-main.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/clk/at91/clk-main.c b/drivers/clk/at91/clk-main.c
> index 733306131b99..59fa3cc96c9e 100644
> --- a/drivers/clk/at91/clk-main.c
> +++ b/drivers/clk/at91/clk-main.c
> @@ -388,6 +388,7 @@ static unsigned long clk_main_recalc_rate(struct
> at91_pmc *pmc, if (parent_rate)
>  		return parent_rate;
>  
> +	pr_warn("Main crystal frequency not set, using approximate
> value\n"); tmp = pmc_read(pmc, AT91_CKGR_MCFR);
>  	if (!(tmp & AT91_PMC_MAINRDY))
>  		return 0;



-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
