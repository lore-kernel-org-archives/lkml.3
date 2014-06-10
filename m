Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752444AbaFJMog (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 08:44:36 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:33257 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbaFJMni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 08:43:38 -0400
From: LABBE Corentin <clabbe.montjoie@gmail.com>
To: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, maxime.ripard@free-electrons.com,
        linux@arm.linux.org.uk, herbert@gondor.apana.org.au,
        davem@davemloft.net, grant.likely@linaro.org
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-sunxi@googlegroups.com,
        LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: [PATCH v3 2/4] crypto: Update makefile and Kconfig for Security System
Date: Tue, 10 Jun 2014 14:43:15 +0200
Message-Id: <1402404197-4236-3-git-send-email-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <1402404197-4236-1-git-send-email-clabbe.montjoie@gmail.com>
References: <1402404197-4236-1-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add necessary changes for configuring and compiling the Security System driver.

Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
---
 drivers/crypto/Kconfig  | 91 +++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/crypto/Makefile |  1 +
 2 files changed, 92 insertions(+)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 03ccdb0..ed1c918 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -418,4 +418,95 @@ config CRYPTO_DEV_MXS_DCP
 	  To compile this driver as a module, choose M here: the module
 	  will be called mxs-dcp.
 
+config CRYPTO_DEV_SUNXI_SS
+	tristate "Support for Allwinner Security System cryptographic accelerator"
+	depends on ARCH_SUNXI
+	help
+	  Some Allwinner SoC have a crypto accelerator named
+	  Security System. Select this if you want to use it.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called sunxi-ss.
+
+if CRYPTO_DEV_SUNXI_SS
+config CRYPTO_DEV_SUNXI_SS_PRNG
+	tristate "Security System PRNG"
+	select CRYPTO_RNG2
+	help
+	  If you enable this option, the SS will provide a pseudo random
+	  number generator.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called sunxi-ss-prng.
+
+config CRYPTO_DEV_SUNXI_SS_HASH
+	tristate "Security System hash common"
+	help
+	  Common parts of Security System shared by hash algorithms.
+
+config CRYPTO_DEV_SUNXI_SS_CIPHER
+	tristate "Security System cipher common"
+	help
+	  Common parts of Security System shared by cipher algorithms.
+
+config CRYPTO_DEV_SUNXI_SS_MD5
+	tristate "Security System MD5"
+	select CRYPTO_MD5
+	select CRYPTO_DEV_SUNXI_SS_HASH
+	help
+	  If you enable this option, the SS will provide MD5 hardware
+	  acceleration.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called sunxi-ss-md5.
+
+config CRYPTO_DEV_SUNXI_SS_SHA1
+	tristate "Security System SHA1"
+	select CRYPTO_SHA1
+	select CRYPTO_DEV_SUNXI_SS_HASH
+	help
+	  If you enable this option, the SS will provide SHA1 hardware
+	  acceleration.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called sunxi-ss-sha1.
+
+config CRYPTO_DEV_SUNXI_SS_AES
+	tristate "Security System AES"
+	select CRYPTO_AES
+	select CRYPTO_BLKCIPHER
+	select CRYPTO_DEV_SUNXI_SS_CIPHER
+	help
+	  If you enable this option, the SS will provide AES hardware
+	  acceleration.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called sunxi-ss-aes.
+
+config CRYPTO_DEV_SUNXI_SS_DES
+	tristate "Security System DES"
+	select CRYPTO_DES
+	select CRYPTO_BLKCIPHER
+	select CRYPTO_DEV_SUNXI_SS_CIPHER
+	help
+	  If you enable this option, the SS will provide DES hardware
+	  acceleration.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called sunxi-ss-des.
+
+config CRYPTO_DEV_SUNXI_SS_3DES
+	tristate "Security System 3DES"
+	select CRYPTO_DES
+	select CRYPTO_BLKCIPHER
+	select CRYPTO_DEV_SUNXI_SS_CIPHER
+	help
+	  If you enable this option, the SS will provide 3DES hardware
+	  acceleration.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called sunxi-ss-3des.
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

