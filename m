Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756272AbaHYQrh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 12:47:37 -0400
Received: from vps0.lunn.ch ([178.209.37.122]:38567 "EHLO vps0.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753635AbaHYQrX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 12:47:23 -0400
Date: Mon, 25 Aug 2014 18:41:24 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Chen-Yu Tsai <wens@csie.org>
Cc: Wolfram Sang <wsa@the-dreams.de>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, linux-i2c@vger.kernel.org,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] i2c: mv64xxx: continue probe when clock-frequency is
 missing
Message-ID: <20140825164124.GA22771@lunn.ch>
References: <1408981819-3477-1-git-send-email-wens@csie.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408981819-3477-1-git-send-email-wens@csie.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2014 at 11:50:19PM +0800, Chen-Yu Tsai wrote:
> The "clock-frequency" DT property is listed as optional, However,
> the current code stores the return value of of_property_read_u32 in
> the return code of mv64xxx_of_config, but then forgets to clear it
> after setting the default value of "clock-frequency". It is then
> passed out to the main probe function, resulting in a probe failure
> when "clock-frequency" is missing.
> 
> This patch checks and then throws away the result of
> of_property_read_u32, instead of storing it and having to clear it
> afterwards.
> 
> This issue was discovered after the property was removed from all
> sunxi DTs.
> 
> Signed-off-by: Chen-Yu Tsai <wens@csie.org>
> Cc: stable@vger.kernel.org

It would be good to add

Fixes: 4c730a06c19bb ("i2c: mv64xxx: Set bus frequency to 100kHz if clock-frequency is not provided")

Acked-by: Andrew Lunn <andrew@lunn.ch>

	  Andrew


> ---
>  drivers/i2c/busses/i2c-mv64xxx.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/i2c/busses/i2c-mv64xxx.c b/drivers/i2c/busses/i2c-mv64xxx.c
> index 6dc5ded..2f64273 100644
> --- a/drivers/i2c/busses/i2c-mv64xxx.c
> +++ b/drivers/i2c/busses/i2c-mv64xxx.c
> @@ -746,8 +746,7 @@ mv64xxx_of_config(struct mv64xxx_i2c_data *drv_data,
>  	}
>  	tclk = clk_get_rate(drv_data->clk);
>  
> -	rc = of_property_read_u32(np, "clock-frequency", &bus_freq);
> -	if (rc)
> +	if (of_property_read_u32(np, "clock-frequency", &bus_freq))
>  		bus_freq = 100000; /* 100kHz by default */
>  
>  	if (!mv64xxx_find_baud_factors(bus_freq, tclk,
> -- 
> 2.1.0
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
