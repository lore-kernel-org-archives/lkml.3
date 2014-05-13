Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760311AbaEMKYu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 06:24:50 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:33415 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933445AbaEMKLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 06:11:25 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 153/182] mac80211: fix potential use-after-free
Date: Tue, 13 May 2014 11:28:25 +0200
Message-Id: <21076e0a28c675c031cec84f8815a503d7669575.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit d2722f8b87fb172ff2f31d3a2816b31d58678d40 upstream.

The bss struct might be freed in ieee80211_rx_bss_put(),
so we shouldn't use it afterwards.

Fixes: 817cee7675237 ("mac80211: track AP's beacon rate and give it to the driver")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/mac80211/mlme.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 8d7f4abe65ba..2af1c38374a4 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2881,8 +2881,8 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 	bss = ieee80211_bss_info_update(local, rx_status, mgmt, len, elems,
 					channel);
 	if (bss) {
-		ieee80211_rx_bss_put(local, bss);
 		sdata->vif.bss_conf.beacon_rate = bss->beacon_rate;
+		ieee80211_rx_bss_put(local, bss);
 	}
 }
 
-- 
1.9.3

