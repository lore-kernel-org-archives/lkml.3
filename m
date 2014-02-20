Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503AbaBTXwF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 18:52:05 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:45676 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755426AbaBTXwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 18:52:01 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 3.12 22/82] iwlwifi: mvm: BT Coex - disable BT when TXing probe request in scan
Date: Thu, 20 Feb 2014 15:52:05 -0800
Message-Id: <20140220235020.145583942@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140220235019.483734207@linuxfoundation.org>
References: <20140220235019.483734207@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit 8e2a866ef214af4e104ec8d593e3269d8fe66d19 upstream.

Not doing so will let BT kill our probe requests leading to
failures in scan.

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/iwlwifi/mvm/scan.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -311,7 +311,8 @@ int iwl_mvm_scan_request(struct iwl_mvm
 
 	iwl_mvm_scan_fill_ssids(cmd, req);
 
-	cmd->tx_cmd.tx_flags = cpu_to_le32(TX_CMD_FLG_SEQ_CTL);
+	cmd->tx_cmd.tx_flags = cpu_to_le32(TX_CMD_FLG_SEQ_CTL |
+					   TX_CMD_FLG_BT_DIS);
 	cmd->tx_cmd.sta_id = mvm->aux_sta.sta_id;
 	cmd->tx_cmd.life_time = cpu_to_le32(TX_CMD_LIFE_TIME_INFINITE);
 	cmd->tx_cmd.rate_n_flags =


