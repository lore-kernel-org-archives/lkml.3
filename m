Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753273Ab3H0MTX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 08:19:23 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:60590 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119Ab3H0MTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 08:19:22 -0400
Message-ID: <521C9946.70009@cogentembedded.com>
Date: Tue, 27 Aug 2013 16:19:18 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: "Vishwanathrao Badarkhe, Manish" <manishv.b@ti.com>
CC: davinci-linux-open-source@linux.davincidsp.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, tony@atomide.com,
        linus.walleij@linaro.org
Subject: Re: [PATCH] pinctrl: pinctrl-single: Convert to devm_ioremap_resource()
References: <1377587134-8967-1-git-send-email-manishv.b@ti.com>
In-Reply-To: <1377587134-8967-1-git-send-email-manishv.b@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 27-08-2013 11:05, Vishwanathrao Badarkhe, Manish wrote:

> From: "Vishwanathrao Badarkhe, Manish" <manishv.b@ti.com>

> Convert devm_request_mem_region() and devm_ioremap() to
> devm_ioremap_resource() which provides more consistent
> error handling to manage resource.

> Signed-off-by: Vishwanathrao Badarkhe, Manish <manishv.b@ti.com>
> ---
> :100644 100644 7323cca... b0fef18... M	drivers/pinctrl/pinctrl-single.c
>   drivers/pinctrl/pinctrl-single.c |   21 +++------------------
>   1 file changed, 3 insertions(+), 18 deletions(-)

> diff --git a/drivers/pinctrl/pinctrl-single.c b/drivers/pinctrl/pinctrl-single.c
> index 7323cca..b0fef18 100644
> --- a/drivers/pinctrl/pinctrl-single.c
> +++ b/drivers/pinctrl/pinctrl-single.c
> @@ -1556,24 +1556,9 @@ static int pcs_probe(struct platform_device *pdev)
>   						  "pinctrl-single,bit-per-mux");
>
>   	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	if (!res) {
> -		dev_err(pcs->dev, "could not get resource\n");
> -		return -ENODEV;
> -	}
> -
> -	pcs->res = devm_request_mem_region(pcs->dev, res->start,
> -			resource_size(res), DRIVER_NAME);
> -	if (!pcs->res) {

    Is pcs->res used anywhere else?

> -		dev_err(pcs->dev, "could not get mem_region\n");
> -		return -EBUSY;
> -	}
> -
> -	pcs->size = resource_size(pcs->res);

    Is pcs->size used anywhere else?

> -	pcs->base = devm_ioremap(pcs->dev, pcs->res->start, pcs->size);
> -	if (!pcs->base) {
> -		dev_err(pcs->dev, "could not ioremap\n");
> -		return -ENODEV;
> -	}
> +	pcs->base = devm_ioremap_resource(pcs->dev, res);
> +	if (IS_ERR(pcs->base))
> +		return PTR_ERR(pcs->base);

WBR, Sergei

