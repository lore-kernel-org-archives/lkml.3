Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751631Ab3HSNGj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 09:06:39 -0400
Received: from mail.active-venture.com ([67.228.131.205]:53931 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511Ab3HSNGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 09:06:37 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <5212185B.8080907@roeck-us.net>
Date: Mon, 19 Aug 2013 06:06:35 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Julia Lawall <Julia.Lawall@lip6.fr>
CC: Wim Van Sebroeck <wim@iguana.be>, kernel-janitors@vger.kernel.org,
        linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] watchdog: simplify platform_get_resource_byname/devm_ioremap_resource
References: <1376902316-18520-1-git-send-email-Julia.Lawall@lip6.fr> <1376902316-18520-3-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1376902316-18520-3-git-send-email-Julia.Lawall@lip6.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/19/2013 01:51 AM, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
>
> Remove unneeded error handling on the result of a call to
> platform_get_resource_byname when the value is passed to devm_ioremap_resource.
>
> A simplified version of the semantic patch that makes this change is as
> follows: (http://coccinelle.lip6.fr/)
>
> // <smpl>
> @@
> expression pdev,res,e,e1;
> expression ret != 0;
> identifier l;
> @@
>
>    res = platform_get_resource_byname(...);
> - if (res == NULL) { ... \(goto l;\|return ret;\) }
>    e = devm_ioremap_resource(e1, res);
> // </smpl>
>
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>

> ---
>   drivers/watchdog/ar7_wdt.c |    5 -----
>   1 file changed, 5 deletions(-)
>
> diff --git a/drivers/watchdog/ar7_wdt.c b/drivers/watchdog/ar7_wdt.c
> index 2f3cc8f..b3709f9 100644
> --- a/drivers/watchdog/ar7_wdt.c
> +++ b/drivers/watchdog/ar7_wdt.c
> @@ -280,11 +280,6 @@ static int ar7_wdt_probe(struct platform_device *pdev)
>
>   	ar7_regs_wdt =
>   		platform_get_resource_byname(pdev, IORESOURCE_MEM, "regs");
> -	if (!ar7_regs_wdt) {
> -		pr_err("could not get registers resource\n");
> -		return -ENODEV;
> -	}
> -
>   	ar7_wdt = devm_ioremap_resource(&pdev->dev, ar7_regs_wdt);
>   	if (IS_ERR(ar7_wdt))
>   		return PTR_ERR(ar7_wdt);
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-watchdog" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>

