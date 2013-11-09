Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933098Ab3KIHSw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 02:18:52 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33242 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932646Ab3KIGvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 01:51:47 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Luciano Coelho <luciano.coelho@intel.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.11 21/94] cfg80211: use the correct macro to check for active monitor support
Date: Fri,  8 Nov 2013 22:51:27 -0800
Message-Id: <20131109065205.735956555@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc0.dirty
In-Reply-To: <20131109065204.252462489@linuxfoundation.org>
References: <20131109065204.252462489@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luciano Coelho <luciano.coelho@intel.com>

commit 180032973ee97daddf5c9d733e5b425b108f8679 upstream.

Use MONITOR_FLAG_ACTIVE, which is a flag mask, instead of
NL80211_MNTR_FLAG_ACTIVE, which is a flag index, when checking if the
hardware supports active monitoring.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/wireless/nl80211.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2379,7 +2379,7 @@ static int nl80211_set_interface(struct
 		change = true;
 	}
 
-	if (flags && (*flags & NL80211_MNTR_FLAG_ACTIVE) &&
+	if (flags && (*flags & MONITOR_FLAG_ACTIVE) &&
 	    !(rdev->wiphy.features & NL80211_FEATURE_ACTIVE_MONITOR))
 		return -EOPNOTSUPP;
 
@@ -2441,7 +2441,7 @@ static int nl80211_new_interface(struct
 				  info->attrs[NL80211_ATTR_MNTR_FLAGS] : NULL,
 				  &flags);
 
-	if (!err && (flags & NL80211_MNTR_FLAG_ACTIVE) &&
+	if (!err && (flags & MONITOR_FLAG_ACTIVE) &&
 	    !(rdev->wiphy.features & NL80211_FEATURE_ACTIVE_MONITOR))
 		return -EOPNOTSUPP;
 


