Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933066AbbAIKrg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 05:47:36 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44580 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757458AbbAIKc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 05:32:29 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 52/78] mac80211: free management frame keys when removing station
Date: Fri,  9 Jan 2015 11:32:01 +0100
Message-Id: <d5c70d8fdcea383449a4ca6b25e3ec16d73e83ba.1420799385.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <72002f1f248c28d1715d10454190e209d5a20fe1.1420799385.git.jslaby@suse.cz>
References: <72002f1f248c28d1715d10454190e209d5a20fe1.1420799385.git.jslaby@suse.cz>
In-Reply-To: <cover.1420799385.git.jslaby@suse.cz>
References: <cover.1420799385.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 28a9bc68124c319b2b3dc861e80828a8865fd1ba upstream.

When writing the code to allow per-station GTKs, I neglected to
take into account the management frame keys (index 4 and 5) when
freeing the station and only added code to free the first four
data frame keys.

Fix this by iterating the array of keys over the right length.

Fixes: e31b82136d1a ("cfg80211/mac80211: allow per-station GTKs")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/mac80211/key.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index 620677e897bd..23dfd244c892 100644
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
2.2.1

