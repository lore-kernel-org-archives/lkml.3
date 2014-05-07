Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933149AbaEGNOq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 09:14:46 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:45536 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933123AbaEGNOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 09:14:43 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tim Chen <tim.c.chen@linux.intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 38/70] crypto: crypto_wq - Fix late crypto work queue initialization
Date: Wed,  7 May 2014 14:12:41 +0100
Message-Id: <1399468393-10140-39-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399468393-10140-1-git-send-email-luis.henriques@canonical.com>
References: <1399468393-10140-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tim Chen <tim.c.chen@linux.intel.com>

commit 130fa5bc81b44b6cc1fbdea3abf6db0da22964e0 upstream.

The crypto algorithm modules utilizing the crypto daemon could
be used early when the system start up.  Using module_init
does not guarantee that the daemon's work queue is initialized
when the cypto alorithm depending on crypto_wq starts.  It is necessary
to initialize the crypto work queue earlier at the subsystem
init time to make sure that it is initialized
when used.

Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 crypto/crypto_wq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/crypto_wq.c b/crypto/crypto_wq.c
index adad92a..2f1b8d1 100644
--- a/crypto/crypto_wq.c
+++ b/crypto/crypto_wq.c
@@ -33,7 +33,7 @@ static void __exit crypto_wq_exit(void)
 	destroy_workqueue(kcrypto_wq);
 }
 
-module_init(crypto_wq_init);
+subsys_initcall(crypto_wq_init);
 module_exit(crypto_wq_exit);
 
 MODULE_LICENSE("GPL");
-- 
1.9.1

