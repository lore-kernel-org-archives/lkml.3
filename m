Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755017AbaGZThG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 15:37:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34376 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754162AbaGZTNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 15:13:22 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 3.15 028/109] iwlwifi: dvm: dont enable CTS to self
Date: Sat, 26 Jul 2014 12:01:50 -0700
Message-Id: <20140726190224.676132096@linuxfoundation.org>
X-Mailer: git-send-email 2.0.2
In-Reply-To: <20140726190223.834037485@linuxfoundation.org>
References: <20140726190223.834037485@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit 43d826ca5979927131685cc2092c7ce862cb91cd upstream.

We should always prefer to use full RTS protection. Using
CTS to self gives a meaningless improvement, but this flow
is much harder for the firmware which is likely to have
issues with it.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/iwlwifi/dvm/rxon.c |   12 ------------
 1 file changed, 12 deletions(-)

--- a/drivers/net/wireless/iwlwifi/dvm/rxon.c
+++ b/drivers/net/wireless/iwlwifi/dvm/rxon.c
@@ -1068,13 +1068,6 @@ int iwlagn_commit_rxon(struct iwl_priv *
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
@@ -1480,11 +1473,6 @@ void iwlagn_bss_info_changed(struct ieee
 	else
 		ctx->staging.flags &= ~RXON_FLG_TGG_PROTECT_MSK;
 
-	if (bss_conf->use_cts_prot)
-		ctx->staging.flags |= RXON_FLG_SELF_CTS_EN;
-	else
-		ctx->staging.flags &= ~RXON_FLG_SELF_CTS_EN;
-
 	memcpy(ctx->staging.bssid_addr, bss_conf->bssid, ETH_ALEN);
 
 	if (vif->type == NL80211_IFTYPE_AP ||


