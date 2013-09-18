Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349Ab3IRMSQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 08:18:16 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:43561 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752863Ab3IRMPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 08:15:17 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@linaro.org, Lee Jones <lee.jones@linaro.org>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH 30/41] usb: musb: ux500: Don't supply a con_id when requesting the clock
Date: Wed, 18 Sep 2013 13:14:27 +0100
Message-Id: <1379506478-16625-31-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379506478-16625-1-git-send-email-lee.jones@linaro.org>
References: <1379506478-16625-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we supply a con_id then the clock framework will search for that name
in MUSB's Device Tree node for the 'clock-names' property. If it's absent
the clock request will fail. However, if we don't supply the con_id then
clk_get() will call into clk_sys() which will use the device name to
search for the appropriate clock, which is much more natural than forcing
'usb'.

Cc: Felipe Balbi <balbi@ti.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/usb/musb/ux500.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/musb/ux500.c b/drivers/usb/musb/ux500.c
index fce71b6..5543b89 100644
--- a/drivers/usb/musb/ux500.c
+++ b/drivers/usb/musb/ux500.c
@@ -259,7 +259,7 @@ static int ux500_probe(struct platform_device *pdev)
 		goto err1;
 	}
 
-	clk = clk_get(&pdev->dev, "usb");
+	clk = clk_get(&pdev->dev, NULL);
 	if (IS_ERR(clk)) {
 		dev_err(&pdev->dev, "failed to get clock\n");
 		ret = PTR_ERR(clk);
-- 
1.8.1.2

