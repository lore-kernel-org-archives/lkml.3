Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424AbbAVSDB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 13:03:01 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:56619 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752839AbbAVSC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 13:02:59 -0500
From: Mohammad Jamal <md.jamalmohiuddin@gmail.com>
To: davem@davemloft.net, therbert@google.com, edumazet@google.com,
        viro@zeniv.linux.org.uk, alexander.h.duyck@redhat.com,
        willemb@google.com, hannes@stressinduktion.org,
        linux-kernel@vger.kernel.org
Cc: Mohammad Jamal <md.jamalmohiuddin@gmail.com>
Subject: [PATCH] include:linux:Optimizations to __skb_push
Date: Thu, 22 Jan 2015 23:32:40 +0530
Message-Id: <1421949760-5705-1-git-send-email-md.jamalmohiuddin@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch optimizes __skb_push function

Signed-off-by: Mohammad Jamal <md.jamalmohiuddin@gmail.com>
---
 include/linux/skbuff.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 85ab7d7..9acffb2 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1671,9 +1671,8 @@ static inline unsigned char *__skb_put(struct sk_buff *skb, unsigned int len)
 unsigned char *skb_push(struct sk_buff *skb, unsigned int len);
 static inline unsigned char *__skb_push(struct sk_buff *skb, unsigned int len)
 {
-	skb->data -= len;
 	skb->len  += len;
-	return skb->data;
+	return skb->data -= len;
 }
 
 unsigned char *skb_pull(struct sk_buff *skb, unsigned int len);
-- 
1.7.9.5

