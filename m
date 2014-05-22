Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751452AbaEVDch (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 23:32:37 -0400
Received: from mail.active-venture.com ([67.228.131.205]:56110 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706AbaEVDcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 23:32:36 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <537D6FC8.5000105@roeck-us.net>
Date: Wed, 21 May 2014 20:32:24 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Flavio Leitner <fbl@redhat.com>, linux-kernel@vger.kernel.org
CC: Arnd Bergmann <arnd@arndb.de>, Flavio Leitner <fbl@sysclose.org>
Subject: Re: [PATCH] i8k: increase fan limit to 3
References: <1400725168-21358-1-git-send-email-fbl@redhat.com>
In-Reply-To: <1400725168-21358-1-git-send-email-fbl@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/21/2014 07:19 PM, Flavio Leitner wrote:
> From: Flavio Leitner <fbl@sysclose.org>
>
> It is possible to increase left fan speed on a
> DELL Precision 490n system up to 3.
>
>      value    fan rpm
>        1      35460
>        2      64740
>        3      78510
>
Guess the speed factor 30 doesn't apply here.

> Signed-off-by: Flavio Leitner <fbl@sysclose.org>
> ---
>   drivers/char/i8k.c       | 4 ++--
>   include/uapi/linux/i8k.h | 3 ++-
>   2 files changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/char/i8k.c b/drivers/char/i8k.c
> index d915707..99180f0 100644
> --- a/drivers/char/i8k.c
> +++ b/drivers/char/i8k.c
> @@ -519,7 +519,7 @@ static ssize_t i8k_hwmon_show_pwm(struct device *dev,
>   	status = i8k_get_fan_status(index);
>   	if (status < 0)
>   		return -EIO;
> -	return sprintf(buf, "%d\n", clamp_val(status * 128, 0, 255));
> +	return sprintf(buf, "%d\n", clamp_val(status * 128, 0, 384));
>   }
>
>   static ssize_t i8k_hwmon_set_pwm(struct device *dev,
> @@ -533,7 +533,7 @@ static ssize_t i8k_hwmon_set_pwm(struct device *dev,
>   	err = kstrtoul(buf, 10, &val);
>   	if (err)
>   		return err;
> -	val = clamp_val(DIV_ROUND_CLOSEST(val, 128), 0, 2);
> +	val = clamp_val(DIV_ROUND_CLOSEST(val, 128), 0, 3);
>
>   	mutex_lock(&i8k_mutex);
>   	err = i8k_set_fan(index, val);
> diff --git a/include/uapi/linux/i8k.h b/include/uapi/linux/i8k.h
> index 1c45ba5..133d02f 100644
> --- a/include/uapi/linux/i8k.h
> +++ b/include/uapi/linux/i8k.h
> @@ -34,7 +34,8 @@
>   #define I8K_FAN_OFF		0
>   #define I8K_FAN_LOW		1
>   #define I8K_FAN_HIGH		2
> -#define I8K_FAN_MAX		I8K_FAN_HIGH
> +#define I8K_FAN_TURBO		3
> +#define I8K_FAN_MAX		I8K_FAN_TURBO
>
>   #define I8K_VOL_UP		1
>   #define I8K_VOL_DOWN		2
>

I'll have to test this on older systems to make sure it doesn't cause problems there.

Guenter

