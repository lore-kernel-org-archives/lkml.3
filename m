Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760884AbaEMK0b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 06:26:31 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:33415 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933437AbaEMKLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 06:11:20 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>,
        Johannes Berg <johannes.berg@intel.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 157/182] mac80211: exclude AP_VLAN interfaces from tx power calculation
Date: Tue, 13 May 2014 11:28:29 +0200
Message-Id: <4f460f6940b950451107b2e6163e84b921708ccf.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Felix Fietkau <nbd@openwrt.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 764152ff66f4a8be1f9d7981e542ffdaa5bd7aff upstream.

Their power value is initialized to zero. This patch fixes an issue
where the configured power drops to the minimum value when AP_VLAN
interfaces are created/removed.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/mac80211/main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index e765f77bb97a..2c5f21c7857f 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -148,6 +148,8 @@ static u32 ieee80211_hw_conf_chan(struct ieee80211_local *local)
 	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
 		if (!rcu_access_pointer(sdata->vif.chanctx_conf))
 			continue;
+		if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
+			continue;
 		power = min(power, sdata->vif.bss_conf.txpower);
 	}
 	rcu_read_unlock();
-- 
1.9.3

