Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752507Ab3JUCz7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Oct 2013 22:55:59 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:40805 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752406Ab3JUCz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Oct 2013 22:55:57 -0400
MIME-Version: 1.0
Date: Mon, 21 Oct 2013 10:55:56 +0800
Message-ID: <CAPgLHd8j82eWmhC6S=JrPgRu30rUspT-yatLYQ1KDnzyj8CcXw@mail.gmail.com>
Subject: [PATCH -next] pinctrl: tb10x: use module_platform_driver to simplify
 the code
From: Wei Yongjun <weiyj.lk@gmail.com>
To: linus.walleij@linaro.org, grant.likely@linaro.org, rob.herring@calxeda.com
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

module_platform_driver() makes the code simpler by eliminating
boilerplate code.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/pinctrl/pinctrl-tb10x.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-tb10x.c b/drivers/pinctrl/pinctrl-tb10x.c
index 2e1ea56..abf55c9 100644
--- a/drivers/pinctrl/pinctrl-tb10x.c
+++ b/drivers/pinctrl/pinctrl-tb10x.c
@@ -870,17 +870,7 @@ static struct platform_driver tb10x_pinctrl_pdrv = {
 	}
 };
 
-static int __init tb10x_iopinctrl_init(void)
-{
-	return platform_driver_register(&tb10x_pinctrl_pdrv);
-}
-
-static void __exit tb10x_iopinctrl_exit(void)
-{
-	platform_driver_unregister(&tb10x_pinctrl_pdrv);
-}
+module_platform_driver(tb10x_pinctrl_pdrv);
 
 MODULE_AUTHOR("Christian Ruppert <christian.ruppert@abilis.com>");
 MODULE_LICENSE("GPL");
-module_init(tb10x_iopinctrl_init);
-module_exit(tb10x_iopinctrl_exit);

