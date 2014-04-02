Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758464AbaDBLFG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 07:05:06 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:19183 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758250AbaDBLFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 07:05:04 -0400
Date: Wed, 2 Apr 2014 14:04:29 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch] clk: vt8500: several forever loops
Message-ID: <20140402110429.GJ18506@mwanda>
References: <20130826154908.GD12428@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130826154908.GD12428@elgon.mountain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is still needed in linux-next.  It was Acked by Tony Prisk in
a private email.

Acked-by: Tony Prisk <linux@prisktech.co.nz>

regards,
dan carpenter

On Mon, Aug 26, 2013 at 07:02:33PM +0300, Dan Carpenter wrote:
> This does a bunch of looping like this:
> 
> 	for (div2 = 7; div2 >= 0; div2--)
> 
> But unsigned values are always greater than or equal to zero so it just
> loops and loops.  Really "mul", "div1" and "div2" should all be declared
> as int for cleanliness sake.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> Static checker stuff.
> 
> diff --git a/drivers/clk/clk-vt8500.c b/drivers/clk/clk-vt8500.c
> index 82306f5..8d5b57c 100644
> --- a/drivers/clk/clk-vt8500.c
> +++ b/drivers/clk/clk-vt8500.c
> @@ -363,7 +363,7 @@ static void vt8500_find_pll_bits(unsigned long rate, unsigned long parent_rate,
>  static void wm8650_find_pll_bits(unsigned long rate, unsigned long parent_rate,
>  				u32 *multiplier, u32 *divisor1, u32 *divisor2)
>  {
> -	u32 mul, div1, div2;
> +	int mul, div1, div2;
>  	u32 best_mul, best_div1, best_div2;
>  	unsigned long tclk, rate_err, best_err;
>  
> @@ -431,7 +431,7 @@ static u32 wm8750_get_filter(u32 parent_rate, u32 divisor1)
>  static void wm8750_find_pll_bits(unsigned long rate, unsigned long parent_rate,
>  				u32 *filter, u32 *multiplier, u32 *divisor1, u32 *divisor2)
>  {
> -	u32 mul, div1, div2;
> +	int mul, div1, div2;
>  	u32 best_mul, best_div1, best_div2;
>  	unsigned long tclk, rate_err, best_err;
>  
> @@ -475,7 +475,7 @@ static void wm8750_find_pll_bits(unsigned long rate, unsigned long parent_rate,
>  static void wm8850_find_pll_bits(unsigned long rate, unsigned long parent_rate,
>  				u32 *multiplier, u32 *divisor1, u32 *divisor2)
>  {
> -	u32 mul, div1, div2;
> +	int mul, div1, div2;
>  	u32 best_mul, best_div1, best_div2;
>  	unsigned long tclk, rate_err, best_err;
>  
