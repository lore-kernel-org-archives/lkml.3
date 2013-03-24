Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779Ab3CXGKq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 02:10:46 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:38669 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690Ab3CXGKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 02:10:43 -0400
From: Kumar Amit Mehta <gmate.amit@gmail.com>
To: eilong@broadcom.com
Cc: davem@davemloft.net, dan.carpenter@oracle.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH v2] bnx2x: fix assignment of signed expression to unsigned variable
Date: Sat, 23 Mar 2013 23:10:25 -0700
Message-Id: <1364105425-8198-1-git-send-email-gmate.amit@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix for incorrect assignment of signed expression to unsigned variable.

Signed-off-by: Kumar Amit Mehta <gmate.amit@gmail.com>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_dcb.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_dcb.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_dcb.c
index 5682054..91ecd6a 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_dcb.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_dcb.c
@@ -2139,12 +2139,12 @@ static u8 bnx2x_dcbnl_get_cap(struct net_device *netdev, int capid, u8 *cap)
 			break;
 		default:
 			BNX2X_ERR("Non valid capability ID\n");
-			rval = -EINVAL;
+			rval = 1;
 			break;
 		}
 	} else {
 		DP(BNX2X_MSG_DCB, "DCB disabled\n");
-		rval = -EINVAL;
+		rval = 1;
 	}
 
 	DP(BNX2X_MSG_DCB, "capid %d:%x\n", capid, *cap);
@@ -2170,12 +2170,12 @@ static int bnx2x_dcbnl_get_numtcs(struct net_device *netdev, int tcid, u8 *num)
 			break;
 		default:
 			BNX2X_ERR("Non valid TC-ID\n");
-			rval = -EINVAL;
+			rval = 1;
 			break;
 		}
 	} else {
 		DP(BNX2X_MSG_DCB, "DCB disabled\n");
-		rval = -EINVAL;
+		rval = 1;
 	}
 
 	return rval;
@@ -2188,7 +2188,7 @@ static int bnx2x_dcbnl_set_numtcs(struct net_device *netdev, int tcid, u8 num)
 	return -EINVAL;
 }
 
-static u8  bnx2x_dcbnl_get_pfc_state(struct net_device *netdev)
+static u8 bnx2x_dcbnl_get_pfc_state(struct net_device *netdev)
 {
 	struct bnx2x *bp = netdev_priv(netdev);
 	DP(BNX2X_MSG_DCB, "state = %d\n", bp->dcbx_local_feat.pfc.enabled);
@@ -2390,12 +2390,12 @@ static u8 bnx2x_dcbnl_get_featcfg(struct net_device *netdev, int featid,
 			break;
 		default:
 			BNX2X_ERR("Non valid featrue-ID\n");
-			rval = -EINVAL;
+			rval = 1;
 			break;
 		}
 	} else {
 		DP(BNX2X_MSG_DCB, "DCB disabled\n");
-		rval = -EINVAL;
+		rval = 1;
 	}
 
 	return rval;
@@ -2431,12 +2431,12 @@ static u8 bnx2x_dcbnl_set_featcfg(struct net_device *netdev, int featid,
 			break;
 		default:
 			BNX2X_ERR("Non valid featrue-ID\n");
-			rval = -EINVAL;
+			rval = 1;
 			break;
 		}
 	} else {
 		DP(BNX2X_MSG_DCB, "dcbnl call not valid\n");
-		rval = -EINVAL;
+		rval = 1;
 	}
 
 	return rval;
-- 
1.7.9.5

