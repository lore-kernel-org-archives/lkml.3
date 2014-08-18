Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798AbaHRKKE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 06:10:04 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42405 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808AbaHRJdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 05:33:31 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 005/137] iwlwifi: dvm: don't enable CTS to self
Date: Mon, 18 Aug 2014 10:31:06 +0100
Message-Id: <1408354398-10226-6-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
References: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit 43d826ca5979927131685cc2092c7ce862cb91cd upstream.

We should always prefer to use full RTS protection. Using
CTS to self gives a meaningless improvement, but this flow
is much harder for the firmware which is likely to have
issues with it.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/iwlwifi/dvm/rxon.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/rxon.c b/drivers/net/wireless/iwlwifi/dvm/rxon.c
index cd1ad0019185..ca17e4c9eca2 100644
--- a/drivers/net/wireless/iwlwifi/dvm/rxon.c
+++ b/drivers/net/wireless/iwlwifi/dvm/rxon.c
@@ -1072,13 +1072,6 @@ int iwlagn_commit_rxon(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
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
@@ -1484,11 +1477,6 @@ void iwlagn_bss_info_changed(struct ieee80211_hw *hw,
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
1.9.1

