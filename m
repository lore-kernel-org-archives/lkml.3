Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755928Ab3IKE6e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 00:58:34 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3257 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754287Ab3IKE5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:57:00 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=4Le3xRq4WwAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=KBTWNNNkQUkA:10 a=QyXUC8HyAAAA:8 a=VwQbUJbxAAAA:8 a=Zz6ZsNEf_ELq4pe8PIAA:9 a=dGJ0OcVc7YAA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042925.453170841@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:30:27 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Ilan Peer <ilan.peer@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [200/251] cfg80211: fix P2P GO interface teardown
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0200-cfg80211-fix-P2P-GO-interface-teardown.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 74418edec915d0f446debebde08d170c7b8ba0ee ]

When a P2P GO interface goes down, cfg80211 doesn't properly
tear it down, leading to warnings later. Add the GO interface
type to the enumeration to tear it down like AP interfaces.
Otherwise, we leave it pending and mac80211's state can get
very confused, leading to warnings later.

Cc: stable@vger.kernel.org
Reported-by: Ilan Peer <ilan.peer@intel.com>
Tested-by: Ilan Peer <ilan.peer@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 net/wireless/core.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index a10901b..250e0a6 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -846,6 +846,7 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 			cfg80211_leave_mesh(rdev, dev);
 			break;
 		case NL80211_IFTYPE_AP:
+		case NL80211_IFTYPE_P2P_GO:
 			cfg80211_stop_ap(rdev, dev);
 			break;
 		default:
-- 
1.7.10.4


