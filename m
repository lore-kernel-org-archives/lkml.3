Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751317AbaESEMg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 00:12:36 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:40278 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbaESEMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 00:12:05 -0400
From: Anton Saraev <antonysaraev@gmail.com>
To: gregkh@linuxfoundation.org
Cc: antonysaraev@gmail.com, jason@lakedaemon.net, jake@lwn.net,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 06/06] staging: crypto: skein: rename files
Date: Mon, 19 May 2014 12:09:59 +0400
Message-Id: <a5204985750d7adf9b20752f889fbf2a2147de94.1399675445.git.antonysaraev@gmail.com>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <2eac124c6a3815c72e91679c8cde729af712bb74.1399675445.git.antonysaraev@gmail.com>
References: <cover.1399675444.git.antonysaraev@gmail.com>
 <abebc2187151826190d6f664acc654241b352ffa.1399675444.git.antonysaraev@gmail.com>
 <dad2a43d54d03ba2b4fae9136331df060c48154c.1399675444.git.antonysaraev@gmail.com>
 <cba3f6453b416ea04b03ad2d165f600e3e39f152.1399675444.git.antonysaraev@gmail.com>
 <b4028782c333773298763d58e14753067c6ae745.1399675444.git.antonysaraev@gmail.com>
 <2eac124c6a3815c72e91679c8cde729af712bb74.1399675445.git.antonysaraev@gmail.com>
In-Reply-To: <cover.1399675444.git.antonysaraev@gmail.com>
References: <cover.1399675444.git.antonysaraev@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

camelCase is not accepted in the Linux Kernel. To prepare skein
driver for mainline inclusion, we rename all files to
non-camelCase equivalents.

Signed-off-by: Anton Saraev <antonysaraev@gmail.com>
---
 drivers/staging/skein/Makefile                                 | 10 +++++-----
 drivers/staging/skein/TODO                                     |  1 -
 drivers/staging/skein/include/{skeinApi.h => skein_api.h}      |  4 ++--
 .../staging/skein/include/{threefishApi.h => threefish_api.h}  |  2 +-
 drivers/staging/skein/{skeinApi.c => skein_api.c}              |  2 +-
 .../staging/skein/{skeinBlockNo3F.c => skein_block_no_3f.c}    |  2 +-
 .../skein/{threefish1024Block.c => threefish_1024_block.c}     |  2 +-
 .../skein/{threefish256Block.c => threefish_256_block.c}       |  2 +-
 .../skein/{threefish512Block.c => threefish_512_block.c}       |  2 +-
 drivers/staging/skein/{threefishApi.c => threefish_api.c}      |  3 +--
 10 files changed, 14 insertions(+), 16 deletions(-)
 rename drivers/staging/skein/include/{skeinApi.h => skein_api.h} (99%)
 rename drivers/staging/skein/include/{threefishApi.h => threefish_api.h} (99%)
 rename drivers/staging/skein/{skeinApi.c => skein_api.c} (99%)
 rename drivers/staging/skein/{skeinBlockNo3F.c => skein_block_no_3f.c} (99%)
 rename drivers/staging/skein/{threefish1024Block.c => threefish_1024_block.c} (99%)
 rename drivers/staging/skein/{threefish256Block.c => threefish_256_block.c} (99%)
 rename drivers/staging/skein/{threefish512Block.c => threefish_512_block.c} (99%)
 rename drivers/staging/skein/{threefishApi.c => threefish_api.c} (98%)

diff --git a/drivers/staging/skein/Makefile b/drivers/staging/skein/Makefile
index 2bb386e..29f51bf 100644
--- a/drivers/staging/skein/Makefile
+++ b/drivers/staging/skein/Makefile
@@ -4,10 +4,10 @@
 subdir-ccflags-y := -I$(src)/include/
 
 obj-$(CONFIG_CRYPTO_SKEIN) +=   skein.o \
-				skeinApi.o \
+				skein_api.o \
 				skein_block.o
 
-obj-$(CONFIG_CRYPTO_THREEFISH) += threefish1024Block.o \
-				  threefish256Block.o \
-				  threefish512Block.o \
-				  threefishApi.o
+obj-$(CONFIG_CRYPTO_THREEFISH) += threefish_1024_block.o \
+				  threefish_256_block.o \
+				  threefish_512_block.o \
+				  threefish_api.o
diff --git a/drivers/staging/skein/TODO b/drivers/staging/skein/TODO
index 88a6e81..cd3508d 100644
--- a/drivers/staging/skein/TODO
+++ b/drivers/staging/skein/TODO
@@ -1,6 +1,5 @@
 skein/threefish TODO
 
- - rename files
  - move macros into appropriate header files
  - add / pass test vectors
  - module support
