Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751341Ab3EEFHG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 May 2013 01:07:06 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:54575 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233Ab3EEFHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 May 2013 01:07:04 -0400
MIME-Version: 1.0
Date: Sun, 5 May 2013 13:07:00 +0800
Message-ID: <CAPgLHd86cg11pHka0TRMFkEJV2ETLHwnr3oUo=FpBYnSLk=8sA@mail.gmail.com>
Subject: [PATCH] rtc: rtc-tile: add missing platform_device_unregister() when
 module exit
From: Wei Yongjun <weiyj.lk@gmail.com>
To: a.zummo@towertech.it, akpm@linux-foundation.org
Cc: yongjun_wei@trendmicro.com.cn, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

We have registered platform device when module init, and
need unregister it when module exit.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/rtc/rtc-tile.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/rtc/rtc-tile.c b/drivers/rtc/rtc-tile.c
index 249b653..fc3dee9 100644
--- a/drivers/rtc/rtc-tile.c
+++ b/drivers/rtc/rtc-tile.c
@@ -146,6 +146,7 @@ exit_driver_unregister:
  */
 static void __exit tile_rtc_driver_exit(void)
 {
+	platform_device_unregister(tile_rtc_platform_device);
 	platform_driver_unregister(&tile_rtc_platform_driver);
 }
 

