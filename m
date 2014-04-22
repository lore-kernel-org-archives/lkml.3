Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755AbaDVTag (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 15:30:36 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:48150 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752285AbaDVTae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 15:30:34 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: security@kernel.org, ebiederm@xmission.com,
        Andy Lutomirski <luto@amacapital.net>, stable@vger.kernel.org
Subject: [PATCH] crypto_user: Fix out-of-bounds read
Date: Tue, 22 Apr 2014 12:30:28 -0700
Message-Id: <57bf4e51f05fad506a0d1638852a5233b359e1dc.1398194946.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is unlikely to be exploitable for anything except an OOPS.

Cc: stable@vger.kernel.org
Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---

Notes:
    This is entirely untested, but it looks obviously correct to me.

 crypto/crypto_user.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/crypto_user.c b/crypto/crypto_user.c
index 1512e41..bc7c4b5 100644
--- a/crypto/crypto_user.c
+++ b/crypto/crypto_user.c
@@ -460,7 +460,7 @@ static int crypto_user_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 	int type, err;
 
 	type = nlh->nlmsg_type;
-	if (type > CRYPTO_MSG_MAX)
+	if (type < CRYPTO_MSG_BASE || type > CRYPTO_MSG_MAX)
 		return -EINVAL;
 
 	type -= CRYPTO_MSG_BASE;
-- 
1.9.0

