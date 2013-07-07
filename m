Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751479Ab3GGF3k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jul 2013 01:29:40 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:45193 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089Ab3GGF3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jul 2013 01:29:37 -0400
Date: Sat, 6 Jul 2013 22:29:34 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Nick Dyer <nick.dyer@itdev.co.uk>
Cc: Daniel Kurtz <djkurtz@chromium.org>, Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Alan Bowens <Alan.Bowens@atmel.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Meerwald <pmeerw@pmeerw.net>,
        Benson Leung <bleung@chromium.org>,
        Olof Johansson <olofj@chromium.org>
Subject: Re: [PATCH 22/51] Input: atmel_mxt_ts - Add shutdown function
Message-ID: <20130707052934.GB15453@core.coreip.homeip.net>
References: <1372337366-9286-1-git-send-email-nick.dyer@itdev.co.uk>
 <1372337366-9286-23-git-send-email-nick.dyer@itdev.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372337366-9286-23-git-send-email-nick.dyer@itdev.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nick,

On Thu, Jun 27, 2013 at 01:48:57PM +0100, Nick Dyer wrote:
> Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
> Acked-by: Benson Leung <bleung@chromium.org>

Why is this needed?

Thanks.

> ---
>  drivers/input/touchscreen/atmel_mxt_ts.c |    8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
> index ee1e866..76f1c20 100644
> --- a/drivers/input/touchscreen/atmel_mxt_ts.c
> +++ b/drivers/input/touchscreen/atmel_mxt_ts.c
> @@ -1897,6 +1897,13 @@ static int mxt_resume(struct device *dev)
>  
>  static SIMPLE_DEV_PM_OPS(mxt_pm_ops, mxt_suspend, mxt_resume);
>  
> +static void mxt_shutdown(struct i2c_client *client)
> +{
> +	struct mxt_data *data = i2c_get_clientdata(client);
> +
> +	disable_irq(data->irq);
> +}
> +
>  static const struct i2c_device_id mxt_id[] = {
>  	{ "qt602240_ts", 0 },
>  	{ "atmel_mxt_ts", 0 },
> @@ -1914,6 +1921,7 @@ static struct i2c_driver mxt_driver = {
>  	},
>  	.probe		= mxt_probe,
>  	.remove		= mxt_remove,
> +	.shutdown	= mxt_shutdown,
>  	.id_table	= mxt_id,
>  };
>  
> -- 
> 1.7.10.4
> 

-- 
Dmitry
