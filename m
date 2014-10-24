Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756219AbaJXLSv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 07:18:51 -0400
Received: from mail-yh0-f43.google.com ([209.85.213.43]:55470 "EHLO
	mail-yh0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756191AbaJXLSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 07:18:50 -0400
Date: Fri, 24 Oct 2014 06:16:42 -0500
From: Eric Rost <eric.rost@mybabylon.net>
To: gregkh@linuxfoundation.org, jason@lakedaemon.net, jake@lwn.net,
        antonysaraev@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 1/7] staging: skein: Collapses threefish module
Message-ID: <d0e59d4120e4e85a33277590d8e6f17daefa01b8.1414149238.git.eric.rost@mybabylon.net>
References: <cover.1414149238.git.eric.rost@mybabylon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1414149238.git.eric.rost@mybabylon.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Collapses threefish module into skein module.

Signed-off-by: Eric Rost <eric.rost@mybabylon.net>
---
 drivers/staging/skein/Kconfig  | 22 +++-------------------
 drivers/staging/skein/Makefile | 11 +++++------
 2 files changed, 8 insertions(+), 25 deletions(-)

diff --git a/drivers/staging/skein/Kconfig b/drivers/staging/skein/Kconfig
index b9172bf..de8bdd7 100644
--- a/drivers/staging/skein/Kconfig
+++ b/drivers/staging/skein/Kconfig
@@ -1,8 +1,8 @@
 config CRYPTO_SKEIN
 	bool "Skein digest algorithm"
 	depends on (X86 || UML_X86) && 64BIT && CRYPTO
-	select CRYPTO_THREEFISH
 	select CRYPTO_HASH
+	select CRYPTO_ALGAPI
 	help
 	  Skein secure hash algorithm is one of 5 finalists from the NIST SHA3
 	  competition.
@@ -12,21 +12,5 @@ config CRYPTO_SKEIN
 
 	  http://www.skein-hash.info/sites/default/files/skein1.3.pdf
 
-	  for more information.  This module depends on the threefish block
-	  cipher module.
-
-config CRYPTO_THREEFISH
-	bool "Threefish tweakable block cipher"
-	depends on (X86 || UML_X86) && 64BIT && CRYPTO
-	select CRYPTO_ALGAPI
-	help
-	  Threefish cipher algorithm is the tweakable block cipher underneath
-	  the Skein family of secure hash algorithms.  Skein is one of 5
-	  finalists from the NIST SHA3 competition.
-
-	  Skein is optimized for modern, 64bit processors and is highly
-	  customizable.  See:
-
-	  http://www.skein-hash.info/sites/default/files/skein1.3.pdf
-
-	  for more information.
+	  for more information. This module also contains the threefish block
+	  cipher algorithm.
diff --git a/drivers/staging/skein/Makefile b/drivers/staging/skein/Makefile
index a14aadd..4b60171 100644
--- a/drivers/staging/skein/Makefile
+++ b/drivers/staging/skein/Makefile
@@ -1,9 +1,8 @@
 #
 # Makefile for the skein secure hash algorithm
 #
-obj-$(CONFIG_CRYPTO_SKEIN) +=   skein.o \
-				skein_api.o \
-				skein_block.o
-
-obj-$(CONFIG_CRYPTO_THREEFISH) += threefish_block.o \
-				  threefish_api.o
+obj-$(CONFIG_CRYPTO_SKEIN) += skein.o \
+			      skein_api.o \
+			      skein_block.o \
+			      threefish_block.o \
+			      threefish_api.o
-- 
2.1.1

