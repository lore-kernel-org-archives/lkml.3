Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933508Ab3GCSto (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 14:49:44 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33384 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933252Ab3GCSlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 14:41:01 -0400
X-Authority-Analysis: v=2.0 cv=Tr1kdUrh c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=hCJnr0Z3Hb0A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=69O_3cKTbeoA:10 a=QyXUC8HyAAAA:8 a=VwQbUJbxAAAA:8 a=fBeKd2HRWbP4T1pgm1MA:9 a=dGJ0OcVc7YAA:10 a=67T1GQF_SpIA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130703184053.698761998@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 14:39:52 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Hinnerk van Bruinehsen <h.v.bruinehsen@fu-berlin.de>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [055/141] iwlwifi: dvm: fix zero LQ CMD sending avoidance
References: <20130703183857.307196999@goodmis.org>
Content-Disposition: inline; filename=0055-iwlwifi-dvm-fix-zero-LQ-CMD-sending-avoidance.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.6 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

[ Upstream commit a87783699b23395c46bbeeb5d28f6db24897bf26 ]

In 63b77bf489881747c5118476918cc8c29378ee63

	iwlwifi: dvm: don't send zeroed LQ cmd

I tried to avoid to send zeroed LQ cmd, but I made a (very)
stupid mistake in the memcmp.
Since this patch has been ported to stable, the fix should
go to stable too.

This fixes https://bugzilla.kernel.org/show_bug.cgi?id=58341

Cc: stable@vger.kernel.org
Reported-by: Hinnerk van Bruinehsen <h.v.bruinehsen@fu-berlin.de>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/wireless/iwlwifi/dvm/sta.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/sta.c b/drivers/net/wireless/iwlwifi/dvm/sta.c
index efe8a4f..12e06f3 100644
--- a/drivers/net/wireless/iwlwifi/dvm/sta.c
+++ b/drivers/net/wireless/iwlwifi/dvm/sta.c
@@ -746,7 +746,7 @@ void iwl_restore_stations(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 					memcpy(&lq, priv->stations[i].lq,
 					       sizeof(struct iwl_link_quality_cmd));
 
-				if (!memcmp(&lq, &zero_lq, sizeof(lq)))
+				if (memcmp(&lq, &zero_lq, sizeof(lq)))
 					send_lq = true;
 			}
 			spin_unlock_bh(&priv->sta_lock);
-- 
1.7.10.4


