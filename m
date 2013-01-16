Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757512Ab3APWbT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 17:31:19 -0500
Received: from mail-ea0-f176.google.com ([209.85.215.176]:55677 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756310Ab3APWbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 17:31:17 -0500
From: Cong Ding <dinggnu@gmail.com>
To: Tony Prisk <linux@prisktech.co.nz>, Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-arm-kernel@lists.infradead.org,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Cong Ding <dinggnu@gmail.com>
Subject: [PATCH] tty: serial/vt8500_serial.c: fix bug caused by missing "{}"
Date: Wed, 16 Jan 2013 23:25:03 +0100
Message-Id: <1358375103-11703-1-git-send-email-dinggnu@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is obviously here should be braced by "{}" in the "if" branch (more than 1
line in the "if" branch), and by the
coding style document of the kernel I also add "{}" to the else branch.

Signed-off-by: Cong Ding <dinggnu@gmail.com>
---
 drivers/tty/serial/vt8500_serial.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/vt8500_serial.c b/drivers/tty/serial/vt8500_serial.c
index 8fd1814..ac46a6e 100644
--- a/drivers/tty/serial/vt8500_serial.c
+++ b/drivers/tty/serial/vt8500_serial.c
@@ -567,12 +567,13 @@ static int vt8500_serial_probe(struct platform_device *pdev)
 	if (!mmres || !irqres)
 		return -ENODEV;
 
-	if (np)
+	if (np) {
 		port = of_alias_get_id(np, "serial");
 		if (port > VT8500_MAX_PORTS)
 			port = -1;
-	else
+	} else {
 		port = -1;
+	}
 
 	if (port < 0) {
 		/* calculate the port id */
-- 
1.7.10.4

