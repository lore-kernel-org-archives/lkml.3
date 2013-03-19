Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758019Ab3CSJw1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 05:52:27 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:64137 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757995Ab3CSJwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 05:52:21 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap8CANk0SFFbdWObgWdsb2JhbABDxSKBWxYOAQEWJiiCJQEFJ1IQUVcGE4gYsjGQIY8OB4NAA5ZflA07
X-IPAS-Result: Ap8CANk0SFFbdWObgWdsb2JhbABDxSKBWxYOAQEWJiiCJQEFJ1IQUVcGE4gYsjGQIY8OB4NAA5ZflA07
X-IronPort-AV: E=Sophos;i="4.84,870,1355094000"; 
   d="scan'208";a="18789994"
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Subject: [PATCH 3/9] staging/sb105x: delete debug printks
Date: Tue, 19 Mar 2013 10:51:24 +0100
Message-Id: <1363686690-27090-4-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363686690-27090-1-git-send-email-siglesias@igalia.com>
References: <1363686690-27090-1-git-send-email-siglesias@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/staging/sb105x/sb_pci_mp.c |   20 --------------------
 1 file changed, 20 deletions(-)

diff --git a/drivers/staging/sb105x/sb_pci_mp.c b/drivers/staging/sb105x/sb_pci_mp.c
index 4c88bfc..7196412 100644
--- a/drivers/staging/sb105x/sb_pci_mp.c
+++ b/drivers/staging/sb105x/sb_pci_mp.c
@@ -1288,26 +1288,20 @@ static void mp_close(struct tty_struct *tty, struct file *filp)
 	struct sb_uart_state *state = tty->driver_data;
 	struct sb_uart_port *port;
 
-	printk("mp_close!\n");
 	if (!state || !state->port)
 		return;
 
 	port = state->port;
-
-	printk("close1 %d\n", __LINE__);
 	MP_STATE_LOCK(state);
 
-	printk("close2 %d\n", __LINE__);
 	if (tty_hung_up_p(filp))
 		goto done;
 
-	printk("close3 %d\n", __LINE__);
 	if ((tty->count == 1) && (state->count != 1)) {
 		printk("mp_close: bad serial port count; tty->count is 1, "
 				"state->count is %d\n", state->count);
 		state->count = 1;
 	}
-	printk("close4 %d\n", __LINE__);
 	if (--state->count < 0) {
 		printk("rs_close: bad serial port count for ttyMP%d: %d\n",
 				port->line, state->count);
@@ -1318,11 +1312,9 @@ static void mp_close(struct tty_struct *tty, struct file *filp)
 
 	tty->closing = 1;
 
-	printk("close5 %d\n", __LINE__);
 	if (state->closing_wait != USF_CLOSING_WAIT_NONE)
 		tty_wait_until_sent(tty, state->closing_wait);
 
-	printk("close6 %d\n", __LINE__);
 	if (state->info->flags & UIF_INITIALIZED) {
 		unsigned long flags;
 		spin_lock_irqsave(&port->lock, flags);
@@ -1330,10 +1322,8 @@ static void mp_close(struct tty_struct *tty, struct file *filp)
 		spin_unlock_irqrestore(&port->lock, flags);
 		mp_wait_until_sent(tty, port->timeout);
 	}
-	printk("close7 %d\n", __LINE__);
 
 	mp_shutdown(state);
-	printk("close8 %d\n", __LINE__);
 	mp_flush_buffer(tty);
 	tty_ldisc_flush(tty);
 	tty->closing = 0;
@@ -1350,13 +1340,11 @@ static void mp_close(struct tty_struct *tty, struct file *filp)
 	{
 		mp_change_pm(state, 3);
 	}
-	printk("close8 %d\n", __LINE__);
 
 	state->info->flags &= ~UIF_NORMAL_ACTIVE;
 	wake_up_interruptible(&state->info->open_wait);
 
 done:
-	printk("close done\n");
 	MP_STATE_UNLOCK(state);
 	module_put(THIS_MODULE);
 }
@@ -1940,7 +1928,6 @@ static void autoconfig(struct mp_port *mtpt, unsigned int probeflags)
 
 	if(mtpt->port.type == PORT_UNKNOWN )
 	{
-printk("unknow2\n");
 		switch (scratch) {
 			case 0:
 			case 1:
@@ -2221,10 +2208,8 @@ static irqreturn_t multi_interrupt(int irq, void *dev_id)
 		mtpt = list_entry(lhead, struct mp_port, list);
 
 		iir = serial_in(mtpt, UART_IIR);
-		printk("intrrupt! port %d, iir 0x%x\n", mtpt->port.line, iir); //wlee
 		if (!(iir & UART_IIR_NO_INT))
 		{
-			printk("interrupt handle\n");
 			spin_lock(&mtpt->port.lock);
 			multi_handle_port(mtpt);
 			spin_unlock(&mtpt->port.lock);
@@ -2238,8 +2223,6 @@ static irqreturn_t multi_interrupt(int irq, void *dev_id)
 		{
 			printk(KERN_ERR "multi: too much work for "
 					"irq%d\n", irq);
-			printk( "multi: too much work for "
-					"irq%d\n", irq);
 			break;
 		}
 	} while (lhead != end);
@@ -2619,7 +2602,6 @@ static void multi_set_termios(struct sb_uart_port *port, struct MP_TERMIOS *term
 
 	if(mtpt->device->device_id == PCI_DEVICE_ID_MP4M) {
 		SendATCommand(mtpt);
-		printk("SendATCommand\n");
 	}
 
 	multi_set_mctrl(&mtpt->port, mtpt->port.mctrl);
@@ -3064,12 +3046,10 @@ static int __init multi_init(void)
         }
 
 
-	printk("MULTI INIT\n");
 	for( i = 0; i < mp_nrpcibrds; i++)
 	{
 
 		while( (dev = pci_get_device(mp_pciboards[i].vendor_id, mp_pciboards[i].device_id, dev) ) ) {
-		printk("FOUND~~~\n");
 //	Cent OS bug fix
 //			if (mp_pciboards[i].device_id & 0x0800)
 			{
-- 
1.7.10.4

