Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935832Ab3DITae (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 15:30:34 -0400
Received: from server.prisktech.co.nz ([115.188.14.127]:63897 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932780Ab3DITad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 15:30:33 -0400
Message-ID: <51646C5C.7080108@prisktech.co.nz>
Date: Wed, 10 Apr 2013 07:30:36 +1200
From: Tony Prisk <linux@prisktech.co.nz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>
CC: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pinctrl: vt8500: wmt: Fix checking return value of pinctrl_register()
References: <1365523198.12439.1.camel@phoenix>
In-Reply-To: <1365523198.12439.1.camel@phoenix>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/13 03:59, Axel Lin wrote:
> pinctrl_register() returns NULL on error.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
>   drivers/pinctrl/vt8500/pinctrl-wmt.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/pinctrl/vt8500/pinctrl-wmt.c b/drivers/pinctrl/vt8500/pinctrl-wmt.c
> index 14400a7..ab63104e 100644
> --- a/drivers/pinctrl/vt8500/pinctrl-wmt.c
> +++ b/drivers/pinctrl/vt8500/pinctrl-wmt.c
> @@ -588,7 +588,7 @@ int wmt_pinctrl_probe(struct platform_device *pdev,
>   	data->dev = &pdev->dev;
>   
>   	data->pctl_dev = pinctrl_register(&wmt_desc, &pdev->dev, data);
> -	if (IS_ERR(data->pctl_dev)) {
> +	if (!data->pctl_dev) {
>   		dev_err(&pdev->dev, "Failed to register pinctrl\n");
>   		return -EINVAL;
>   	}
Not sure why I missed this...

Linus,
If you're happy with this patch, I'll forward it on to arm-soc to go in 
with the rest.

Regards
Tony P
