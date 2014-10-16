Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753089AbaJPU4f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 16:56:35 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:46816 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753123AbaJPUyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 16:54:44 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH -next 08/10] serial: core: Colocate crucial structure linkage
Date: Thu, 16 Oct 2014 16:54:25 -0400
Message-Id: <1413492867-20679-9-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413492867-20679-1-git-send-email-peter@hurleysoftware.com>
References: <1413492867-20679-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The key function of uart_add_one_port() is to cross-reference the
UART driver's port structure with the serial core's state table;
keep the assignments together and document this crucial association.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/serial/serial_core.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 676c03a..e04ae58 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -2594,11 +2594,12 @@ int uart_add_one_port(struct uart_driver *drv, struct uart_port *uport)
 		goto out;
 	}
 
+	/* Link the port to the driver state table and vice versa */
 	state->uart_port = uport;
-	state->pm_state = UART_PM_STATE_UNDEFINED;
+	uport->state = state;
 
+	state->pm_state = UART_PM_STATE_UNDEFINED;
 	uport->cons = drv->cons;
-	uport->state = state;
 
 	/*
 	 * If this port is a console, then the spinlock is already
-- 
2.1.1

