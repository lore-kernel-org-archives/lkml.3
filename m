Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756564Ab3ETKxv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 06:53:51 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56352 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756400Ab3ETKxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 06:53:49 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Patrick McHardy <kaber@trash.net>, "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 089/115] net: use netdev_features_t in skb_needs_linearize()
Date: Mon, 20 May 2013 11:51:29 +0100
Message-Id: <1369047116-9378-90-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
References: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Patrick McHardy <kaber@trash.net>

commit 6708c9e5cc9bfc7c9a00ce9c0fdd0b1d4952b3d1 upstream.

Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/core/dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index ba9d7a7..a0eaa60 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2168,7 +2168,7 @@ EXPORT_SYMBOL(netif_skb_features);
  *	   support DMA from it.
  */
 static inline int skb_needs_linearize(struct sk_buff *skb,
-				      int features)
+				      netdev_features_t features)
 {
 	return skb_is_nonlinear(skb) &&
 			((skb_has_frag_list(skb) &&
-- 
1.8.1.2

