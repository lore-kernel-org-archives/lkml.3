Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932460Ab3DIRuO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 13:50:14 -0400
Received: from smtp22.mail.ru ([94.100.176.175]:49160 "EHLO smtp22.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751809Ab3DIRuN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 13:50:13 -0400
From: Alexander Shiyan <shc_work@mail.ru>
To: linux-kernel@vger.kernel.org
Cc: Dong Aisheng <dong.aisheng@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Arnd Bergmann <arnd@arndb.de>, Alexander Shiyan <shc_work@mail.ru>
Subject: [PATCH] mfd: syscon: fix warnings when printing resource_size_t
Date: Tue,  9 Apr 2013 21:50:02 +0400
Message-Id: <1365529802-17844-1-git-send-email-shc_work@mail.ru>
X-Mailer: git-send-email 1.8.1.5
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gets rid of these warnings when compile module for 64 bit targets:
  CC      drivers/mfd/syscon.o
  drivers/mfd/syscon.c: In function 'syscon_probe':
  drivers/mfd/syscon.c:155:2: warning: format '%x' expects argument of type 'unsigned int', but argument 3 has type 'resource_size_t' [-Wformat]
  drivers/mfd/syscon.c:155:2: warning: format '%x' expects argument of type 'unsigned int', but argument 4 has type 'resource_size_t' [-Wformat]

Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
---
 drivers/mfd/syscon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/syscon.c b/drivers/mfd/syscon.c
index 7905d36..962a6e1 100644
--- a/drivers/mfd/syscon.c
+++ b/drivers/mfd/syscon.c
@@ -152,7 +152,7 @@ static int syscon_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, syscon);
 
-	dev_info(dev, "regmap 0x%x-0x%x registered\n", res->start, res->end);
+	dev_info(dev, "regmap %pR registered\n", res);
 
 	return 0;
 }
-- 
1.8.1.5

