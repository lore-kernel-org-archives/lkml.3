Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932927AbaJXWfE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 18:35:04 -0400
Received: from mail-ig0-f176.google.com ([209.85.213.176]:44170 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754480AbaJXWfC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 18:35:02 -0400
Date: Fri, 24 Oct 2014 17:32:53 -0500
From: Eric Rost <eric.rost@mybabylon.net>
To: gregkh@linuxfoundation.org, jason@lakedaemon.net, jake@lwn.net,
        antonysaraev@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v6 2/7] staging: skein: Renames skein to skein_base
Message-ID: <fe1b3908ff4a604036b829076cd81417f1960b92.1414189566.git.eric.rost@mybabylon.net>
References: <cover.1414189566.git.eric.rost@mybabylon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1414189566.git.eric.rost@mybabylon.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Renames skein.c to skein_base.c and skein.h to skein_base.h in
preparation for naming loadable module skein.ko

Signed-off-by: Eric Rost <eric.rost@mybabylon.net>
---
 drivers/staging/skein/Makefile                  | 2 +-
 drivers/staging/skein/skein_api.h               | 2 +-
 drivers/staging/skein/{skein.c => skein_base.c} | 3 ++-
 drivers/staging/skein/{skein.h => skein_base.h} | 0
 drivers/staging/skein/skein_block.c             | 2 +-
 drivers/staging/skein/skein_block.h             | 2 +-
 drivers/staging/skein/skein_iv.h                | 2 +-
 drivers/staging/skein/threefish_api.h           | 2 +-
 8 files changed, 8 insertions(+), 7 deletions(-)
 rename drivers/staging/skein/{skein.c => skein_base.c} (99%)
 rename drivers/staging/skein/{skein.h => skein_base.h} (100%)

diff --git a/drivers/staging/skein/Makefile b/drivers/staging/skein/Makefile
index 4b60171..ca746a9 100644
--- a/drivers/staging/skein/Makefile
+++ b/drivers/staging/skein/Makefile
@@ -1,7 +1,7 @@
 #
 # Makefile for the skein secure hash algorithm
 #
-obj-$(CONFIG_CRYPTO_SKEIN) += skein.o \
+obj-$(CONFIG_CRYPTO_SKEIN) += skein_base.o \
 			      skein_api.o \
 			      skein_block.o \
 			      threefish_block.o \
diff --git a/drivers/staging/skein/skein_api.h b/drivers/staging/skein/skein_api.h
index e02fa19..171b875 100644
--- a/drivers/staging/skein/skein_api.h
+++ b/drivers/staging/skein/skein_api.h
@@ -79,7 +79,7 @@ OTHER DEALINGS IN THE SOFTWARE.
  */
 
 #include <linux/types.h>
-#include "skein.h"
+#include "skein_base.h"
 
 /**
  * Which Skein size to use
diff --git a/drivers/staging/skein/skein.c b/drivers/staging/skein/skein_base.c
similarity index 99%
rename from drivers/staging/skein/skein.c
rename to drivers/staging/skein/skein_base.c
index 8cc8358..e0994ea 100644
--- a/drivers/staging/skein/skein.c
+++ b/drivers/staging/skein/skein_base.c
@@ -11,7 +11,8 @@
 #define  SKEIN_PORT_CODE /* instantiate any code in skein_port.h */
 
 #include <linux/string.h>       /* get the memcpy/memset functions */
-#include "skein.h" /* get the Skein API definitions   */
+#include <linux/export.h>
+#include "skein_base.h" /* get the Skein API definitions   */
 #include "skein_iv.h"    /* get precomputed IVs */
 #include "skein_block.h"
 
diff --git a/drivers/staging/skein/skein.h b/drivers/staging/skein/skein_base.h
similarity index 100%
rename from drivers/staging/skein/skein.h
rename to drivers/staging/skein/skein_base.h
diff --git a/drivers/staging/skein/skein_block.c b/drivers/staging/skein/skein_block.c
index 88bc718..36b0b40 100644
--- a/drivers/staging/skein/skein_block.c
+++ b/drivers/staging/skein/skein_block.c
@@ -15,7 +15,7 @@
 ************************************************************************/
 
 #include <linux/string.h>
-#include "skein.h"
+#include "skein_base.h"
 #include "skein_block.h"
 
 #ifndef SKEIN_USE_ASM
diff --git a/drivers/staging/skein/skein_block.h b/drivers/staging/skein/skein_block.h
index bd7bdc3..9d40f4a 100644
--- a/drivers/staging/skein/skein_block.h
+++ b/drivers/staging/skein/skein_block.h
@@ -10,7 +10,7 @@
 #ifndef _SKEIN_BLOCK_H_
 #define _SKEIN_BLOCK_H_
 
-#include "skein.h" /* get the Skein API definitions   */
+#include "skein_base.h" /* get the Skein API definitions   */
 
 void skein_256_process_block(struct skein_256_ctx *ctx, const u8 *blk_ptr,
 			     size_t blk_cnt, size_t byte_cnt_add);
diff --git a/drivers/staging/skein/skein_iv.h b/drivers/staging/skein/skein_iv.h
index d9dc1d5..8a06314 100644
--- a/drivers/staging/skein/skein_iv.h
+++ b/drivers/staging/skein/skein_iv.h
@@ -1,7 +1,7 @@
 #ifndef _SKEIN_IV_H_
 #define _SKEIN_IV_H_
 
-#include "skein.h"    /* get Skein macros and types */
+#include "skein_base.h"    /* get Skein macros and types */
 
 /*
 ***************** Pre-computed Skein IVs *******************
diff --git a/drivers/staging/skein/threefish_api.h b/drivers/staging/skein/threefish_api.h
index 8d5ddf8..8e0a0b7 100644
--- a/drivers/staging/skein/threefish_api.h
+++ b/drivers/staging/skein/threefish_api.h
@@ -29,7 +29,7 @@
  */
 
 #include <linux/types.h>
-#include "skein.h"
+#include "skein_base.h"
 
 #define KEY_SCHEDULE_CONST 0x1BD11BDAA9FC1A22L
 
-- 
2.1.1

