Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758311AbaELQO1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 12:14:27 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:46460 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754760AbaELQOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 12:14:25 -0400
Date: Mon, 12 May 2014 09:14:15 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Josef Gajdusek <atx@atx.name>
Cc: jdelvare@suse.de, lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/hwmon/emc1403.c: add support for emc14x2
Message-ID: <20140512161415.GA16770@roeck-us.net>
References: <20140512123409.GB16252@dashie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140512123409.GB16252@dashie>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Josef,

On Mon, May 12, 2014 at 02:34:09PM +0200, Josef Gajdusek wrote:
> Adds support for emc1402/emc1412/emc1422 temperature monitoring chips.
> This line of sensors does only have 2 channels (internal and external) in comparison to the emc14x3 (3 channels) and emc14x4 (4 channels) lines.
> 
> Signed-off-by: Josef Gajdusek <atx@atx.name>

Applied, with a couple of minor adjustments.

> ---

[ ... ]
>  
>  static const unsigned short emc1403_address_list[] = {
> -	0x18, 0x29, 0x4c, 0x4d, I2C_CLIENT_END
> +	0x18, 0x29, 0x1c, 0x4c, 0x4d, 0x5c, I2C_CLIENT_END

Changed to numerical order.

>  };
>  
> +/* Last number in name indicates the amount of channels */

I found that comment a bit confusing, so I changed it to

/* Last digit of chip name indicates number of channels */

>  static const struct i2c_device_id emc1403_idtable[] = {
> -	{ "emc1403", 0 },
> -	{ "emc1404", 1 },
> -	{ "emc1423", 0 },
> -	{ "emc1424", 1 },
> +	{ "emc1402", emc1402 },
> +	{ "emc1403", emc1403 },
> +	{ "emc1404", emc1404 },
> +	{ "emc1422", emc1402 },
> +	{ "emc1423", emc1403 },
> +	{ "emc1424", emc1404 },

Wonder if we should list the emc141x chips here. Jean, any thoughts ?

>  	{ }
>  };
>  MODULE_DEVICE_TABLE(i2c, emc1403_idtable);
> 

It would be nice to also have support for the alarms on EMC14x2,
but that can be a separate patch.

Thanks,
Guenter
