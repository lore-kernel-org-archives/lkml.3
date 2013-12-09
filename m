Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760879Ab3LIIY6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 03:24:58 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:59759 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760858Ab3LIIYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 03:24:54 -0500
Message-ID: <52A57E55.40808@atmel.com>
Date: Mon, 9 Dec 2013 09:24:53 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        "Jean-Christophe Plagniol-Villard" <plagnioj@jcrosoft.com>,
        Linus Walleij <linus.walleij@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 2/3] pinctrl: at91: initialize config parameter to 0
References: <1386421734-10240-1-git-send-email-alexandre.belloni@free-electrons.com> <1386421734-10240-2-git-send-email-alexandre.belloni@free-electrons.com>
In-Reply-To: <1386421734-10240-2-git-send-email-alexandre.belloni@free-electrons.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2013 14:08, Alexandre Belloni :
> When passing a not initialized config parameter, at91_pinconf_get() would return
> a bogus value. Fix that by initializing it to zero before using it.
>
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> ---
>   drivers/pinctrl/pinctrl-at91.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/pinctrl/pinctrl-at91.c b/drivers/pinctrl/pinctrl-at91.c
> index 6446dc804aa7..b0b78f3468ae 100644
> --- a/drivers/pinctrl/pinctrl-at91.c
> +++ b/drivers/pinctrl/pinctrl-at91.c
> @@ -722,7 +722,8 @@ static int at91_pinconf_get(struct pinctrl_dev *pctldev,
>   	unsigned pin;
>   	int div;
>
> -	dev_dbg(info->dev, "%s:%d, pin_id=%d, config=0x%lx", __func__, __LINE__, pin_id, *config);
> +	*config = 0;
> +	dev_dbg(info->dev, "%s:%d, pin_id=%d", __func__, __LINE__, pin_id);
>   	pio = pin_to_controller(info, pin_to_bank(pin_id));
>   	pin = pin_id % MAX_NB_GPIO_PER_BANK;

Beyond this patch, I must say that I am puzzled by this function.

What I read from the prototype documentation and what I see in different 
implementations is different...

Linus, can we have a review of this function because it seems not in 
line with what is used for u300 (but on the other hand looks like the 
what is returned by pinctrl-exynos5440.c driver for example).

What would be the consequences if we change this function's behavior: I 
mean use of -EINVAL for pin configuration "available but disabled" as 
said in include/linux/pinctrl/pinconf.h?

Bye,
-- 
Nicolas Ferre
