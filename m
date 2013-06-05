Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933218Ab3FEVg2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 17:36:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38141 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933203Ab3FEVgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 17:36:25 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>
Subject: [ 126/127] mac80211_hwsim: remove P2P_DEVICE support
Date: Wed,  5 Jun 2013 14:34:53 -0700
Message-Id: <20130605213232.288638188@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130605213217.966891866@linuxfoundation.org>
References: <20130605213217.966891866@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

Unfortunately, advertising P2P_DEVICE support was a little
premature, a number of issues came up in testing and have
been fixed for 3.10. Rather than try to backport all the
different fixes, disable P2P_DEVICE support in the drivers
using it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/mac80211_hwsim.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -2118,7 +2118,6 @@ static const struct ieee80211_iface_limi
 #endif
 				 BIT(NL80211_IFTYPE_AP) |
 				 BIT(NL80211_IFTYPE_P2P_GO) },
-	{ .max = 1, .types = BIT(NL80211_IFTYPE_P2P_DEVICE) },
 };
 
 static struct ieee80211_iface_combination hwsim_if_comb = {
@@ -2230,8 +2229,7 @@ static int __init init_mac80211_hwsim(vo
 			BIT(NL80211_IFTYPE_P2P_CLIENT) |
 			BIT(NL80211_IFTYPE_P2P_GO) |
 			BIT(NL80211_IFTYPE_ADHOC) |
-			BIT(NL80211_IFTYPE_MESH_POINT) |
-			BIT(NL80211_IFTYPE_P2P_DEVICE);
+			BIT(NL80211_IFTYPE_MESH_POINT);
 
 		hw->flags = IEEE80211_HW_MFP_CAPABLE |
 			    IEEE80211_HW_SIGNAL_DBM |


