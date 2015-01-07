Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757947AbbAGCXj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 21:23:39 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47112 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757733AbbAGCSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 21:18:07 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.17 40/73] mac80211: free management frame keys when removing station
Date: Tue,  6 Jan 2015 18:16:01 -0800
Message-Id: <20150107021558.738793260@linuxfoundation.org>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <20150107021557.521276020@linuxfoundation.org>
References: <20150107021557.521276020@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/key.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -650,7 +650,7 @@ void ieee80211_free_sta_keys(struct ieee
 	int i;
 
 	mutex_lock(&local->key_mtx);
-	for (i = 0; i < NUM_DEFAULT_KEYS; i++) {
+	for (i = 0; i < ARRAY_SIZE(sta->gtk); i++) {
 		key = key_mtx_dereference(local, sta->gtk[i]);
 		if (!key)
 			continue;


