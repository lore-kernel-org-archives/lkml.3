Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308AbaJPUyu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 16:54:50 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:34284 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752984AbaJPUyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 16:54:43 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH -next 06/10] serial: core: Unwrap >80 char line in uart_close()
Date: Thu, 16 Oct 2014 16:54:23 -0400
Message-Id: <1413492867-20679-7-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413492867-20679-1-git-send-email-peter@hurleysoftware.com>
References: <1413492867-20679-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The wrapped line looks wrong and out-of-place; leave it as
>80 char line.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/serial/serial_core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 6ebe78c..be58916 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -1373,8 +1373,7 @@ static void uart_close(struct tty_struct *tty, struct file *filp)
 	if (port->blocked_open) {
 		spin_unlock_irqrestore(&port->lock, flags);
 		if (port->close_delay)
-			msleep_interruptible(
-					jiffies_to_msecs(port->close_delay));
+			msleep_interruptible(jiffies_to_msecs(port->close_delay));
 		spin_lock_irqsave(&port->lock, flags);
 	} else if (!uart_console(uport)) {
 		spin_unlock_irqrestore(&port->lock, flags);
-- 
2.1.1

