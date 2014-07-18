Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965830AbaGRNQ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:16:59 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17891 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S935182AbaGRNQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:16:50 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?q?Krzysztof=20Ha=C5=82asa?= <khalasa@piap.pl>,
        Johannes Berg <johannes.berg@intel.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 096/170] mac80211: fix IBSS join by initializing last_scan_completed
Date: Fri, 18 Jul 2014 14:11:41 +0200
Message-Id: <8b623dad986de9a560cae3f61a2be21180f10add.1405685481.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
References: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
In-Reply-To: <cover.1405685481.git.jslaby@suse.cz>
References: <cover.1405685481.git.jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Krzysztof Hałasa <khalasa@piap.pl>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit c7d37a66e345df2fdf1aa7b2c9a6d3d53846ca5b upstream.

Without this fix, freshly rebooted Linux creates a new IBSS
instead of joining an existing one. Only when jiffies counter
overflows after 5 minutes the IBSS can be successfully joined.

Signed-off-by: Krzysztof Hałasa <khalasa@piap.pl>
[edit commit message slightly]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/mac80211/ibss.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index a12afe77bb26..f69cac4bf39f 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -1203,6 +1203,7 @@ int ieee80211_ibss_join(struct ieee80211_sub_if_data *sdata,
 	sdata->u.ibss.privacy = params->privacy;
 	sdata->u.ibss.control_port = params->control_port;
 	sdata->u.ibss.basic_rates = params->basic_rates;
+	sdata->u.ibss.last_scan_completed = jiffies;
 
 	/* fix basic_rates if channel does not support these rates */
 	rate_flags = ieee80211_chandef_rate_flags(&params->chandef);
-- 
2.0.0

