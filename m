Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933127AbaLBTVr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 14:21:47 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46571 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933107AbaLBTVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 14:21:44 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Luciano Coelho <luciano.coelho@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 052/121] mac80211: schedule the actual switch of the station before CSA count 0
Date: Tue,  2 Dec 2014 11:18:51 -0800
Message-Id: <1417548000-1794-53-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417548000-1794-1-git-send-email-kamal@canonical.com>
References: <1417548000-1794-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luciano Coelho <luciano.coelho@intel.com>

commit ff1e417c7c239b7abfe70aa90460a77eaafc7f83 upstream.

Due to the time it takes to process the beacon that started the CSA
process, we may be late for the switch if we try to reach exactly
beacon 0.  To avoid that, use count - 1 when calculating the switch time.

Reported-by: Jouni Malinen <j@w1.fi>
Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/mac80211/mlme.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index d8824f9..0c32180 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1083,7 +1083,8 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 		ieee80211_queue_work(&local->hw, &ifmgd->chswitch_work);
 	else
 		mod_timer(&ifmgd->chswitch_timer,
-			  TU_TO_EXP_TIME(csa_ie.count * cbss->beacon_interval));
+			  TU_TO_EXP_TIME((csa_ie.count - 1) *
+					 cbss->beacon_interval));
 }
 
 static u32 ieee80211_handle_pwr_constr(struct ieee80211_sub_if_data *sdata,
-- 
1.9.1

