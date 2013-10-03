Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754437Ab3JCNuv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 09:50:51 -0400
Received: from top.free-electrons.com ([176.31.233.9]:41842 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754157Ab3JCNuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 09:50:50 -0400
Date: Thu, 3 Oct 2013 10:50:58 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ARM: kirkwood: remove ethernet clock gate workaround
Message-ID: <20131003135057.GB2388@localhost>
References: <1380804294-13726-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1380804294-13726-2-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1380804294-13726-2-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 03, 2013 at 02:44:54PM +0200, Sebastian Hesselbarth wrote:
> With a proper fix for Kirkwood ethernet IP MAC address clock gating
> issue, we can now remove the clock gating workaround that always
> enabled ethernet clocks.
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> ---
> Cc: Jason Cooper <jason@lakedaemon.net>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
> Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  arch/arm/mach-kirkwood/board-dt.c |   14 --------------
>  1 file changed, 14 deletions(-)
> 
> diff --git a/arch/arm/mach-kirkwood/board-dt.c b/arch/arm/mach-kirkwood/board-dt.c
> index a2974ad..a3bf0c7 100644
> --- a/arch/arm/mach-kirkwood/board-dt.c
> +++ b/arch/arm/mach-kirkwood/board-dt.c
> @@ -41,7 +41,6 @@ static void __init kirkwood_legacy_clk_init(void)
>  	struct device_node *np = of_find_compatible_node(
>  		NULL, NULL, "marvell,kirkwood-gating-clock");
>  	struct of_phandle_args clkspec;
> -	struct clk *clk;
>  
>  	clkspec.np = np;
>  	clkspec.args_count = 1;
> @@ -53,19 +52,6 @@ static void __init kirkwood_legacy_clk_init(void)
>  	clkspec.args[0] = CGC_BIT_PEX1;
>  	orion_clkdev_add("1", "pcie",
>  			 of_clk_get_from_provider(&clkspec));
> -
> -	/*
> -	 * The ethernet interfaces forget the MAC address assigned by
> -	 * u-boot if the clocks are turned off. Until proper DT support
> -	 * is available we always enable them for now.
> -	 */
> -	clkspec.args[0] = CGC_BIT_GE0;
> -	clk = of_clk_get_from_provider(&clkspec);
> -	clk_prepare_enable(clk);
> -
> -	clkspec.args[0] = CGC_BIT_GE1;
> -	clk = of_clk_get_from_provider(&clkspec);
> -	clk_prepare_enable(clk);
>  }
>  
>  #define MV643XX_ETH_MAC_ADDR_LOW	0x0414
> -- 
> 1.7.10.4
> 

Good!

And if this works, this patch effectively removes the
kirkwood_legacy_clk_init() call from this file.

I'll certainly give this a test later (not soon though).

Nice job!
-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
