Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932314AbaGIU07 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 16:26:59 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:39975 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932144AbaGIU05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 16:26:57 -0400
Date: Wed, 9 Jul 2014 13:26:54 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Roald Frederickx <roald.frederickx@gmail.com>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] compal-laptop: correct invalid hwmon name
Message-ID: <20140709202654.GA25846@roeck-us.net>
References: <53BD942A.2070106@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53BD942A.2070106@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2014 at 09:12:42PM +0200, Roald Frederickx wrote:
> From: Roald Frederickx <roald.frederickx@gmail.com>
> 
> Change the name of the hwmon interface from "compal-laptop" to
> "compal". A dash is an invalid character for a hwmon name and caused
> the call to hwmon_device_register_with_groups() to fail.
> 
> Signed-off-by: Roald Frederickx <roald.frederickx@gmail.com>

Acked-by: Guenter Roeck <linux@roeck-us.net>

> ---
> 
> diff --git a/drivers/platform/x86/compal-laptop.c
> b/drivers/platform/x86/compal-laptop.c
> index 7297df2..26bfd7b 100644
> --- a/drivers/platform/x86/compal-laptop.c
> +++ b/drivers/platform/x86/compal-laptop.c
> @@ -1028,7 +1028,7 @@ static int compal_probe(struct platform_device *pdev)
>  		return err;
> 
>  	hwmon_dev = hwmon_device_register_with_groups(&pdev->dev,
> -						      DRIVER_NAME, data,
> +						      "compal", data,
>  						      compal_hwmon_groups);
>  	if (IS_ERR(hwmon_dev)) {
>  		err = PTR_ERR(hwmon_dev);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
> 
