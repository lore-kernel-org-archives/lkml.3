Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552Ab3FQRbt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 13:31:49 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50375 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966Ab3FQRbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 13:31:41 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 03/84] iwlwifi: dvm: fix zero LQ CMD sending avoidance
Date: Mon, 17 Jun 2013 10:30:07 -0700
Message-Id: <1371490288-23167-4-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371490288-23167-1-git-send-email-kamal@canonical.com>
References: <1371490288-23167-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit a87783699b23395c46bbeeb5d28f6db24897bf26 upstream.

In 63b77bf489881747c5118476918cc8c29378ee63

	iwlwifi: dvm: don't send zeroed LQ cmd

I tried to avoid to send zeroed LQ cmd, but I made a (very)
stupid mistake in the memcmp.
Since this patch has been ported to stable, the fix should
go to stable too.

This fixes https://bugzilla.kernel.org/show_bug.cgi?id=58341

Reported-by: Hinnerk van Bruinehsen <h.v.bruinehsen@fu-berlin.de>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/wireless/iwlwifi/dvm/sta.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/sta.c b/drivers/net/wireless/iwlwifi/dvm/sta.c
index a8632a4..181d14c 100644
--- a/drivers/net/wireless/iwlwifi/dvm/sta.c
+++ b/drivers/net/wireless/iwlwifi/dvm/sta.c
@@ -747,7 +747,7 @@ void iwl_restore_stations(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 					memcpy(&lq, priv->stations[i].lq,
 					       sizeof(struct iwl_link_quality_cmd));
 
-				if (!memcmp(&lq, &zero_lq, sizeof(lq)))
+				if (memcmp(&lq, &zero_lq, sizeof(lq)))
 					send_lq = true;
 			}
 			spin_unlock_bh(&priv->sta_lock);
-- 
1.8.1.2

