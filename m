Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416Ab3FGAWO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 20:22:14 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:62858 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848Ab3FGAWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 20:22:13 -0400
Date: Thu, 6 Jun 2013 17:17:57 -0700
From: Anton Vorontsov <anton@enomsg.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'David Woodhouse'" <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        "'Jett.Zhou'" <jtzhou@marvell.com>
Subject: Re: [PATCH 1/8] 88pm860x_battery: remove unnecessary
 platform_set_drvdata()
Message-ID: <20130607001756.GA7052@lizard.sbx05280.losalca.wayport.net>
References: <003601ce4a10$7c1adaf0$745090d0$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <003601ce4a10$7c1adaf0$745090d0$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 06, 2013 at 01:16:30PM +0900, Jingoo Han wrote:
> The driver core clears the driver data to NULL after device_release
> or on probe failure, since commit 0998d0631001288a5974afc0b2a5f568bcdecb4d
> (device-core: Ensure drvdata = NULL when no driver is bound).
> Thus, it is not needed to manually clear the device driver data to NULL.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

1-8 applied, thanks a lot!

Anton

> ---
>  drivers/power/88pm860x_battery.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/power/88pm860x_battery.c b/drivers/power/88pm860x_battery.c
> index d338c1c..dfcda3a 100644
> --- a/drivers/power/88pm860x_battery.c
> +++ b/drivers/power/88pm860x_battery.c
> @@ -992,7 +992,6 @@ static int pm860x_battery_remove(struct platform_device *pdev)
>  	free_irq(info->irq_batt, info);
>  	free_irq(info->irq_cc, info);
>  	power_supply_unregister(&info->battery);
> -	platform_set_drvdata(pdev, NULL);
>  	return 0;
>  }
>  
> -- 
> 1.7.2.5
