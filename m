Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934422Ab3GWW0Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 18:26:25 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:53600 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933350Ab3GWW0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 18:26:22 -0400
Message-ID: <51EF030B.70209@tilera.com>
Date: Tue, 23 Jul 2013 18:26:19 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH 09/13] tile: enable GRO in the tilegx network driver
References: <cover.1374609948.git.cmetcalf@tilera.com>  <1188c5613d72850983d54f3b6d0276f3a5aa98f0.1374609949.git.cmetcalf@tilera.com> <1374614351.3449.51.camel@edumazet-glaptop>
In-Reply-To: <1374614351.3449.51.camel@edumazet-glaptop>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/23/2013 5:19 PM, Eric Dumazet wrote:
> On Tue, 2013-07-23 at 16:05 -0400, Chris Metcalf wrote:
>> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
>> ---
>>  drivers/net/ethernet/tile/tilegx.c | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/ethernet/tile/tilegx.c b/drivers/net/ethernet/tile/tilegx.c
>> index b34fd2c..9c128ff 100644
>> --- a/drivers/net/ethernet/tile/tilegx.c
>> +++ b/drivers/net/ethernet/tile/tilegx.c
>> @@ -458,7 +458,7 @@ static void tile_net_receive_skb(struct net_device *dev, struct sk_buff *skb,
>>  	/* Get RX timestamp from idesc. */
>>  	tile_rx_timestamp(skb, idesc);
>>  
>> -	netif_receive_skb(skb);
>> +	napi_gro_receive(&info->napi, skb);
>>  
>>  	/* Update stats. */
>>  	tile_net_stats_add(1, &dev->stats.rx_packets);
>> @@ -1880,6 +1880,7 @@ static void tile_net_setup(struct net_device *dev)
>>  	dev->features |= NETIF_F_HW_CSUM;
>>  	dev->features |= NETIF_F_SG;
>>  	dev->features |= NETIF_F_TSO;
>> +	dev->features |= NETIF_F_GRO;
> This line should not be needed
>
> register_netdevice() does it for all devices :
>
> dev->hw_features |= NETIF_F_SOFT_FEATURES;
> dev->features |= NETIF_F_SOFT_FEATURES;

Thanks; I removed the line from my tile-net-next tree so it will get pulled without it.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

