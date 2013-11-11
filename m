Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752651Ab3KKGSi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 01:18:38 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:51906 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762Ab3KKGSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 01:18:30 -0500
MIME-Version: 1.0
Date: Mon, 11 Nov 2013 14:18:29 +0800
Message-ID: <CAPgLHd-qf8Zj0gWgJh3_WMZOAx5-H6aABrVFqRsAw=XkOfDdmw@mail.gmail.com>
Subject: [PATCH] MIPS: Alchemy: add missing platform_set_drvdata() in au1550nd_probe()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: dwmw2@infradead.org, wfp5p@virginia.edu, artem.bityutskiy@linux.intel.com,
        jg1.han@samsung.com, computersforpeace@gmail.com
Cc: yongjun_wei@trendmicro.com.cn, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Add missing platform_set_drvdata() in au1550nd_probe(), otherwise
calling platform_get_drvdata() in remove returns NULL.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/mtd/nand/au1550nd.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/mtd/nand/au1550nd.c b/drivers/mtd/nand/au1550nd.c
index ae8dd7c..909b673 100644
--- a/drivers/mtd/nand/au1550nd.c
+++ b/drivers/mtd/nand/au1550nd.c
@@ -480,6 +480,8 @@ static int au1550nd_probe(struct platform_device *pdev)
 
 	mtd_device_register(&ctx->info, pd->parts, pd->num_parts);
 
+	platform_set_drvdata(pdev, ctx);
+
 	return 0;
 
 out3:

