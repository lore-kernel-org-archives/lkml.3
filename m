Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755660AbaG3MlH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 08:41:07 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:36662 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752786AbaG3MP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 08:15:26 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 29/94] iwlwifi: dvm: don't enable CTS to self
Date: Wed, 30 Jul 2014 14:14:18 +0200
Message-Id: <3a0722ddd6e925eecfe335b7405a0d1067b9acf4.1406722270.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
References: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
In-Reply-To: <cover.1406722269.git.jslaby@suse.cz>
References: <cover.1406722269.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 43d826ca5979927131685cc2092c7ce862cb91cd upstream.

We should always prefer to use full RTS protection. Using
CTS to self gives a meaningless improvement, but this flow
is much harder for the firmware which is likely to have
issues with it.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/net/wireless/iwlwifi/dvm/rxon.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/rxon.c b/drivers/net/wireless/iwlwifi/dvm/rxon.c
index d7ce2f12a907..6a5b7593ea42 100644
--- a/drivers/net/wireless/iwlwifi/dvm/rxon.c
+++ b/drivers/net/wireless/iwlwifi/dvm/rxon.c
@@ -1068,13 +1068,6 @@ int iwlagn_commit_rxon(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 	/* recalculate basic rates */
 	iwl_calc_basic_rates(priv, ctx);
 
-	/*
-	 * force CTS-to-self frames protection if RTS-CTS is not preferred
-	 * one aggregation protection method
-	 */
-	if (!priv->hw_params.use_rts_for_aggregation)
-		ctx->staging.flags |= RXON_FLG_SELF_CTS_EN;
-
 	if ((ctx->vif && ctx->vif->bss_conf.use_short_slot) ||
 	    !(ctx->staging.flags & RXON_FLG_BAND_24G_MSK))
 		ctx->staging.flags |= RXON_FLG_SHORT_SLOT_MSK;
@@ -1480,11 +1473,6 @@ void iwlagn_bss_info_changed(struct ieee80211_hw *hw,
 	else
 		ctx->staging.flags &= ~RXON_FLG_TGG_PROTECT_MSK;
 
-	if (bss_conf->use_cts_prot)
-		ctx->staging.flags |= RXON_FLG_SELF_CTS_EN;
-	else
-		ctx->staging.flags &= ~RXON_FLG_SELF_CTS_EN;
-
 	memcpy(ctx->staging.bssid_addr, bss_conf->bssid, ETH_ALEN);
 
 	if (vif->type == NL80211_IFTYPE_AP ||
-- 
2.0.1

