Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932763AbaFEAs1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 20:48:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39734 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752357AbaFDXUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:20:53 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Eliad Peller <eliadx.peller@intel.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.14 034/228] mac80211: fix nested rtnl locking on ieee80211_reconfig
Date: Wed,  4 Jun 2014 16:21:03 -0700
Message-Id: <20140604232349.169335040@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232347.966798903@linuxfoundation.org>
References: <20140604232347.966798903@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eliad Peller <eliad@wizery.com>

commit e669ba2d06c6195662601956454ac959892f0762 upstream.

ieee80211_reconfig already holds rtnl, so calling
cfg80211_sched_scan_stopped results in deadlock.

Use the rtnl-version of this function instead.

Fixes: d43c6b6 ("mac80211: reschedule sched scan after HW restart")
Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/util.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1754,7 +1754,7 @@ int ieee80211_reconfig(struct ieee80211_
 	mutex_unlock(&local->mtx);
 
 	if (sched_scan_stopped)
-		cfg80211_sched_scan_stopped(local->hw.wiphy);
+		cfg80211_sched_scan_stopped_rtnl(local->hw.wiphy);
 
 	/*
 	 * If this is for hw restart things are still running.


