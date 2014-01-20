Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753291AbaATRw3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 12:52:29 -0500
Received: from smtprelay0126.hostedemail.com ([216.40.44.126]:55010 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752156AbaATRw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 12:52:26 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1541:1711:1730:1747:1777:1792:2198:2199:2393:2553:2559:2562:2693:2915:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3871:3872:3873:3874:4321:4605:5007:6119:6261:7576:7903:10004:10026:10848:10967:11026:11232:11658:11914:12050:12438:12517:12519:12679:12740:13161:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: nose58_322d96d9acd4f
X-Filterd-Recvd-Size: 2280
From: Joe Perches <joe@perches.com>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/7] net: Convert aligned memcpy to ether_addr_copy
Date: Mon, 20 Jan 2014 09:52:13 -0800
Message-Id: <cover.1390239869.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <20140115.164540.450877805879786067.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-01-15 at 16:45 -0800, David Miller wrote:
From: Joe Perches <joe@perches.com>
> Date: Wed, 15 Jan 2014 16:07:58 -0800
> 
> > If you want the ones for net-next net/ now (but not
> > for batman-adv, that maybe could use a new function like
> > ether_addr_copy_unaligned) here's a changestat.
> > 
> > Otherwise, I'll wait for the next cycle.
> 
> This looks fine, why don't you toss it my way over the weekend as I
> still have some backlog to process at the moment?
 
I didn't get that done this weekend, so next cycle
for most of net/.

I don't want to introduce any breakage this late and
there are possible unaligned memcpy(foo, bar, ETH_ALEN)
where one or both of foo/bar are stack pointers where
the alignment is hard to verify.

There are also statics declared without __aligned(2)
that will need updating.

Maybe ether_addr_copy_unaligned should be added too.

Here are the ones I could easily verify...
No worries if it's this cycle or next.

Joe Perches (7):
  8021q: Use ether_addr_copy
  appletalk: Use ether_addr_copy
  atm: Use ether_addr_copy
  caif_usb: Use ether_addr_copy
  netpoll: Use ether_addr_copy
  pktgen: Use ether_addr_copy
  dsa: Use ether_addr_copy

 net/8021q/vlan.c     |  2 +-
 net/8021q/vlan_dev.c |  6 +++---
 net/appletalk/aarp.c | 12 ++++++------
 net/atm/lec.c        |  9 +++++----
 net/atm/mpc.c        |  2 +-
 net/caif/caif_usb.c  |  4 ++--
 net/core/netpoll.c   |  4 ++--
 net/core/pktgen.c    |  8 ++++----
 net/dsa/slave.c      |  2 +-
 9 files changed, 25 insertions(+), 24 deletions(-)

-- 
1.8.1.2.459.gbcd45b4.dirty

