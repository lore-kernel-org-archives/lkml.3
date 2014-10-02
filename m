Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752521AbaJBINL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 04:13:11 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:26771 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304AbaJBINI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 04:13:08 -0400
Date: Thu, 2 Oct 2014 11:12:50 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Giedrius Statkevicius <giedrius.statkevicius@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, mahati.chamarthy@gmail.com,
        fabio.falzoi84@gmail.com
Subject: Re: [PATCH] staging: rts5208: Clean up coding style in rtsx_chip.c
 to get rid of checkpatch.pl warnings
Message-ID: <20141002081250.GF5865@mwanda>
References: <542C7C53.7060609@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <542C7C53.7060609@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 02, 2014 at 01:12:35AM +0300, Giedrius Statkevicius wrote:
> diff --git a/drivers/staging/rts5208/rtsx_chip.c b/drivers/staging/rts5208/rtsx_chip.c
> index 1411471..d604341 100644
> --- a/drivers/staging/rts5208/rtsx_chip.c
> +++ b/drivers/staging/rts5208/rtsx_chip.c
> @@ -291,7 +291,9 @@ int rtsx_reset_chip(struct rtsx_chip *chip)
>  		if (chip->dynamic_aspm) {
>  			if (CHK_SDIO_EXIST(chip)) {
>  				if (CHECK_PID(chip, 0x5288)) {

These two conditions can be combined and the indenting pulled in one
tab.

  			if (CHK_SDIO_EXIST(chip) && CHECK_PID(chip, 0x5288)) {


 			}
> @@ -988,8 +995,10 @@ void rtsx_polling_func(struct rtsx_chip *chip)
>  
>  			turn_off_led(chip, LED_GPIO);
>  
> -			if (chip->auto_power_down && !chip->card_ready && !chip->sd_io)
> -				rtsx_force_power_down(chip, SSC_PDCTL | OC_PDCTL);
> +			if (chip->auto_power_down && !chip->card_ready &&
> +					!chip->sd_io)

Line this up like this:

			if (chip->auto_power_down && !chip->card_ready &&
			    !chip->sd_io)
[tab][tab][tab][space][space][space][space]!chip->sd_io)


> +				rtsx_force_power_down(chip,
> +						SSC_PDCTL | OC_PDCTL);
>  
>  		}
>  	}

regards,
dan carpenter

