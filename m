Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752073AbaJSRXS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 13:23:18 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:54973 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537AbaJSRXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 13:23:16 -0400
Date: Sun, 19 Oct 2014 13:23:14 -0400 (EDT)
Message-Id: <20141019.132314.264021750039480460.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Networking
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sun, 19 Oct 2014 10:23:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


A quick batch of bug fixes:

1) Fix build with IPV6 disabled, from Eric Dumazet.

2) Several more cases of caching SKB data pointers across
   calls to pskb_may_pull(), thus referencing potentially
   free'd memory.  From Li RongQing.

3) DSA phy code tests operation presence improperly, instead
   of going:

	if (x->ops->foo)
		r = x->ops->foo(args);

   it was going:

	if (x->ops->foo(args))
		r = x->ops->foo(args);

   Fix from Andew Lunn.

Please pull, thanks a lot.

The following changes since commit f2d9da1a8375cbe53df5b415d059429013a3a79f:

  bna: fix skb->truesize underestimation (2014-10-17 23:56:33 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git master

for you to fetch changes up to 228b16cb13dfa2f77354a9b144a07e86e2dda01c:

  Net: DSA: Fix checking for get_phy_flags function (2014-10-19 12:46:31 -0400)

----------------------------------------------------------------
Andrew Lunn (1):
      Net: DSA: Fix checking for get_phy_flags function

Eric Dumazet (1):
      tcp: fix build error if IPv6 is not enabled

Li RongQing (3):
      ipv4: fix a potential use after free in gre_offload.c
      ipv6: fix a potential use after free in ip6_offload.c
      ipv6: fix a potential use after free in sit.c

 include/net/tcp.h      | 2 ++
 net/dsa/slave.c        | 2 +-
 net/ipv4/gre_offload.c | 6 +++---
 net/ipv6/ip6_offload.c | 1 +
 net/ipv6/sit.c         | 6 +++---
 5 files changed, 10 insertions(+), 7 deletions(-)
