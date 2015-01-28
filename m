Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965101AbbA2Cg4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 21:36:56 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46977 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965031AbbA2Cgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:36:52 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johannes Berg <johannes.berg@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 133/139] mac80211: free management frame keys when removing station
Date: Wed, 28 Jan 2015 14:21:16 -0800
Message-Id: <1422483682-15393-134-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422483682-15393-1-git-send-email-kamal@canonical.com>
References: <1422483682-15393-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit 28a9bc68124c319b2b3dc861e80828a8865fd1ba upstream.

When writing the code to allow per-station GTKs, I neglected to
take into account the management frame keys (index 4 and 5) when
freeing the station and only added code to free the first four
data frame keys.

Fix this by iterating the array of keys over the right length.

Fixes: e31b82136d1a ("cfg80211/mac80211: allow per-station GTKs")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/mac80211/key.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index 3e51dd7..e574eac 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -615,7 +615,7 @@ void ieee80211_free_sta_keys(struct ieee80211_local *local,
 	int i;
 
 	mutex_lock(&local->key_mtx);
-	for (i = 0; i < NUM_DEFAULT_KEYS; i++) {
+	for (i = 0; i < ARRAY_SIZE(sta->gtk); i++) {
 		key = key_mtx_dereference(local, sta->gtk[i]);
 		if (!key)
 			continue;
-- 
1.9.1

