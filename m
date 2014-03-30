Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336AbaC3XZp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 19:25:45 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36431 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753301AbaC3XZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:25:31 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Emmanuel Grumbach" <emmanuel.grumbach@intel.com>,
        "Johannes Berg" <johannes.berg@intel.com>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.664069839@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 161/200] mac80211: clear sequence/fragment number in
 QoS-null frames
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: Drop change to mps_qos_null_get()]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1211,6 +1211,7 @@ static void ieee80211_send_null_response
 	memcpy(nullfunc->addr1, sta->sta.addr, ETH_ALEN);
 	memcpy(nullfunc->addr2, sdata->vif.addr, ETH_ALEN);
 	memcpy(nullfunc->addr3, sdata->vif.addr, ETH_ALEN);
+	nullfunc->seq_ctrl = 0;
 
 	skb->priority = tid;
 	skb_set_queue_mapping(skb, ieee802_1d_to_ac[tid]);

