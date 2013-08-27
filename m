Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295Ab3H0BHF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 21:07:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59383 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753214Ab3H0BG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 21:06:56 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [ 11/74] iwlwifi: mvm: properly tell the fw that a STA is awake
Date: Mon, 26 Aug 2013 18:08:09 -0700
Message-Id: <20130827010427.051035637@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20130827010424.535365435@linuxfoundation.org>
References: <20130827010424.535365435@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit 5af01772ee1d6e96849adf728ff837bd71b119c0 upstream.

The firmware API wasn't being used correctly, fix that.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/iwlwifi/mvm/sta.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

--- a/drivers/net/wireless/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/iwlwifi/mvm/sta.c
@@ -1296,17 +1296,11 @@ void iwl_mvm_sta_modify_ps_wake(struct i
 	struct iwl_mvm_add_sta_cmd cmd = {
 		.add_modify = STA_MODE_MODIFY,
 		.sta_id = mvmsta->sta_id,
-		.modify_mask = STA_MODIFY_SLEEPING_STA_TX_COUNT,
-		.sleep_state_flags = cpu_to_le16(STA_SLEEP_STATE_AWAKE),
+		.station_flags_msk = cpu_to_le32(STA_FLG_PS),
 		.mac_id_n_color = cpu_to_le32(mvmsta->mac_id_n_color),
 	};
 	int ret;
 
-	/*
-	 * Same modify mask for sleep_tx_count and sleep_state_flags but this
-	 * should be fine since if we set the STA as "awake", then
-	 * sleep_tx_count is not relevant.
-	 */
 	ret = iwl_mvm_send_cmd_pdu(mvm, ADD_STA, CMD_ASYNC, sizeof(cmd), &cmd);
 	if (ret)
 		IWL_ERR(mvm, "Failed to send ADD_STA command (%d)\n", ret);


