Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933248AbaFIMLE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 08:11:04 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:32994 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932586AbaFIMLB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 08:11:01 -0400
From: Stanimir Varbanov <svarbanov@mm-sol.com>
To: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Grant Likely <grant.likely@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, Stanimir Varbanov <svarbanov@mm-sol.com>
Subject: [PATCH v3 2/3] crypto: qce: Build Qualcomm crypto driver
Date: Mon,  9 Jun 2014 15:08:39 +0300
Message-Id: <1402315720-5042-3-git-send-email-svarbanov@mm-sol.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1402315720-5042-1-git-send-email-svarbanov@mm-sol.com>
References: <1402315720-5042-1-git-send-email-svarbanov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Modify crypto Kconfig and Makefile in order to build the qce
driver and adds qce Makefile as well.

Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
---
 drivers/crypto/Kconfig      |   15 +++++++++++++++
 drivers/crypto/Makefile     |    1 +
 drivers/crypto/qce/Makefile |    6 ++++++
 3 files changed, 22 insertions(+), 0 deletions(-)
 create mode 100644 drivers/crypto/qce/Makefile

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index f066fa2..8b87362 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -418,4 +418,19 @@ config CRYPTO_DEV_MXS_DCP
 	  To compile this driver as a module, choose M here: the module
 	  will be called mxs-dcp.
 
+config CRYPTO_DEV_QCE
+	tristate "Qualcomm crypto engine accelerator"
+	select CRYPTO_AES
+	select CRYPTO_DES
+	select CRYPTO_ECB
+	select CRYPTO_CBC
+	select CRYPTO_XTS
+	select CRYPTO_CTR
+	select CRYPTO_ALGAPI
+	select CRYPTO_BLKCIPHER
+	help
+	  This driver supports Qualcomm crypto engine accelerator
+	  hardware. To compile this driver as a module, choose M here. The
+	  module will be called qcrypto.
+
 endif # CRYPTO_HW
diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
index 482f090..320937b 100644
--- a/drivers/crypto/Makefile
+++ b/drivers/crypto/Makefile
@@ -23,3 +23,4 @@ obj-$(CONFIG_CRYPTO_DEV_S5P) += s5p-sss.o
 obj-$(CONFIG_CRYPTO_DEV_SAHARA) += sahara.o
 obj-$(CONFIG_CRYPTO_DEV_TALITOS) += talitos.o
 obj-$(CONFIG_CRYPTO_DEV_UX500) += ux500/
+obj-$(CONFIG_CRYPTO_DEV_QCE) += qce/
diff --git a/drivers/crypto/qce/Makefile b/drivers/crypto/qce/Makefile
new file mode 100644
index 0000000..348dc31
--- /dev/null
+++ b/drivers/crypto/qce/Makefile
@@ -0,0 +1,6 @@
+obj-$(CONFIG_CRYPTO_DEV_QCE) += qcrypto.o
+qcrypto-objs := core.o \
+		common.o \
+		dma.o \
+		sha.o \
+		ablkcipher.o
-- 
1.7.0.4

