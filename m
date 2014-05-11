Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754931AbaEKWr0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 18:47:26 -0400
Received: from mail.active-venture.com ([67.228.131.205]:49227 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbaEKWrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 18:47:25 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <536FFDF5.5070103@roeck-us.net>
Date: Sun, 11 May 2014 15:47:17 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Josef Gajdusek <atx@atx.name>, jdelvare@suse.de
CC: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/hwmon/emc1403.c: add support for emc1412
References: <20140511130023.GA501@dashie>
In-Reply-To: <20140511130023.GA501@dashie>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/2014 06:00 AM, Josef Gajdusek wrote:
> Adds support for emc1412.
>
[ ... ]
> @@ -330,9 +389,9 @@ static int emc1403_detect(struct i2c_client *client,
>   	}
>
>   	id = i2c_smbus_read_byte_data(client, THERMAL_REVISION_REG);
> -	if (id != 0x01)
> +	if (id != 0x01 && id != 0x04) {
>   		return -ENODEV;
> -
> +	}

Forgot: Please see Documents/CodingStyle, Chapter 3:

	"Do not unnecessarily use braces where a single statement will do."

As it turns out, this change generates a checkpatch warning.

Also, you forgot to sign this patch.

Guenter

