Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751408AbaKXVKr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 16:10:47 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:17067 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751195AbaKXVKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 16:10:46 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 104.193.169.186
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19Fy9C4XVUTv0XMc0BcVxCf
Date: Mon, 24 Nov 2014 13:08:10 -0800
From: Tony Lindgren <tony@atomide.com>
To: Alexander Kochetkov <al.kochet@gmail.com>
Cc: linux-omap@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, Felipe Balbi <balbi@ti.com>,
        Wolfram Sang <wsa@the-dreams.de>, Kevin Hilman <khilman@kernel.org>
Subject: Re: [PATCH] omap: i2c: don't check bus state IP rev3.3 and earlier
Message-ID: <20141124210809.GG2817@atomide.com>
References: <1416685634-5864-3-git-send-email-al.kochet@gmail.com>
 <1416861189-17109-1-git-send-email-al.kochet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416861189-17109-1-git-send-email-al.kochet@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Alexander Kochetkov <al.kochet@gmail.com> [141124 12:35]:
> Commit 903c3859f77f9b0aace551da03267ef7a211dbc4 ("i2c: omap: implement
> workaround for handling invalid BB-bit values") introduce the error result
> in boot test fault on OMAP3530 boards
> 
> The patch fix the error (disable i2c bus test for OMAP3530).

Maybe add Reported-by: credit for Kevin Hilman here?
Other than that, this fixes the problem for me:

Tested-by: Tony Lindgren <tony@atomide.com>
 
> Signed-off-by: Alexander Kochetkov <al.kochet@gmail.com>
> Fixes: 903c3859f77f9b0aace551da03267ef7a211dbc4
> ---
>  drivers/i2c/busses/i2c-omap.c |    8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
> index 5d92d0e..4563200 100644
> --- a/drivers/i2c/busses/i2c-omap.c
> +++ b/drivers/i2c/busses/i2c-omap.c
> @@ -344,8 +344,10 @@ static int omap_i2c_reset(struct omap_i2c_dev *dev)
>  		/* SYSC register is cleared by the reset; rewrite it */
>  		omap_i2c_write_reg(dev, OMAP_I2C_SYSC_REG, sysc);
>  
> -		/* Schedule I2C-bus monitoring on the next transfer */
> -		dev->bb_valid = 0;
> +		if (dev->rev > OMAP_I2C_REV_ON_3430_3530) {
> +			/* Schedule I2C-bus monitoring on the next transfer */
> +			dev->bb_valid = 0;
> +		}
>  	}
>  
>  	return 0;
> @@ -460,7 +462,7 @@ static int omap_i2c_init(struct omap_i2c_dev *dev)
>  	dev->scllstate = scll;
>  	dev->sclhstate = sclh;
>  
> -	if (dev->rev < OMAP_I2C_OMAP1_REV_2) {
> +	if (dev->rev <= OMAP_I2C_REV_ON_3430_3530) {
>  		/* Not implemented */
>  		dev->bb_valid = 1;
>  	}
> -- 
> 1.7.9.5
> 
