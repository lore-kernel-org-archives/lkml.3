Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755070Ab3H2X2o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 19:28:44 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:55874 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752662Ab3H2X2l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 19:28:41 -0400
From: Joel Fernandes <joelf@ti.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Mark Greer <mgreer@animalcreek.com>, Tony Lindgren <tony@atomide.com>,
        Lokesh Vutla <lokeshvutla@ti.com>
CC: Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Joel Fernandes <joelf@ti.com>
Subject: [PATCH 2/3] crypto: omap-des: Add config and build options
Date: Thu, 29 Aug 2013 18:27:52 -0500
Message-ID: <1377818873-21174-3-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1377818873-21174-1-git-send-email-joelf@ti.com>
References: <1377818873-21174-1-git-send-email-joelf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add config and build options for the newly added omap-des driver.

Signed-off-by: Joel Fernandes <joelf@ti.com>
---
 drivers/crypto/Kconfig  | 11 +++++++++++
 drivers/crypto/Makefile |  1 +
 2 files changed, 12 insertions(+)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index e289afa..119a8e5 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -259,6 +259,17 @@ config CRYPTO_DEV_OMAP_AES
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
index 38ce13d..ada440f 100644
--- a/drivers/crypto/Makefile
+++ b/drivers/crypto/Makefile
@@ -11,6 +11,7 @@ obj-$(CONFIG_CRYPTO_DEV_IXP4XX) += ixp4xx_crypto.o
 obj-$(CONFIG_CRYPTO_DEV_PPC4XX) += amcc/
 obj-$(CONFIG_CRYPTO_DEV_OMAP_SHAM) += omap-sham.o
 obj-$(CONFIG_CRYPTO_DEV_OMAP_AES) += omap-aes.o
+obj-$(CONFIG_CRYPTO_DEV_OMAP_DES) += omap-des.o
 obj-$(CONFIG_CRYPTO_DEV_PICOXCELL) += picoxcell_crypto.o
 obj-$(CONFIG_CRYPTO_DEV_SAHARA) += sahara.o
 obj-$(CONFIG_CRYPTO_DEV_S5P) += s5p-sss.o
-- 
1.8.1.2

