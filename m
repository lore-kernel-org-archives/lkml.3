Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753148AbaEBPl7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 11:41:59 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43825 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608AbaEBPlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 11:41:52 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 063/151] iwlwifi: mvm: disable uAPSD due to bugs in the firmware
Date: Fri,  2 May 2014 08:37:31 -0700
Message-Id: <1399045139-4531-64-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399045139-4531-1-git-send-email-kamal@canonical.com>
References: <1399045139-4531-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit a82dda6cd492b8c88952be6f6527f3656f7ac585 upstream.

The current firmware advertises support for uAPSD, but
critical bugs force us to disable the feature.
When a fixed firmware will be available, we will be able to
re-enable uAPSD.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index cd6ea2e..c68e4ae 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -179,7 +179,7 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 	    !iwlwifi_mod_params.sw_crypto)
 		hw->flags |= IEEE80211_HW_MFP_CAPABLE;
 
-	if (mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_UAPSD_SUPPORT) {
+	if (0 && mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_UAPSD_SUPPORT) {
 		hw->flags |= IEEE80211_HW_SUPPORTS_UAPSD;
 		hw->uapsd_queues = IWL_UAPSD_AC_INFO;
 		hw->uapsd_max_sp_len = IWL_UAPSD_MAX_SP;
-- 
1.9.1

