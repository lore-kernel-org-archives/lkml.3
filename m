Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752092AbaLRJUk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 04:20:40 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:63203 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084AbaLRJUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 04:20:38 -0500
From: Karthik Nayak <karthik.188@gmail.com>
To: trivial@kernel.org
Cc: gregkh@linuxfoundation.org, anarey@gmail.com, linux-kernel@vger.kernel.org,
        Karthik Nayak <karthik.188@gmail.com>
Subject: [PATCH] Staging: rtl8192u: removed an unnecessary else statement
Date: Thu, 18 Dec 2014 14:50:11 +0530
Message-Id: <1418894411-9787-1-git-send-email-karthik.188@gmail.com>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As per checkpatch warning, removed an unnecessary else statement
proceeding an if statement with a return.

Signed-off-by: Karthik Nayak <karthik.188@gmail.com>
---
 drivers/staging/rtl8192u/r8192U_dm.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/rtl8192u/r8192U_dm.c b/drivers/staging/rtl8192u/r8192U_dm.c
index 936565d..b3b508c 100644
--- a/drivers/staging/rtl8192u/r8192U_dm.c
+++ b/drivers/staging/rtl8192u/r8192U_dm.c
@@ -480,15 +480,13 @@ static void dm_bandwidth_autoswitch(struct net_device *dev)
 
 	if(priv->CurrentChannelBW == HT_CHANNEL_WIDTH_20 ||!priv->ieee80211->bandwidth_auto_switch.bautoswitch_enable){
 		return;
-	}else{
-		if(priv->ieee80211->bandwidth_auto_switch.bforced_tx20Mhz == false){//If send packets in 40 Mhz in 20/40
-			if(priv->undecorated_smoothed_pwdb <= priv->ieee80211->bandwidth_auto_switch.threshold_40Mhzto20Mhz)
-				priv->ieee80211->bandwidth_auto_switch.bforced_tx20Mhz = true;
-		}else{//in force send packets in 20 Mhz in 20/40
-			if(priv->undecorated_smoothed_pwdb >= priv->ieee80211->bandwidth_auto_switch.threshold_20Mhzto40Mhz)
-				priv->ieee80211->bandwidth_auto_switch.bforced_tx20Mhz = false;
-
-		}
+	}
+	if(priv->ieee80211->bandwidth_auto_switch.bforced_tx20Mhz == false){//If send packets in 40 Mhz in 20/40
+		if(priv->undecorated_smoothed_pwdb <= priv->ieee80211->bandwidth_auto_switch.threshold_40Mhzto20Mhz)
+			priv->ieee80211->bandwidth_auto_switch.bforced_tx20Mhz = true;
+	}else{//in force send packets in 20 Mhz in 20/40
+		if(priv->undecorated_smoothed_pwdb >= priv->ieee80211->bandwidth_auto_switch.threshold_20Mhzto40Mhz)
+			priv->ieee80211->bandwidth_auto_switch.bforced_tx20Mhz = false;
 	}
 }	// dm_BandwidthAutoSwitch
 
-- 
2.1.3

