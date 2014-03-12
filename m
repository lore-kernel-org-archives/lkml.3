Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756134AbaCLRW5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 13:22:57 -0400
Received: from smtprelay0033.hostedemail.com ([216.40.44.33]:56598 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756093AbaCLRWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 13:22:54 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1540:1711:1730:1747:1777:1792:2393:2559:2562:2904:3138:3139:3140:3141:3142:3352:3865:3866:5007:6261:7903:10004:10026:10848:11026:11657:11658:11914:12043:12438:12517:12519:12555:13161:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCach
X-HE-Tag: smile73_8d3d015753647
X-Filterd-Recvd-Size: 2120
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
Subject: [PATCH net-next 2/9] e100: Convert uses of __constant_<foo> to <foo>
Date: Wed, 12 Mar 2014 10:22:31 -0700
Message-Id: <b7d59e4e50e0e90546ca66d2865d52552be1e553.1394644825.git.joe@perches.com>
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
 drivers/net/ethernet/intel/e100.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/e100.c b/drivers/net/ethernet/intel/e100.c
index bf7a01e..b56461c 100644
--- a/drivers/net/ethernet/intel/e100.c
+++ b/drivers/net/ethernet/intel/e100.c
@@ -1778,9 +1778,9 @@ static int e100_xmit_prepare(struct nic *nic, struct cb *cb,
 	 * testing, ie sending frames with bad CRC.
 	 */
 	if (unlikely(skb->no_fcs))
-		cb->command |= __constant_cpu_to_le16(cb_tx_nc);
+		cb->command |= cpu_to_le16(cb_tx_nc);
 	else
-		cb->command &= ~__constant_cpu_to_le16(cb_tx_nc);
+		cb->command &= ~cpu_to_le16(cb_tx_nc);
 
 	/* interrupt every 16 packets regardless of delay */
 	if ((nic->cbs_avail & ~15) == nic->cbs_avail)
-- 
1.8.1.2.459.gbcd45b4.dirty

