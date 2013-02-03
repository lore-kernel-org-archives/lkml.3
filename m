Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753717Ab3BCOzA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 09:55:00 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34095 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753667Ab3BCOy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 09:54:56 -0500
Message-Id: <20130203144644.402902931@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 03 Feb 2013 15:46:48 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Johannes Berg <johannes.berg@intel.com>,
        Ben Greear <greearb@candelatech.com>
Subject: [ 004/128] mac80211: use del_timer_sync for final sta cleanup timer deletion
In-Reply-To: <20130203144644.035172954@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.5
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/mac80211/sta_info.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 8bbd3b0..ca9fde1 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -884,7 +884,7 @@ void sta_info_init(struct ieee80211_local *local)
 
 void sta_info_stop(struct ieee80211_local *local)
 {
-	del_timer(&local->sta_cleanup);
+	del_timer_sync(&local->sta_cleanup);
 	sta_info_flush(local, NULL);
 }
 


