Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752263AbaB1CVO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 21:21:14 -0500
Received: from mail-ea0-f176.google.com ([209.85.215.176]:38111 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941AbaB1CVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 21:21:12 -0500
From: Kumar Amit Mehta <gmate.amit@gmail.com>
To: gregkh@linuxfoundation.org
Cc: standby24x7@gmail.com, josh@joshtriplett.org, rashika.kheria@gmail.com,
        lidza.louina@gmail.com, dan.carpenter@oracle.com, lisa@xenapiadmin.com,
        devel@driverdev.osuosl.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: sb105x: b_pci_mp.c: fix for non-member access
Date: Fri, 28 Feb 2014 04:21:03 +0200
Message-Id: <1393554063-25823-1-git-send-email-gmate.amit@gmail.com>
X-Mailer: git-send-email 1.8.5.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'struct tty_struct’ has no member named ‘low_latency’

Signed-off-by: Kumar Amit Mehta <gmate.amit@gmail.com>
---
 drivers/staging/sb105x/sb_pci_mp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/sb105x/sb_pci_mp.c b/drivers/staging/sb105x/sb_pci_mp.c
index c9d6ee3..5687d6c 100644
--- a/drivers/staging/sb105x/sb_pci_mp.c
+++ b/drivers/staging/sb105x/sb_pci_mp.c
@@ -898,7 +898,7 @@ static int mp_set_info(struct sb_uart_state *state, struct serial_struct *newinf
 	state->closing_wait    = closing_wait;
 	port->fifosize         = new_serial.xmit_fifo_size;
 	if (state->info->tty)
-		state->info->tty->low_latency =
+		state->info->tty->port->low_latency =
 			(port->flags & UPF_LOW_LATENCY) ? 1 : 0;
 
 check_and_exit:
@@ -1571,7 +1571,7 @@ static int mp_open(struct tty_struct *tty, struct file *filp)
 	mtpt  = (struct mp_port *)state->port;
 
 	tty->driver_data = state;
-	tty->low_latency = (state->port->flags & UPF_LOW_LATENCY) ? 1 : 0;
+	tty->port->low_latency = (state->port->flags & UPF_LOW_LATENCY) ? 1 : 0;
 	tty->alt_speed = 0;
 	state->info->tty = tty;
 
-- 
1.8.5.3

