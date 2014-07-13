Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532AbaGMDB4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 23:01:56 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:57751 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786AbaGMDBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 23:01:50 -0400
Message-ID: <53C1F692.4000105@gmail.com>
Date: Sun, 13 Jul 2014 11:01:38 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: herbert@gondor.apana.org.au
CC: davem@davemloft.net, linux-crypto@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Liqin Chen <liqin.linux@gmail.com>, Lennox Wu <lennox.wu@gmail.com>
Subject: [PATCH] drivers/crypto/Kconfig: Let 'DEV_QCE' depend on both HAS_DMA
 and HAS_IOMEM
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'DEV_QCE' needs both HAS_DMA and HAS_IOMEM, so let it depend on them.

The related error (with allmodconfig under score):

    MODPOST 1365 modules
  ERROR: "devm_ioremap_resource" [drivers/crypto/qce/qcrypto.ko] undefined!
  ERROR: "dma_map_sg" [drivers/crypto/qce/qcrypto.ko] undefined!
  ERROR: "dma_set_mask" [drivers/crypto/qce/qcrypto.ko] undefined!
  ERROR: "dma_supported" [drivers/crypto/qce/qcrypto.ko] undefined!
  ERROR: "dma_unmap_sg" [drivers/crypto/qce/qcrypto.ko] undefined!

Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 drivers/crypto/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 5ef9ec9..2fb0fdf 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -422,7 +422,7 @@ source "drivers/crypto/qat/Kconfig"
 
 config CRYPTO_DEV_QCE
 	tristate "Qualcomm crypto engine accelerator"
-	depends on ARCH_QCOM || COMPILE_TEST
+	depends on (ARCH_QCOM || COMPILE_TEST) && HAS_DMA && HAS_IOMEM
 	select CRYPTO_AES
 	select CRYPTO_DES
 	select CRYPTO_ECB
-- 
1.7.11.7
