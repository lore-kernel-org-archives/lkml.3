Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755167Ab3BBKFO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 05:05:14 -0500
Received: from mail-ea0-f180.google.com ([209.85.215.180]:43879 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753661Ab3BBKFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 05:05:10 -0500
Date: Sat, 2 Feb 2013 11:05:06 +0100
From: Jiri Pirko <jiri@resnulli.us>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        =?utf-8?B?IllPU0hJRlVKSSBIaWRlYWtpIC8g5ZCJ6Jek6Iux5piOIg==?= 
	<yoshfuji@linux-ipv6.org>
Subject: Re: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20130202100506.GB1864@minipsycho.orion>
References: <20130202142253.e31167bf695f000c0c78f4cc@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130202142253.e31167bf695f000c0c78f4cc@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sat, Feb 02, 2013 at 04:22:53AM CET, sfr@canb.auug.org.au wrote:
>Hi all,
>
>Today's linux-next merge of the net-next tree got a conflict in
>net/ipv6/route.c between commit bd30e947207e ("ipv6: do not create
>neighbor entries for local delivery") from the net tree and commit
>c440f1609b65 ("ipv6: Do not depend on rt->n in ip6_pol_route()") from the
>net-next tree.
>
>I fixed it up (I think - see below) and can carry the fix as necessary
>(no action is required).
>
>-- 
>Cheers,
>Stephen Rothwell                    sfr@canb.auug.org.au
>
>diff --cc net/ipv6/route.c
>index 363d8b7,f3328bc..0000000
>--- a/net/ipv6/route.c
>+++ b/net/ipv6/route.c
>@@@ -928,7 -884,7 +884,7 @@@ restart
>  	dst_hold(&rt->dst);
>  	read_unlock_bh(&table->tb6_lock);
>  
>- 	if (!rt->n && !(rt->rt6i_flags & (RTF_NONEXTHOP | RTF_LOCAL)))
> -	if (!(rt->rt6i_flags & (RTF_NONEXTHOP | RTF_GATEWAY)))
>++	if (!(rt->rt6i_flags & (RTF_NONEXTHOP | RTF_LOCAL | RTF_GATEWAY)))

I believe that no change here is correct to do. RTF_LOCAL here is needed
only before Yoshifuji's "IPv6 rt->n removal"
	
	
>  		nrt = rt6_alloc_cow(rt, &fl6->daddr, &fl6->saddr);
>  	else if (!(rt->dst.flags & DST_HOST))
>  		nrt = rt6_alloc_clone(rt, &fl6->daddr);


