Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964994AbaFCUN1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 16:13:27 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:35444 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932917AbaFCUN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 16:13:26 -0400
From: Kumar Gala <galak@codeaurora.org>
To: linux-arm-msm@vger.kernel.org
Cc: Kumar Gala <galak@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, gregkh@linuxfoundation.org,
        olof@lixom.net
Subject: [PATCH] tty: serial: msm: Fix section mismatch warning
Date: Tue,  3 Jun 2014 15:13:22 -0500
Message-Id: <1401826402-1079-1-git-send-email-galak@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WARNING: drivers/tty/built-in.o(.data+0x3544): Section mismatch in
reference from the variable msm_platform_driver to the function
.init.text:msm_serial_probe()
The variable msm_platform_driver references
the function __init msm_serial_probe()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console

Signed-off-by: Kumar Gala <galak@codeaurora.org>
---
 drivers/tty/serial/msm_serial.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/msm_serial.c b/drivers/tty/serial/msm_serial.c
index 778e376..24f3cdc 100644
--- a/drivers/tty/serial/msm_serial.c
+++ b/drivers/tty/serial/msm_serial.c
@@ -991,7 +991,7 @@ static const struct of_device_id msm_uartdm_table[] = {
 	{ }
 };
 
-static int __init msm_serial_probe(struct platform_device *pdev)
+static int msm_serial_probe(struct platform_device *pdev)
 {
 	struct msm_port *msm_port;
 	struct resource *resource;
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

