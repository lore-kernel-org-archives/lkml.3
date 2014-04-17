Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755194AbaDQJsR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 05:48:17 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:2965 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157AbaDQJsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 05:48:14 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 17 Apr 2014 02:43:00 -0700
Message-ID: <534FA35B.6060005@nvidia.com>
Date: Thu, 17 Apr 2014 15:18:11 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Andrew Bresticker <abrestic@chromium.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>
CC: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] pinctrl: as3722: fix handling of GPIO invert bit
References: <1397611505-17917-1-git-send-email-abrestic@chromium.org>
In-Reply-To: <1397611505-17917-1-git-send-email-abrestic@chromium.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On Wednesday 16 April 2014 06:55 AM, Andrew Bresticker wrote:
> diff --git a/drivers/pinctrl/pinctrl-as3722.c b/drivers/pinctrl/pinctrl-as3722.c
> index 92ed4b2..c862f9c0 100644
> --- a/drivers/pinctrl/pinctrl-as3722.c
> +++ b/drivers/pinctrl/pinctrl-as3722.c
> @@ -64,7 +64,6 @@ struct as3722_pin_function {
>   };
>   
>   struct as3722_gpio_pin_control {
> -	bool enable_gpio_invert;
>   	unsigned mode_prop;
>   	int io_function;
>   };

Instead of removing this flag and  calling read of register on every 
gpio set, better if we update this flag on probe once and use this for 
entire life.

So adding the code in probe() as

         for (i = 0; i < ARRAY_SIZE(as3722_pingroups); ++i) {
                 int gpio_cntr_reg = AS3722_GPIOn_CONTROL_REG(i);
                 u32 val;

                 ret = as3722_read(as3722, gpio_cntr_reg, &val);
                 if (!ret)
as_pci->gpio_control[i].enable_gpio_invert =
                                         !!(val & AS3722_GPIO_INV);
         }


Thanks,
Laxman
