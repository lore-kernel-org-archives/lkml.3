Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753129AbaBNQuX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 11:50:23 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:59780 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752916AbaBNQuS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 11:50:18 -0500
From: Joel Fernandes <joelf@ti.com>
To: <herbert@gondor.apana.org.au>, <rnayak@ti.com>
CC: <linux-crypto@vger.kernel.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Joel Fernandes <joelf@ti.com>
Subject: [PATCH v2 2/2] crypto: omap-des: Add config and build options
Date: Fri, 14 Feb 2014 10:49:47 -0600
Message-ID: <1392396587-24524-1-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add config and build options for the omap-des driver.

Signed-off-by: Joel Fernandes <joelf@ti.com>
---
 drivers/crypto/Kconfig  |   11 +++++++++++
 drivers/crypto/Makefile |    1 +
 2 files changed, 12 insertions(+)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 13857f5..8e38000 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -262,6 +262,17 @@ config CRYPTO_DEV_OMAP_AES
 	  OMAP processors have AES module accelerator. Select this if you
 	  want to use the OMAP module for AES algorithms.
 
+config CRYPTO_DEV_OMAP_DES
+	tristate "Support for OMAP DES3DES hw engine"
+	depends on ARCH_OMAP2PLUS
+	select CRYPTO_DES
+	select CRYPTO_BLKCIPHER2
+	help
+	  OMAP processors have DES/3DES module accelerator. Select this if you
+	  want to use the OMAP module for DES and 3DES algorithms. Currently
+	  the ECB and CBC modes of operation supported by the driver. Also
+	  accesses made on unaligned boundaries are also supported.
+
 config CRYPTO_DEV_PICOXCELL
 	tristate "Support for picoXcell IPSEC and Layer2 crypto engines"
 	depends on ARCH_PICOXCELL && HAVE_CLK
diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
index 0bc6aa0..9a53fb8 100644
--- a/drivers/crypto/Makefile
+++ b/drivers/crypto/Makefile
@@ -13,6 +13,7 @@ obj-$(CONFIG_CRYPTO_DEV_NIAGARA2) += n2_crypto.o
 n2_crypto-y := n2_core.o n2_asm.o
 obj-$(CONFIG_CRYPTO_DEV_NX) += nx/
 obj-$(CONFIG_CRYPTO_DEV_OMAP_AES) += omap-aes.o
+obj-$(CONFIG_CRYPTO_DEV_OMAP_DES) += omap-des.o
 obj-$(CONFIG_CRYPTO_DEV_OMAP_SHAM) += omap-sham.o
 obj-$(CONFIG_CRYPTO_DEV_PADLOCK_AES) += padlock-aes.o
 obj-$(CONFIG_CRYPTO_DEV_PADLOCK_SHA) += padlock-sha.o
-- 
1.7.9.5

