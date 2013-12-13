Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752124Ab3LMIvF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 03:51:05 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:32157 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834Ab3LMIvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 03:51:04 -0500
Message-ID: <52AACA73.9060409@atmel.com>
Date: Fri, 13 Dec 2013 09:50:59 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        "Jean-Christophe Plagniol-Villard" <plagnioj@jcrosoft.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 3/3] pinctrl: at91: implement at91_pinconf_dbg_show
References: <1386421734-10240-1-git-send-email-alexandre.belloni@free-electrons.com> <1386421734-10240-3-git-send-email-alexandre.belloni@free-electrons.com>
In-Reply-To: <1386421734-10240-3-git-send-email-alexandre.belloni@free-electrons.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2013 14:08, Alexandre Belloni :
> This allows to get the pin configuration by using debugfs. On my system:
>   # cat /sys/kernel/debug/pinctrl/pinctrl.3/pinconf-pins
>
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>

I am fine with these helpers:

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

But still a little disappointed that Laurent announced that he wouldn't 
review the whole kernel ;-)

Bye guys and thanks a lot!

> ---
>   drivers/pinctrl/pinctrl-at91.c | 25 +++++++++++++++++++++++++
>   1 file changed, 25 insertions(+)
>
> diff --git a/drivers/pinctrl/pinctrl-at91.c b/drivers/pinctrl/pinctrl-at91.c
> index b0b78f3468ae..bcfc8a2eebca 100644
> --- a/drivers/pinctrl/pinctrl-at91.c
> +++ b/drivers/pinctrl/pinctrl-at91.c
> @@ -784,10 +784,35 @@ static int at91_pinconf_set(struct pinctrl_dev *pctldev,
>   	return 0;
>   }
>
> +#define DBG_SHOW_FLAG(flag) do {		\
> +	if (config & flag) {			\
> +		if (num_conf)			\
> +			seq_puts(s, "|");	\
> +		seq_puts(s, #flag);		\
> +		num_conf++;			\
> +	}					\
> +} while (0)
> +
>   static void at91_pinconf_dbg_show(struct pinctrl_dev *pctldev,
>   				   struct seq_file *s, unsigned pin_id)
>   {
> +	unsigned long config;
> +	int ret, val, num_conf = 0;
> +
> +	ret = at91_pinconf_get(pctldev, pin_id, &config);
> +
> +	DBG_SHOW_FLAG(MULTI_DRIVE);
> +	DBG_SHOW_FLAG(PULL_UP);
> +	DBG_SHOW_FLAG(PULL_DOWN);
> +	DBG_SHOW_FLAG(DIS_SCHMIT);
> +	DBG_SHOW_FLAG(DEGLITCH);
> +	DBG_SHOW_FLAG(DEBOUNCE);
> +	if (config & DEBOUNCE) {
> +		val = config >> DEBOUNCE_VAL_SHIFT;
> +		seq_printf(s, "(%d)", val);
> +	}
>
> +	return;
>   }
>
>   static void at91_pinconf_group_dbg_show(struct pinctrl_dev *pctldev,
>


-- 
Nicolas Ferre
