Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755955Ab3FQGNq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 02:13:46 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:45780 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750Ab3FQGNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 02:13:45 -0400
Message-ID: <51BEA914.1040301@linaro.org>
Date: Mon, 17 Jun 2013 11:43:40 +0530
From: Tushar Behera <tushar.behera@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: thierry.reding@gmail.com, patches@linaro.org, linux-gpio@vger.kernel.org,
        Grant Likely <grant.likely@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 05/15] gpio-sta2x11: Convert to use devm_ioremap_resource
References: <1370864113-17895-1-git-send-email-tushar.behera@linaro.org> <1370864113-17895-6-git-send-email-tushar.behera@linaro.org>
In-Reply-To: <1370864113-17895-6-git-send-email-tushar.behera@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2013 05:05 PM, Tushar Behera wrote:
> Commit 75096579c3ac ("lib: devres: Introduce devm_ioremap_resource()")
> introduced devm_ioremap_resource() and deprecated the use of
> devm_request_and_ioremap().
> 
> Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
> CC: linux-gpio@vger.kernel.org
> CC: Grant Likely <grant.likely@linaro.org>
> CC: Linus Walleij <linus.walleij@linaro.org>
> ---
>  drivers/gpio/gpio-sta2x11.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/gpio/gpio-sta2x11.c b/drivers/gpio/gpio-sta2x11.c
> index 5585425..c977c14 100644
> --- a/drivers/gpio/gpio-sta2x11.c
> +++ b/drivers/gpio/gpio-sta2x11.c
> @@ -372,7 +372,9 @@ static int gsta_probe(struct platform_device *dev)
>  
>  	chip = devm_kzalloc(&dev->dev, sizeof(*chip), GFP_KERNEL);
>  	chip->dev = &dev->dev;
> -	chip->reg_base = devm_request_and_ioremap(&dev->dev, res);
> +	chip->reg_base = devm_ioremap_resource(&dev->dev, res);
> +	if (IS_ERR(chip->reg_base))
> +		return PTR_ERR(chip->reg_base);
>  
>  	for (i = 0; i < GSTA_NR_BLOCKS; i++) {
>  		chip->regs[i] = chip->reg_base + i * 4096;
> 

Ping.

-- 
Tushar Behera
