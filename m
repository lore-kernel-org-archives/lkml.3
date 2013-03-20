Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932159Ab3CTMUX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 08:20:23 -0400
Received: from mail-bk0-f41.google.com ([209.85.214.41]:39426 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407Ab3CTMUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 08:20:22 -0400
MIME-Version: 1.0
Date: Wed, 20 Mar 2013 20:20:20 +0800
Message-ID: <CAPgLHd81XvGLMBwfyBz6Rf6aVJhKXzqg_PGiujtob=re2EdKuw@mail.gmail.com>
Subject: [PATCH -next] mtip32xx: fix error return code in mtip_pci_probe()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: axboe@kernel.dk, asamymuthupa@micron.com, smani@micron.com,
        sbradshaw@micron.com
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fix to return a negative error code from the error handling
case instead of 0, as returned elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/block/mtip32xx/mtip32xx.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index b84dda5..044c781 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -4234,6 +4234,7 @@ static int mtip_pci_probe(struct pci_dev *pdev,
 	dd->isr_workq = create_workqueue(dd->workq_name);
 	if (!dd->isr_workq) {
 		dev_warn(&pdev->dev, "Can't create wq %d\n", dd->instance);
+		rv = -ENOMEM;
 		goto block_initialize_err;
 	}
 
@@ -4292,7 +4293,8 @@ static int mtip_pci_probe(struct pci_dev *pdev,
 	INIT_WORK(&dd->work[7].work, mtip_workq_sdbf7);
 
 	pci_set_master(pdev);
-	if (pci_enable_msi(pdev)) {
+	rv = pci_enable_msi(pdev);
+	if (rv) {
 		dev_warn(&pdev->dev,
 			"Unable to enable MSI interrupt.\n");
 		goto block_initialize_err;


