Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707Ab3JUFdx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 01:33:53 -0400
Received: from mail-bk0-f49.google.com ([209.85.214.49]:38815 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752534Ab3JUFdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 01:33:52 -0400
MIME-Version: 1.0
Date: Mon, 21 Oct 2013 13:33:50 +0800
Message-ID: <CAPgLHd9XPcwT+PXQsKqQRJxTNvJRi4FC-pOojp6ngHC=q6J4=w@mail.gmail.com>
Subject: [PATCH -next] staging: sep: add missing misc_deregister() on error in sep_register_driver_with_fs()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: gregkh@linuxfoundation.org, peterhuewe@gmx.de, wfp5p@virginia.edu,
        yongjun_wei@trendmicro.com.cn, devendra.aaru@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Add the missing misc_deregister() before return from
sep_register_driver_with_fs() in the error handling case.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/staging/sep/sep_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/sep/sep_main.c b/drivers/staging/sep/sep_main.c
index 11f5b21..5f8c0a8 100644
--- a/drivers/staging/sep/sep_main.c
+++ b/drivers/staging/sep/sep_main.c
@@ -4075,6 +4075,7 @@ static int sep_register_driver_with_fs(struct sep_device *sep)
 	if (ret_val) {
 		dev_warn(&sep->pdev->dev, "sysfs attribute1 fails for SEP %x\n",
 			ret_val);
+		misc_deregister(&sep->miscdev_sep);
 		return ret_val;
 	}
 

