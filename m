Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451Ab3IYTil (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 15:38:41 -0400
Received: from smtprelay0116.hostedemail.com ([216.40.44.116]:50104 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755405Ab3IYTii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 15:38:38 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1535:1544:1711:1730:1747:1777:1792:2194:2199:2393:2559:2562:2892:3138:3139:3140:3141:3142:3355:3865:3866:3867:3868:3870:3871:4321:4605:5007:6261:6691:7875:7903:10004:10026:10848:11026:11473:11657:11658:11914:12043:12438:12517:12519:12555:12683:13161:13229:13972,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: bead83_84fa4b22cb82f
X-Filterd-Recvd-Size: 5303
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <ilw@linux.intel.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 08/11] iwlwifi: Remove extern from function prototypes
Date: Wed, 25 Sep 2013 12:37:26 -0700
Message-Id: <b3818394ccdf68d834ca1060c1d5a1fc44e2daee.1380137610.git.joe@perches.com>
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
 drivers/net/wireless/iwlwifi/dvm/agn.h | 2 +-
 drivers/net/wireless/iwlwifi/dvm/dev.h | 2 +-
 drivers/net/wireless/iwlwifi/dvm/rs.h  | 8 ++++----
 drivers/net/wireless/iwlwifi/mvm/rs.h  | 9 ++++-----
 4 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/agn.h b/drivers/net/wireless/iwlwifi/dvm/agn.h
index f2a86ff..23d5f02 100644
--- a/drivers/net/wireless/iwlwifi/dvm/agn.h
+++ b/drivers/net/wireless/iwlwifi/dvm/agn.h
@@ -397,7 +397,7 @@ static inline __le32 iwl_hw_set_rate_n_flags(u8 rate, u32 flags)
 	return cpu_to_le32(flags|(u32)rate);
 }
 
-extern int iwl_alive_start(struct iwl_priv *priv);
+int iwl_alive_start(struct iwl_priv *priv);
 
 #ifdef CONFIG_IWLWIFI_DEBUG
 void iwl_print_rx_config_cmd(struct iwl_priv *priv,
diff --git a/drivers/net/wireless/iwlwifi/dvm/dev.h b/drivers/net/wireless/iwlwifi/dvm/dev.h
index a79fdd1..7434d9e 100644
--- a/drivers/net/wireless/iwlwifi/dvm/dev.h
+++ b/drivers/net/wireless/iwlwifi/dvm/dev.h
@@ -270,7 +270,7 @@ struct iwl_sensitivity_ranges {
  * iwlXXXX_     <-- Hardware specific (implemented in iwl-XXXX.c for XXXX)
  *
  ****************************************************************************/
-extern void iwl_update_chain_flags(struct iwl_priv *priv);
+void iwl_update_chain_flags(struct iwl_priv *priv);
 extern const u8 iwl_bcast_addr[ETH_ALEN];
 
 #define IWL_OPERATION_MODE_AUTO     0
diff --git a/drivers/net/wireless/iwlwifi/dvm/rs.h b/drivers/net/wireless/iwlwifi/dvm/rs.h
index 5d83cab..26fc550 100644
--- a/drivers/net/wireless/iwlwifi/dvm/rs.h
+++ b/drivers/net/wireless/iwlwifi/dvm/rs.h
@@ -407,8 +407,8 @@ static inline u8 first_antenna(u8 mask)
 
 
 /* Initialize station's rate scaling information after adding station */
-extern void iwl_rs_rate_init(struct iwl_priv *priv,
-			     struct ieee80211_sta *sta, u8 sta_id);
+void iwl_rs_rate_init(struct iwl_priv *priv, struct ieee80211_sta *sta,
+		      u8 sta_id);
 
 /**
  * iwl_rate_control_register - Register the rate control algorithm callbacks
@@ -420,7 +420,7 @@ extern void iwl_rs_rate_init(struct iwl_priv *priv,
  * ieee80211_register_hw
  *
  */
-extern int iwlagn_rate_control_register(void);
+int iwlagn_rate_control_register(void);
 
 /**
  * iwl_rate_control_unregister - Unregister the rate control callbacks
@@ -428,6 +428,6 @@ extern int iwlagn_rate_control_register(void);
  * This should be called after calling ieee80211_unregister_hw, but before
  * the driver is unloaded.
  */
-extern void iwlagn_rate_control_unregister(void);
+void iwlagn_rate_control_unregister(void);
 
 #endif /* __iwl_agn__rs__ */
diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.h b/drivers/net/wireless/iwlwifi/mvm/rs.h
index 335cf16..465d40e 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.h
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.h
@@ -314,9 +314,8 @@ static inline u8 num_of_ant(u8 mask)
 }
 
 /* Initialize station's rate scaling information after adding station */
-extern void iwl_mvm_rs_rate_init(struct iwl_mvm *mvm,
-				 struct ieee80211_sta *sta,
-				 enum ieee80211_band band);
+void iwl_mvm_rs_rate_init(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
+			  enum ieee80211_band band);
 
 /**
  * iwl_rate_control_register - Register the rate control algorithm callbacks
@@ -328,7 +327,7 @@ extern void iwl_mvm_rs_rate_init(struct iwl_mvm *mvm,
  * ieee80211_register_hw
  *
  */
-extern int iwl_mvm_rate_control_register(void);
+int iwl_mvm_rate_control_register(void);
 
 /**
  * iwl_rate_control_unregister - Unregister the rate control callbacks
@@ -336,7 +335,7 @@ extern int iwl_mvm_rate_control_register(void);
  * This should be called after calling ieee80211_unregister_hw, but before
  * the driver is unloaded.
  */
-extern void iwl_mvm_rate_control_unregister(void);
+void iwl_mvm_rate_control_unregister(void);
 
 struct iwl_mvm_sta;
 
-- 
1.8.1.2.459.gbcd45b4.dirty

