Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754362AbaLIWwp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 17:52:45 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:37491 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753984AbaLIWum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 17:50:42 -0500
From: Al Viro <viro@ZenIV.linux.org.uk>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 23/25] ppp_read(): switch to skb_copy_datagram_iter()
Date: Tue,  9 Dec 2014 22:50:36 +0000
Message-Id: <1418165438-2205-23-git-send-email-viro@ZenIV.linux.org.uk>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <20141209224928.GL22149@ZenIV.linux.org.uk>
References: <20141209224928.GL22149@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/net/ppp/ppp_generic.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ppp/ppp_generic.c b/drivers/net/ppp/ppp_generic.c
index 794a473..af034db 100644
--- a/drivers/net/ppp/ppp_generic.c
+++ b/drivers/net/ppp/ppp_generic.c
@@ -417,6 +417,7 @@ static ssize_t ppp_read(struct file *file, char __user *buf,
 	ssize_t ret;
 	struct sk_buff *skb = NULL;
 	struct iovec iov;
+	struct iov_iter to;
 
 	ret = count;
 
@@ -462,7 +463,8 @@ static ssize_t ppp_read(struct file *file, char __user *buf,
 	ret = -EFAULT;
 	iov.iov_base = buf;
 	iov.iov_len = count;
-	if (skb_copy_datagram_iovec(skb, 0, &iov, skb->len))
+	iov_iter_init(&to, READ, &iov, 1, count);
+	if (skb_copy_datagram_iter(skb, 0, &to, skb->len))
 		goto outf;
 	ret = skb->len;
 
-- 
2.1.3

