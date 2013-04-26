Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756673Ab3DZGSy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 02:18:54 -0400
Received: from mail-bk0-f49.google.com ([209.85.214.49]:32817 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754560Ab3DZGSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 02:18:53 -0400
MIME-Version: 1.0
Date: Fri, 26 Apr 2013 14:18:51 +0800
Message-ID: <CAPgLHd_O=4+iOa4J72n_1MC5Lv4tT86mZdQ7GZzAnz-vHLQKEQ@mail.gmail.com>
Subject: [PATCH] w1: ds2781: fix the error handling in w1_ds2781_add_slave()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: zbr@ioremap.net, neilb@suse.de, gregkh@linuxfoundation.org
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Use platform_device_put() instead of platform_device_unregister() if
platform_device_add() fail, and platform_device_del() should be used
in the error handling case after platform_device_add() success.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/w1/slaves/w1_ds2781.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/w1/slaves/w1_ds2781.c b/drivers/w1/slaves/w1_ds2781.c
index 877daf7..5140d7b 100644
--- a/drivers/w1/slaves/w1_ds2781.c
+++ b/drivers/w1/slaves/w1_ds2781.c
@@ -139,8 +139,9 @@ static int w1_ds2781_add_slave(struct w1_slave *sl)
 	return 0;
 
 bin_attr_failed:
+	platform_device_del(pdev);
 pdev_add_failed:
-	platform_device_unregister(pdev);
+	platform_device_put(pdev);
 pdev_alloc_failed:
 	ida_simple_remove(&bat_ida, id);
 noid:

