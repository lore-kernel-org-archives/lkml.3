Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753136AbaDAQaX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 12:30:23 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44601 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752941AbaDAQPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 12:15:37 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johannes Berg <johannes.berg@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 58/86] mac80211: clear sequence/fragment number in QoS-null frames
Date: Tue,  1 Apr 2014 09:08:11 -0700
Message-Id: <1396368519-12728-59-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1396368519-12728-1-git-send-email-kamal@canonical.com>
References: <1396368519-12728-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.21 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit 864a6040f395464003af8dd0d8ca86fed19866d4 upstream.

Avoid leaking data by sending uninitialized memory and setting an
invalid (non-zero) fragment number (the sequence number is ignored
anyway) by setting the seq_ctrl field to zero.

Fixes: 3f52b7e328c5 ("mac80211: mesh power save basics")
Fixes: ce662b44ce22 ("mac80211: send (QoS) Null if no buffered frames")
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
[ kamal: backport to 3.8 (no mesh_ps.c) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/mac80211/sta_info.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index b6f24a7..39665d6 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1107,6 +1107,7 @@ static void ieee80211_send_null_response(struct ieee80211_sub_if_data *sdata,
 	memcpy(nullfunc->addr1, sta->sta.addr, ETH_ALEN);
 	memcpy(nullfunc->addr2, sdata->vif.addr, ETH_ALEN);
 	memcpy(nullfunc->addr3, sdata->vif.addr, ETH_ALEN);
+	nullfunc->seq_ctrl = 0;
 
 	skb->priority = tid;
 	skb_set_queue_mapping(skb, ieee802_1d_to_ac[tid]);
-- 
1.8.3.2

