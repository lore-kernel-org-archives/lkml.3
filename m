Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932808AbaJUQUV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 12:20:21 -0400
Received: from mailrelay011.isp.belgacom.be ([195.238.6.178]:17977 "EHLO
	mailrelay011.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932553AbaJUQUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 12:20:19 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjAOADJxRlRbslJR/2dsb2JhbABcgw6BK7kQBQEBAQEBAQUBc5lhgRIXAX2EMC8jgRo3iEMBtROOXyyGI4ouHYQ1BZ1ajGSJPoFHbYFFOy+CSwEBAQ
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>,
        Johannes Berg <johannes@sipsolutions.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 1/1 net-next] mac80211: remove unnecessary null test before debugfs_remove
Date: Tue, 21 Oct 2014 18:20:12 +0200
Message-Id: <1413908412-5177-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch warnings:

    WARNING: debugfs_remove(NULL) is safe this check is probably not required

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 net/mac80211/debugfs_key.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/net/mac80211/debugfs_key.c b/net/mac80211/debugfs_key.c
index 1521cab..ec40f27 100644
--- a/net/mac80211/debugfs_key.c
+++ b/net/mac80211/debugfs_key.c
@@ -299,11 +299,8 @@ void ieee80211_debugfs_key_update_default(struct ieee80211_sub_if_data *sdata)
 		return;
 
 	lockdep_assert_held(&sdata->local->key_mtx);
-
-	if (sdata->debugfs.default_unicast_key) {
-		debugfs_remove(sdata->debugfs.default_unicast_key);
-		sdata->debugfs.default_unicast_key = NULL;
-	}
+	debugfs_remove(sdata->debugfs.default_unicast_key);
+	sdata->debugfs.default_unicast_key = NULL;
 
 	if (sdata->default_unicast_key) {
 		key = key_mtx_dereference(sdata->local,
@@ -314,10 +311,8 @@ void ieee80211_debugfs_key_update_default(struct ieee80211_sub_if_data *sdata)
 					       sdata->vif.debugfs_dir, buf);
 	}
 
-	if (sdata->debugfs.default_multicast_key) {
-		debugfs_remove(sdata->debugfs.default_multicast_key);
-		sdata->debugfs.default_multicast_key = NULL;
-	}
+	debugfs_remove(sdata->debugfs.default_multicast_key);
+	sdata->debugfs.default_multicast_key = NULL;
 
 	if (sdata->default_multicast_key) {
 		key = key_mtx_dereference(sdata->local,
-- 
1.9.3

