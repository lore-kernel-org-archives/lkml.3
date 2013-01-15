Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933177Ab3AOXje (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 18:39:34 -0500
Received: from mail.kernel.org ([198.145.19.201]:46370 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933368Ab3AOWvS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:51:18 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Ben Greear <greearb@candelatech.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [ 088/171] mac80211: use del_timer_sync for final sta cleanup timer deletion
Date: Tue, 15 Jan 2013 14:44:13 -0800
Message-Id: <20130115224319.734378137@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115224313.394976595@linuxfoundation.org>
References: <20130115224313.394976595@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/sta_info.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -844,7 +844,7 @@ void sta_info_init(struct ieee80211_loca
 
 void sta_info_stop(struct ieee80211_local *local)
 {
-	del_timer(&local->sta_cleanup);
+	del_timer_sync(&local->sta_cleanup);
 	sta_info_flush(local, NULL);
 }
 


