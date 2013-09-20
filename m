Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103Ab3ITH01 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 03:26:27 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:41006 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752713Ab3ITH0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 03:26:25 -0400
Message-ID: <523BF89E.4000508@atmel.com>
Date: Fri, 20 Sep 2013 09:26:22 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Thomas Meyer <thomas@m3y3r.de>, <jic23@cam.ac.uk>,
        <grant.likely@linaro.org>, <rob.herring@calxeda.com>,
        <linux-iio@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH 3/10] iio: at91_adc: Cocci spatch "noderef"
References: <1379604755850-858421494-0-diffsplit-thomas@m3y3r.de> <1379604755852-604229709-3-diffsplit-thomas@m3y3r.de>
In-Reply-To: <1379604755852-604229709-3-diffsplit-thomas@m3y3r.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/09/2013 23:42, Thomas Meyer :
> sizeof when applied to a pointer typed expression gives the size of the
> pointer.
> Found by coccinelle spatch "misc/noderef.cocci"
>
> Signed-off-by: Thomas Meyer <thomas@m3y3r.de>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

> ---
>
> diff -u -p a/drivers/iio/adc/at91_adc.c b/drivers/iio/adc/at91_adc.c
> --- a/drivers/iio/adc/at91_adc.c
> +++ b/drivers/iio/adc/at91_adc.c
> @@ -279,7 +279,7 @@ static int at91_adc_trigger_init(struct
>   	int i, ret;
>
>   	st->trig = devm_kzalloc(&idev->dev,
> -				st->trigger_number * sizeof(st->trig),
> +				st->trigger_number * sizeof(*st->trig),
>   				GFP_KERNEL);
>
>   	if (st->trig == NULL) {
> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
Nicolas Ferre
