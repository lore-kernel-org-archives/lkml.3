Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447AbbALNwH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 08:52:07 -0500
Received: from smtp89.ord1c.emailsrvr.com ([108.166.43.89]:59397 "EHLO
	smtp89.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752238AbbALNwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 08:52:04 -0500
X-Sender-Id: pramod.gurav@smartplayin.com
From: Pramod Gurav <pramod.gurav@smartplayin.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-arm-msm@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pramod Gurav <pramod.gurav@smartplayin.com>
Subject: [PATCH] tty: serial: msm_serial: Remove console unregistration from driver exit.
Date: Mon, 12 Jan 2015 19:22:12 +0530
Message-Id: <1421070732-24527-1-git-send-email-pramod.gurav@smartplayin.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

unregister_console() will be called from uart_remove_one_port() while
removing the platform driver. So not necessary to call it in driver
exit path.

Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
---
 drivers/tty/serial/msm_serial.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/tty/serial/msm_serial.c b/drivers/tty/serial/msm_serial.c
index 8a7af98..58ba602 100644
--- a/drivers/tty/serial/msm_serial.c
+++ b/drivers/tty/serial/msm_serial.c
@@ -1298,9 +1298,6 @@ static int __init msm_serial_init(void)
 
 static void __exit msm_serial_exit(void)
 {
-#ifdef CONFIG_SERIAL_MSM_CONSOLE
-	unregister_console(&msm_console);
-#endif
 	platform_driver_unregister(&msm_platform_driver);
 	uart_unregister_driver(&msm_uart_driver);
 }
-- 
1.7.9.5

