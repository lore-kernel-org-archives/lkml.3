Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028Ab3AOE5u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 23:57:50 -0500
Received: from server.prisktech.co.nz ([115.188.14.127]:63047 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753041Ab3AOE5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 23:57:49 -0500
From: Tony Prisk <linux@prisktech.co.nz>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: vt8500-wm8505-linux-kernel@googlegroups.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        Tony Prisk <linux@prisktech.co.nz>
Subject: [PATCH 1/4] serial: vt8500: Fix range-checking on vt8500_uart_ports
Date: Tue, 15 Jan 2013 17:58:03 +1300
Message-Id: <1358225886-5686-2-git-send-email-linux@prisktech.co.nz>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358225886-5686-1-git-send-email-linux@prisktech.co.nz>
References: <1358225886-5686-1-git-send-email-linux@prisktech.co.nz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix two instances where the index to vt8500_uart_ports is tested
against > VT8500_MAX_PORTS. Correct usage should be >= VT8500_MAX_PORTS.

Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
---
 drivers/tty/serial/vt8500_serial.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/vt8500_serial.c b/drivers/tty/serial/vt8500_serial.c
index 8fd1814..4c4a58d 100644
--- a/drivers/tty/serial/vt8500_serial.c
+++ b/drivers/tty/serial/vt8500_serial.c
@@ -569,7 +569,7 @@ static int vt8500_serial_probe(struct platform_device *pdev)
 
 	if (np)
 		port = of_alias_get_id(np, "serial");
-		if (port > VT8500_MAX_PORTS)
+		if (port >= VT8500_MAX_PORTS)
 			port = -1;
 	else
 		port = -1;
@@ -580,7 +580,7 @@ static int vt8500_serial_probe(struct platform_device *pdev)
 					sizeof(vt8500_ports_in_use));
 	}
 
-	if (port > VT8500_MAX_PORTS)
+	if (port >= VT8500_MAX_PORTS)
 		return -ENODEV;
 
 	/* reserve the port id */
-- 
1.7.9.5

