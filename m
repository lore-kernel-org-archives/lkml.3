Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934086AbaFQQ7G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 12:59:06 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50419 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933627AbaFQQPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 12:15:40 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Felix Fietkau <nbd@openwrt.org>, Johannes Berg <johannes.berg@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 004/121] mac80211: exclude AP_VLAN interfaces from tx power calculation
Date: Tue, 17 Jun 2014 09:13:17 -0700
Message-Id: <1403021714-16320-5-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403021714-16320-1-git-send-email-kamal@canonical.com>
References: <1403021714-16320-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.24 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit 764152ff66f4a8be1f9d7981e542ffdaa5bd7aff upstream.

Their power value is initialized to zero. This patch fixes an issue
where the configured power drops to the minimum value when AP_VLAN
interfaces are created/removed.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/mac80211/main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index e93d39d..6079959 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -157,6 +157,8 @@ static u32 ieee80211_hw_conf_chan(struct ieee80211_local *local)
 	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
 		if (!rcu_access_pointer(sdata->vif.chanctx_conf))
 			continue;
+		if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
+			continue;
 		power = min(power, sdata->vif.bss_conf.txpower);
 	}
 	rcu_read_unlock();
-- 
1.9.1

