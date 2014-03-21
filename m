Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760262AbaCUIZ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 04:25:29 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:40163 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753842AbaCUIZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 04:25:26 -0400
From: Sanjay Singh Rawat <sanjay.rawat@linaro.org>
To: gregkh@linuxfoundation.org, jslaby@suse.cz
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sanjay Singh Rawat <sanjay.rawat@linaro.org>
Subject: [PATCH] serial: omap: free the wakeup settings in remove
Date: Fri, 21 Mar 2014 13:55:10 +0530
Message-Id: <1395390310-21602-1-git-send-email-sanjay.rawat@linaro.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Sanjay Singh Rawat <sanjay.rawat@linaro.org>
---
 drivers/tty/serial/omap-serial.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap-serial.c
index 77f0351..56b61d4 100644
--- a/drivers/tty/serial/omap-serial.c
+++ b/drivers/tty/serial/omap-serial.c
@@ -1782,6 +1782,7 @@ static int serial_omap_remove(struct platform_device *dev)
 	pm_runtime_disable(up->dev);
 	uart_remove_one_port(&serial_omap_reg, &up->port);
 	pm_qos_remove_request(&up->pm_qos_request);
+	device_init_wakeup(&dev->dev, false);
 
 	return 0;
 }
-- 
1.7.10.4

