Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934323AbaEKTsW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 15:48:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48202 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933225AbaEKTXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 15:23:23 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Felix Fietkau <nbd@openwrt.org>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.14 46/83] mac80211: exclude AP_VLAN interfaces from tx power calculation
Date: Sun, 11 May 2014 21:19:47 +0200
Message-Id: <20140511191913.180337513@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140511191907.024339448@linuxfoundation.org>
References: <20140511191907.024339448@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit 764152ff66f4a8be1f9d7981e542ffdaa5bd7aff upstream.

Their power value is initialized to zero. This patch fixes an issue
where the configured power drops to the minimum value when AP_VLAN
interfaces are created/removed.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/main.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -148,6 +148,8 @@ static u32 ieee80211_hw_conf_chan(struct
 	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
 		if (!rcu_access_pointer(sdata->vif.chanctx_conf))
 			continue;
+		if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
+			continue;
 		power = min(power, sdata->vif.bss_conf.txpower);
 	}
 	rcu_read_unlock();


