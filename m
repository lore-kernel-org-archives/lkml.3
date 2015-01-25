Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757935AbbAYSiW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 13:38:22 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57882 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755906AbbAYSKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:10:17 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Eyal Shapira <eyalx.shapira@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 3.18 118/183] iwlwifi: mvm: fix Rx with both chains
Date: Sun, 25 Jan 2015 10:07:20 -0800
Message-Id: <20150125180815.316770239@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180810.160428929@linuxfoundation.org>
References: <20150125180810.160428929@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/net/wireless/iwlwifi/mvm/utils.c b/drivers/net/wireless/iwlwifi/mvm/utils.c
index e56e77ef5d2e..917431e30f74 100644
--- a/drivers/net/wireless/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/iwlwifi/mvm/utils.c
@@ -665,7 +665,7 @@ bool iwl_mvm_rx_diversity_allowed(struct iwl_mvm *mvm)
 	if (num_of_ant(mvm->fw->valid_rx_ant) == 1)
 		return false;
 
-	if (!mvm->cfg->rx_with_siso_diversity)
+	if (mvm->cfg->rx_with_siso_diversity)
 		return false;
 
 	ieee80211_iterate_active_interfaces_atomic(


