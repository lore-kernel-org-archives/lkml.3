Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933503AbaBUNoS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 08:44:18 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46983 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932245AbaBUMuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 07:50:21 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 053/121] iwlwifi: mvm: BT Coex - disable BT when TXing probe request in scan
Date: Fri, 21 Feb 2014 12:47:57 +0000
Message-Id: <1392986945-9693-54-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
References: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit 8e2a866ef214af4e104ec8d593e3269d8fe66d19 upstream.

Not doing so will let BT kill our probe requests leading to
failures in scan.

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/iwlwifi/mvm/scan.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index c55d88f..aa6bf6b 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -309,7 +309,8 @@ int iwl_mvm_scan_request(struct iwl_mvm *mvm,
 
 	iwl_mvm_scan_fill_ssids(cmd, req);
 
-	cmd->tx_cmd.tx_flags = cpu_to_le32(TX_CMD_FLG_SEQ_CTL);
+	cmd->tx_cmd.tx_flags = cpu_to_le32(TX_CMD_FLG_SEQ_CTL |
+					   TX_CMD_FLG_BT_DIS);
 	cmd->tx_cmd.sta_id = mvm->aux_sta.sta_id;
 	cmd->tx_cmd.life_time = cpu_to_le32(TX_CMD_LIFE_TIME_INFINITE);
 	cmd->tx_cmd.rate_n_flags =
-- 
1.9.0

