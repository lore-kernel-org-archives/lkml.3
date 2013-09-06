Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757566Ab3IFQPE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 12:15:04 -0400
Received: from mail-pd0-f193.google.com ([209.85.192.193]:38706 "EHLO
	mail-pd0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755672Ab3IFQPC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 12:15:02 -0400
From: Avinash Kumar <avi.kp.137@gmail.com>
To: gregkh@linuxfoundation.org
Cc: emilgoode@gmail.com, bzhao@marvell.com, johannes.berg@intel.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Avinash Kumar <avi.kp.137@gmail.com>
Subject: [PATCH 2/2] staging: wlan-ng: cfg80211.c: replaced printk() with netdev_warn()
Date: Fri,  6 Sep 2013 21:44:51 +0530
Message-Id: <1378484091-5827-1-git-send-email-avi.kp.137@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

replaced printk functions used for debug messages by respective netdev_warn
netdev_err functions.

Signed-off-by: Avinash Kumar <avi.kp.137@gmail.com>
---
 drivers/staging/wlan-ng/cfg80211.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wlan-ng/cfg80211.c b/drivers/staging/wlan-ng/cfg80211.c
index f1bce18..237479a 100644
--- a/drivers/staging/wlan-ng/cfg80211.c
+++ b/drivers/staging/wlan-ng/cfg80211.c
@@ -122,7 +122,7 @@ int prism2_change_virtual_intf(struct wiphy *wiphy,
 		data = 1;
 		break;
 	default:
-		printk(KERN_WARNING "Operation mode: %d not support\n", type);
+		netdev_warn(dev, "Operation mode: %d not support\n", type);
 		return -EOPNOTSUPP;
 	}
 
@@ -352,7 +352,7 @@ int prism2_scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
 		return -EBUSY;
 
 	if (wlandev->macmode == WLAN_MACMODE_ESS_AP) {
-		printk(KERN_ERR "Can't scan in AP mode\n");
+		netdev_err(dev, "Can't scan in AP mode\n");
 		return -EOPNOTSUPP;
 	}
 
@@ -510,7 +510,7 @@ int prism2_connect(struct wiphy *wiphy, struct net_device *dev,
 		((sme->auth_type == NL80211_AUTHTYPE_AUTOMATIC) && is_wep))
 			msg_join.authtype.data = P80211ENUM_authalg_sharedkey;
 	else
-		printk(KERN_WARNING
+		netdev_warn(dev,
 			"Unhandled authorisation type for connect (%d)\n",
 			sme->auth_type);
 
-- 
1.7.10.4

