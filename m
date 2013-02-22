Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755560Ab3BVCwj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 21:52:39 -0500
Received: from mail-bk0-f52.google.com ([209.85.214.52]:58820 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753736Ab3BVCwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 21:52:36 -0500
MIME-Version: 1.0
Date: Fri, 22 Feb 2013 10:52:35 +0800
Message-ID: <CAPgLHd-PhE2igUQOeg90H98Ni55DwfYdp0D52uaBK0=J3M1V+g@mail.gmail.com>
Subject: [PATCH -next] spi: fix return value check in ce4100_spi_probe()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: eric.y.miao@gmail.com, linux@arm.linux.org.uk, haojian.zhuang@gmail.com,
        grant.likely@secretlab.ca, broonie@opensource.wolfsonmicro.com
Cc: yongjun_wei@trendmicro.com.cn, linux-arm-kernel@lists.infradead.org,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

In case of error, the function platform_device_register_full()
returns ERR_PTR() and never returns NULL. The NULL test in the
return value check should be replaced with IS_ERR().

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/spi/spi-pxa2xx-pci.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-pxa2xx-pci.c b/drivers/spi/spi-pxa2xx-pci.c
index 364964d..0a11dcfc 100644
--- a/drivers/spi/spi-pxa2xx-pci.c
+++ b/drivers/spi/spi-pxa2xx-pci.c
@@ -47,8 +47,8 @@ static int ce4100_spi_probe(struct pci_dev *dev,
 	pi.size_data = sizeof(spi_pdata);
 
 	pdev = platform_device_register_full(&pi);
-	if (!pdev)
-		return -ENOMEM;
+	if (IS_ERR(pdev))
+		return PTR_ERR(pdev);
 
 	pci_set_drvdata(dev, pdev);
 

