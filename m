Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933464Ab3E1VcA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 17:32:00 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59760 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933208Ab3E1VZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 17:25:30 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Chen Gang <gang.chen@asianux.com>, "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 61/78] net: mac802154: comparision issue of type cast, finding by EXTRA_CFLAGS=-W
Date: Tue, 28 May 2013 14:20:10 -0700
Message-Id: <1369776027-17859-62-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369776027-17859-1-git-send-email-kamal@canonical.com>
References: <1369776027-17859-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Gang <gang.chen@asianux.com>

[ Upstream commit 2c1bbbffa0b644fab4f91878cde0c2e8f52e2dcc ]

Change MAC802154_CHAN_NONE from ~(u8)0 to 0xff, or the comparison in
mac802154_wpan_xmit() for ``chan == MAC802154_CHAN_NONE'' will not
succeed.

This bug can be boiled down to ``u8 foo = 0xff; if (foo == ~(u8)0)
[...] else [...]'' where the condition will always take the else
branch.

Signed-off-by: Chen Gang <gang.chen@asianux.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/mac802154/mac802154.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac802154/mac802154.h b/net/mac802154/mac802154.h
index a4dcaf1..703c121 100644
--- a/net/mac802154/mac802154.h
+++ b/net/mac802154/mac802154.h
@@ -90,7 +90,7 @@ struct mac802154_sub_if_data {
 
 #define MAC802154_MAX_XMIT_ATTEMPTS	3
 
-#define MAC802154_CHAN_NONE		(~(u8)0) /* No channel is assigned */
+#define MAC802154_CHAN_NONE		0xff /* No channel is assigned */
 
 extern struct ieee802154_reduced_mlme_ops mac802154_mlme_reduced;
 extern struct ieee802154_mlme_ops mac802154_mlme_wpan;
-- 
1.8.1.2

