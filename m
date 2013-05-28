Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933332Ab3E1VZg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 17:25:36 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59765 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933163Ab3E1VZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 17:25:33 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Patrick McHardy <kaber@trash.net>, "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 65/78] net: use netdev_features_t in skb_needs_linearize()
Date: Tue, 28 May 2013 14:20:14 -0700
Message-Id: <1369776027-17859-66-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369776027-17859-1-git-send-email-kamal@canonical.com>
References: <1369776027-17859-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Patrick McHardy <kaber@trash.net>

[ Upstream commit 6708c9e5cc9bfc7c9a00ce9c0fdd0b1d4952b3d1 ]

Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/core/dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index d592214..e55fb91 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2290,7 +2290,7 @@ EXPORT_SYMBOL(netif_skb_features);
  *	2. skb is fragmented and the device does not support SG.
  */
 static inline int skb_needs_linearize(struct sk_buff *skb,
-				      int features)
+				      netdev_features_t features)
 {
 	return skb_is_nonlinear(skb) &&
 			((skb_has_frag_list(skb) &&
-- 
1.8.1.2

