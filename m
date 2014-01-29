Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940AbaA2Gqw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 01:46:52 -0500
Received: from mail-oa0-f47.google.com ([209.85.219.47]:43274 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbaA2Gqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 01:46:51 -0500
Message-ID: <52E8A407.1020809@gmail.com>
Date: Tue, 28 Jan 2014 22:47:35 -0800
From: Florian Fainelli <f.fainelli@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Max Filippov <jcmvbkbc@gmail.com>, linux-xtensa@linux-xtensa.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
CC: Chris Zankel <chris@zankel.net>, Marc Gauthier <marc@cadence.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [PATCH v2 2/4] net: ethoc: don't advertise gigabit speed on attached
 PHY
References: <1390975218-13863-1-git-send-email-jcmvbkbc@gmail.com> <1390975218-13863-3-git-send-email-jcmvbkbc@gmail.com>
In-Reply-To: <1390975218-13863-3-git-send-email-jcmvbkbc@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Max,

Le 28/01/2014 22:00, Max Filippov a écrit :
> OpenCores 10/100 Mbps MAC does not support speeds above 100 Mbps, but does
> not disable advertisement when PHY supports them. This results in
> non-functioning network when the MAC is connected to a gigabit PHY connected
> to a gigabit switch.
>
> The fix is to disable gigabit speed advertisement on attached PHY
> unconditionally.
>
> Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
> ---
> Changes v1->v2:
> - disable both gigabit advertisement and support.
>
>   drivers/net/ethernet/ethoc.c | 8 ++++++++
>   1 file changed, 8 insertions(+)
>
> diff --git a/drivers/net/ethernet/ethoc.c b/drivers/net/ethernet/ethoc.c
> index 4de8cfd..5643b2d 100644
> --- a/drivers/net/ethernet/ethoc.c
> +++ b/drivers/net/ethernet/ethoc.c
> @@ -688,6 +688,14 @@ static int ethoc_mdio_probe(struct net_device *dev)
>   	}
>
>   	priv->phy = phy;
> +	phy_update_advert(phy,
> +			  ADVERTISED_1000baseT_Full |
> +			  ADVERTISED_1000baseT_Half, 0);
> +	phy_start_aneg(phy);

This does not look necessary, you should not have to call 
phy_start_aneg() because the PHY state machine is not yet started, at 
best this calls does nothing.

> +	phy_update_supported(phy,
> +			     SUPPORTED_1000baseT_Full |
> +			     SUPPORTED_1000baseT_Half, 0);
> +
>   	return 0;
>   }
>
>

