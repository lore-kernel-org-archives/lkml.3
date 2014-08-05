Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932398AbaHEH4b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 03:56:31 -0400
Received: from smtp97.ord1c.emailsrvr.com ([108.166.43.97]:39078 "EHLO
	smtp97.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932363AbaHEH43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 03:56:29 -0400
X-Sender-Id: kiran.padwal@smartplayin.com
From: Kiran Padwal <kiran.padwal@smartplayin.com>
To: davidb@codeaurora.org
Cc: dwalker@fifo99.com, bryanh@codeaurora.org, sboyd@codeaurora.org,
        gregkh@linuxfoundation.org, jslaby@suse.cz,
        kiran.padwal@smartplayin.com, linux-arm-msm@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] tty: serial: msm: Fix 'else is not generally useful after a break or return' warning
Date: Tue,  5 Aug 2014 13:22:02 +0530
Message-Id: <1407225124-25074-5-git-send-email-kiran.padwal@smartplayin.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1407225124-25074-1-git-send-email-kiran.padwal@smartplayin.com>
References: <1407225124-25074-1-git-send-email-kiran.padwal@smartplayin.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed below checkpatch.pl warning:

WARNING: else is not generally useful after a break or return

Signed-off-by: Kiran Padwal <kiran.padwal@smartplayin.com>
---
 drivers/tty/serial/msm_serial.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/msm_serial.c b/drivers/tty/serial/msm_serial.c
index e70d4e8..dfebbaf 100644
--- a/drivers/tty/serial/msm_serial.c
+++ b/drivers/tty/serial/msm_serial.c
@@ -700,8 +700,8 @@ static int msm_poll_get_char_single(struct uart_port *port)
 
 	if (!(msm_read(port, UART_SR) & UART_SR_RX_READY))
 		return NO_POLL_CHAR;
-	else
-		return msm_read(port, rf_reg) & 0xff;
+
+	return msm_read(port, rf_reg) & 0xff;
 }
 
 static int msm_poll_get_char_dm_1p3(struct uart_port *port)
-- 
1.7.9.5

