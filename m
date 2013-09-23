Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754452Ab3IWWLy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 18:11:54 -0400
Received: from smtprelay0002.hostedemail.com ([216.40.44.2]:48430 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754412Ab3IWWLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 18:11:51 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1542:1711:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3353:3865:3866:3867:3868:3870:3871:5007:6261:7903:10004:10026:10848:11473:11657:11658:11914:12043:12438:12517:12519:12555:13161:13229:13972,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: field77_2d0d8b606315c
X-Filterd-Recvd-Size: 3732
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        Jay Cliburn <jcliburn@gmail.com>, Chris Snook <chris.snook@gmail.com>
Subject: [PATCH 05/10] atheros: Remove extern from function prototypes
Date: Mon, 23 Sep 2013 15:11:32 -0700
Message-Id: <b7bf26665e0378a3ec9d4450daf60dc115f75e49.1379974101.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <5570169a078375fa8662adeb2a7f24c1ae718bfb.1379974101.git.joe@perches.com>
References: <5570169a078375fa8662adeb2a7f24c1ae718bfb.1379974101.git.joe@perches.com>
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
 drivers/net/ethernet/atheros/atl1c/atl1c.h |  6 +++---
 drivers/net/ethernet/atheros/atl1e/atl1e.h | 12 ++++++------
 drivers/net/ethernet/atheros/atlx/atl2.h   |  2 +-
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c.h b/drivers/net/ethernet/atheros/atl1c/atl1c.h
index 0f05565..7f9369a 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c.h
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c.h
@@ -600,7 +600,7 @@ struct atl1c_adapter {
 extern char atl1c_driver_name[];
 extern char atl1c_driver_version[];
 
-extern void atl1c_reinit_locked(struct atl1c_adapter *adapter);
-extern s32 atl1c_reset_hw(struct atl1c_hw *hw);
-extern void atl1c_set_ethtool_ops(struct net_device *netdev);
+void atl1c_reinit_locked(struct atl1c_adapter *adapter);
+s32 atl1c_reset_hw(struct atl1c_hw *hw);
+void atl1c_set_ethtool_ops(struct net_device *netdev);
 #endif /* _ATL1C_H_ */
diff --git a/drivers/net/ethernet/atheros/atl1e/atl1e.h b/drivers/net/ethernet/atheros/atl1e/atl1e.h
index b5fd934..1b0fe2d 100644
--- a/drivers/net/ethernet/atheros/atl1e/atl1e.h
+++ b/drivers/net/ethernet/atheros/atl1e/atl1e.h
@@ -499,10 +499,10 @@ struct atl1e_adapter {
 extern char atl1e_driver_name[];
 extern char atl1e_driver_version[];
 
-extern void atl1e_check_options(struct atl1e_adapter *adapter);
-extern int atl1e_up(struct atl1e_adapter *adapter);
-extern void atl1e_down(struct atl1e_adapter *adapter);
-extern void atl1e_reinit_locked(struct atl1e_adapter *adapter);
-extern s32 atl1e_reset_hw(struct atl1e_hw *hw);
-extern void atl1e_set_ethtool_ops(struct net_device *netdev);
+void atl1e_check_options(struct atl1e_adapter *adapter);
+int atl1e_up(struct atl1e_adapter *adapter);
+void atl1e_down(struct atl1e_adapter *adapter);
+void atl1e_reinit_locked(struct atl1e_adapter *adapter);
+s32 atl1e_reset_hw(struct atl1e_hw *hw);
+void atl1e_set_ethtool_ops(struct net_device *netdev);
 #endif /* _ATL1_E_H_ */
diff --git a/drivers/net/ethernet/atheros/atlx/atl2.h b/drivers/net/ethernet/atheros/atlx/atl2.h
index 3ebe19f..2f27d4c 100644
--- a/drivers/net/ethernet/atheros/atlx/atl2.h
+++ b/drivers/net/ethernet/atheros/atlx/atl2.h
@@ -42,7 +42,7 @@
 #include "atlx.h"
 
 #ifdef ETHTOOL_OPS_COMPAT
-extern int ethtool_ioctl(struct ifreq *ifr);
+int ethtool_ioctl(struct ifreq *ifr);
 #endif
 
 #define PCI_COMMAND_REGISTER	PCI_COMMAND
-- 
1.8.1.2.459.gbcd45b4.dirty

