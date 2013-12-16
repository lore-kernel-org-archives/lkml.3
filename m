Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752505Ab3LPFvS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 00:51:18 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:50150 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781Ab3LPFvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 00:51:17 -0500
MIME-Version: 1.0
Date: Mon, 16 Dec 2013 13:51:16 +0800
Message-ID: <CAPgLHd_jJ-gR0CWZKuWUVALXhE9c9a3b+-GspKE_AXKvFW6qPQ@mail.gmail.com>
Subject: [PATCH -next] staging: xillybus: fix error return code in xilly_probe()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: gregkh@linuxfoundation.org, eli.billauer@gmail.com, jg1.han@samsung.com
Cc: yongjun_wei@trendmicro.com.cn, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fix to return negative error code -EIO from the error handling
case instead of 0.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/staging/xillybus/xillybus_pcie.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/xillybus/xillybus_pcie.c b/drivers/staging/xillybus/xillybus_pcie.c
index 0564f97..51426d8 100644
--- a/drivers/staging/xillybus/xillybus_pcie.c
+++ b/drivers/staging/xillybus/xillybus_pcie.c
@@ -168,9 +168,9 @@ static int xilly_probe(struct pci_dev *pdev,
 	}
 
 	endpoint->registers = pci_iomap(pdev, 0, 128);
-
 	if (!endpoint->registers) {
 		dev_err(endpoint->dev, "Failed to map BAR 0. Aborting.\n");
+		rc = -EIO;
 		goto failed_iomap0;
 	}
 

