Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758054Ab3CSJwr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 05:52:47 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:35471 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757998Ab3CSJwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 05:52:22 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqsCANk0SFFbdWObgWdsb2JhbABDwRuEB4FbFg4BARYmKIIlAQUnUhBRVwYTiBiyMZAhjw4Hg0ADll+JbIohOw
X-IPAS-Result: AqsCANk0SFFbdWObgWdsb2JhbABDwRuEB4FbFg4BARYmKIIlAQUnUhBRVwYTiBiyMZAhjw4Hg0ADll+JbIohOw
X-IronPort-AV: E=Sophos;i="4.84,870,1355094000"; 
   d="scan'208";a="18790011"
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Subject: [PATCH 5/9] staging/sb105x: change some printk to corresponding pr_*
Date: Tue, 19 Mar 2013 10:51:26 +0100
Message-Id: <1363686690-27090-6-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363686690-27090-1-git-send-email-siglesias@igalia.com>
References: <1363686690-27090-1-git-send-email-siglesias@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/staging/sb105x/sb_pci_mp.c |   30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/sb105x/sb_pci_mp.c b/drivers/staging/sb105x/sb_pci_mp.c
index 9e30a0c..cb27fb6 100644
--- a/drivers/staging/sb105x/sb_pci_mp.c
+++ b/drivers/staging/sb105x/sb_pci_mp.c
@@ -1,3 +1,5 @@
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include "sb_pci_mp.h"
 #include <linux/module.h>
 #include <linux/parport.h>
@@ -1605,7 +1607,7 @@ static inline void mp_report_port(struct uart_driver *drv, struct sb_uart_port *
 			break;
 	}
 
-	printk( "%s%d at %s (irq = %d) is a %s\n",
+	pr_info( "%s%d at %s (irq = %d) is a %s\n",
 			drv->dev_name, port->line, address, port->irq, mp_type(port));
 
 }
@@ -1698,17 +1700,15 @@ static int mp_register_driver(struct uart_driver *drv)
 
 	drv->state = kmalloc(sizeof(struct sb_uart_state) * drv->nr, GFP_KERNEL);
 	retval = -ENOMEM;
-	if (!drv->state)
-	{
-		printk("SB PCI Error: Kernel memory allocation error!\n");
+	if (!drv->state) {
+		pr_err("SB PCI Error: Kernel memory allocation error!\n");
 		goto out;
 	}
 	memset(drv->state, 0, sizeof(struct sb_uart_state) * drv->nr);
 
 	normal = alloc_tty_driver(drv->nr);
-	if (!normal)
-	{
-		printk("SB PCI Error: tty allocation error!\n");
+	if (!normal) {
+		pr_err("SB PCI Error: tty allocation error!\n");
 		goto out;
 	}
 
@@ -1744,7 +1744,7 @@ for (i = 0; i < drv->nr; i++) {
 	retval = tty_register_driver(normal);
 out:
 	if (retval < 0) {
-		printk("Register tty driver Fail!\n");
+		pr_err("Register tty driver Fail!\n");
 		put_tty_driver(normal);
 		kfree(drv->state);
 	}
@@ -1814,7 +1814,7 @@ static int mp_remove_one_port(struct uart_driver *drv, struct sb_uart_port *port
 	struct sb_uart_state *state = drv->state + port->line;
 
 	if (state->port != port)
-		printk(KERN_ALERT "Removing wrong port: %p != %p\n",
+		pr_err(KERN_ALERT "Removing wrong port: %p != %p\n",
 				state->port, port);
 
 	MP_MUTEX_LOCK(mp_mutex);
@@ -2114,7 +2114,7 @@ static inline void transmit_chars(struct mp_port *mtpt)
 		count = mtpt->port.fifosize;
 	}
 
-	printk("[%d] mdmode: %x\n", mtpt->port.line, mtpt->port.mdmode);
+	pr_info("[%d] mdmode: %x\n", mtpt->port.line, mtpt->port.mdmode);
 	do {
 #if 0
 		/* check multi-drop mode */
@@ -2220,7 +2220,7 @@ static irqreturn_t multi_interrupt(int irq, void *dev_id)
 		lhead = lhead->next;
 		if (lhead == iinfo->head && pass_counter++ > PASS_LIMIT)
 		{
-			printk(KERN_ERR "multi: too much work for "
+			pr_err("multi: too much work for "
 					"irq%d\n", irq);
 			break;
 		}
@@ -2786,7 +2786,7 @@ static void __init multi_init_ports(void)
 				b_ret = sb1053a_get_interface(mtpt, i);
 			} else {
 				b_ret = read_option_register(mtpt,(MP_OPTR_IIR0 + i/8));
-				printk("IIR_RET = %x\n",b_ret);
+				pr_info("IIR_RET = %x\n",b_ret);
 			}
 
 			/* default to RS232 */
@@ -3057,9 +3057,9 @@ static int __init multi_init(void)
 	        		status = pci_enable_device(dev);
 
 				if (status != 0) {
-					printk("Multiport Board Enable Fail !\n\n");
-               				status = -ENXIO;
-                			return status;
+					pr_err("Multiport Board Enable Fail !\n\n");
+					status = -ENXIO;
+					return status;
            			}
 			}
 
-- 
1.7.10.4

