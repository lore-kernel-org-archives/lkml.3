Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757858AbaFANhg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 09:37:36 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:33171 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757544AbaFANhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 09:37:32 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, linux-arm-msm@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH] tty: serial: msm_serial.c:  Cleaning up uninitialized variables
Date: Sun,  1 Jun 2014 15:38:24 +0200
Message-Id: <1401629904-19492-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a risk that the variable will be used without being initialized.

This was largely found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/tty/serial/msm_serial.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/msm_serial.c b/drivers/tty/serial/msm_serial.c
index 053b98e..c67f5c5 100644
--- a/drivers/tty/serial/msm_serial.c
+++ b/drivers/tty/serial/msm_serial.c
@@ -962,7 +962,7 @@ static int __init msm_console_setup(struct console *co, char *options)
 {
 	struct uart_port *port;
 	struct msm_port *msm_port;
-	int baud, flow, bits, parity;
+	int baud = 0, flow, bits, parity;
 
 	if (unlikely(co->index >= UART_NR || co->index < 0))
 		return -ENXIO;
-- 
1.7.10.4

