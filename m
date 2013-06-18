Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135Ab3FRLxb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 07:53:31 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:43049 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755796Ab3FRLx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 07:53:28 -0400
Message-ID: <51C04A32.1080208@linaro.org>
Date: Tue, 18 Jun 2013 17:23:22 +0530
From: Tushar Behera <tushar.behera@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Wei Yongjun <weiyj.lk@gmail.com>
CC: gregkh@linuxfoundation.org, ganesanr@broadcom.com,
        yongjun_wei@trendmicro.com.cn, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] Staging: netlogic: fix missing free_netdev() on
 error in xlr_net_probe()
References: <CAPgLHd_vfuN7Uenprrc_230MbyR7hAg+D4NCSSKEfcGNDtbS_Q@mail.gmail.com>
In-Reply-To: <CAPgLHd_vfuN7Uenprrc_230MbyR7hAg+D4NCSSKEfcGNDtbS_Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2013 03:23 PM, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Fix missing free_netdev() before return from function xlr_net_probe()
> in the devm_ioremap_resource() error handling case.
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
> no compile test.
> ---
>  drivers/staging/netlogic/xlr_net.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/staging/netlogic/xlr_net.c b/drivers/staging/netlogic/xlr_net.c
> index b529d79..2acde54 100644
> --- a/drivers/staging/netlogic/xlr_net.c
> +++ b/drivers/staging/netlogic/xlr_net.c
> @@ -1023,9 +1023,9 @@ static int xlr_net_probe(struct platform_device *pdev)
>  	ndev->base_addr = (unsigned long) devm_ioremap_resource
>  		(&pdev->dev, res);
>  	if (IS_ERR_VALUE(ndev->base_addr)) {
> -		dev_err(&pdev->dev,
> -				"devm_ioremap_resource failed\n");
> -		return ndev->base_addr;
> +		dev_err(&pdev->dev, "devm_ioremap_resource failed\n");

Please remove this error message too. During review of my patchset, it
was pointed that this error message is redundant. There is already a
similar error message within devm_ioremap_resource call.

> +		err = ndev->base_addr;
> +		goto err_gmac;
>  	}
>  
>  	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
> 


-- 
Tushar Behera
