Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758440Ab3BZONw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 09:13:52 -0500
Received: from slimlogic.co.uk ([89.16.172.20]:47715 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757122Ab3BZONv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 09:13:51 -0500
Message-ID: <512CC31D.6070602@slimlogic.co.uk>
Date: Tue, 26 Feb 2013 14:13:49 +0000
From: Ian Lartey <ian@slimlogic.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        Graeme Gregory <gg@slimlogic.co.uk>
Subject: Re: [PATCH] gpio: palmas: add in GPIO support for palmas charger
References: <1361884868-27783-1-git-send-email-ian@slimlogic.co.uk> <512CBF75.9000103@nvidia.com>
In-Reply-To: <512CBF75.9000103@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/02/13 13:58, Laxman Dewangan wrote:
> On Tuesday 26 February 2013 06:51 PM, Ian Lartey wrote:
>> this patch depenfs on [PATCH] mfd: palmas: is_palmas_charger needed by
>> multiple drivers
>>
>> Palmas charger has 16 GPIOs
>> add palmas_gpio_[read|write|update] api to take account
>> second bank of GPIOs
>>
>> Signed-off-by: Ian Lartey <ian@slimlogic.co.uk>
>> Signed-off-by: Graeme Gregory <gg@slimlogic.co.uk>
>> ---
>
>> +    /* palmas charger has 16 gpios */
>> +    if (is_palmas_charger(palmas->product_id))
>> +        palmas_gpio->gpio_chip.ngpio = 16;
>> +
> what happen if it is not palma charger?
> palmas_gpio->gpio_chip.ngpio = 8; is missing or it will overwrite
> somewhere.
>

the non palmas charger value of ngpio remains where it was  -
but you have shown up an error in the ordering - Thanks

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

