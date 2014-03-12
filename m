Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756209AbaCLRXH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 13:23:07 -0400
Received: from smtprelay0221.hostedemail.com ([216.40.44.221]:43317 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751674AbaCLRXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 13:23:03 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1541:1711:1714:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3351:3865:3866:5007:6261:10004:10026:10848:11026:11473:11657:11658:11914:12043:12296:12438:12517:12519:12555:13161:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,Dom
X-HE-Tag: rice51_8eaab2cce445a
X-Filterd-Recvd-Size: 2241
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        Greg Rose <gregory.v.rose@intel.com>,
        Alex Duyck <alexander.h.duyck@intel.com>,
        John Ronciak <john.ronciak@intel.com>,
        Mitch Williams <mitch.a.williams@intel.com>,
        e1000-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 4/9] igbvf: Convert uses of __constant_<foo> to <foo>
Date: Wed, 12 Mar 2014 10:22:33 -0700
Message-Id: <52ad53c6822c19de67480e8b3e36201a30cab308.1394644825.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1394644825.git.joe@perches.com>
References: <cover.1394644825.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The use of __constant_<foo> has been unnecessary for quite awhile now.

Make these uses consistent with the rest of the kernel.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/ethernet/intel/igbvf/netdev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/igbvf/netdev.c b/drivers/net/ethernet/intel/igbvf/netdev.c
index e2c6d80..b7ab03a 100644
--- a/drivers/net/ethernet/intel/igbvf/netdev.c
+++ b/drivers/net/ethernet/intel/igbvf/netdev.c
@@ -2014,12 +2014,12 @@ static inline bool igbvf_tx_csum(struct igbvf_adapter *adapter,
 
 		if (skb->ip_summed == CHECKSUM_PARTIAL) {
 			switch (skb->protocol) {
-			case __constant_htons(ETH_P_IP):
+			case htons(ETH_P_IP):
 				tu_cmd |= E1000_ADVTXD_TUCMD_IPV4;
 				if (ip_hdr(skb)->protocol == IPPROTO_TCP)
 					tu_cmd |= E1000_ADVTXD_TUCMD_L4T_TCP;
 				break;
-			case __constant_htons(ETH_P_IPV6):
+			case htons(ETH_P_IPV6):
 				if (ipv6_hdr(skb)->nexthdr == IPPROTO_TCP)
 					tu_cmd |= E1000_ADVTXD_TUCMD_L4T_TCP;
 				break;
-- 
1.8.1.2.459.gbcd45b4.dirty

