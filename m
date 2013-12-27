Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781Ab3L0UMo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 15:12:44 -0500
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:51382
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754728Ab3L0UMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 15:12:42 -0500
X-IronPort-AV: E=Sophos;i="4.95,562,1384297200"; 
   d="scan'208";a="42485766"
Date: Fri, 27 Dec 2013 21:12:37 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: Joe Perches <joe@perches.com>
cc: Eric Dumazet <eric.dumazet@gmail.com>, Julia Lawall <julia.lawall@lip6.fr>,
        Ding Tianhong <dingtianhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 19/20] net: plip: slight optimization of addr
 compare
In-Reply-To: <1388163982.30298.12.camel@joe-AO722>
Message-ID: <alpine.DEB.2.02.1312272112110.2018@localhost6.localdomain6>
References: <52BD22ED.4030302@huawei.com>  <1388159283.12212.80.camel@edumazet-glaptop2.roam.corp.google.com> <1388163982.30298.12.camel@joe-AO722>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Dec 2013, Joe Perches wrote:

> On Fri, 2013-12-27 at 07:48 -0800, Eric Dumazet wrote:
> > On Fri, 2013-12-27 at 14:49 +0800, Ding Tianhong wrote:
> > > Use possibly more efficient ether_addr_equal
> > > to instead of memcmp.
> []
> > > diff --git a/drivers/net/plip/plip.c b/drivers/net/plip/plip.c
> []
> > > @@ -549,7 +549,7 @@ static __be16 plip_type_trans(struct sk_buff *skb, struct net_device *dev)
> > >  
> > >  	if(*eth->h_dest&1)
> > >  	{
> > > -		if(memcmp(eth->h_dest,dev->broadcast, ETH_ALEN)==0)
> > > +		if(ether_addr_equal(eth->h_dest, dev->broadcast))
> > >  			skb->pkt_type=PACKET_BROADCAST;
> > >  		else
> > >  			skb->pkt_type=PACKET_MULTICAST;
> > 
> > What about :
> > 
> >         if (is_multicast_ether_addr(eth->h_dest)) {
> >                 if (ether_addr_equal_64bits(eth->h_dest, dev->broadcast))
> >                         skb->pkt_type = PACKET_BROADCAST;
> >                 else
> >                         skb->pkt_type = PACKET_MULTICAST;
> >         }
> 
> That is better though I wonder how many systems are
> still using laplink via parallel null-printer cables.
> 
> No matter, better is better.
> 
> The same optimization using ether_addr_equal_64bits
> may be possible to do in other places given other
> structs too.
> 
> Perhaps it's a possible spatch/coccinelle conversion,
> 
> I don't know spatch well enough to know if a
> mechanism to check if structure members have other
> fields that follow them in the structure or if the
> structure member is an array of a minimum size.
> 
> Maybe Julia does.  (cc'd)

I'm not sure to competely understand the issues.  Could you explain more?

thanks,
julia
