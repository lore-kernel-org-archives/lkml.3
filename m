Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932686AbaJ2L6M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 07:58:12 -0400
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:15187 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932390AbaJ2L6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 07:58:11 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgMTANfVUFRXQzqR/2dsb2JhbABcgw6BLLo0BgEBAQEBBQF0mkEEAoEaFwEBAQEBfYQwLyOBGjeIRQG3II8bhjWJcGQdhDUFnWiWOIFHAYIxPC+BBoFFAQEB
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org
Subject: [PATCH 1/1 net-next] ipv6: remove assignment in if condition
Date: Wed, 29 Oct 2014 12:57:51 +0100
Message-Id: <1414583871-14196-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do assignment before if condition and test !skb like in rawv6_recvmsg()

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 net/ipv6/raw.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
index 896af88..075a0fb 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -548,7 +548,8 @@ static int rawv6_push_pending_frames(struct sock *sk, struct flowi6 *fl6,
 	if (!rp->checksum)
 		goto send;
 
-	if ((skb = skb_peek(&sk->sk_write_queue)) == NULL)
+	skb = skb_peek(&sk->sk_write_queue);
+	if (!skb)
 		goto out;
 
 	offset = rp->offset;
-- 
1.9.3

