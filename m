Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754448AbaCaNz5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 09:55:57 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35520 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752953AbaCaNX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 09:23:28 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 04/71] iwlwifi: dvm: clear IWL_STA_UCODE_INPROGRESS when assoc fails
Date: Mon, 31 Mar 2014 14:22:10 +0100
Message-Id: <1396272197-13394-5-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396272197-13394-1-git-send-email-luis.henriques@canonical.com>
References: <1396272197-13394-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.33 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit ec6f678c74dbdb06a6a775bbb00f1d26c17c404b upstream.

We set IWL_STA_UCODE_INPROGRESS flag when we add a station
and clear it when we send the LQ command for it. But the LQ
command is sent only when the association succeeds.
If the association doesn't succeed, we would leave this flag
set and that wouldn't indicate the station entry as vacant.

This probably fixes:
https://bugzilla.redhat.com/show_bug.cgi?id=1065663

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
[ luis: backported to 3.5:
  - file rename: dvm/sta.c -> iwl-agn-sta.c ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-sta.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
index dff75ea..f896ca6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
@@ -618,6 +618,7 @@ void iwl_deactivate_station(struct iwl_priv *priv, const u8 sta_id,
 			sizeof(priv->tid_data[sta_id][tid]));
 
 	priv->stations[sta_id].used &= ~IWL_STA_DRIVER_ACTIVE;
+	priv->stations[sta_id].used &= ~IWL_STA_UCODE_INPROGRESS;
 
 	priv->num_stations--;
 
-- 
1.9.1

