Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753Ab3J3FfX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 01:35:23 -0400
Received: from mail-bk0-f52.google.com ([209.85.214.52]:44912 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757Ab3J3FfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 01:35:22 -0400
MIME-Version: 1.0
Date: Wed, 30 Oct 2013 13:35:20 +0800
Message-ID: <CAPgLHd94ZpQ22iRgW+GtcFO2M7EBGmEbyk35knH9aHLOZ39niw@mail.gmail.com>
Subject: [PATCH -next] tifm: fix error return code in tifm_7xx1_probe()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: oakad@yahoo.com, arnd@arndb.de, gregkh@linuxfoundation.org
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fix to return ENODEV in the pci ioremap error handling case
instead of 0, as done elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/misc/tifm_7xx1.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/misc/tifm_7xx1.c b/drivers/misc/tifm_7xx1.c
index ae282a1..a606c89 100644
--- a/drivers/misc/tifm_7xx1.c
+++ b/drivers/misc/tifm_7xx1.c
@@ -356,8 +356,10 @@ static int tifm_7xx1_probe(struct pci_dev *dev,
 	pci_set_drvdata(dev, fm);
 
 	fm->addr = pci_ioremap_bar(dev, 0);
-	if (!fm->addr)
+	if (!fm->addr) {
+		rc = -ENODEV;
 		goto err_out_free;
+	}
 
 	rc = request_irq(dev->irq, tifm_7xx1_isr, IRQF_SHARED, DRIVER_NAME, fm);
 	if (rc)

