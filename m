Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777AbaCKKL2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 06:11:28 -0400
Received: from albert.telenet-ops.be ([195.130.137.90]:45788 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754535AbaCKKLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 06:11:24 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Simon Horman <horms+renesas@verge.net.au>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-serial@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Subject: [PATCH 1/4] serial: sh-sci: Replace printk() by pr_*()
Date: Tue, 11 Mar 2014 11:11:17 +0100
Message-Id: <1394532680-4264-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

Make banner const while we're at it

Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
---
 drivers/tty/serial/sh-sci.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/serial/sh-sci.c b/drivers/tty/serial/sh-sci.c
index 7958115e6a51..24ec6ef67984 100644
--- a/drivers/tty/serial/sh-sci.c
+++ b/drivers/tty/serial/sh-sci.c
@@ -428,7 +428,7 @@ static int sci_probe_regmap(struct plat_sci_port *cfg)
 		cfg->regtype = SCIx_HSCIF_REGTYPE;
 		break;
 	default:
-		printk(KERN_ERR "Can't probe register map for given port\n");
+		pr_err("Can't probe register map for given port\n");
 		return -EINVAL;
 	}
 
@@ -2389,8 +2389,7 @@ static inline int sci_probe_earlyprintk(struct platform_device *pdev)
 
 #endif /* CONFIG_SERIAL_SH_SCI_CONSOLE */
 
-static char banner[] __initdata =
-	KERN_INFO "SuperH (H)SCI(F) driver initialized\n";
+static const char banner[] __initconst = "SuperH (H)SCI(F) driver initialized";
 
 static struct uart_driver sci_uart_driver = {
 	.owner		= THIS_MODULE,
@@ -2616,7 +2615,7 @@ static int __init sci_init(void)
 {
 	int ret;
 
-	printk(banner);
+	pr_info("%s\n", banner);
 
 	ret = uart_register_driver(&sci_uart_driver);
 	if (likely(ret == 0)) {
-- 
1.7.9.5

