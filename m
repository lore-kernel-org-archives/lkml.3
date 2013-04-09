Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937007Ab3DIQAG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 12:00:06 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:40396 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936290Ab3DIQAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 12:00:04 -0400
Message-ID: <1365523198.12439.1.camel@phoenix>
Subject: [PATCH] pinctrl: vt8500: wmt: Fix checking return value of
 pinctrl_register()
From: Axel Lin <axel.lin@ingics.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Tony Prisk <linux@prisktech.co.nz>, linux-kernel@vger.kernel.org
Date: Tue, 09 Apr 2013 23:59:58 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pinctrl_register() returns NULL on error.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/pinctrl/vt8500/pinctrl-wmt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/vt8500/pinctrl-wmt.c b/drivers/pinctrl/vt8500/pinctrl-wmt.c
index 14400a7..ab63104e 100644
--- a/drivers/pinctrl/vt8500/pinctrl-wmt.c
+++ b/drivers/pinctrl/vt8500/pinctrl-wmt.c
@@ -588,7 +588,7 @@ int wmt_pinctrl_probe(struct platform_device *pdev,
 	data->dev = &pdev->dev;
 
 	data->pctl_dev = pinctrl_register(&wmt_desc, &pdev->dev, data);
-	if (IS_ERR(data->pctl_dev)) {
+	if (!data->pctl_dev) {
 		dev_err(&pdev->dev, "Failed to register pinctrl\n");
 		return -EINVAL;
 	}
-- 
1.7.10.4



