Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568Ab3HRUe7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 16:34:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43643 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756324Ab3HRUe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 16:34:56 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ilan Peer <ilan.peer@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [ 19/45] cfg80211: fix P2P GO interface teardown
Date: Sun, 18 Aug 2013 13:36:08 -0700
Message-Id: <20130818203622.347164743@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.3.825.g36032ce.dirty
In-Reply-To: <20130818203620.996166594@linuxfoundation.org>
References: <20130818203620.996166594@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/wireless/core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -876,6 +876,7 @@ void cfg80211_leave(struct cfg80211_regi
 		cfg80211_leave_mesh(rdev, dev);
 		break;
 	case NL80211_IFTYPE_AP:
+	case NL80211_IFTYPE_P2P_GO:
 		cfg80211_stop_ap(rdev, dev);
 		break;
 	default:


