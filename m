Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757921Ab3JOHlt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 03:41:49 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:53506 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757821Ab3JOHls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 03:41:48 -0400
Message-ID: <525CF1B1.6020600@atmel.com>
Date: Tue, 15 Oct 2013 09:41:37 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Soren Brinkmann <soren.brinkmann@xilinx.com>, <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, Michal Simek <michal.simek@xilinx.com>
Subject: Re: [PATCH RFC 1/5] net: macb: Migrate to dev_pm_ops
References: <1381795140-10792-1-git-send-email-soren.brinkmann@xilinx.com> <1381795140-10792-2-git-send-email-soren.brinkmann@xilinx.com>
In-Reply-To: <1381795140-10792-2-git-send-email-soren.brinkmann@xilinx.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/10/2013 01:58, Soren Brinkmann :
> Migrate the suspend/resume functions to use the dev_pm_ops PM interface.
>
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

> ---
>   drivers/net/ethernet/cadence/macb.c | 14 +++++++-------
>   1 file changed, 7 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/net/ethernet/cadence/macb.c b/drivers/net/ethernet/cadence/macb.c
> index 92578690f6de..389ccf1362d5 100644
> --- a/drivers/net/ethernet/cadence/macb.c
> +++ b/drivers/net/ethernet/cadence/macb.c
> @@ -1946,8 +1946,9 @@ static int __exit macb_remove(struct platform_device *pdev)
>   }
>
>   #ifdef CONFIG_PM
> -static int macb_suspend(struct platform_device *pdev, pm_message_t state)
> +static int macb_suspend(struct device *dev)
>   {
> +	struct platform_device *pdev = to_platform_device(dev);
>   	struct net_device *netdev = platform_get_drvdata(pdev);
>   	struct macb *bp = netdev_priv(netdev);
>
> @@ -1960,8 +1961,9 @@ static int macb_suspend(struct platform_device *pdev, pm_message_t state)
>   	return 0;
>   }
>
> -static int macb_resume(struct platform_device *pdev)
> +static int macb_resume(struct device *dev)
>   {
> +	struct platform_device *pdev = to_platform_device(dev);
>   	struct net_device *netdev = platform_get_drvdata(pdev);
>   	struct macb *bp = netdev_priv(netdev);
>
> @@ -1972,19 +1974,17 @@ static int macb_resume(struct platform_device *pdev)
>
>   	return 0;
>   }
> -#else
> -#define macb_suspend	NULL
> -#define macb_resume	NULL
>   #endif
>
> +static SIMPLE_DEV_PM_OPS(macb_pm_ops, macb_suspend, macb_resume);
> +
>   static struct platform_driver macb_driver = {
>   	.remove		= __exit_p(macb_remove),
> -	.suspend	= macb_suspend,
> -	.resume		= macb_resume,
>   	.driver		= {
>   		.name		= "macb",
>   		.owner	= THIS_MODULE,
>   		.of_match_table	= of_match_ptr(macb_dt_ids),
> +		.pm	= &macb_pm_ops,
>   	},
>   };
>
>


-- 
Nicolas Ferre
