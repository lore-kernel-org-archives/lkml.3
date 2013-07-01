Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755329Ab3GAUgS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 16:36:18 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:43773 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755090Ab3GAUgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 16:36:16 -0400
Date: Mon, 01 Jul 2013 13:36:15 -0700 (PDT)
Message-Id: <20130701.133615.366371022223254228.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: joe.jin@oracle.com, frank.blaschka@de.ibm.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        zheng.x.li@oracle.com, xen-devel@lists.xen.org,
        Ian.Campbell@citrix.com, JBeulich@suse.com,
        stefano.stabellini@eu.citrix.com
Subject: Re: kernel panic in skb_copy_bits
From: David Miller <davem@davemloft.net>
In-Reply-To: <1372412262.3301.251.camel@edumazet-glaptop>
References: <51CD0E67.4000008@oracle.com>
	<1372402340.3301.229.camel@edumazet-glaptop>
	<1372412262.3301.251.camel@edumazet-glaptop>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Fri, 28 Jun 2013 02:37:42 -0700

> [PATCH] neighbour: fix a race in neigh_destroy()
> 
> There is a race in neighbour code, because neigh_destroy() uses
> skb_queue_purge(&neigh->arp_queue) without holding neighbour lock,
> while other parts of the code assume neighbour rwlock is what
> protects arp_queue
> 
> Convert all skb_queue_purge() calls to the __skb_queue_purge() variant
> 
> Use __skb_queue_head_init() instead of skb_queue_head_init()
> to make clear we do not use arp_queue.lock
> 
> And hold neigh->lock in neigh_destroy() to close the race.
> 
> Reported-by: Joe Jin <joe.jin@oracle.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Applied and queued up for -stable, thanks Eric.
