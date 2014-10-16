Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751546AbaJPIqf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 04:46:35 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:46616 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbaJPIqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 04:46:32 -0400
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] serial: 8250: sparse warning of incorrect type
Date: Thu, 16 Oct 2014 14:16:22 +0530
Message-Id: <1413449182-1117-1-git-send-email-sudipm.mukherjee@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed a sparse warning in 8250_core.c :
	incorrect type in assignment (different address spaces)

the warning was because an unsigned char pointer was being assigned to
a pointer of unsigned char __iomem type .

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---
 drivers/tty/serial/8250/8250.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/8250/8250.h b/drivers/tty/serial/8250/8250.h
index cb51be55..9547fd5 100644
--- a/drivers/tty/serial/8250/8250.h
+++ b/drivers/tty/serial/8250/8250.h
@@ -51,7 +51,7 @@ struct old_serial_port {
 	unsigned int flags;
 	unsigned char hub6;
 	unsigned char io_type;
-	unsigned char *iomem_base;
+	unsigned char __iomem *iomem_base;
 	unsigned short iomem_reg_shift;
 	unsigned long irqflags;
 };
-- 
1.8.1.2

