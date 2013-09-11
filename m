Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757250Ab3IKFdi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 01:33:38 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3257 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754615Ab3IKE5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:57:20 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=2eUqJNqmaHoA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=uTb-VIio9ugA:10 a=stkexhm8AAAA:8 a=VwQbUJbxAAAA:8 a=5cIBTxRJ4pZzZk2xk6UA:9 a=DV8Pb4sAe4kA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042915.429131235@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:29:26 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>
Subject: [139/251] mac80211: fix ethtool stats for non-station interfaces
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0139-mac80211-fix-ethtool-stats-for-non-station-interface.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes@sipsolutions.net>

[ Upstream commit e13bae4f807401729b3f27c7e882a96b8b292809 ]

As reported in https://bugzilla.kernel.org/show_bug.cgi?id=60514,
the station loop never initialises 'sinfo' and therefore adds up
a stack values, leaking stack information (the number of times it
adds values is easily obtained another way.)

Fix this by initialising the sinfo for each station to add.

Cc: stable@vger.kernel.org
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 net/mac80211/cfg.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index bb8d96b..cf9523e 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -554,6 +554,8 @@ static void ieee80211_get_et_stats(struct wiphy *wiphy,
 			if (sta->sdata->dev != dev)
 				continue;
 
+			sinfo.filled = 0;
+			sta_set_sinfo(sta, &sinfo);
 			i = 0;
 			ADD_STA_STATS(sta);
 		}
-- 
1.7.10.4


