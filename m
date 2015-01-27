Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758624AbbA0MTB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:19:01 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35177 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932363AbbA0MSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:18:40 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Thomas Graf <tgraf@suug.ch>, "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 065/126] net: Reset secmark when scrubbing packet
Date: Tue, 27 Jan 2015 12:16:10 +0000
Message-Id: <1422361031-19364-66-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
References: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Graf <tgraf@suug.ch>

commit b8fb4e0648a2ab3734140342002f68fb0c7d1602 upstream.

skb_scrub_packet() is called when a packet switches between a context
such as between underlay and overlay, between namespaces, or between
L3 subnets.

While we already scrub the packet mark, connection tracking entry,
and cached destination, the security mark/context is left intact.

It seems wrong to inherit the security context of a packet when going
from overlay to underlay or across forwarding paths.

Signed-off-by: Thomas Graf <tgraf@suug.ch>
Acked-by: Flavio Leitner <fbl@sysclose.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/core/skbuff.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index f5f14d54d6a2..fe07faaed256 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3933,6 +3933,7 @@ void skb_scrub_packet(struct sk_buff *skb, bool xnet)
 	skb->ignore_df = 0;
 	skb_dst_drop(skb);
 	skb->mark = 0;
+	skb_init_secmark(skb);
 	secpath_reset(skb);
 	nf_reset(skb);
 	nf_reset_trace(skb);
-- 
2.1.4

