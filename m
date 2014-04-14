Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591AbaDNSTa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 14:19:30 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:57222 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbaDNST2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 14:19:28 -0400
Message-ID: <1397499566.4222.36.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [BUG] A panic caused by null pointer dereference aftering
 updating to
From: Eric Dumazet <eric.dumazet@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: nasa4836@gmail.com, jchapman@katalix.com, edumazet@google.com,
        joe@perches.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Date: Mon, 14 Apr 2014 11:19:26 -0700
In-Reply-To: <20140414.140253.788885546068554928.davem@davemloft.net>
References: <1397497204.4222.28.camel@edumazet-glaptop2.roam.corp.google.com>
	 <20140414.134901.2191404761213317963.davem@davemloft.net>
	 <1397498082.4222.29.camel@edumazet-glaptop2.roam.corp.google.com>
	 <20140414.140253.788885546068554928.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-04-14 at 14:02 -0400, David Miller wrote:

> BTW, it occurs to me that there may be some other spots in the output path
> that expect that if SKB is ETH_P_IP then skb->sk is IP socket.  For example
> somewhere in netfilter or packet classifier paths.
> 
> Just FYI... that was one of the things I was going to audit.

packet classifiers cannot have such assumptions for sure.

About iptunnel_xmit(), I do not think there is an issue, as we do not
enter ip_queue_xmit() on this path, but ip_local_out().

ip_local_out() doesn't use skb->sk , unless some netfilter module
uses this. I am not sure how the previous behavior could be useful in
this case, as all packets were sharing same socket ownership.

net/netfilter/xt_owner.c for example has better coverage if it can
really have a pointer to the user socket, not the internal socket used
by l2tp or vxlan tunnel.




