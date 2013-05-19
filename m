Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651Ab3ESHyQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 May 2013 03:54:16 -0400
Received: from server.prisktech.co.nz ([115.188.14.127]:50246 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753426Ab3ESHyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 May 2013 03:54:15 -0400
Message-ID: <51988528.1010402@prisktech.co.nz>
Date: Sun, 19 May 2013 19:54:16 +1200
From: Tony Prisk <linux@prisktech.co.nz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>
CC: Linus Walleij <linus.walleij@stericsson.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] pinctrl: Don't override the error code in probe error
 handling
References: <1368943117.3455.4.camel@phoenix>
In-Reply-To: <1368943117.3455.4.camel@phoenix>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/05/13 17:58, Axel Lin wrote:
> Otherwise, we return 0 in probe error paths when gpiochip_remove() returns 0.
> Also show error message if gpiochip_remove() fails.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> Cc: Linus Walleij <linus.walleij@stericsson.com>
> Cc: Maxime Ripard <maxime.ripard@free-electrons.com>
> Cc: Tony Prisk <linux@prisktech.co.nz>
> ---
>   drivers/pinctrl/pinctrl-coh901.c     | 3 ++-
>   drivers/pinctrl/pinctrl-sunxi.c      | 3 ++-
>   drivers/pinctrl/vt8500/pinctrl-wmt.c | 3 +--
>   3 files changed, 5 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/pinctrl/pinctrl-coh901.c b/drivers/pinctrl/pinctrl-coh901.c
> index 20da215..ea98df9 100644
> --- a/drivers/pinctrl/pinctrl-coh901.c
> +++ b/drivers/pinctrl/pinctrl-coh901.c
> @@ -830,7 +830,8 @@ static int __init u300_gpio_probe(struct platform_device *pdev)
>   	return 0;
>   
>   err_no_range:
> -	err = gpiochip_remove(&gpio->chip);
> +	if (gpiochip_remove(&gpio->chip))
> +		dev_err(&pdev->dev, "failed to remove gpio chip\n");
>   err_no_chip:
>   err_no_domain:
>   err_no_port:
> diff --git a/drivers/pinctrl/pinctrl-sunxi.c b/drivers/pinctrl/pinctrl-sunxi.c
> index c52fc2c..c058529 100644
> --- a/drivers/pinctrl/pinctrl-sunxi.c
> +++ b/drivers/pinctrl/pinctrl-sunxi.c
> @@ -2000,7 +2000,8 @@ static int sunxi_pinctrl_probe(struct platform_device *pdev)
>   	return 0;
>   
>   gpiochip_error:
> -	ret = gpiochip_remove(pctl->chip);
> +	if (gpiochip_remove(pctl->chip))
> +		dev_err(&pdev->dev, "failed to remove gpio chip\n");
>   pinctrl_error:
>   	pinctrl_unregister(pctl->pctl_dev);
>   	return ret;
> diff --git a/drivers/pinctrl/vt8500/pinctrl-wmt.c b/drivers/pinctrl/vt8500/pinctrl-wmt.c
> index e877082..fb30edf3 100644
> --- a/drivers/pinctrl/vt8500/pinctrl-wmt.c
> +++ b/drivers/pinctrl/vt8500/pinctrl-wmt.c
> @@ -609,8 +609,7 @@ int wmt_pinctrl_probe(struct platform_device *pdev,
>   	return 0;
>   
>   fail_range:
> -	err = gpiochip_remove(&data->gpio_chip);
> -	if (err)
> +	if (gpiochip_remove(&data->gpio_chip))
>   		dev_err(&pdev->dev, "failed to remove gpio chip\n");
>   fail_gpio:
>   	pinctrl_unregister(data->pctl_dev);
Good catch.

for pinctrl-wmt
Acked-by: Tony Prisk <linux@prisktech.co.nz>

Regards
Tony P
