Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932134Ab3FQGMb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 02:12:31 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:49899 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979Ab3FQGM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 02:12:29 -0400
Message-ID: <51BEA8C7.3090501@linaro.org>
Date: Mon, 17 Jun 2013 11:42:23 +0530
From: Tushar Behera <tushar.behera@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: thierry.reding@gmail.com, patches@linaro.org, linux-mmc@vger.kernel.org,
        Chris Ball <cjb@laptop.org>
Subject: Re: [PATCH 03/15] mmc: mvsdio: Convert to use devm_ioremap_resource
References: <1370864113-17895-1-git-send-email-tushar.behera@linaro.org> <1370864113-17895-4-git-send-email-tushar.behera@linaro.org>
In-Reply-To: <1370864113-17895-4-git-send-email-tushar.behera@linaro.org>
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
> CC: linux-mmc@vger.kernel.org
> CC: Chris Ball <cjb@laptop.org>
> ---
>  drivers/mmc/host/mvsdio.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/mmc/host/mvsdio.c b/drivers/mmc/host/mvsdio.c
> index d08fe6a..656f1f5 100644
> --- a/drivers/mmc/host/mvsdio.c
> +++ b/drivers/mmc/host/mvsdio.c
> @@ -758,9 +758,9 @@ static int __init mvsd_probe(struct platform_device *pdev)
>  
>  	spin_lock_init(&host->lock);
>  
> -	host->base = devm_request_and_ioremap(&pdev->dev, r);
> -	if (!host->base) {
> -		ret = -ENOMEM;
> +	host->base = devm_ioremap_resource(&pdev->dev, r);
> +	if (IS_ERR(host->base)) {
> +		ret = PTR_ERR(host->base);
>  		goto out;
>  	}
>  
> 

Ping.

-- 
Tushar Behera