diff --git a/drivers/staging/skein/include/skeinApi.h b/drivers/staging/skein/include/skein_api.h
similarity index 99%
rename from drivers/staging/skein/include/skeinApi.h
rename to drivers/staging/skein/include/skein_api.h
index b4e879d..87f769a 100644
--- a/drivers/staging/skein/include/skeinApi.h
+++ b/drivers/staging/skein/include/skein_api.h
@@ -28,7 +28,7 @@ OTHER DEALINGS IN THE SOFTWARE.
 #define SKEINAPI_H
 
 /**
- * @file skeinApi.h
+ * @file skein_api.h
  * @brief A Skein API and its functions.
  * @{
  *
@@ -44,7 +44,7 @@ OTHER DEALINGS IN THE SOFTWARE.
  *
  * @code
  *
- * #include <skeinApi.h>
+ * #include <skein_api.h>
  *
  * ...
  * struct skein_ctx ctx;             // a Skein hash or MAC context
diff --git a/drivers/staging/skein/include/threefishApi.h b/drivers/staging/skein/include/threefish_api.h
similarity index 99%
rename from drivers/staging/skein/include/threefishApi.h
rename to drivers/staging/skein/include/threefish_api.h
index 96cc0e8..fe28981 100644
--- a/drivers/staging/skein/include/threefishApi.h
+++ b/drivers/staging/skein/include/threefish_api.h
@@ -3,7 +3,7 @@
 #define THREEFISHAPI_H
 
 /**
- * @file threefishApi.h
+ * @file threefish_api.h
  * @brief A Threefish cipher API and its functions.
  * @{
  *
diff --git a/drivers/staging/skein/skeinApi.c b/drivers/staging/skein/skein_api.c
similarity index 99%
rename from drivers/staging/skein/skeinApi.c
rename to drivers/staging/skein/skein_api.c
index 16d596b..7fb0160 100644
--- a/drivers/staging/skein/skeinApi.c
+++ b/drivers/staging/skein/skein_api.c
@@ -25,7 +25,7 @@ OTHER DEALINGS IN THE SOFTWARE.
 */
 
 #include <linux/string.h>
-#include <skeinApi.h>
+#include <skein_api.h>
 
 int skein_ctx_prepare(struct skein_ctx *ctx, enum skein_size size)
 {
diff --git a/drivers/staging/skein/skeinBlockNo3F.c b/drivers/staging/skein/skein_block_no_3f.c
similarity index 99%
rename from drivers/staging/skein/skeinBlockNo3F.c
rename to drivers/staging/skein/skein_block_no_3f.c
index 4ee7f9f..23a3ac5 100644
--- a/drivers/staging/skein/skeinBlockNo3F.c
+++ b/drivers/staging/skein/skein_block_no_3f.c
@@ -1,7 +1,7 @@
 
 #include <linux/string.h>
 #include <skein.h>
-#include <threefishApi.h>
+#include <threefish_api.h>
 
 
 /*****************************  Skein_256 ******************************/
diff --git a/drivers/staging/skein/threefish1024Block.c b/drivers/staging/skein/threefish_1024_block.c
similarity index 99%
rename from drivers/staging/skein/threefish1024Block.c
rename to drivers/staging/skein/threefish_1024_block.c
index 827ce1a..7ecde26 100644
--- a/drivers/staging/skein/threefish1024Block.c
+++ b/drivers/staging/skein/threefish_1024_block.c
@@ -1,5 +1,5 @@
 #include <linux/string.h>
-#include <threefishApi.h>
+#include <threefish_api.h>
 
 
 void threefish_encrypt_1024(struct threefish_key *key_ctx, u64 *input,
diff --git a/drivers/staging/skein/threefish256Block.c b/drivers/staging/skein/threefish_256_block.c
similarity index 99%
rename from drivers/staging/skein/threefish256Block.c
rename to drivers/staging/skein/threefish_256_block.c
index 1329c71..6bb747c 100644
--- a/drivers/staging/skein/threefish256Block.c
+++ b/drivers/staging/skein/threefish_256_block.c
@@ -1,5 +1,5 @@
 #include <linux/string.h>
-#include <threefishApi.h>
+#include <threefish_api.h>
 
 
 void threefish_encrypt_256(struct threefish_key *key_ctx, u64 *input,
diff --git a/drivers/staging/skein/threefish512Block.c b/drivers/staging/skein/threefish_512_block.c
similarity index 99%
rename from drivers/staging/skein/threefish512Block.c
rename to drivers/staging/skein/threefish_512_block.c
index db50d83..68bf5c4 100644
--- a/drivers/staging/skein/threefish512Block.c
+++ b/drivers/staging/skein/threefish_512_block.c
@@ -1,5 +1,5 @@
 #include <linux/string.h>
-#include <threefishApi.h>
+#include <threefish_api.h>
 
 
 void threefish_encrypt_512(struct threefish_key *key_ctx, u64 *input,
diff --git a/drivers/staging/skein/threefishApi.c b/drivers/staging/skein/threefish_api.c
similarity index 98%
rename from drivers/staging/skein/threefishApi.c
rename to drivers/staging/skein/threefish_api.c
index 0ba42fa..45769c5 100644
--- a/drivers/staging/skein/threefishApi.c
+++ b/drivers/staging/skein/threefish_api.c
@@ -1,7 +1,7 @@
 
 
 #include <linux/string.h>
-#include <threefishApi.h>
+#include <threefish_api.h>
 
 void threefish_set_key(struct threefish_key *key_ctx,
 		       enum threefish_size state_size,
@@ -76,4 +76,3 @@ void threefish_decrypt_block_words(struct threefish_key *key_ctx, u64 *in,
 		break;
 	}
 }
-
-- 
1.9.2

