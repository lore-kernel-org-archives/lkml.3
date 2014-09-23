Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755438AbaIWS15 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 14:27:57 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:54104 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754282AbaIWS14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 14:27:56 -0400
Date: Tue, 23 Sep 2014 11:27:51 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Jisheng Zhang <jszhang@marvell.com>
Cc: wim@iguana.be, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 1/2] watchdog: dw_wdt: initialise TOP_INIT in
 dw_wdt_set_top()
Message-ID: <20140923182751.GA24930@roeck-us.net>
References: <1411458132-5410-1-git-send-email-jszhang@marvell.com>
 <1411458132-5410-2-git-send-email-jszhang@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411458132-5410-2-git-send-email-jszhang@marvell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 03:42:11PM +0800, Jisheng Zhang wrote:
> The TOP_INIT, ie bit 4-7 of the WDOG_TIMEOUT_RANGE_REG_OFFSET register
> may be zero, so the timeout period may be very short after initialization
> is done, thus the system may be reset soon after enabling. We fix this
> problem by also initialising the TOP_INIT when setting TOP in function
> dw_wdt_set_top().
> 
> Signed-off-by: Jisheng Zhang <jszhang@marvell.com>

That should do it.

Reviewed-by: Guenter Roeck <linux@roeck-us.net>

> ---
>  drivers/watchdog/dw_wdt.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/watchdog/dw_wdt.c b/drivers/watchdog/dw_wdt.c
> index 9f21029..449c885 100644
> --- a/drivers/watchdog/dw_wdt.c
> +++ b/drivers/watchdog/dw_wdt.c
> @@ -40,6 +40,7 @@
>  #define WDOG_CONTROL_REG_OFFSET		    0x00
>  #define WDOG_CONTROL_REG_WDT_EN_MASK	    0x01
>  #define WDOG_TIMEOUT_RANGE_REG_OFFSET	    0x04
> +#define WDOG_TIMEOUT_RANGE_TOPINIT_SHIFT    4
>  #define WDOG_CURRENT_COUNT_REG_OFFSET	    0x08
>  #define WDOG_COUNTER_RESTART_REG_OFFSET     0x0c
>  #define WDOG_COUNTER_RESTART_KICK_VALUE	    0x76
> @@ -106,7 +107,8 @@ static int dw_wdt_set_top(unsigned top_s)
>  		}
>  
>  	/* Set the new value in the watchdog. */
> -	writel(top_val, dw_wdt.regs + WDOG_TIMEOUT_RANGE_REG_OFFSET);
> +	writel(top_val | top_val << WDOG_TIMEOUT_RANGE_TOPINIT_SHIFT,
> +		dw_wdt.regs + WDOG_TIMEOUT_RANGE_REG_OFFSET);
>  
>  	dw_wdt_set_next_heartbeat();
>  
> -- 
> 2.1.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-watchdog" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
