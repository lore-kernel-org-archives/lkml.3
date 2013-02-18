Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757358Ab3BRBtO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 20:49:14 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:43306 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756192Ab3BRBtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 20:49:12 -0500
Message-ID: <51218897.2150420a.5715.ffff85d5@mx.google.com>
Date: Mon, 18 Feb 2013 10:48:55 +0900
From: gshark <gshark.jeong@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Jingoo Han <jg1.han@samsung.com>
CC: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Daniel Jeong'" <daniel.jeong@gmail.com>
Subject: Re: [PATCH] backlight: lm3630: remove ret = -EIO of lm3630_backlight_register()
References: <00b801ce026c$8a90ec00$9fb2c400$%han@samsung.com>
In-Reply-To: <00b801ce026c$8a90ec00$9fb2c400$%han@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013년 02월 04일 09:14, Jingoo Han 쓴 글:
> There is no need to return -EIO, because backlight_device_register()
> already returns correct error values.
>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>   drivers/video/backlight/lm3630_bl.c |    4 ++--
>   1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/video/backlight/lm3630_bl.c b/drivers/video/backlight/lm3630_bl.c
> index a6d637b..76a62e9 100644
> --- a/drivers/video/backlight/lm3630_bl.c
> +++ b/drivers/video/backlight/lm3630_bl.c
> @@ -320,7 +320,7 @@ static int lm3630_backlight_register(struct lm3630_chip_data *pchip,
>   		    backlight_device_register(name, pchip->dev, pchip,
>   					      &lm3630_bank_a_ops, &props);
>   		if (IS_ERR(pchip->bled1))
> -			return -EIO;
> +			return PTR_ERR(pchip->bled1);
>   		break;
>   	case BLED_2:
>   		props.brightness = pdata->init_brt_led2;
> @@ -329,7 +329,7 @@ static int lm3630_backlight_register(struct lm3630_chip_data *pchip,
>   		    backlight_device_register(name, pchip->dev, pchip,
>   					      &lm3630_bank_b_ops, &props);
>   		if (IS_ERR(pchip->bled2))
> -			return -EIO;
> +			return PTR_ERR(pchip->bled2);
>   		break;
>   	}
>   	return 0;

Thank you. This patch looks good for us.
Acked-by: Daniel Jeong<daniel.jeong@ti.com>

