Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754999Ab3JPOhm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 10:37:42 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:38388 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074Ab3JPOhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 10:37:41 -0400
Message-ID: <1381934259.2045.130.camel@edumazet-glaptop.roam.corp.google.com>
Subject: Re: [PATCH 1/6] net: ip4_datagram_connect: Use correct form of
 statistics update
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org,
        rostedt@goodmis.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <edumazet@google.com>, David Miller <davem@davemloft.net>
Date: Wed, 16 Oct 2013 07:37:39 -0700
In-Reply-To: <00000141c1a9a88d-2fe8384a-435c-4c40-bafd-c3fc04960783-000000@email.amazonses.com>
References: <20131015174722.615394057@linux.com>
	 <20131015174745.197380080@linux.com>
	 <20131016083545.GP10651@twins.programming.kicks-ass.net>
	 <1381914869.2045.112.camel@edumazet-glaptop.roam.corp.google.com>
	 <20131016092601.GB23440@gmail.com>
	 <00000141c1a9a88d-2fe8384a-435c-4c40-bafd-c3fc04960783-000000@email.amazonses.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-10-16 at 14:27 +0000, Christoph Lameter wrote:
> Same issue in ipv6 code.
> 
> 
> Subject: net: Fix statistics update in ip6
> 
> ipv6 does the same as ipv4. IP6_INC_STATS must be used outside
> of BH sections.
> 
> Signed-off-by: Christoph Lameter <cl@linux.com>
> 

Missing separator "---"

> Index: linux/net/ipv6/ip6_output.c
> ===================================================================
> --- linux.orig/net/ipv6/ip6_output.c	2013-10-10 11:01:01.119771564 -0500
> +++ linux/net/ipv6/ip6_output.c	2013-10-16 08:48:19.474562100 -0500
> @@ -909,7 +909,7 @@ static int ip6_dst_lookup_tail(struct so
> 
>  out_err_release:
>  	if (err == -ENETUNREACH)
> -		IP6_INC_STATS_BH(net, NULL, IPSTATS_MIB_OUTNOROUTES);
> +		IP6_INC_STATS(net, NULL, IPSTATS_MIB_OUTNOROUTES);
>  	dst_release(*dst);
>  	*dst = NULL;
>  	return err;

Yes, bug added in commit ca46f9c834913fc5
("[IPv6] SNMP: Increment OutNoRoutes when connecting to unreachable
network")

Your inability to cc netdev for netdev patches is really irritating,
you do know that, right ?



