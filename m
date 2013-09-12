Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753028Ab3ILE2k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 00:28:40 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:59530 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067Ab3ILE2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 00:28:37 -0400
From: Olof Johansson <olof@lixom.net>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Olof Johansson <olof@lixom.net>
Subject: [PATCH] serial: imx: Change cast to handle 64-bit resource_size_t
Date: Wed, 11 Sep 2013 21:27:53 -0700
Message-Id: <1378960073-15307-1-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.8.1.192.gc4361b8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This resolves a warning where resource_size_t is larger than void *:

  drivers/tty/serial/imx.c:1542:6: warning: cast to pointer from integer
  	of different size [-Wint-to-pointer-cast]

Since iomem_base is a void *, casting to unsigned long is safe.

It's unclear to me that this comparison is truly needed, but it's there
on several other drivers as well.

Signed-off-by: Olof Johansson <olof@lixom.net>
---
 drivers/tty/serial/imx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/imx.c b/drivers/tty/serial/imx.c
index a0ebbc9..dd5e583 100644
--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -1539,7 +1539,7 @@ imx_verify_port(struct uart_port *port, struct serial_struct *ser)
 		ret = -EINVAL;
 	if (sport->port.uartclk / 16 != ser->baud_base)
 		ret = -EINVAL;
-	if ((void *)sport->port.mapbase != ser->iomem_base)
+	if (sport->port.mapbase != (unsigned long)ser->iomem_base)
 		ret = -EINVAL;
 	if (sport->port.iobase != ser->port)
 		ret = -EINVAL;
-- 
1.7.10.4

