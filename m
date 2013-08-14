Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932623Ab3HNKqh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 06:46:37 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:41437 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932604Ab3HNKqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 06:46:34 -0400
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Cc: gregkh@linuxfoundation.org, tobetter@gmail.com, broonie@linaro.org,
        patches@linaro.org
Subject: [PATCH] usb: misc: usb3503: Force late initialization
Date: Wed, 14 Aug 2013 15:59:31 +0530
Message-Id: <1376476171-19072-1-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

USB3503 chip needs to be reset after the USB PHY controller has been
intiliazed, otherwise it is not detected as plugged in.

Currently there is no other way to ensure that USB3503 chip is probed
after the USB PHY has been initialized, hence the last resort.

Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
---
 drivers/usb/misc/usb3503.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/misc/usb3503.c b/drivers/usb/misc/usb3503.c
index a31641e..ad8368d 100644
--- a/drivers/usb/misc/usb3503.c
+++ b/drivers/usb/misc/usb3503.c
@@ -339,7 +339,7 @@ static int __init usb3503_init(void)
 
 	return 0;
 }
-module_init(usb3503_init);
+late_initcall(usb3503_init);
 
 static void __exit usb3503_exit(void)
 {
-- 
1.7.9.5

