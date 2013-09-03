Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756789Ab3ICQYP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 12:24:15 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46357 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755117Ab3ICQYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 12:24:12 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johannes Berg <johannes.berg@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 03/58] cfg80211: fix P2P GO interface teardown
Date: Tue,  3 Sep 2013 09:23:07 -0700
Message-Id: <1378225442-20654-4-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1378225442-20654-1-git-send-email-kamal@canonical.com>
References: <1378225442-20654-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit 74418edec915d0f446debebde08d170c7b8ba0ee upstream.

When a P2P GO interface goes down, cfg80211 doesn't properly
tear it down, leading to warnings later. Add the GO interface
type to the enumeration to tear it down like AP interfaces.
Otherwise, we leave it pending and mac80211's state can get
very confused, leading to warnings later.

Reported-by: Ilan Peer <ilan.peer@intel.com>
Tested-by: Ilan Peer <ilan.peer@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/wireless/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index ce1eff7..e4f226c 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -841,6 +841,7 @@ void cfg80211_leave(struct cfg80211_registered_device *rdev,
 		cfg80211_leave_mesh(rdev, dev);
 		break;
 	case NL80211_IFTYPE_AP:
+	case NL80211_IFTYPE_P2P_GO:
 		cfg80211_stop_ap(rdev, dev);
 		break;
 	default:
-- 
1.8.1.2

