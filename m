Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751530Ab3FZFig (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 01:38:36 -0400
Received: from server.prisktech.co.nz ([115.188.14.127]:59999 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718Ab3FZFif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 01:38:35 -0400
Message-ID: <51CA7E6F.5020105@prisktech.co.nz>
Date: Wed, 26 Jun 2013 17:38:55 +1200
From: Tony Prisk <linux@prisktech.co.nz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Wei Yongjun <weiyj.lk@gmail.com>
CC: linus.walleij@linaro.org, axel.lin@ingics.com,
        maxime.ripard@free-electrons.com, swarren@nvidia.com,
        yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] pinctrl: vt8500: wmt: remove redundant dev_err
 call in wmt_pinctrl_probe()
References: <CAPgLHd8wYkHaqH90Xyg=QgBKaREwjgS=H-pOMz-jLrwtdWuQ3g@mail.gmail.com>
In-Reply-To: <CAPgLHd8wYkHaqH90Xyg=QgBKaREwjgS=H-pOMz-jLrwtdWuQ3g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/06/13 13:56, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> There is a error message within devm_ioremap_resource
> already, so remove the dev_err call to avoid redundant
> error message.
>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>   drivers/pinctrl/vt8500/pinctrl-wmt.c | 4 +---
>   1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/drivers/pinctrl/vt8500/pinctrl-wmt.c b/drivers/pinctrl/vt8500/pinctrl-wmt.c
> index fb30edf3..0cc4335 100644
> --- a/drivers/pinctrl/vt8500/pinctrl-wmt.c
> +++ b/drivers/pinctrl/vt8500/pinctrl-wmt.c
> @@ -570,10 +570,8 @@ int wmt_pinctrl_probe(struct platform_device *pdev,
>   
>   	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>   	data->base = devm_ioremap_resource(&pdev->dev, res);
> -	if (IS_ERR(data->base)) {
> -		dev_err(&pdev->dev, "failed to map memory resource\n");
> +	if (IS_ERR(data->base))
>   		return PTR_ERR(data->base);
> -	}
>   
>   	wmt_desc.pins = data->pins;
>   	wmt_desc.npins = data->npins;
Acked-by: Tony Prisk <linux@prisktech.co.nz>

Regards
Tony P
