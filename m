Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756599Ab3HZJKS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 05:10:18 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:62756 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756543Ab3HZJKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 05:10:17 -0400
Message-ID: <521B1B56.8060903@atmel.com>
Date: Mon, 26 Aug 2013 17:09:42 +0800
From: Bo Shen <voice.shen@atmel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Boris BREZILLON <b.brezillon@overkiz.com>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] net/cadence/macb: fix kernel Oops if no PHY were discovered
 during probe
References: <1377372065-8938-1-git-send-email-b.brezillon@overkiz.com>
In-Reply-To: <1377372065-8938-1-git-send-email-b.brezillon@overkiz.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.168.5.13]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Boris,

On 08/25/2013 03:21 AM, Boris BREZILLON wrote:
> Test the presence of a PHY device before printing attached PHY
> informations.
>
> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
> ---
>   drivers/net/ethernet/cadence/macb.c |    6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/ethernet/cadence/macb.c b/drivers/net/ethernet/cadence/macb.c
> index e866608..fd3b67f 100644
> --- a/drivers/net/ethernet/cadence/macb.c
> +++ b/drivers/net/ethernet/cadence/macb.c
> @@ -1868,8 +1868,10 @@ static int __init macb_probe(struct platform_device *pdev)
>   		    dev->irq, dev->dev_addr);
>
>   	phydev = bp->phy_dev;
> -	netdev_info(dev, "attached PHY driver [%s] (mii_bus:phy_addr=%s, irq=%d)\n",
> -		    phydev->drv->name, dev_name(&phydev->dev), phydev->irq);
> +	if (phydev)
> +		netdev_info(dev, "attached PHY driver [%s] (mii_bus:phy_addr=%s, irq=%d)\n",
> +			    phydev->drv->name, dev_name(&phydev->dev),
> +			    phydev->irq);

Actually no need this check, if PHY is attached failed, the macb driver 
probe will fail, then it won't show this message.

>   	return 0;
>
>

Best Regards,
Bo Shen
