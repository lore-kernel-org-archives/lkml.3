Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751765AbaLOHWO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 02:22:14 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:40948 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419AbaLOHWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 02:22:12 -0500
Date: Mon, 15 Dec 2014 09:22:07 +0200
From: Asaf Vertz <asaf.vertz@tandemg.com>
To: gregkh@linuxfoundation.org
Cc: davidm@egauge.net, khoroshilov@ispras.ru, asaf.vertz@tandemg.com,
        sachin.kamat@linaro.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] usb: host: max3421-hcd: use time_after()
Message-ID: <20141215072207.GA15062@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To be future-proof and for better readability the time comparisons are
modified to use time_after() instead of plain, error-prone math.

Signed-off-by: Asaf Vertz <asaf.vertz@tandemg.com>
---
 drivers/usb/host/max3421-hcd.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/host/max3421-hcd.c b/drivers/usb/host/max3421-hcd.c
index 6234c75..aaaff94 100644
--- a/drivers/usb/host/max3421-hcd.c
+++ b/drivers/usb/host/max3421-hcd.c
@@ -55,6 +55,7 @@
  * single thread (max3421_spi_thread).
  */
 
+#include <linux/jiffies.h>
 #include <linux/module.h>
 #include <linux/spi/spi.h>
 #include <linux/usb.h>
@@ -1291,7 +1292,7 @@ max3421_handle_irqs(struct usb_hcd *hcd)
 		char sbuf[16 * 16], *dp, *end;
 		int i;
 
-		if (jiffies - last_time > 5*HZ) {
+		if (time_after(jiffies, last_time + 5*HZ)) {
 			dp = sbuf;
 			end = sbuf + sizeof(sbuf);
 			*dp = '\0';
-- 
1.7.0.4

