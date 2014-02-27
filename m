Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145AbaB0Amf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 19:42:35 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:39183 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929AbaB0Ame convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 19:42:34 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Jean-Jacques Hiblot <jjhiblot@traphandler.com>, nicolas.ferre@atmel.com
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1391589458-28018-3-git-send-email-jjhiblot@traphandler.com>
Cc: b.brezillon@overkiz.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, jason@lakedaemon.net
References: <1391589458-28018-1-git-send-email-jjhiblot@traphandler.com>
 <1391589458-28018-3-git-send-email-jjhiblot@traphandler.com>
Message-ID: <20140227004229.12081.25317@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH v2 2/4] clk: at91: propagate rate change on system clks
Date: Wed, 26 Feb 2014 16:42:29 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Jean-Jacques Hiblot (2014-02-05 00:37:36)
> From: Boris BREZILLON <b.brezillon@overkiz.com>
> 
> System clks are just gates, and thus do not provide any rate operations.
> Authorize clk rate change to be propagated to system clk parents.
> 
> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
> ---
>  drivers/clk/at91/clk-system.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/clk/at91/clk-system.c b/drivers/clk/at91/clk-system.c
> index 8f7c043..a98557b 100644
> --- a/drivers/clk/at91/clk-system.c
> +++ b/drivers/clk/at91/clk-system.c
> @@ -84,7 +84,8 @@ at91_clk_register_system(struct at91_pmc *pmc, const char *name,
>          * (see drivers/memory) which would request and enable the ddrck clock.
>          * When this is done we will be able to remove CLK_IGNORE_UNUSED flag.
>          */
> -       init.flags = CLK_IGNORE_UNUSED;
> +       init.flags = CLK_SET_RATE_GATE | CLK_SET_RATE_PARENT |

Just wanted to do a quick sanity check here. Do you really need
CLK_SET_RATE_GATE? Otherwise these patches look fine.

Regards,
Mike

> +                    CLK_IGNORE_UNUSED;
>  
>         sys->id = id;
>         sys->hw.init = &init;
> -- 
> 1.8.5.2
> 
