Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751560AbaEBDOV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 23:14:21 -0400
Received: from mout.web.de ([212.227.17.12]:62405 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750798AbaEBDOU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 23:14:20 -0400
Date: Fri, 2 May 2014 05:14:05 +0200
From: Linus =?utf-8?Q?L=C3=BCssing?= <linus.luessing@web.de>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        stephen@networkplumber.org, linux-kernel@vger.kernel.org,
        hannes@stressinduktion.org
Subject: Re: [PATCH] bridge: simplify a br_multicast_query_received()
 function call
Message-ID: <20140502031404.GR4593@Linus-Debian>
References: <1398106775-14857-1-git-send-email-linus.luessing@web.de>
 <20140423.144748.1259564888396787227.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140423.144748.1259564888396787227.davem@davemloft.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Provags-ID: V03:K0:51mHUCpS9xPv8nLgAquUNFRVC/9AKJMticpC/65YhxRf71PIA6r
 EudAIW/rIg1LrA5RTKAx6o4Qtq3pFr0GIpEcg5fY1/LCtGhTUmWDifZY23lMi7/ds0cvX7o
 sJCq1nghmtbLkO4W9wa3p7dnyuEH8dkoTd23hZjnduHISwy19OA6OgeK9MeaiILtxDQ39uT
 T1Jp1CNGWBLr+QW/dkG2g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 02:47:48PM -0400, David Miller wrote:
> > --- a/net/bridge/br_multicast.c
> > +++ b/net/bridge/br_multicast.c
> > @@ -1282,8 +1282,7 @@ static int br_ip6_multicast_query(struct net_bridge *br,
> >  		goto out;
> >  	}
> >  
> > -	br_multicast_query_received(br, port, &br->ip6_querier,
> > -				    !ipv6_addr_any(&ip6h->saddr),
> > +	br_multicast_query_received(br, port, &br->ip6_querier, 1,
> >  				    is_general_query, max_delay);
> >  
> >  	if (!group)
> 
> This doesn't make any sense to me, is_general_query can be false at this
> point.

This change has nothing to do with is_general_query, the fifth
argument. I'm modifying the fourth, the is_saddr flag. As Hannes
has pointed out here [0], now that we make sure that we have a
link-local IPv6 address at the beginning of
br_ip6_multicast_query() this implies that the source address is
not '::'.

> 
> Furthermore, even if your change would be correct, the argument is a
> boolean not an integer.

Semantically yes. Syntactically the fourth argument is an integer
at the moment (unnecessarily). Should I change 'int saddr' to
'bool saddr' while at it, within the same patch?

Cheers
