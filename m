Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756601AbaFEAX7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 20:23:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40125 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753126AbaFDXW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:22:26 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 3.14 127/228] crypto: crypto_wq - Fix late crypto work queue initialization
Date: Wed,  4 Jun 2014 16:22:36 -0700
Message-Id: <20140604232352.112650002@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232347.966798903@linuxfoundation.org>
References: <20140604232347.966798903@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 crypto/crypto_wq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/crypto/crypto_wq.c
+++ b/crypto/crypto_wq.c
@@ -33,7 +33,7 @@ static void __exit crypto_wq_exit(void)
 	destroy_workqueue(kcrypto_wq);
 }
 
-module_init(crypto_wq_init);
+subsys_initcall(crypto_wq_init);
 module_exit(crypto_wq_exit);
 
 MODULE_LICENSE("GPL");


