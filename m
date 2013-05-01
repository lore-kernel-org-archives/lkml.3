Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756819Ab3EAT23 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 15:28:29 -0400
Received: from casper.infradead.org ([85.118.1.10]:50383 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756025Ab3EAT2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 15:28:18 -0400
Message-ID: <51816CA3.7000806@infradead.org>
Date: Wed, 01 May 2013 12:27:31 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
Subject: [PATCH -next] staging: sep: fix driver build and kconfig
References: <20130501183734.7ad1efca2d06e75432edabbd@canb.auug.org.au>
In-Reply-To: <20130501183734.7ad1efca2d06e75432edabbd@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Fix build errors in staging/sep/ by making DX_SEP depend on
CRYPTO.

drivers/built-in.o: In function `sep_sha1_init':
sep_crypto.c:(.text+0x245ece): undefined reference to `crypto_enqueue_request'
drivers/built-in.o: In function `sep_sha1_update':
sep_crypto.c:(.text+0x245f4f): undefined reference to `crypto_enqueue_request'
drivers/built-in.o: In function `sep_sha1_final':
sep_crypto.c:(.text+0x245fcf): undefined reference to `crypto_enqueue_request'
drivers/built-in.o: In function `sep_sha1_finup':
sep_crypto.c:(.text+0x24604f): undefined reference to `crypto_enqueue_request'
drivers/built-in.o: In function `sep_sha1_digest':
sep_crypto.c:(.text+0x2460de): undefined reference to `crypto_enqueue_request'
drivers/built-in.o:sep_crypto.c:(.text+0x24616e): more undefined references to `crypto_enqueue_request' follow
drivers/built-in.o: In function `sep_crypto_block':
sep_crypto.c:(.text+0x247c81): undefined reference to `ablkcipher_walk_phys'
sep_crypto.c:(.text+0x247e40): undefined reference to `ablkcipher_walk_phys'
drivers/built-in.o: In function `sep_dequeuer':
sep_crypto.c:(.text+0x248ab9): undefined reference to `crypto_dequeue_request'
sep_crypto.c:(.text+0x248afa): undefined reference to `crypto_ahash_type'
sep_crypto.c:(.text+0x248fdf): undefined reference to `crypto_dequeue_request'
drivers/built-in.o: In function `sep_crypto_setup':
(.text+0x24902a): undefined reference to `crypto_init_queue'
drivers/built-in.o: In function `sep_crypto_setup':
(.text+0x24909c): undefined reference to `crypto_register_ahash'
drivers/built-in.o: In function `sep_crypto_setup':
(.text+0x2490c4): undefined reference to `crypto_register_alg'
drivers/built-in.o: In function `sep_crypto_setup':
(.text+0x2490f7): undefined reference to `crypto_unregister_alg'
drivers/built-in.o: In function `sep_crypto_setup':
(.text+0x249118): undefined reference to `crypto_unregister_ahash'
drivers/built-in.o: In function `sep_crypto_takedown':
(.text+0x249176): undefined reference to `crypto_unregister_ahash'
drivers/built-in.o: In function `sep_crypto_takedown':
(.text+0x249197): undefined reference to `crypto_unregister_alg'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
 drivers/staging/sep/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20130501.orig/drivers/staging/sep/Kconfig
+++ linux-next-20130501/drivers/staging/sep/Kconfig
@@ -1,6 +1,6 @@
 config DX_SEP
 	tristate "Discretix SEP driver"
-	depends on PCI
+	depends on PCI && CRYPTO
 	help
 	  Discretix SEP driver; used for the security processor subsystem
 	  on board the Intel Mobile Internet Device and adds SEP availability
