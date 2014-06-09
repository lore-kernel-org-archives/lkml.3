Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933539AbaFIIze (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 04:55:34 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58589 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932250AbaFIIv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 04:51:27 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Tim Chen <tim.c.chen@linux.intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 086/146] crypto: crypto_wq - Fix late crypto work queue initialization
Date: Mon,  9 Jun 2014 10:50:21 +0200
Message-Id: <11fb773d97473b4eea536817cbd0f6834714727f.1402303821.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
References: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
In-Reply-To: <cover.1402303820.git.jslaby@suse.cz>
References: <cover.1402303820.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tim Chen <tim.c.chen@linux.intel.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 crypto/crypto_wq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/crypto_wq.c b/crypto/crypto_wq.c
index adad92a44ba2..2f1b8d12952a 100644
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
1.9.3

