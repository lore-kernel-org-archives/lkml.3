Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936486Ab3DRTJO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 15:09:14 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:55675 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359Ab3DRTJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 15:09:13 -0400
Date: Thu, 18 Apr 2013 15:09:10 -0400 (EDT)
Message-Id: <20130418.150910.1780951630545456624.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: vitalyb@telenet.dn.ua, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, fubar@us.ibm.com, linux@8192.net
Subject: Re: Bonding driver has bad load balancing for forwarded traffic,
 3.7+
From: David Miller <davem@davemloft.net>
In-Reply-To: <1366081404.4459.127.camel@edumazet-glaptop>
References: <516C075E.30105@telenet.dn.ua>
	<1366072679.4459.113.camel@edumazet-glaptop>
	<1366081404.4459.127.camel@edumazet-glaptop>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Thu, 18 Apr 2013 12:09:12 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Mon, 15 Apr 2013 20:03:24 -0700

> [PATCH] bonding: fix l23 and l34 load balancing in forwarding path
> 
> Since commit 6b923cb7188d46 (bonding: support for IPv6 transmit hashing)
> bonding doesn't properly hash traffic in forwarding setups.
> 
> Vitaly V. Bursov diagnosed that skb_network_header_len() returned 0 in
> this case.
> 
> More generally, the transport header might not be in the skb head.
> 
> Use pskb_may_pull() & skb_header_pointer() to get it right, and use
> proto_ports_offset() in bond_xmit_hash_policy_l34() to get support for
> more protocols than TCP and UDP.
> 
> Reported-by: Vitaly V. Bursov <vitalyb@telenet.dn.ua>
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Applied and queued up for -stable, but:

> +						sizeof(_l4), &_l4);						
                                                                   ^^^^^^^^^^^^^^^^^^^^^^^^^

That's some rather amazing trailing whitespace.  Are you trying to break
free of earth's atmosphere? :-)
