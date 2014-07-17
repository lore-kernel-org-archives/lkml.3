Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932219AbaGQMNk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 08:13:40 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:45272 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756330AbaGQMNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 08:13:38 -0400
From: Andrey Utkin <andrey.krieger.utkin@gmail.com>
To: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: dcb314@hotmail.com, tj@kernel.org,
        Andrey Utkin <andrey.krieger.utkin@gmail.com>
Subject: [PATCH 1/3] drivers/ata/pata_ep93xx.c: use signed int type for result of platform_get_irq()
Date: Thu, 17 Jul 2014 15:13:23 +0300
Message-Id: <1405599203-11113-1-git-send-email-andrey.krieger.utkin@gmail.com>
X-Mailer: git-send-email 1.8.5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[linux-3.16-rc5/drivers/ata/pata_ep93xx.c:929]: (style) Checking if unsigned
variable 'irq' is less than zero.

Source code is

    irq = platform_get_irq(pdev, 0);
    if (irq < 0) {

but

    unsigned int irq;

$ fgrep platform_get_irq `find . -name \*.h -print`
./include/linux/platform_device.h:extern int platform_get_irq(struct
platform_device *, unsigned int);

Now using "int" type instead of "unsigned int" for "irq" variable.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=80401
Reported-by: David Binderman <dcb314@hotmail.com>
Signed-off-by: Andrey Utkin <andrey.krieger.utkin@gmail.com>
---
 drivers/ata/pata_ep93xx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ata/pata_ep93xx.c b/drivers/ata/pata_ep93xx.c
index 6ad5c07..4d37c54 100644
--- a/drivers/ata/pata_ep93xx.c
+++ b/drivers/ata/pata_ep93xx.c
@@ -915,7 +915,7 @@ static int ep93xx_pata_probe(struct platform_device *pdev)
 	struct ep93xx_pata_data *drv_data;
 	struct ata_host *host;
 	struct ata_port *ap;
-	unsigned int irq;
+	int irq;
 	struct resource *mem_res;
 	void __iomem *ide_base;
 	int err;
-- 
1.8.5.5

