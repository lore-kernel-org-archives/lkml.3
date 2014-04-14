Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871AbaDNM63 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 08:58:29 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:43140 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754169AbaDNM62 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 08:58:28 -0400
From: Stanimir Varbanov <svarbanov@mm-sol.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc: Stanimir Varbanov <svarbanov@mm-sol.com>, linux-arm-msm@vger.kernel.org,
        Mona Hossain <mhossain@codeaurora.org>,
        Hariprasad Dhalinarasimha <hnamgund@codeaurora.org>,
        Zhen Kong <zkong@codeaurora.org>,
        Niranjana Vishwanathapura <nvishwan@codeaurora.org>,
        Rohit Vaswani <rvaswani@codeaurora.org>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH v2 8/9] crypto: qce: Build Qualcomm qce driver
Date: Mon, 14 Apr 2014 15:48:44 +0300
Message-Id: <1397479725-20954-9-git-send-email-svarbanov@mm-sol.com>
X-Mailer: git-send-email 1.8.4.4
In-Reply-To: <1397479725-20954-1-git-send-email-svarbanov@mm-sol.com>
References: <1397479725-20954-1-git-send-email-svarbanov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Modify crypto Kconfig and Makefile in order to build the qce
driver.

Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
---
 drivers/crypto/Kconfig  | 10 ++++++++++
 drivers/crypto/Makefile |  1 +
 2 files changed, 11 insertions(+)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 03ccdb0ccf9e..0f8ec047b9e2 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -418,4 +418,14 @@ config CRYPTO_DEV_MXS_DCP
 	  To compile this driver as a module, choose M here: the module
 	  will be called mxs-dcp.
 
+config CRYPTO_DEV_QCE
+	tristate "Qualcomm crypto engine accelerator"
+	select CRYPTO_DES
+	select CRYPTO_ALGAPI
+	select CRYPTO_BLKCIPHER
+	help
+	  This driver supports Qualcomm crypto engine accelerator
+	  hardware. To compile this driver as a module, choose M here. The
+	  module will be called qcrypto.
+
 endif # CRYPTO_HW
diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
index 482f090d16d0..320937bf201e 100644
--- a/drivers/crypto/Makefile
+++ b/drivers/crypto/Makefile
@@ -23,3 +23,4 @@ obj-$(CONFIG_CRYPTO_DEV_S5P) += s5p-sss.o
 obj-$(CONFIG_CRYPTO_DEV_SAHARA) += sahara.o
 obj-$(CONFIG_CRYPTO_DEV_TALITOS) += talitos.o
 obj-$(CONFIG_CRYPTO_DEV_UX500) += ux500/
+obj-$(CONFIG_CRYPTO_DEV_QCE) += qce/
-- 
1.8.4.4

