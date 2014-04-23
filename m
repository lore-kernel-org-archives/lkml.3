Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206AbaDWSrz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 14:47:55 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:50741 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbaDWSrx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 14:47:53 -0400
Date: Wed, 23 Apr 2014 14:47:48 -0400 (EDT)
Message-Id: <20140423.144748.1259564888396787227.davem@davemloft.net>
To: linus.luessing@web.de
Cc: netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        stephen@networkplumber.org, linux-kernel@vger.kernel.org,
        hannes@stressinduktion.org
Subject: Re: [PATCH] bridge: simplify a br_multicast_query_received()
 function call
From: David Miller <davem@davemloft.net>
In-Reply-To: <1398106775-14857-1-git-send-email-linus.luessing@web.de>
References: <1398106775-14857-1-git-send-email-linus.luessing@web.de>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 23 Apr 2014 11:47:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Lüssing <linus.luessing@web.de>
Date: Mon, 21 Apr 2014 20:59:35 +0200

> The call from the IPv6 part can be simplified as the beginning of the
> calling function ensures that we end up here when having a proper IPv6
> source address only.
> 
> Introduced by 6565b9eeef194afbb3beec80d6dd2447f4091f8c
> ("bridge: multicast: add sanity check for query source addresses")
> 
> Reported-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
> Signed-off-by: Linus Lüssing <linus.luessing@web.de>
> ---
>  net/bridge/br_multicast.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
> index 7b757b5..d2c3aae 100644
> --- a/net/bridge/br_multicast.c
> +++ b/net/bridge/br_multicast.c
> @@ -1282,8 +1282,7 @@ static int br_ip6_multicast_query(struct net_bridge *br,
>  		goto out;
>  	}
>  
> -	br_multicast_query_received(br, port, &br->ip6_querier,
> -				    !ipv6_addr_any(&ip6h->saddr),
> +	br_multicast_query_received(br, port, &br->ip6_querier, 1,
>  				    is_general_query, max_delay);
>  
>  	if (!group)

This doesn't make any sense to me, is_general_query can be false at this
point.

Furthermore, even if your change would be correct, the argument is a
boolean not an integer.
