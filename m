Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755039Ab3IYTh4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 15:37:56 -0400
Received: from smtprelay0152.hostedemail.com ([216.40.44.152]:50048 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754894Ab3IYThx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 15:37:53 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1541:1711:1730:1747:1777:1792:2194:2199:2393:2559:2562:3138:3139:3140:3141:3142:3352:3865:3866:3867:3868:3870:3871:4321:4605:5007:6261:7903:10004:10026:10848:11658:11914:12043:12438:12517:12519:12555:13161:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: soup70_7e9bdce79d148
X-Filterd-Recvd-Size: 1988
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
        Shreyas Bhatewara <sbhatewara@vmware.com>,
        "VMware, Inc." <pv-drivers@vmware.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 01/11] vmxnet3: Remove extern from function prototypes
Date: Wed, 25 Sep 2013 12:37:19 -0700
Message-Id: <d8dea1eb36bcc004416b9587f09730430905e5b7.1380137609.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1380137609.git.joe@perches.com>
References: <cover.1380137609.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are a mix of function prototypes with and without extern
in the kernel sources.  Standardize on not using extern for
function prototypes.

Function prototypes don't need to be written with extern.
extern is assumed by the compiler.  Its use is as unnecessary as
using auto to declare automatic/local variables in a block.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/vmxnet3/vmxnet3_int.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/vmxnet3/vmxnet3_int.h b/drivers/net/vmxnet3/vmxnet3_int.h
index a03f358..12040a3 100644
--- a/drivers/net/vmxnet3/vmxnet3_int.h
+++ b/drivers/net/vmxnet3/vmxnet3_int.h
@@ -410,9 +410,9 @@ int
 vmxnet3_create_queues(struct vmxnet3_adapter *adapter,
 		      u32 tx_ring_size, u32 rx_ring_size, u32 rx_ring2_size);
 
-extern void vmxnet3_set_ethtool_ops(struct net_device *netdev);
+void vmxnet3_set_ethtool_ops(struct net_device *netdev);
 
-extern struct rtnl_link_stats64 *
+struct rtnl_link_stats64 *
 vmxnet3_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *stats);
 
 extern char vmxnet3_driver_name[];
-- 
1.8.1.2.459.gbcd45b4.dirty

