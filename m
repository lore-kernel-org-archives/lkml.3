Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753782Ab3L0PsJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 10:48:09 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:60501 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134Ab3L0PsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 10:48:07 -0500
Message-ID: <1388159283.12212.80.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH net-next 19/20] net: plip: slight optimization of addr
 compare
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Ding Tianhong <dingtianhong@huawei.com>
Cc: "David S. Miller" <davem@davemloft.net>, Netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 27 Dec 2013 07:48:03 -0800
In-Reply-To: <52BD22ED.4030302@huawei.com>
References: <52BD22ED.4030302@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-12-27 at 14:49 +0800, Ding Tianhong wrote:
> Use possibly more efficient ether_addr_equal
> to instead of memcmp.
> 
> Cc: "David S. Miller" <davem@davemloft.net>
> Signed-off-by: Ding Tianhong <dingtianhong@huawei.com>
> ---
>  drivers/net/plip/plip.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/plip/plip.c b/drivers/net/plip/plip.c
> index 7b4ff35..26614df 100644
> --- a/drivers/net/plip/plip.c
> +++ b/drivers/net/plip/plip.c
> @@ -549,7 +549,7 @@ static __be16 plip_type_trans(struct sk_buff *skb, struct net_device *dev)
>  
>  	if(*eth->h_dest&1)
>  	{
> -		if(memcmp(eth->h_dest,dev->broadcast, ETH_ALEN)==0)
> +		if(ether_addr_equal(eth->h_dest, dev->broadcast))
>  			skb->pkt_type=PACKET_BROADCAST;
>  		else
>  			skb->pkt_type=PACKET_MULTICAST;

What about :

        if (is_multicast_ether_addr(eth->h_dest)) {
                if (ether_addr_equal_64bits(eth->h_dest, dev->broadcast))
                        skb->pkt_type = PACKET_BROADCAST;
                else
                        skb->pkt_type = PACKET_MULTICAST;
        }



