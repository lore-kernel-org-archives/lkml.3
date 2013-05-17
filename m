Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758127Ab3EQWN0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 18:13:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54245 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757121Ab3EQVhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 17:37:41 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Patrick McHardy <kaber@trash.net>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 061/102] net: use netdev_features_t in skb_needs_linearize()
Date: Fri, 17 May 2013 14:36:16 -0700
Message-Id: <20130517213250.795489575@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130517213244.277411019@linuxfoundation.org>
References: <20130517213244.277411019@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Patrick McHardy <kaber@trash.net>

[ Upstream commit 6708c9e5cc9bfc7c9a00ce9c0fdd0b1d4952b3d1 ]

Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/dev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2458,7 +2458,7 @@ EXPORT_SYMBOL(netif_skb_features);
  *	2. skb is fragmented and the device does not support SG.
  */
 static inline int skb_needs_linearize(struct sk_buff *skb,
-				      int features)
+				      netdev_features_t features)
 {
 	return skb_is_nonlinear(skb) &&
 			((skb_has_frag_list(skb) &&


