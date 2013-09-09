Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141Ab3IISvd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 14:51:33 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:57065 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753363Ab3IISpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 14:45:21 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johannes Berg <johannes.berg@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 05/24] mac80211: add missing channel context release
Date: Mon,  9 Sep 2013 11:44:55 -0700
Message-Id: <1378752314-2416-6-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1378752314-2416-1-git-send-email-kamal@canonical.com>
References: <1378752314-2416-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit 2a3ba63c235fdcd37f6451bdf4a0c7865a3930cf upstream.

IBSS needs to release the channel context when leaving
but I evidently missed that. Fix it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/mac80211/ibss.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 6b7644e..34741ee 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -1207,6 +1207,7 @@ int ieee80211_ibss_leave(struct ieee80211_sub_if_data *sdata)
 	sdata->vif.bss_conf.ibss_creator = false;
 	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON_ENABLED |
 						BSS_CHANGED_IBSS);
+	ieee80211_vif_release_channel(sdata);
 	synchronize_rcu();
 	kfree_skb(skb);
 
-- 
1.8.1.2

