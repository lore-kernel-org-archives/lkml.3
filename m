Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752472AbaCGTQZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 14:16:25 -0500
Received: from mail-ig0-f182.google.com ([209.85.213.182]:61418 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753454AbaCGTOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 14:14:24 -0500
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Arnd Bergmann <arnd@arndb.de>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Michal Simek <michal.simek@xilinx.com>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-serial@vger.kernel.org,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH RFC v2 04/11] tty: xuartps: Remove bogus comment and register write
Date: Fri,  7 Mar 2014 11:13:27 -0800
Message-Id: <1394219614-3197-5-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.9.0.1.g4196000
In-Reply-To: <1394219614-3197-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1394219614-3197-1-git-send-email-soren.brinkmann@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
 drivers/tty/serial/xilinx_uartps.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/tty/serial/xilinx_uartps.c b/drivers/tty/serial/xilinx_uartps.c
index a4bd6242e72d..a39c2d290902 100644
--- a/drivers/tty/serial/xilinx_uartps.c
+++ b/drivers/tty/serial/xilinx_uartps.c
@@ -1082,11 +1082,7 @@ static void xuartps_console_write(struct console *co, const char *s,
 
 	xuartps_writel(ctrl, XUARTPS_CR_OFFSET);
 
-	/* restore interrupt state, it seems like there may be a h/w bug
-	 * in that the interrupt enable register should not need to be
-	 * written based on the data sheet
-	 */
-	xuartps_writel(~imr, XUARTPS_IDR_OFFSET);
+	/* restore interrupt state */
 	xuartps_writel(imr, XUARTPS_IER_OFFSET);
 
 	if (locked)
-- 
1.9.0.1.g4196000

