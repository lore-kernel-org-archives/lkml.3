Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555Ab3JSNOK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 09:14:10 -0400
Received: from mail-gg0-f178.google.com ([209.85.161.178]:33047 "EHLO
	mail-gg0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011Ab3JSNOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 09:14:09 -0400
From: "Geyslan G. Bem" <geyslan@gmail.com>
To: kernel-br@googlegroups.com
Cc: "Geyslan G. Bem" <geyslan@gmail.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org (open list:CRYPTO API),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] crypto: n2_core: insert '!err' condition in else scope
Date: Sat, 19 Oct 2013 10:09:31 -0300
Message-Id: <1382188171-25595-1-git-send-email-geyslan@gmail.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves the '!err' condition into the above else scope,
what is more obvious and has the secondary goal of avoid false-positives
in statical analyze tools.

Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
---
 drivers/crypto/n2_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/n2_core.c b/drivers/crypto/n2_core.c
index e1f0ab4..afc6983 100644
--- a/drivers/crypto/n2_core.c
+++ b/drivers/crypto/n2_core.c
@@ -1511,9 +1511,9 @@ static int __n2_register_one_ahash(const struct n2_hash_tmpl *tmpl)
 		kfree(p);
 	} else {
 		pr_info("%s alg registered\n", base->cra_name);
+		if (p->hmac_type != AUTH_TYPE_RESERVED)
+			err = __n2_register_one_hmac(p);
 	}
-	if (!err && p->hmac_type != AUTH_TYPE_RESERVED)
-		err = __n2_register_one_hmac(p);
 	return err;
 }
 
-- 
1.8.4

