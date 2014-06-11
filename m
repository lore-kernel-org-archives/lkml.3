Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752276AbaFKIg2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 04:36:28 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:48638 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575AbaFKIg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 04:36:26 -0400
Message-ID: <53981501.9090404@gmail.com>
Date: Wed, 11 Jun 2014 10:36:17 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
To: Dan Carpenter <dan.carpenter@oracle.com>,
        Linus Walleij <linus.walleij@linaro.org>
CC: Antoine Tenart <antoine.tenart@free-electrons.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] pinctrl: berlin: fix an error code in berlin_pinctrl_probe()
References: <20140611081513.GA29572@mwanda>
In-Reply-To: <20140611081513.GA29572@mwanda>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/2014 10:15 AM, Dan Carpenter wrote:
> We are returning success here because PTR_ERR(NULL) is zero.  We should
> be returning -ENODEV.
>
> Fixes: 3de68d331c24 ('pinctrl: berlin: add the core pinctrl driver for Marvell Berlin SoCs')
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Dan, thanks for the fix!

Acked-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>

> diff --git a/drivers/pinctrl/berlin/berlin.c b/drivers/pinctrl/berlin/berlin.c
> index edf5d2f..86db223 100644
> --- a/drivers/pinctrl/berlin/berlin.c
> +++ b/drivers/pinctrl/berlin/berlin.c
> @@ -320,7 +320,7 @@ int berlin_pinctrl_probe(struct platform_device *pdev,
>
>   	regmap = dev_get_regmap(&pdev->dev, NULL);
>   	if (!regmap)
> -		return PTR_ERR(regmap);
> +		return -ENODEV;
>
>   	pctrl = devm_kzalloc(dev, sizeof(*pctrl), GFP_KERNEL);
>   	if (!pctrl)
>

