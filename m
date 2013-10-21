Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736Ab3JUXlQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 19:41:16 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:34197 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560Ab3JUXlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 19:41:13 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Michal Simek <michal.simek@xilinx.com>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH 1/3] tty: xuartps: Fix "may be used uninitialized" build warning
Date: Mon, 21 Oct 2013 16:40:59 -0700
Message-Id: <1382398861-21542-2-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.8.4.1
In-Reply-To: <1382398861-21542-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1382398861-21542-1-git-send-email-soren.brinkmann@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Initialize varibles for which a 'may be used uninitalized' warning is
issued.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
The warning is actually a false positive. The variables are passed to a
function per reference. That function uses those variables to return
values, which then are used by the caller. Is there a way to
avoid the initialization and the build warning alltogether?
---
 drivers/tty/serial/xilinx_uartps.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/xilinx_uartps.c b/drivers/tty/serial/xilinx_uartps.c
index c7c96c2f149c..5ac6c480df43 100644
--- a/drivers/tty/serial/xilinx_uartps.c
+++ b/drivers/tty/serial/xilinx_uartps.c
@@ -389,7 +389,7 @@ static unsigned int xuartps_set_baud_rate(struct uart_port *port,
 		unsigned int baud)
 {
 	unsigned int calc_baud;
-	u32 cd, bdiv;
+	u32 cd = 0, bdiv = 0;
 	u32 mreg;
 	int div8;
 	struct xuartps *xuartps = port->private_data;
-- 
1.8.4.1

