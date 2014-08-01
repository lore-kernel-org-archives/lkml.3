Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374AbaHAFjt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 01:39:49 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:54552 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487AbaHAFjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 01:39:48 -0400
Date: Thu, 31 Jul 2014 22:39:46 -0700 (PDT)
Message-Id: <20140731.223946.2222491319947824077.davem@davemloft.net>
To: tgraf@suug.ch
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kaber@trash.net,
        paulmck@linux.vnet.ibm.com, josh@joshtriplett.org,
        challa@noironetworks.com, walpole@cs.pdx.edu, dev@openvswitch.org,
        tklauser@distanz.ch, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v2 0/3 net-next] Lockless netlink_lookup() with new
 concurrent hash table
From: David Miller <davem@davemloft.net>
In-Reply-To: <cover.1406846586.git.tgraf@suug.ch>
References: <cover.1406846586.git.tgraf@suug.ch>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 31 Jul 2014 22:39:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Graf <tgraf@suug.ch>
Date: Fri,  1 Aug 2014 00:56:00 +0200

> Netlink sockets are maintained in a hash table to allow efficient lookup
> via the port ID for unicast messages. However, lookups currently require
> a read lock to be taken. This series adds a new generic, resizable,
> scalable, concurrent hash table based on the paper referenced in the first
> patch. It then makes use of the new data type to implement lockless
> netlink_lookup().
> 
> Patch 3/3 to convert nft_hash is included for reference but should be
> merged via the netfilter tree. Inclusion in this series is to provide
> context for the suggested API.
> 
> Against net-next since the initial user of the new hash table is in net/
> 
> Changes:
> v1-v2:
>  - fixed traversal off-by-one as spotted by Tobias Klauser
>  - removed unlikely() from BUG_ON() as spotted by Josh Triplett
>  - new 3rd patch to convert nft_hash to rhashtable
>  - make rhashtable_insert() return void
>  - nl_sk_hash_lock must be a mutex
>  - fixed wrong name of rht_shrink_below_30()
>  - exported symbols rht_grow_above_75() and rht_shrink_below_30()
>  - allow table freeing with RCU callback

Looks great, series applied, thanks!
