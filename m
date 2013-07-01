Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753583Ab3GAIoG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 04:44:06 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:56821 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753102Ab3GAIkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 04:40:03 -0400
From: Richard Genoud <richard.genoud@gmail.com>
To: devicetree-discuss@lists.ozlabs.org
Cc: linux-arm-kernel@lists.infradead.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        linux-kernel@vger.kernel.org,
        Richard Genoud <richard.genoud@gmail.com>
Subject: [RFC PATCH 02/13] misc: atmel_ssc: keep the count of pdev->id
Date: Mon,  1 Jul 2013 10:39:27 +0200
Message-Id: <1372667978-4718-3-git-send-email-richard.genoud@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1372667978-4718-1-git-send-email-richard.genoud@gmail.com>
References: <1372667978-4718-1-git-send-email-richard.genoud@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With device tree, pdev->id is always -1, so we introduce a local
counter.

Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
---
 drivers/misc/atmel-ssc.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/misc/atmel-ssc.c b/drivers/misc/atmel-ssc.c
index 3afbd82..d1ec5ab 100644
--- a/drivers/misc/atmel-ssc.c
+++ b/drivers/misc/atmel-ssc.c
@@ -173,6 +173,12 @@ out:
 	return err;
 }
 
+/* counter of ssc devive instances.
+ * With device tree pdev->id is always -1, so we have to keep the
+ * count ourselves
+ */
+static int ssc_device_id;
+
 static int ssc_probe(struct platform_device *pdev)
 {
 	struct resource *regs;
@@ -235,6 +241,7 @@ static int ssc_probe(struct platform_device *pdev)
 	}
 
 	spin_lock(&user_lock);
+	pdev->id = ssc_device_id++;
 	list_add_tail(&ssc->list, &ssc_list);
 	spin_unlock(&user_lock);
 
-- 
1.7.10.4

