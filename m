Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758039Ab3CSJwn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 05:52:43 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:35471 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757966Ab3CSJwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 05:52:20 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqsCANk0SFFbdWObgWdsb2JhbABDwRuEB4FbFg4BARYmKIIlAQUnUhBRVwYTiBiyMZAhjw4Hg0ADll+JbIohOw
X-IPAS-Result: AqsCANk0SFFbdWObgWdsb2JhbABDwRuEB4FbFg4BARYmKIIlAQUnUhBRVwYTiBiyMZAhjw4Hg0ADll+JbIohOw
X-IronPort-AV: E=Sophos;i="4.84,870,1355094000"; 
   d="scan'208";a="18789987"
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Subject: [PATCH 4/9] staging/sb105x: change some printk to corresponding dev_*
Date: Tue, 19 Mar 2013 10:51:25 +0100
Message-Id: <1363686690-27090-5-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363686690-27090-1-git-send-email-siglesias@igalia.com>
References: <1363686690-27090-1-git-send-email-siglesias@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/staging/sb105x/sb_pci_mp.c |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/sb105x/sb_pci_mp.c b/drivers/staging/sb105x/sb_pci_mp.c
index 7196412..9e30a0c 100644
--- a/drivers/staging/sb105x/sb_pci_mp.c
+++ b/drivers/staging/sb105x/sb_pci_mp.c
@@ -180,7 +180,7 @@ static int sb1054_get_register(struct sb_uart_port * port, int page, int reg)
 	unsigned int tmp = 0;
 
 	if (page <= 0) {
-		printk(" page 0 can not use this fuction\n");
+		dev_err(port->dev, " page 0 can not use this fuction\n");
 		return -1;
 	}
 
@@ -225,7 +225,7 @@ static int sb1054_get_register(struct sb_uart_port * port, int page, int reg)
 		SB105X_PUT_LCR(port,lcr);
 		break;
 	default:
-		printk(" error invalid page number \n");
+		dev_err(port->dev, " error invalid page number \n");
 		return -1;
 	}
 
@@ -239,7 +239,7 @@ static int sb1054_set_register(struct sb_uart_port * port, int page, int reg, in
 	int ret = 0;
 
 	if (page <= 0) {
-		printk(" page 0 can not use this fuction\n");
+		dev_err(port->dev, " page 0 can not use this fuction\n");
 		return -1;
 	}
 
@@ -283,7 +283,7 @@ static int sb1054_set_register(struct sb_uart_port * port, int page, int reg, in
 		ret = 1;
 		break;
 	default:
-		printk(" error invalid page number \n");
+		dev_err(port->dev, " error invalid page number \n");
 		return -1;
 	}
 
@@ -309,7 +309,7 @@ static int set_multidrop_mode(struct sb_uart_port *port, unsigned int mode)
 	sb1054_set_register(port, PAGE_1, SB105XA_MDR, mdr);
 	port->mdmode &= ~0x6;
 	port->mdmode |= mode;
-	printk("[%d] multidrop init: %x\n", port->line, port->mdmode);
+	dev_info(port->dev, "[%d] multidrop init: %x\n", port->line, port->mdmode);
 
 	return 0;
 }
@@ -477,7 +477,6 @@ static void mp_tasklet_action(unsigned long data)
 	struct sb_uart_state *state = (struct sb_uart_state *)data;
 	struct tty_struct *tty;
 
-	printk("tasklet is called!\n");
 	tty = state->info->tty;
 	tty_wakeup(tty);
 }
@@ -890,7 +889,7 @@ check_and_exit:
 		if (((old_flags ^ port->flags) & UPF_SPD_MASK) ||
 				old_custom_divisor != port->custom_divisor) {
 			if (port->flags & UPF_SPD_MASK) {
-				printk(KERN_NOTICE
+				dev_notice(port->dev,
 						"%s sets custom speed on ttyMP%d. This "
 						"is deprecated.\n", current->comm,
 						port->line);
@@ -1298,12 +1297,12 @@ static void mp_close(struct tty_struct *tty, struct file *filp)
 		goto done;
 
 	if ((tty->count == 1) && (state->count != 1)) {
-		printk("mp_close: bad serial port count; tty->count is 1, "
+		dev_err(port->dev, "mp_close: bad serial port count; tty->count is 1, "
 				"state->count is %d\n", state->count);
 		state->count = 1;
 	}
 	if (--state->count < 0) {
-		printk("rs_close: bad serial port count for ttyMP%d: %d\n",
+		dev_err(port->dev, "rs_close: bad serial port count for ttyMP%d: %d\n",
 				port->line, state->count);
 		state->count = 0;
 	}
@@ -2397,7 +2396,7 @@ static int multi_startup(struct sb_uart_port *port)
 
 	if (!(mtpt->port.flags & UPF_BUGGY_UART) &&
 			(serial_inp(mtpt, UART_LSR) == 0xff)) {
-		printk("ttyS%d: LSR safety check engaged!\n", mtpt->port.line);
+		dev_info(port->dev, "ttyS%d: LSR safety check engaged!\n", mtpt->port.line);
 		//return -ENODEV;
 	}
 
-- 
1.7.10.4

