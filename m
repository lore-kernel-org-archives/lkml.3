Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932340AbaHEHzm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 03:55:42 -0400
Received: from smtp97.ord1c.emailsrvr.com ([108.166.43.97]:60491 "EHLO
	smtp97.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932324AbaHEHzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 03:55:40 -0400
X-Sender-Id: kiran.padwal@smartplayin.com
From: Kiran Padwal <kiran.padwal@smartplayin.com>
To: davidb@codeaurora.org
Cc: dwalker@fifo99.com, bryanh@codeaurora.org, sboyd@codeaurora.org,
        gregkh@linuxfoundation.org, jslaby@suse.cz,
        kiran.padwal@smartplayin.com, linux-arm-msm@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] tty: serial: msm: remove braces {} in msm_serial.c
Date: Tue,  5 Aug 2014 13:21:59 +0530
Message-Id: <1407225124-25074-2-git-send-email-kiran.padwal@smartplayin.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1407225124-25074-1-git-send-email-kiran.padwal@smartplayin.com>
References: <1407225124-25074-1-git-send-email-kiran.padwal@smartplayin.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed below checkpatch.pl warning:

WARNING: braces {} are not necessary for any arm of this statement

Signed-off-by: Kiran Padwal <kiran.padwal@smartplayin.com>
---
 drivers/tty/serial/msm_serial.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/serial/msm_serial.c b/drivers/tty/serial/msm_serial.c
index 0da0b54..6c7300b 100644
--- a/drivers/tty/serial/msm_serial.c
+++ b/drivers/tty/serial/msm_serial.c
@@ -190,11 +190,10 @@ static void handle_rx(struct uart_port *port)
 		/* Mask conditions we're ignorning. */
 		sr &= port->read_status_mask;
 
-		if (sr & UART_SR_RX_BREAK) {
+		if (sr & UART_SR_RX_BREAK)
 			flag = TTY_BREAK;
-		} else if (sr & UART_SR_PAR_FRAME_ERR) {
+		else if (sr & UART_SR_PAR_FRAME_ERR)
 			flag = TTY_FRAME;
-		}
 
 		if (!uart_handle_sysrq_char(port, c))
 			tty_insert_flip_char(tport, c, flag);
-- 
1.7.9.5

