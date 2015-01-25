Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758952AbbAYTB7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 14:01:59 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57564 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755483AbbAYSJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:09:37 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.18 008/183] net: drop the packet when fails to do software segmentation or header check
Date: Sun, 25 Jan 2015 10:05:30 -0800
Message-Id: <20150125180810.550782960@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180810.160428929@linuxfoundation.org>
References: <20150125180810.160428929@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Wang <jasowang@redhat.com>

[ Upstream commit af6dabc9c70ae3f307685b1f32f52d60b1bf0527 ]

Commit cecda693a969816bac5e470e1d9c9c0ef5567bca ("net: keep original skb
which only needs header checking during software GSO") keeps the original
skb for packets that only needs header check, but it doesn't drop the
packet if software segmentation or header check were failed.

Fixes cecda693a9 ("net: keep original skb which only needs header checking during software GSO")
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/dev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2680,7 +2680,7 @@ static struct sk_buff *validate_xmit_skb
 
 		segs = skb_gso_segment(skb, features);
 		if (IS_ERR(segs)) {
-			segs = NULL;
+			goto out_kfree_skb;
 		} else if (segs) {
 			consume_skb(skb);
 			skb = segs;


