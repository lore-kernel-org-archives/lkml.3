Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932649AbbA0McA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:32:00 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35283 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932440AbbA0MTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:19:12 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eyal Shapira <eyalx.shapira@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 084/126] iwlwifi: mvm: fix Rx with both chains
Date: Tue, 27 Jan 2015 12:16:29 +0000
Message-Id: <1422361031-19364-85-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
References: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eyal Shapira <eyal@wizery.com>

commit c93edc639392df733c7d72db4376a9add775d18a upstream.

commit 5c90422439d6
"iwlwifi: mvm: don't allow diversity if BT Coex / TT forbid it"
broke Rx with 2 chains for diversity.
This had an impact on throughput where we're using only a single
stream (11a/b/g APs, single stream APs, static SMPS).

Fixes: 5c90422439d6 ("iwlwifi: mvm: don't allow diversity if BT Coex / TT forbid it")
Signed-off-by: Eyal Shapira <eyalx.shapira@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/iwlwifi/mvm/utils.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/utils.c b/drivers/net/wireless/iwlwifi/mvm/utils.c
index aa9fc77e8413..3aba78dff0ba 100644
--- a/drivers/net/wireless/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/iwlwifi/mvm/utils.c
@@ -673,7 +673,7 @@ bool iwl_mvm_rx_diversity_allowed(struct iwl_mvm *mvm)
 	if (num_of_ant(mvm->fw->valid_rx_ant) == 1)
 		return false;
 
-	if (!mvm->cfg->rx_with_siso_diversity)
+	if (mvm->cfg->rx_with_siso_diversity)
 		return false;
 
 	ieee80211_iterate_active_interfaces_atomic(
-- 
2.1.4

