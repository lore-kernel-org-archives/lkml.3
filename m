Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755695Ab3DZGSe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 02:18:34 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:52479 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755454Ab3DZGS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 02:18:29 -0400
MIME-Version: 1.0
Date: Fri, 26 Apr 2013 14:18:28 +0800
Message-ID: <CAPgLHd_m0t7YL+W0TrPDuHHH3xkpUEXN6SP5SvWdFL9u9o2wTg@mail.gmail.com>
Subject: [PATCH] w1: bq27000: fix the error handling in w1_bq27000_add_slave()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: zbr@ioremap.net, gregkh@linuxfoundation.org, neilb@suse.de,
        akpm@linux-foundation.org
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Use platform_device_put() instead of platform_device_unregister() if
platform_device_add() fails, and also add the return value check of
platform_device_add_data().

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/w1/slaves/w1_bq27000.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/w1/slaves/w1_bq27000.c b/drivers/w1/slaves/w1_bq27000.c
index 773dca5..afbefed 100644
--- a/drivers/w1/slaves/w1_bq27000.c
+++ b/drivers/w1/slaves/w1_bq27000.c
@@ -57,6 +57,8 @@ static int w1_bq27000_add_slave(struct w1_slave *sl)
 	ret = platform_device_add_data(pdev,
 				       &bq27000_battery_info,
 				       sizeof(bq27000_battery_info));
+	if (ret)
+		goto pdev_add_failed;
 	pdev->dev.parent = &sl->dev;
 
 	ret = platform_device_add(pdev);
@@ -68,7 +70,7 @@ static int w1_bq27000_add_slave(struct w1_slave *sl)
 	goto success;
 
 pdev_add_failed:
-	platform_device_unregister(pdev);
+	platform_device_put(pdev);
 success:
 	return ret;
 }

