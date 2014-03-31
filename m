Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988AbaCaNYK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 09:24:10 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35669 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753813AbaCaNYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 09:24:08 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johannes Berg <johannes.berg@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 33/71] mac80211: clear sequence/fragment number in QoS-null frames
Date: Mon, 31 Mar 2014 14:22:39 +0100
Message-Id: <1396272197-13394-34-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396272197-13394-1-git-send-email-luis.henriques@canonical.com>
References: <1396272197-13394-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.33 -stable review patch.  If anyone has any objections, please let me know.

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
[ luis: backported to 3.5:
  - Dropped changes to mps_qos_null_get() as 3f52b7e328c5 ("mac80211: mesh
    power save basics") is not present in 3.5 kernel ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/mac80211/sta_info.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 55975bd..15162a0 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1049,6 +1049,7 @@ static void ieee80211_send_null_response(struct ieee80211_sub_if_data *sdata,
 	memcpy(nullfunc->addr1, sta->sta.addr, ETH_ALEN);
 	memcpy(nullfunc->addr2, sdata->vif.addr, ETH_ALEN);
 	memcpy(nullfunc->addr3, sdata->vif.addr, ETH_ALEN);
+	nullfunc->seq_ctrl = 0;
 
 	skb->priority = tid;
 	skb_set_queue_mapping(skb, ieee802_1d_to_ac[tid]);
-- 
1.9.1

