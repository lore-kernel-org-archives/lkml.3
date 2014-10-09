Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751633AbaJIVDv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:03:51 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58914 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240AbaJIVD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:03:27 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johannes Berg <johannes.berg@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 012/163] Revert "mac80211: disable uAPSD if all ACs are under ACM"
Date: Thu,  9 Oct 2014 14:00:37 -0700
Message-Id: <1412888588-26755-13-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412888588-26755-1-git-send-email-kamal@canonical.com>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit bb512ad0732232f1d2693bb68f31a76bed8f22ae upstream.

This reverts commit 24aa11ab8ae03292d38ec0dbd9bc2ac49fe8a6dd.

That commit was wrong since it uses data that hasn't even been set
up yet, but might be a hold-over from a previous connection.

Additionally, it seems like a driver-specific workaround that
shouldn't have been in mac80211 to start with.

Fixes: 24aa11ab8ae0 ("mac80211: disable uAPSD if all ACs are under ACM")
Reviewed-by: Luciano Coelho <luciano.coelho@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/mac80211/mlme.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index fcdd5de..6c126fc 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -4219,8 +4219,7 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 	rcu_read_unlock();
 
 	if (bss->wmm_used && bss->uapsd_supported &&
-	    (sdata->local->hw.flags & IEEE80211_HW_SUPPORTS_UAPSD) &&
-	    sdata->wmm_acm != 0xff) {
+	    (sdata->local->hw.flags & IEEE80211_HW_SUPPORTS_UAPSD)) {
 		assoc_data->uapsd = true;
 		ifmgd->flags |= IEEE80211_STA_UAPSD_ENABLED;
 	} else {
-- 
1.9.1

