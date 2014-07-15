Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934073AbaGOVj3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 17:39:29 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55098 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964876AbaGOVjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 17:39:25 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Felix Fietkau <nbd@openwrt.org>, Johannes Berg <johannes.berg@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 068/198] mac80211: fix a memory leak on sta rate selection table
Date: Tue, 15 Jul 2014 14:28:58 -0700
Message-Id: <1405459868-15089-69-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405459868-15089-1-git-send-email-kamal@canonical.com>
References: <1405459868-15089-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit 53d045258ee2e38b1e882617cb0799a04d05f5fa upstream.

If the rate control algorithm uses a selection table, it
is leaked when the station is destroyed - fix that.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Reported-by: Christophe Prévotaux <cprevotaux@nltinc.com>
Fixes: 0d528d85c519 ("mac80211: improve the rate control API")
[add commit log entry, remove pointless NULL check]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/mac80211/sta_info.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index f92e221..ae0c132 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -271,6 +271,7 @@ void sta_info_free(struct ieee80211_local *local, struct sta_info *sta)
 
 	sta_dbg(sta->sdata, "Destroyed STA %pM\n", sta->sta.addr);
 
+	kfree(rcu_dereference_raw(sta->sta.rates));
 	kfree(sta);
 }
 
-- 
1.9.1

