Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932361AbaHEH4W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 03:56:22 -0400
Received: from smtp97.ord1c.emailsrvr.com ([108.166.43.97]:51737 "EHLO
	smtp97.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932345AbaHEH4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 03:56:20 -0400
X-Sender-Id: kiran.padwal@smartplayin.com
From: Kiran Padwal <kiran.padwal@smartplayin.com>
To: davidb@codeaurora.org
Cc: dwalker@fifo99.com, bryanh@codeaurora.org, sboyd@codeaurora.org,
        gregkh@linuxfoundation.org, jslaby@suse.cz,
        kiran.padwal@smartplayin.com, linux-arm-msm@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] tty: serial: msm: Fix 'Missing a blank line after declarations' warning
Date: Tue,  5 Aug 2014 13:22:00 +0530
Message-Id: <1407225124-25074-3-git-send-email-kiran.padwal@smartplayin.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1407225124-25074-1-git-send-email-kiran.padwal@smartplayin.com>
References: <1407225124-25074-1-git-send-email-kiran.padwal@smartplayin.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes below checkpatch.pl warning and it remove extra blank lines:

WARNING: Missing a blank line after declarations

Signed-off-by: Kiran Padwal <kiran.padwal@smartplayin.com>
---
 drivers/tty/serial/msm_serial.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/msm_serial.c b/drivers/tty/serial/msm_serial.c
index 6c7300b..0295493 100644
--- a/drivers/tty/serial/msm_serial.c
+++ b/drivers/tty/serial/msm_serial.c
@@ -314,7 +314,6 @@ static unsigned int msm_get_mctrl(struct uart_port *port)
 	return TIOCM_CAR | TIOCM_CTS | TIOCM_DSR | TIOCM_RTS;
 }
 
-
 static void msm_reset(struct uart_port *port)
 {
 	struct msm_port *msm_port = UART_TO_MSM(port);
@@ -335,6 +334,7 @@ static void msm_reset(struct uart_port *port)
 static void msm_set_mctrl(struct uart_port *port, unsigned int mctrl)
 {
 	unsigned int mr;
+
 	mr = msm_read(port, UART_MR1);
 
 	if (!(mctrl & TIOCM_RTS)) {
@@ -430,7 +430,6 @@ static int msm_set_baud_rate(struct uart_port *port, unsigned int baud)
 	return baud;
 }
 
-
 static void msm_init_clock(struct uart_port *port)
 {
 	struct msm_port *msm_port = UART_TO_MSM(port);
@@ -645,6 +644,7 @@ fail_release_port:
 static void msm_config_port(struct uart_port *port, int flags)
 {
 	int ret;
+
 	if (flags & UART_CONFIG_TYPE) {
 		port->type = PORT_MSM;
 		ret = msm_request_port(port);
-- 
1.7.9.5

