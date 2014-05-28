Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097AbaE1OIL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 10:08:11 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:52471 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752584AbaE1OIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 10:08:09 -0400
Message-ID: <5385EDCD.5030001@cogentembedded.com>
Date: Wed, 28 May 2014 18:08:13 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Ondrej Zary <linux@rainbow-software.org>,
        Samuel Chessman <chessman@tux.org>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/9] tlan: Restart autonegotiation on link loss
References: <1401226727-5508-1-git-send-email-linux@rainbow-software.org> <1401226727-5508-6-git-send-email-linux@rainbow-software.org>
In-Reply-To: <1401226727-5508-6-git-send-email-linux@rainbow-software.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 05/28/2014 01:38 AM, Ondrej Zary wrote:

> When link is lost on a card which uses internal PHY for 10 Mbit speeds,
> restart autonegotiation to allow switching between 10 and 100 Mbps speeds.

> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
> ---
>   drivers/net/ethernet/ti/tlan.c |   14 ++++++++++++++
>   1 file changed, 14 insertions(+)

> diff --git a/drivers/net/ethernet/ti/tlan.c b/drivers/net/ethernet/ti/tlan.c
> index 31d4a96..1047b3f 100644
> --- a/drivers/net/ethernet/ti/tlan.c
> +++ b/drivers/net/ethernet/ti/tlan.c
[...]
> @@ -2788,6 +2789,19 @@ static void tlan_phy_monitor(unsigned long data)
>   			       dev->name);
>   			tlan_dio_write8(dev->base_addr, TLAN_LED_REG, 0);
>   			netif_carrier_off(dev);
> +			if (priv->adapter->flags & TLAN_ADAPTER_USE_INTERN_10) {
> +				/* power down internal PHY */
> +				u16 data = MII_GC_PDOWN | MII_GC_LOOPBK
> +					| MII_GC_ISOLATE;

    Please, leave | on the previosu line.

> +				tlan_mii_sync(dev->base_addr);
> +				tlan_mii_write_reg(dev, priv->phy[0],
> +					MII_GEN_CTL, data);

    Please start this line right under 'dev' on the previous one.

> +				/* set to external PHY */
> +				priv->phy_num = 1;
> +				/* restart autonegotiation */
> +				tlan_set_timer(dev, (4*HZ/10), TLAN_TIMER_PHY_PDOWN);

    Spaces around * and / wouldn't hurt for consistency.

> +				return;
> +			}
>   		}
>   	}

WBR, Sergei

