Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755678Ab3FGCOb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 22:14:31 -0400
Received: from mail-bk0-f54.google.com ([209.85.214.54]:51751 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754357Ab3FGCO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 22:14:29 -0400
MIME-Version: 1.0
Date: Fri, 7 Jun 2013 10:14:27 +0800
Message-ID: <CAPgLHd9jbdU13hJo5c3kFM7vBCHzHHoahgFVos5kiO4ywe8QUQ@mail.gmail.com>
Subject: [PATCH] staging: tidspbridge: fix error return code in omap34_xx_bridge_probe()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: omar.ramirez@copitl.com, gregkh@linuxfoundation.org, wfp5p@virginia.edu,
        akpm@linux-foundation.org, tony@atomide.com
Cc: yongjun_wei@trendmicro.com.cn, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fix to return a negative error code in the class_create() error
handling case instead of 0, as done elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/staging/tidspbridge/rmgr/drv_interface.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/tidspbridge/rmgr/drv_interface.c b/drivers/staging/tidspbridge/rmgr/drv_interface.c
index c4d632c..6d04eb4 100644
--- a/drivers/staging/tidspbridge/rmgr/drv_interface.c
+++ b/drivers/staging/tidspbridge/rmgr/drv_interface.c
@@ -507,6 +507,7 @@ static int omap34_xx_bridge_probe(struct platform_device *pdev)
 	bridge_class = class_create(THIS_MODULE, "ti_bridge");
 	if (IS_ERR(bridge_class)) {
 		pr_err("%s: Error creating bridge class\n", __func__);
+		err = PTR_ERR(bridge_class);
 		goto err3;
 	}
 

