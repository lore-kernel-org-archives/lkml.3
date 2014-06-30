Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755018AbaF3Jef (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 05:34:35 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:42629 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753803AbaF3Jee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 05:34:34 -0400
Message-ID: <53B12F25.5060908@gmail.com>
Date: Mon, 30 Jun 2014 11:34:29 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
To: Himangi Saraogi <himangi774@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org
CC: julia.lawall@lip6.fr
Subject: Re: [PATCH] pinctrl: berlin: fix return value for dev_get_regmap
References: <20140629071815.GA16257@himangi-Dell>
In-Reply-To: <20140629071815.GA16257@himangi-Dell>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29/2014 09:18 AM, Himangi Saraogi wrote:
> The failure value of dev_get_regmap is NULL. Hence, the return value is
> changed to -ENODEV.
>
> A simplified version of the semantic match that finds this problem is as
> follows:
>
> // <smpl>
> @@
> expression e1;
> @@
>
> * if (!e1)
>    return PTR_ERR(e1);
>
> // </smpl>
>
> Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
> Acked-by: Julia Lawall <julia.lawall@lip6.fr>

Himangi,

thanks for the fix, but we already have a similar patch [1] pending.

Sebastian

[1] http://www.spinics.net/lists/linux-kernel-janitors/msg19125.html

> ---
>   drivers/pinctrl/berlin/berlin.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
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

