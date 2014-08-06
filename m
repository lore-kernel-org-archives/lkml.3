Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551AbaHFEqj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 00:46:39 -0400
Received: from s87.loopia.se ([194.9.94.112]:34177 "EHLO s87.loopia.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754758AbaHFEnw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 00:43:52 -0400
X-Spam-Flag: NO
X-Spam-Score: -1
From: Hans Wennborg <hans@hanshq.net>
To: akarwar@marvell.com, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Hans Wennborg <hans@hanshq.net>
Subject: [PATCH 07/15] mwifiex: fix decimal printf format specifiers prefixed with 0x
Date: Tue,  5 Aug 2014 21:42:55 -0700
Message-Id: <1407300175-32635-1-git-send-email-hans@hanshq.net>
X-Mailer: git-send-email 2.0.0.526.g5318336
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The prefix suggests the number should be printed in hex, so use
the %x specifier to do that.

Found by using regex suggested by Joe Perches.

Signed-off-by: Hans Wennborg <hans@hanshq.net>
---
 drivers/net/wireless/mwifiex/cfg80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index e2e6bf1..2856f0e 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -246,7 +246,7 @@ mwifiex_cfg80211_remain_on_channel(struct wiphy *wiphy,
 	}
 
 	if (priv->roc_cfg.cookie) {
-		wiphy_dbg(wiphy, "info: ongoing ROC, cookie = 0x%llu\n",
+		wiphy_dbg(wiphy, "info: ongoing ROC, cookie = 0x%llx\n",
 			  priv->roc_cfg.cookie);
 		return -EBUSY;
 	}
-- 
2.0.0.526.g5318336

