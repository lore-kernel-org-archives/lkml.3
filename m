Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933215Ab3FEVhe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 17:37:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38138 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933192Ab3FEVgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 17:36:24 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>
Subject: [ 125/127] iwlwifi: mvm: remove P2P_DEVICE support
Date: Wed,  5 Jun 2013 14:34:52 -0700
Message-Id: <20130605213232.177053992@linuxfoundation.org>
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
using it. For iwlmvm that implies disabling P2P completely
as it can't support P2P operation w/o P2P Device.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c |   14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -82,15 +82,6 @@ static const struct ieee80211_iface_limi
 		.types = BIT(NL80211_IFTYPE_STATION) |
 			BIT(NL80211_IFTYPE_AP),
 	},
-	{
-		.max = 1,
-		.types = BIT(NL80211_IFTYPE_P2P_CLIENT) |
-			BIT(NL80211_IFTYPE_P2P_GO),
-	},
-	{
-		.max = 1,
-		.types = BIT(NL80211_IFTYPE_P2P_DEVICE),
-	},
 };
 
 static const struct ieee80211_iface_combination iwl_mvm_iface_combinations[] = {
@@ -136,10 +127,7 @@ int iwl_mvm_mac_setup_register(struct iw
 	hw->chanctx_data_size = sizeof(struct iwl_mvm_phy_ctxt);
 
 	hw->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
-		BIT(NL80211_IFTYPE_P2P_CLIENT) |
-		BIT(NL80211_IFTYPE_AP) |
-		BIT(NL80211_IFTYPE_P2P_GO) |
-		BIT(NL80211_IFTYPE_P2P_DEVICE);
+		BIT(NL80211_IFTYPE_AP);
 
 	hw->wiphy->flags |= WIPHY_FLAG_CUSTOM_REGULATORY |
 			    WIPHY_FLAG_DISABLE_BEACON_HINTS |


