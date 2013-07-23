Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758123Ab3GWVTO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 17:19:14 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:54128 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754929Ab3GWVTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 17:19:13 -0400
Message-ID: <1374614351.3449.51.camel@edumazet-glaptop>
Subject: Re: [PATCH 09/13] tile: enable GRO in the tilegx network driver
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Date: Tue, 23 Jul 2013 14:19:11 -0700
In-Reply-To: <1188c5613d72850983d54f3b6d0276f3a5aa98f0.1374609949.git.cmetcalf@tilera.com>
References: <cover.1374609948.git.cmetcalf@tilera.com>
	 <1188c5613d72850983d54f3b6d0276f3a5aa98f0.1374609949.git.cmetcalf@tilera.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-07-23 at 16:05 -0400, Chris Metcalf wrote:
> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
> ---
>  drivers/net/ethernet/tile/tilegx.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/tile/tilegx.c b/drivers/net/ethernet/tile/tilegx.c
> index b34fd2c..9c128ff 100644
> --- a/drivers/net/ethernet/tile/tilegx.c
> +++ b/drivers/net/ethernet/tile/tilegx.c
> @@ -458,7 +458,7 @@ static void tile_net_receive_skb(struct net_device *dev, struct sk_buff *skb,
>  	/* Get RX timestamp from idesc. */
>  	tile_rx_timestamp(skb, idesc);
>  
> -	netif_receive_skb(skb);
> +	napi_gro_receive(&info->napi, skb);
>  
>  	/* Update stats. */
>  	tile_net_stats_add(1, &dev->stats.rx_packets);
> @@ -1880,6 +1880,7 @@ static void tile_net_setup(struct net_device *dev)
>  	dev->features |= NETIF_F_HW_CSUM;
>  	dev->features |= NETIF_F_SG;
>  	dev->features |= NETIF_F_TSO;
> +	dev->features |= NETIF_F_GRO;

This line should not be needed

register_netdevice() does it for all devices :

dev->hw_features |= NETIF_F_SOFT_FEATURES;
dev->features |= NETIF_F_SOFT_FEATURES;


 


