Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498AbaFJTxu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 15:53:50 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35565 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755438AbaFJTxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 15:53:47 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Seth Forshee <seth.forshee@canonical.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 047/160] iwlwifi: mvm: disable beacon filtering
Date: Tue, 10 Jun 2014 12:44:47 -0700
Message-Id: <1402429600-20477-48-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402429600-20477-1-git-send-email-kamal@canonical.com>
References: <1402429600-20477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit 7bacc782270ff7db3b9f29fa5d24ad2ee1e8e81d upstream.

This feature has been causing trouble - disable it for now.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: Seth Forshee <seth.forshee@canonical.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index c68e4ae..b3338b1 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -619,7 +619,7 @@ static int iwl_mvm_mac_add_interface(struct ieee80211_hw *hw,
 	if (ret)
 		goto out_remove_mac;
 
-	if (!mvm->bf_allowed_vif &&
+	if (!mvm->bf_allowed_vif && false &&
 	    vif->type == NL80211_IFTYPE_STATION && !vif->p2p &&
 	    mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_BF_UPDATED){
 		mvm->bf_allowed_vif = mvmvif;
-- 
1.9.1

