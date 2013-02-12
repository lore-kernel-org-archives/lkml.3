Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934878Ab3BTLYc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 06:24:32 -0500
Received: from mail-bk0-f50.google.com ([209.85.214.50]:57134 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934662Ab3BTLYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 06:24:30 -0500
From: Pawel Wieczorkiewicz <wpawel@gmail.com>
To: nicolas.ferre@atmel.com, gregkh@linuxfoundation.org,
        grant.likely@secretlab.ca, jslaby@suse.cz
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pawel Wieczorkiewicz <wpawel@gmail.com>
Subject: [PATCH 1/1] tty: atmel_serial_probe(): index of atmel_ports[] fix
Date: Wed, 13 Feb 2013 00:17:29 +0100
Message-Id: <1360711049-5557-1-git-send-email-wpawel@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pawel Wieczorkiewicz <wpawel@gmail.com>

Index of atmel_ports[ATMEL_MAX_UART] should be smaller
than ATMEL_MAX_UART.

Signed-off-by: Pawel Wieczorkiewicz <wpawel@gmail.com>
---
 drivers/tty/serial/atmel_serial.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/atmel_serial.c b/drivers/tty/serial/atmel_serial.c
index d4a7c24..3f7586a 100644
--- a/drivers/tty/serial/atmel_serial.c
+++ b/drivers/tty/serial/atmel_serial.c
@@ -1772,7 +1772,7 @@ static int atmel_serial_probe(struct platform_device *pdev)
 		ret = find_first_zero_bit(&atmel_ports_in_use,
 				sizeof(atmel_ports_in_use));
 
-	if (ret > ATMEL_MAX_UART) {
+	if (!(ret < ATMEL_MAX_UART)) {
 		ret = -ENODEV;
 		goto err;
 	}
-- 
1.7.9.5

