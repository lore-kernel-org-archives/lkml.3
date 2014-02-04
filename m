Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404AbaBDJFl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 04:05:41 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:56775 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754045AbaBDJFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 04:05:21 -0500
Message-ID: <52F0AD44.6090203@atmel.com>
Date: Tue, 4 Feb 2014 10:05:08 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Boris BREZILLON <b.brezillon@overkiz.com>,
        Mike Turquette <mturquette@linaro.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] clk: at91: propagate rate change on system clks
References: <1391426731-9392-1-git-send-email-b.brezillon@overkiz.com> <1391426731-9392-4-git-send-email-b.brezillon@overkiz.com>
In-Reply-To: <1391426731-9392-4-git-send-email-b.brezillon@overkiz.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/02/2014 12:25, Boris BREZILLON :
> System clks are just gates, and thus do not provide any rate operations.
> Authorize clk rate change to be propagated to system clk parents.
> 
> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

> ---
>  drivers/clk/at91/clk-system.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/clk/at91/clk-system.c b/drivers/clk/at91/clk-system.c
> index 8f7c043..a98557b 100644
> --- a/drivers/clk/at91/clk-system.c
> +++ b/drivers/clk/at91/clk-system.c
> @@ -84,7 +84,8 @@ at91_clk_register_system(struct at91_pmc *pmc, const char *name,
>  	 * (see drivers/memory) which would request and enable the ddrck clock.
>  	 * When this is done we will be able to remove CLK_IGNORE_UNUSED flag.
>  	 */
> -	init.flags = CLK_IGNORE_UNUSED;
> +	init.flags = CLK_SET_RATE_GATE | CLK_SET_RATE_PARENT |
> +		     CLK_IGNORE_UNUSED;
>  
>  	sys->id = id;
>  	sys->hw.init = &init;
> 


-- 
Nicolas Ferre
