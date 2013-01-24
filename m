Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847Ab3AXDpM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 22:45:12 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44138 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753624Ab3AXD2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 22:28:00 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johannes Berg <johannes.berg@intel.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 06/74] mac80211: use del_timer_sync for final sta cleanup timer deletion
Date: Thu, 24 Jan 2013 01:26:18 -0200
Message-Id: <1358998046-613-7-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit a56f992cdabc63f56b4b142885deebebf936ff76 upstream.

This is a very old bug, but there's nothing that prevents the
timer from running while the module is being removed when we
only do del_timer() instead of del_timer_sync().

The timer should normally not be running at this point, but
it's not clearly impossible (or we could just remove this.)

Tested-by: Ben Greear <greearb@candelatech.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/mac80211/sta_info.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 6c74f1e..fec8eab 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -844,7 +844,7 @@ void sta_info_init(struct ieee80211_local *local)
 
 void sta_info_stop(struct ieee80211_local *local)
 {
-	del_timer(&local->sta_cleanup);
+	del_timer_sync(&local->sta_cleanup);
 	sta_info_flush(local, NULL);
 }
 
-- 
1.7.9.5

