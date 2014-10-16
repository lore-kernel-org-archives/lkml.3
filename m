Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753142AbaJPU4h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 16:56:37 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:45490 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753064AbaJPUyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 16:54:44 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH -next 07/10] serial: core: Remove redundant timeout assignments
Date: Thu, 16 Oct 2014 16:54:24 -0400
Message-Id: <1413492867-20679-8-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413492867-20679-1-git-send-email-peter@hurleysoftware.com>
References: <1413492867-20679-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tty_port_init() initializes close_delay and closing_wait to these
same values; remove.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/serial/serial_core.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index be58916..676c03a 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -2346,8 +2346,6 @@ int uart_register_driver(struct uart_driver *drv)
 
 		tty_port_init(port);
 		port->ops = &uart_port_ops;
-		port->close_delay     = HZ / 2;	/* .5 seconds */
-		port->closing_wait    = 30 * HZ;/* 30 seconds */
 	}
 
 	retval = tty_register_driver(normal);
-- 
2.1.1

