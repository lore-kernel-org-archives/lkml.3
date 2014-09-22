Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751730AbaIVGay (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 02:30:54 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:37538 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbaIVGax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 02:30:53 -0400
From: Sudhir Sreedharan <ssreedharan@mvista.com>
To: linux-serial@vger.kernel.org
Cc: gregkh@linuxfoundation.org, jslaby@suse.cz, linux-kernel@vger.kernel.org,
        Sudhir Sreedharan <ssreedharan@mvista.com>
Subject: [PATCH] serial/core: Initialize the console pm state
Date: Mon, 22 Sep 2014 12:00:22 +0530
Message-Id: <1411367422-2095-1-git-send-email-ssreedharan@mvista.com>
X-Mailer: git-send-email 1.7.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For console devices having UART_CAP_SLEEP capability, the uart_pm_state has
to be initialized to UART_PM_STATE_ON. Otherwise the LCR regiser values
are reinitialized when uart_change_pm is called from uart_configure_port.

Signed-off-by: Sudhir Sreedharan <ssreedharan@mvista.com>
---
 drivers/tty/serial/serial_core.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 29a7be4..91bfd52 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -2615,6 +2615,9 @@ int uart_add_one_port(struct uart_driver *drv, struct uart_port *uport)
 	if (uport->cons && uport->dev)
 		of_console_check(uport->dev->of_node, uport->cons->name, uport->line);
 
+	if (uart_console(uport))
+		state->pm_state = UART_PM_STATE_ON;
+
 	uart_configure_port(drv, state, uport);
 
 	num_groups = 2;
-- 
1.7.0.1

