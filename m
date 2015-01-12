Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755025AbbALSaK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:30:10 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58106 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753491AbbALSaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:30:05 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johannes Berg <johannes.berg@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 143/216] mac80211: free management frame keys when removing station
Date: Mon, 12 Jan 2015 18:28:41 +0000
Message-Id: <1421087394-2712-31-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/mac80211/key.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index 16d97f044a20..947daa9d3346 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -653,7 +653,7 @@ void ieee80211_free_sta_keys(struct ieee80211_local *local,
 	int i;
 
 	mutex_lock(&local->key_mtx);
-	for (i = 0; i < NUM_DEFAULT_KEYS; i++) {
+	for (i = 0; i < ARRAY_SIZE(sta->gtk); i++) {
 		key = key_mtx_dereference(local, sta->gtk[i]);
 		if (!key)
 			continue;
-- 
2.1.4

