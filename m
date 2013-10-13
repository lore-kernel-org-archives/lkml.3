Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751354Ab3JMEtU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 00:49:20 -0400
Received: from top.free-electrons.com ([176.31.233.9]:56081 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750807Ab3JMEtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 00:49:19 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: herbert@gondor.hengli.com.au, davem@davemloft.net
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] crypto: mv_cesa: remove deprecated IRQF_DISABLED
Date: Sun, 13 Oct 2013 06:49:13 +0200
Message-Id: <1381639753-7042-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch proposes to remove the use of the IRQF_DISABLED flag

It's a NOOP since 2.6.35 and it will be removed one day.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 drivers/crypto/mv_cesa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/mv_cesa.c b/drivers/crypto/mv_cesa.c
index 3374a3e..e0f9ed4 100644
--- a/drivers/crypto/mv_cesa.c
+++ b/drivers/crypto/mv_cesa.c
@@ -1084,7 +1084,7 @@ static int mv_probe(struct platform_device *pdev)
 		goto err_unmap_sram;
 	}
 
-	ret = request_irq(irq, crypto_int, IRQF_DISABLED, dev_name(&pdev->dev),
+	ret = request_irq(irq, crypto_int, 0, dev_name(&pdev->dev),
 			cp);
 	if (ret)
 		goto err_thread;
-- 
1.8.1.2

