Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933183AbaFIK7d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 06:59:33 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:63608 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754875AbaFIK7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 06:59:23 -0400
From: LABBE Corentin <clabbe.montjoie@gmail.com>
To: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, maxime.ripard@free-electrons.com,
        linux@arm.linux.org.uk, herbert@gondor.apana.org.au,
        davem@davemloft.net, grant.likely@linaro.org
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: [PATCH v2 2/4] crypto: Update makefile and Kconfig for Security System
Date: Mon,  9 Jun 2014 12:59:09 +0200
Message-Id: <1402311551-19564-3-git-send-email-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <1402311551-19564-1-git-send-email-clabbe.montjoie@gmail.com>
References: <1402311551-19564-1-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add necessary changes for configuring and compiling the Security System driver.

Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
---
 drivers/crypto/Kconfig  | 76 +++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/crypto/Makefile |  1 +
 2 files changed, 77 insertions(+)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 03ccdb0..758f63d 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -418,4 +418,80 @@ config CRYPTO_DEV_MXS_DCP
 	  To compile this driver as a module, choose M here: the module
 	  will be called mxs-dcp.
 
+config CRYPTO_DEV_SUNXI_SS
+        tristate "Support for Allwinner Security System cryptographic accelerator"
+        depends on ARCH_SUNXI
+        help
+          Some Allwinner SoC have a crypto accelerator named
+          Security System. Select this if you want to use it.
+
+          To compile this driver as a module, choose M here: the module
+          will be called sunxi-ss.
+
+if CRYPTO_DEV_SUNXI_SS
+config CRYPTO_DEV_SUNXI_SS_PRNG
+	tristate "Security System PRNG"
+	select CRYPTO_RNG2
+	help
+	  If you enable this option, the SS will provide a pseudo random
+	  number generator.
+
+          To compile this driver as a module, choose M here: the module
+          will be called sunxi-ss-prng.
+
+config CRYPTO_DEV_SUNXI_SS_MD5
+	tristate "Security System MD5"
+	select CRYPTO_MD5
+	help
+	  If you enable this option, the SS will provide MD5 hardware
+	  acceleration.
+
+          To compile this driver as a module, choose M here: the module
+          will be called sunxi-ss-md5.
+
+config CRYPTO_DEV_SUNXI_SS_SHA1
+	tristate "Security System SHA1"
+	select CRYPTO_SHA1
+	help
+	  If you enable this option, the SS will provide SHA1 hardware
+	  acceleration.
+
+          To compile this driver as a module, choose M here: the module
+          will be called sunxi-ss-sha1.
+
+config CRYPTO_DEV_SUNXI_SS_AES
+	tristate "Security System AES"
+	select CRYPTO_AES
+	select CRYPTO_BLKCIPHER
+	help
+	  If you enable this option, the SS will provide AES hardware
+	  acceleration.
+
+          To compile this driver as a module, choose M here: the module
+          will be called sunxi-ss-aes.
+
+config CRYPTO_DEV_SUNXI_SS_DES
+	tristate "Security System DES"
+	select CRYPTO_DES
+	select CRYPTO_BLKCIPHER
+	help
+	  If you enable this option, the SS will provide DES hardware
+	  acceleration.
+
+          To compile this driver as a module, choose M here: the module
+          will be called sunxi-ss-des.
+
+config CRYPTO_DEV_SUNXI_SS_3DES
+	tristate "Security System 3DES"
+	select CRYPTO_DES
+	select CRYPTO_BLKCIPHER
+	help
+	  If you enable this option, the SS will provide 3DES hardware
+	  acceleration.
+
+          To compile this driver as a module, choose M here: the module
+          will be called sunxi-ss-3des.
+
+endif #CRYPTO_DEV_SUNXI_SS
+
 endif # CRYPTO_HW
diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
index 482f090..855292a 100644
--- a/drivers/crypto/Makefile
+++ b/drivers/crypto/Makefile
@@ -23,3 +23,4 @@ obj-$(CONFIG_CRYPTO_DEV_S5P) += s5p-sss.o
 obj-$(CONFIG_CRYPTO_DEV_SAHARA) += sahara.o
 obj-$(CONFIG_CRYPTO_DEV_TALITOS) += talitos.o
 obj-$(CONFIG_CRYPTO_DEV_UX500) += ux500/
+obj-$(CONFIG_CRYPTO_DEV_SUNXI_SS) += sunxi-ss/
-- 
1.8.5.5

