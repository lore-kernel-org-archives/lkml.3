Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479AbaAUVde (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 16:33:34 -0500
Received: from mail1.windriver.com ([147.11.146.13]:50791 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754875AbaAUVZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 16:25:40 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arch@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>
Subject: [PATCH 62/73] drivers/crypto: delete non-required instances of include <linux/init.h>
Date: Tue, 21 Jan 2014 16:23:05 -0500
Message-ID: <1390339396-3479-63-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.4.1
In-Reply-To: <1390339396-3479-1-git-send-email-paul.gortmaker@windriver.com>
References: <1390339396-3479-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

None of these files are actually using any __init type directives
and hence don't need to include <linux/init.h>.  Most are just a
left over from __devinit and __cpuinit removal, or simply due to
code getting copied from one driver to the next.

Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/crypto/atmel-aes.c        | 1 -
 drivers/crypto/atmel-sha.c        | 1 -
 drivers/crypto/atmel-tdes.c       | 1 -
 drivers/crypto/nx/nx_debugfs.c    | 1 -
 drivers/crypto/omap-aes.c         | 1 -
 drivers/crypto/omap-sham.c        | 1 -
 drivers/crypto/picoxcell_crypto.c | 1 -
 drivers/crypto/s5p-sss.c          | 1 -
 drivers/crypto/tegra-aes.c        | 1 -
 9 files changed, 9 deletions(-)

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index d7c9e31..70fb6fb 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -24,7 +24,6 @@
 #include <linux/platform_device.h>
 
 #include <linux/device.h>
-#include <linux/init.h>
 #include <linux/errno.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
diff --git a/drivers/crypto/atmel-sha.c b/drivers/crypto/atmel-sha.c
index 0618be0..637141b 100644
--- a/drivers/crypto/atmel-sha.c
+++ b/drivers/crypto/atmel-sha.c
@@ -24,7 +24,6 @@
 #include <linux/platform_device.h>
 
 #include <linux/device.h>
-#include <linux/init.h>
 #include <linux/errno.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
diff --git a/drivers/crypto/atmel-tdes.c b/drivers/crypto/atmel-tdes.c
index 6cde5b5..604a67f 100644
--- a/drivers/crypto/atmel-tdes.c
+++ b/drivers/crypto/atmel-tdes.c
@@ -24,7 +24,6 @@
 #include <linux/platform_device.h>
 
 #include <linux/device.h>
-#include <linux/init.h>
 #include <linux/errno.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
diff --git a/drivers/crypto/nx/nx_debugfs.c b/drivers/crypto/nx/nx_debugfs.c
index 7ab2e8d..899d857 100644
--- a/drivers/crypto/nx/nx_debugfs.c
+++ b/drivers/crypto/nx/nx_debugfs.c
@@ -24,7 +24,6 @@
 #include <linux/string.h>
 #include <linux/debugfs.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/crypto.h>
 #include <crypto/hash.h>
 #include <asm/vio.h>
diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index dde41f1d..6d34dac 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -19,7 +19,6 @@
 
 #include <linux/err.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/errno.h>
 #include <linux/kernel.h>
 #include <linux/platform_device.h>
diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index a727a6a..5d303eb 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -19,7 +19,6 @@
 #include <linux/err.h>
 #include <linux/device.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/errno.h>
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
diff --git a/drivers/crypto/picoxcell_crypto.c b/drivers/crypto/picoxcell_crypto.c
index a6175ba..e50a1b9 100644
--- a/drivers/crypto/picoxcell_crypto.c
+++ b/drivers/crypto/picoxcell_crypto.c
@@ -29,7 +29,6 @@
 #include <linux/dma-mapping.h>
 #include <linux/dmapool.h>
 #include <linux/err.h>
-#include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
 #include <linux/list.h>
diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
index cf149b1..78b7eed 100644
--- a/drivers/crypto/s5p-sss.c
+++ b/drivers/crypto/s5p-sss.c
@@ -14,7 +14,6 @@
 #include <linux/delay.h>
 #include <linux/err.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/errno.h>
 #include <linux/kernel.h>
 #include <linux/clk.h>
diff --git a/drivers/crypto/tegra-aes.c b/drivers/crypto/tegra-aes.c
index 060eecc..4c0548f 100644
--- a/drivers/crypto/tegra-aes.c
+++ b/drivers/crypto/tegra-aes.c
@@ -30,7 +30,6 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/errno.h>
 #include <linux/kernel.h>
 #include <linux/clk.h>
-- 
1.8.4.1

