Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753658AbaJWWOn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 18:14:43 -0400
Received: from mail-qc0-f170.google.com ([209.85.216.170]:48355 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233AbaJWWOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 18:14:41 -0400
Date: Thu, 23 Oct 2014 17:12:31 -0500
From: Eric Rost <eric.rost@mybabylon.net>
To: gregkh@linuxfoundation.org, jason@lakedaemon.net, jake@lwn.net,
        antonysaraev@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/2] staging: skein: Adds Loadable Module Support
Message-ID: <fa9c4d268834eda2f66280e24ca2fdaf4fabcf30.1414102205.git.eric.rost@mybabylon.net>
References: <cover.1414102205.git.eric.rost@mybabylon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1414102205.git.eric.rost@mybabylon.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds loadable module support for the Skein Hashing Algorithm.

Signed-off-by: Eric Rost <eric.rost@mybabylon.net>
---
 drivers/staging/skein/Kconfig         |  2 +-
 drivers/staging/skein/skein_generic.c | 19 ++++++++++++++++++-
 2 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/skein/Kconfig b/drivers/staging/skein/Kconfig
index de8bdd7..012a823 100644
--- a/drivers/staging/skein/Kconfig
+++ b/drivers/staging/skein/Kconfig
@@ -1,5 +1,5 @@
 config CRYPTO_SKEIN
-	bool "Skein digest algorithm"
+	tristate "Skein digest algorithm"
 	depends on (X86 || UML_X86) && 64BIT && CRYPTO
 	select CRYPTO_HASH
 	select CRYPTO_ALGAPI
diff --git a/drivers/staging/skein/skein_generic.c b/drivers/staging/skein/skein_generic.c
index 815f9a4..3c9c6d0 100644
--- a/drivers/staging/skein/skein_generic.c
+++ b/drivers/staging/skein/skein_generic.c
@@ -16,6 +16,7 @@
  */
 #include <linux/types.h>
 #include <linux/init.h>
+#include <linux/module.h>
 #include <crypto/internal/hash.h>
 #include "skein_base.h"
 
@@ -142,6 +143,7 @@ static struct shash_alg alg256 = {
 		.cra_driver_name	=	"skein",
 		.cra_flags		=	CRYPTO_ALG_TYPE_SHASH,
 		.cra_blocksize		=	SKEIN_256_BLOCK_BYTES,
+		.cra_module		=	THIS_MODULE,
 	}
 };
 
@@ -159,6 +161,7 @@ static struct shash_alg alg512 = {
 		.cra_driver_name	=	"skein",
 		.cra_flags		=	CRYPTO_ALG_TYPE_SHASH,
 		.cra_blocksize		=	SKEIN_512_BLOCK_BYTES,
+		.cra_module		=	THIS_MODULE,
 	}
 };
 
@@ -176,6 +179,7 @@ static struct shash_alg alg1024 = {
 		.cra_driver_name	=	"skein",
 		.cra_flags		=	CRYPTO_ALG_TYPE_SHASH,
 		.cra_blocksize		=	SKEIN_1024_BLOCK_BYTES,
+		.cra_module		=	THIS_MODULE,
 	}
 };
 
@@ -191,4 +195,17 @@ static int __init skein_generic_init(void)
 	return 0;
 }
 
-device_initcall(skein_generic_init);
+static void __exit skein_generic_fini(void)
+{
+	crypto_unregister_shash(&alg256);
+	crypto_unregister_shash(&alg512);
+	crypto_unregister_shash(&alg1024);
+}
+
+module_init(skein_generic_init);
+module_exit(skein_generic_fini);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Skein Hash Algorithm");
+
+MODULE_ALIAS("skein");
-- 
2.1.1

