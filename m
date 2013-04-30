Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934054Ab3D3X7R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 19:59:17 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:60279 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934039Ab3D3X7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 19:59:03 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Michal Simek <michal.simek@xilinx.com>,
        Josh Cartwright <joshc@eso.teric.us>,
        Mike Turquette <mturquette@linaro.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org
Subject: [PATCH 2/7] tty: xuartps: Remove suspend/resume functions
Date: Tue, 30 Apr 2013 16:57:59 -0700
Message-Id: <1367366284-28304-3-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <1367366284-28304-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1367366284-28304-1-git-send-email-soren.brinkmann@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently Zynq does not support suspend/resume.
The driver callbacks are never used or tested, broken and using the old
PM interface.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: linux-serial@vger.kernel.org
---
 drivers/tty/serial/xilinx_uartps.c | 30 ------------------------------
 1 file changed, 30 deletions(-)

diff --git a/drivers/tty/serial/xilinx_uartps.c b/drivers/tty/serial/xilinx_uartps.c
index 773732b..04a1f8f 100644
--- a/drivers/tty/serial/xilinx_uartps.c
+++ b/drivers/tty/serial/xilinx_uartps.c
@@ -1006,34 +1006,6 @@ static int xuartps_remove(struct platform_device *pdev)
 	return rc;
 }
 
-/**
- * xuartps_suspend - suspend event
- * @pdev: Pointer to the platform device structure
- * @state: State of the device
- *
- * Returns 0
- **/
-static int xuartps_suspend(struct platform_device *pdev, pm_message_t state)
-{
-	/* Call the API provided in serial_core.c file which handles
-	 * the suspend.
-	 */
-	uart_suspend_port(&xuartps_uart_driver, &xuartps_port[pdev->id]);
-	return 0;
-}
-
-/**
- * xuartps_resume - Resume after a previous suspend
- * @pdev: Pointer to the platform device structure
- *
- * Returns 0
- **/
-static int xuartps_resume(struct platform_device *pdev)
-{
-	uart_resume_port(&xuartps_uart_driver, &xuartps_port[pdev->id]);
-	return 0;
-}
-
 /* Match table for of_platform binding */
 static struct of_device_id xuartps_of_match[] = {
 	{ .compatible = "xlnx,xuartps", },
@@ -1044,8 +1016,6 @@ MODULE_DEVICE_TABLE(of, xuartps_of_match);
 static struct platform_driver xuartps_platform_driver = {
 	.probe   = xuartps_probe,		/* Probe method */
 	.remove  = xuartps_remove,		/* Detach method */
-	.suspend = xuartps_suspend,		/* Suspend */
-	.resume  = xuartps_resume,		/* Resume after a suspend */
 	.driver  = {
 		.owner = THIS_MODULE,
 		.name = XUARTPS_NAME,		/* Driver name */
-- 
1.8.2.2

