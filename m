Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758273Ab3BGACh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 19:02:37 -0500
Received: from mail.ispras.ru ([83.149.199.43]:39865 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757415Ab3BGACf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 19:02:35 -0500
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>, Jiri Slaby <jslaby@suse.cz>,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: [PATCH 2/2] pcmcia: synclink_cs: cleanup checkpatch warnings
Date: Thu,  7 Feb 2013 01:00:35 +0100
Message-Id: <1360195235-28949-2-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360195235-28949-1-git-send-email-khoroshilov@ispras.ru>
References: <1360195235-28949-1-git-send-email-khoroshilov@ispras.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ERROR: open brace '{' following struct go on the same line
ERROR: space required after that ','
ERROR: space prohibited after that open parenthesis '('
WARNING: please, no spaces at the start of a line
WARNING: please, no space before tabs

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/char/pcmcia/synclink_cs.c |  616 +++++++++++++++++++------------------
 1 file changed, 310 insertions(+), 306 deletions(-)

diff --git a/drivers/char/pcmcia/synclink_cs.c b/drivers/char/pcmcia/synclink_cs.c
index 56e4e94..29f6bec 100644
--- a/drivers/char/pcmcia/synclink_cs.c
+++ b/drivers/char/pcmcia/synclink_cs.c
@@ -102,8 +102,7 @@ static MGSL_PARAMS default_params = {
 	ASYNC_PARITY_NONE		/* unsigned char parity; */
 };
 
-typedef struct
-{
+typedef struct {
 	int count;
 	unsigned char status;
 	char data[1];
@@ -326,10 +325,10 @@ typedef struct _mgslpc_info {
 #define write_reg16(info, reg, val) outw((val), (info)->io_base + (reg))
 
 #define set_reg_bits(info, reg, mask) \
-    write_reg(info, (reg), \
+	write_reg(info, (reg), \
 		 (unsigned char) (read_reg(info, (reg)) | (mask)))
 #define clear_reg_bits(info, reg, mask) \
-    write_reg(info, (reg), \
+	write_reg(info, (reg), \
 		 (unsigned char) (read_reg(info, (reg)) & ~(mask)))
 /*
  * interrupt enable/disable routines
@@ -356,10 +355,10 @@ static void irq_enable(MGSLPC_INFO *info, unsigned char channel, unsigned short
 }
 
 #define port_irq_disable(info, mask) \
-  { info->pim_value |= (mask); write_reg(info, PIM, info->pim_value); }
+	{ info->pim_value |= (mask); write_reg(info, PIM, info->pim_value); }
 
 #define port_irq_enable(info, mask) \
-  { info->pim_value &= ~(mask); write_reg(info, PIM, info->pim_value); }
+	{ info->pim_value &= ~(mask); write_reg(info, PIM, info->pim_value); }
 
 static void rx_start(MGSLPC_INFO *info);
 static void rx_stop(MGSLPC_INFO *info);
@@ -514,56 +513,56 @@ static const struct tty_port_operations mgslpc_port_ops = {
 
 static int mgslpc_probe(struct pcmcia_device *link)
 {
-    MGSLPC_INFO *info;
-    int ret;
-
-    if (debug_level >= DEBUG_LEVEL_INFO)
-	    printk("mgslpc_attach\n");
-
-    info = kzalloc(sizeof(MGSLPC_INFO), GFP_KERNEL);
-    if (!info) {
-	    printk("Error can't allocate device instance data\n");
-	    return -ENOMEM;
-    }
-
-    info->magic = MGSLPC_MAGIC;
-    tty_port_init(&info->port);
-    info->port.ops = &mgslpc_port_ops;
-    INIT_WORK(&info->task, bh_handler);
-    info->max_frame_size = 4096;
-    info->port.close_delay = 5*HZ/10;
-    info->port.closing_wait = 30*HZ;
-    init_waitqueue_head(&info->status_event_wait_q);
-    init_waitqueue_head(&info->event_wait_q);
-    spin_lock_init(&info->lock);
-    spin_lock_init(&info->netlock);
-    memcpy(&info->params,&default_params,sizeof(MGSL_PARAMS));
-    info->idle_mode = HDLC_TXIDLE_FLAGS;
-    info->imra_value = 0xffff;
-    info->imrb_value = 0xffff;
-    info->pim_value = 0xff;
-
-    info->p_dev = link;
-    link->priv = info;
-
-    /* Initialize the struct pcmcia_device structure */
-
-    ret = mgslpc_config(link);
-    if (ret != 0)
-	    goto failed;
-
-    ret = mgslpc_add_device(info);
-    if (ret != 0)
-	    goto failed_release;
-
-    return 0;
+	MGSLPC_INFO *info;
+	int ret;
+
+	if (debug_level >= DEBUG_LEVEL_INFO)
+		printk("mgslpc_attach\n");
+
+	info = kzalloc(sizeof(MGSLPC_INFO), GFP_KERNEL);
+	if (!info) {
+		printk("Error can't allocate device instance data\n");
+		return -ENOMEM;
+	}
+
+	info->magic = MGSLPC_MAGIC;
+	tty_port_init(&info->port);
+	info->port.ops = &mgslpc_port_ops;
+	INIT_WORK(&info->task, bh_handler);
+	info->max_frame_size = 4096;
+	info->port.close_delay = 5*HZ/10;
+	info->port.closing_wait = 30*HZ;
+	init_waitqueue_head(&info->status_event_wait_q);
+	init_waitqueue_head(&info->event_wait_q);
+	spin_lock_init(&info->lock);
+	spin_lock_init(&info->netlock);
+	memcpy(&info->params,&default_params,sizeof(MGSL_PARAMS));
+	info->idle_mode = HDLC_TXIDLE_FLAGS;
+	info->imra_value = 0xffff;
+	info->imrb_value = 0xffff;
+	info->pim_value = 0xff;
+
+	info->p_dev = link;
+	link->priv = info;
+
+	/* Initialize the struct pcmcia_device structure */
+
+	ret = mgslpc_config(link);
+	if (ret != 0)
+		goto failed;
+
+	ret = mgslpc_add_device(info);
+	if (ret != 0)
+		goto failed_release;
+
+	return 0;
 
 failed_release:
-    mgslpc_release((u_long)link);
+	mgslpc_release((u_long)link);
 failed:
-    tty_port_destroy(&info->port);
-    kfree(info);
-    return ret;
+	tty_port_destroy(&info->port);
+	kfree(info);
+	return ret;
 }
 
 /* Card has been inserted.
@@ -576,35 +575,35 @@ static int mgslpc_ioprobe(struct pcmcia_device *p_dev, void *priv_data)
 
 static int mgslpc_config(struct pcmcia_device *link)
 {
-    MGSLPC_INFO *info = link->priv;
-    int ret;
+	MGSLPC_INFO *info = link->priv;
+	int ret;
 
-    if (debug_level >= DEBUG_LEVEL_INFO)
-	    printk("mgslpc_config(0x%p)\n", link);
+	if (debug_level >= DEBUG_LEVEL_INFO)
+		printk("mgslpc_config(0x%p)\n", link);
 
-    link->config_flags |= CONF_ENABLE_IRQ | CONF_AUTO_SET_IO;
+	link->config_flags |= CONF_ENABLE_IRQ | CONF_AUTO_SET_IO;
 
-    ret = pcmcia_loop_config(link, mgslpc_ioprobe, NULL);
-    if (ret != 0)
-	    goto failed;
+	ret = pcmcia_loop_config(link, mgslpc_ioprobe, NULL);
+	if (ret != 0)
+		goto failed;
 
-    link->config_index = 8;
-    link->config_regs = PRESENT_OPTION;
+	link->config_index = 8;
+	link->config_regs = PRESENT_OPTION;
 
-    ret = pcmcia_request_irq(link, mgslpc_isr);
-    if (ret)
-	    goto failed;
-    ret = pcmcia_enable_device(link);
-    if (ret)
-	    goto failed;
+	ret = pcmcia_request_irq(link, mgslpc_isr);
+	if (ret)
+		goto failed;
+	ret = pcmcia_enable_device(link);
+	if (ret)
+		goto failed;
 
-    info->io_base = link->resource[0]->start;
-    info->irq_level = link->irq;
-    return 0;
+	info->io_base = link->resource[0]->start;
+	info->irq_level = link->irq;
+	return 0;
 
 failed:
-    mgslpc_release((u_long)link);
-    return -ENODEV;
+	mgslpc_release((u_long)link);
+	return -ENODEV;
 }
 
 /* Card has been removed.
@@ -710,12 +709,12 @@ static void tx_pause(struct tty_struct *tty)
 	if (mgslpc_paranoia_check(info, tty->name, "tx_pause"))
 		return;
 	if (debug_level >= DEBUG_LEVEL_INFO)
-		printk("tx_pause(%s)\n",info->device_name);
+		printk("tx_pause(%s)\n", info->device_name);
 
-	spin_lock_irqsave(&info->lock,flags);
+	spin_lock_irqsave(&info->lock, flags);
 	if (info->tx_enabled)
-	 	tx_stop(info);
-	spin_unlock_irqrestore(&info->lock,flags);
+		tx_stop(info);
+	spin_unlock_irqrestore(&info->lock, flags);
 }
 
 static void tx_release(struct tty_struct *tty)
@@ -726,12 +725,12 @@ static void tx_release(struct tty_struct *tty)
 	if (mgslpc_paranoia_check(info, tty->name, "tx_release"))
 		return;
 	if (debug_level >= DEBUG_LEVEL_INFO)
-		printk("tx_release(%s)\n",info->device_name);
+		printk("tx_release(%s)\n", info->device_name);
 
-	spin_lock_irqsave(&info->lock,flags);
+	spin_lock_irqsave(&info->lock, flags);
 	if (!info->tx_enabled)
-	 	tx_start(info, tty);
-	spin_unlock_irqrestore(&info->lock,flags);
+		tx_start(info, tty);
+	spin_unlock_irqrestore(&info->lock, flags);
 }
 
 /* Return next bottom half action to perform.
@@ -742,7 +741,7 @@ static int bh_action(MGSLPC_INFO *info)
 	unsigned long flags;
 	int rc = 0;
 
-	spin_lock_irqsave(&info->lock,flags);
+	spin_lock_irqsave(&info->lock, flags);
 
 	if (info->pending_bh & BH_RECEIVE) {
 		info->pending_bh &= ~BH_RECEIVE;
@@ -761,7 +760,7 @@ static int bh_action(MGSLPC_INFO *info)
 		info->bh_requested = false;
 	}
 
-	spin_unlock_irqrestore(&info->lock,flags);
+	spin_unlock_irqrestore(&info->lock, flags);
 
 	return rc;
 }
@@ -776,7 +775,7 @@ static void bh_handler(struct work_struct *work)
 		return;
 
 	if (debug_level >= DEBUG_LEVEL_BH)
-		printk( "%s(%d):bh_handler(%s) entry\n",
+		printk("%s(%d):bh_handler(%s) entry\n",
 			__FILE__,__LINE__,info->device_name);
 
 	info->bh_running = true;
@@ -785,8 +784,8 @@ static void bh_handler(struct work_struct *work)
 	while((action = bh_action(info)) != 0) {
 
 		/* Process work item */
-		if ( debug_level >= DEBUG_LEVEL_BH )
-			printk( "%s(%d):bh_handler() work item action=%d\n",
+		if (debug_level >= DEBUG_LEVEL_BH)
+			printk("%s(%d):bh_handler() work item action=%d\n",
 				__FILE__,__LINE__,action);
 
 		switch (action) {
@@ -809,7 +808,7 @@ static void bh_handler(struct work_struct *work)
 
 	tty_kref_put(tty);
 	if (debug_level >= DEBUG_LEVEL_BH)
-		printk( "%s(%d):bh_handler(%s) exit\n",
+		printk("%s(%d):bh_handler(%s) exit\n",
 			__FILE__,__LINE__,info->device_name);
 }
 
@@ -838,7 +837,7 @@ static void rx_ready_hdlc(MGSLPC_INFO *info, int eom)
 	RXBUF *buf = (RXBUF*)(info->rx_buf + (info->rx_put * info->rx_buf_size));
 
 	if (debug_level >= DEBUG_LEVEL_ISR)
-		printk("%s(%d):rx_ready_hdlc(eom=%d)\n",__FILE__,__LINE__,eom);
+		printk("%s(%d):rx_ready_hdlc(eom=%d)\n", __FILE__, __LINE__, eom);
 
 	if (!info->rx_enabled)
 		return;
@@ -854,7 +853,8 @@ static void rx_ready_hdlc(MGSLPC_INFO *info, int eom)
 
 	if (eom) {
 		/* end of frame, get FIFO count from RBCL register */
-		if (!(fifo_count = (unsigned char)(read_reg(info, CHA+RBCL) & 0x1f)))
+		fifo_count = (unsigned char)(read_reg(info, CHA+RBCL) & 0x1f);
+		if (fifo_count == 0)
 			fifo_count = 32;
 	} else
 		fifo_count = 32;
@@ -898,13 +898,13 @@ static void rx_ready_async(MGSLPC_INFO *info, int tcd, struct tty_struct *tty)
 	unsigned char data, status, flag;
 	int fifo_count;
 	int work = 0;
- 	struct mgsl_icount *icount = &info->icount;
+	struct mgsl_icount *icount = &info->icount;
 
 	if (!tty) {
 		/* tty is not available anymore */
 		issue_command(info, CHA, CMD_RXRESET);
 		if (debug_level >= DEBUG_LEVEL_ISR)
-			printk("%s(%d):rx_ready_async(tty=NULL)\n",__FILE__,__LINE__);
+			printk("%s(%d):rx_ready_async(tty=NULL)\n", __FILE__, __LINE__);
 		return;
 	}
 
@@ -1011,7 +1011,7 @@ static void tx_ready(MGSLPC_INFO *info, struct tty_struct *tty)
 	int c;
 
 	if (debug_level >= DEBUG_LEVEL_ISR)
-		printk("%s(%d):tx_ready(%s)\n", __FILE__,__LINE__,info->device_name);
+		printk("%s(%d):tx_ready(%s)\n", __FILE__, __LINE__, info->device_name);
 
 	if (info->params.mode == MGSL_MODE_HDLC) {
 		if (!info->tx_active)
@@ -1256,7 +1256,7 @@ static irqreturn_t mgslpc_isr(int dummy, void *dev_id)
 	 */
 
 	if (info->pending_bh && !info->bh_running && !info->bh_requested) {
-		if ( debug_level >= DEBUG_LEVEL_ISR )
+		if (debug_level >= DEBUG_LEVEL_ISR)
 			printk("%s(%d):%s queueing bh task.\n",
 				__FILE__,__LINE__,info->device_name);
 		schedule_work(&info->task);
@@ -1280,7 +1280,7 @@ static int startup(MGSLPC_INFO * info, struct tty_struct *tty)
 	int retval = 0;
 
 	if (debug_level >= DEBUG_LEVEL_INFO)
-		printk("%s(%d):startup(%s)\n",__FILE__,__LINE__,info->device_name);
+		printk("%s(%d):startup(%s)\n", __FILE__, __LINE__, info->device_name);
 
 	if (info->port.flags & ASYNC_INITIALIZED)
 		return 0;
@@ -1290,7 +1290,7 @@ static int startup(MGSLPC_INFO * info, struct tty_struct *tty)
 		info->tx_buf = (unsigned char *)get_zeroed_page(GFP_KERNEL);
 		if (!info->tx_buf) {
 			printk(KERN_ERR"%s(%d):%s can't allocate transmit buffer\n",
-				__FILE__,__LINE__,info->device_name);
+				__FILE__, __LINE__, info->device_name);
 			return -ENOMEM;
 		}
 	}
@@ -1305,15 +1305,15 @@ static int startup(MGSLPC_INFO * info, struct tty_struct *tty)
 	retval = claim_resources(info);
 
 	/* perform existence check and diagnostics */
-	if ( !retval )
+	if (!retval)
 		retval = adapter_test(info);
 
-	if ( retval ) {
-  		if (capable(CAP_SYS_ADMIN) && tty)
+	if (retval) {
+		if (capable(CAP_SYS_ADMIN) && tty)
 			set_bit(TTY_IO_ERROR, &tty->flags);
 		release_resources(info);
-  		return retval;
-  	}
+		return retval;
+	}
 
 	/* program hardware for current parameters */
 	mgslpc_change_params(info, tty);
@@ -1337,7 +1337,7 @@ static void shutdown(MGSLPC_INFO * info, struct tty_struct *tty)
 
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("%s(%d):mgslpc_shutdown(%s)\n",
-			 __FILE__,__LINE__, info->device_name );
+			 __FILE__, __LINE__, info->device_name);
 
 	/* clear status wait queue because status changes */
 	/* can't happen after shutting down the hardware */
@@ -1351,7 +1351,7 @@ static void shutdown(MGSLPC_INFO * info, struct tty_struct *tty)
 		info->tx_buf = NULL;
 	}
 
-	spin_lock_irqsave(&info->lock,flags);
+	spin_lock_irqsave(&info->lock, flags);
 
 	rx_stop(info);
 	tx_stop(info);
@@ -1359,12 +1359,12 @@ static void shutdown(MGSLPC_INFO * info, struct tty_struct *tty)
 	/* TODO:disable interrupts instead of reset to preserve signal states */
 	reset_device(info);
 
- 	if (!tty || tty->termios.c_cflag & HUPCL) {
- 		info->serial_signals &= ~(SerialSignal_DTR + SerialSignal_RTS);
+	if (!tty || tty->termios.c_cflag & HUPCL) {
+		info->serial_signals &= ~(SerialSignal_DTR + SerialSignal_RTS);
 		set_signals(info);
 	}
 
-	spin_unlock_irqrestore(&info->lock,flags);
+	spin_unlock_irqrestore(&info->lock, flags);
 
 	release_resources(info);
 
@@ -1378,7 +1378,7 @@ static void mgslpc_program_hw(MGSLPC_INFO *info, struct tty_struct *tty)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&info->lock,flags);
+	spin_lock_irqsave(&info->lock, flags);
 
 	rx_stop(info);
 	tx_stop(info);
@@ -1403,7 +1403,7 @@ static void mgslpc_program_hw(MGSLPC_INFO *info, struct tty_struct *tty)
 	if (info->netcount || (tty && (tty->termios.c_cflag & CREAD)))
 		rx_start(info);
 
-	spin_unlock_irqrestore(&info->lock,flags);
+	spin_unlock_irqrestore(&info->lock, flags);
 }
 
 /* Reconfigure adapter based on new parameters
@@ -1418,13 +1418,13 @@ static void mgslpc_change_params(MGSLPC_INFO *info, struct tty_struct *tty)
 
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("%s(%d):mgslpc_change_params(%s)\n",
-			 __FILE__,__LINE__, info->device_name );
+			 __FILE__, __LINE__, info->device_name);
 
 	cflag = tty->termios.c_cflag;
 
 	/* if B0 rate (hangup) specified then negate DTR and RTS */
 	/* otherwise assert DTR and RTS */
- 	if (cflag & CBAUD)
+	if (cflag & CBAUD)
 		info->serial_signals |= SerialSignal_RTS + SerialSignal_DTR;
 	else
 		info->serial_signals &= ~(SerialSignal_RTS + SerialSignal_DTR);
@@ -1470,7 +1470,7 @@ static void mgslpc_change_params(MGSLPC_INFO *info, struct tty_struct *tty)
 		info->params.data_rate = tty_get_baud_rate(tty);
 	}
 
-	if ( info->params.data_rate ) {
+	if (info->params.data_rate) {
 		info->timeout = (32*HZ*bits_per_char) /
 				info->params.data_rate;
 	}
@@ -1505,8 +1505,8 @@ static int mgslpc_put_char(struct tty_struct *tty, unsigned char ch)
 	unsigned long flags;
 
 	if (debug_level >= DEBUG_LEVEL_INFO) {
-		printk( "%s(%d):mgslpc_put_char(%d) on %s\n",
-			__FILE__,__LINE__,ch,info->device_name);
+		printk("%s(%d):mgslpc_put_char(%d) on %s\n",
+			__FILE__, __LINE__, ch, info->device_name);
 	}
 
 	if (mgslpc_paranoia_check(info, tty->name, "mgslpc_put_char"))
@@ -1515,7 +1515,7 @@ static int mgslpc_put_char(struct tty_struct *tty, unsigned char ch)
 	if (!info->tx_buf)
 		return 0;
 
-	spin_lock_irqsave(&info->lock,flags);
+	spin_lock_irqsave(&info->lock, flags);
 
 	if (info->params.mode == MGSL_MODE_ASYNC || !info->tx_active) {
 		if (info->tx_count < TXBUFSIZE - 1) {
@@ -1525,7 +1525,7 @@ static int mgslpc_put_char(struct tty_struct *tty, unsigned char ch)
 		}
 	}
 
-	spin_unlock_irqrestore(&info->lock,flags);
+	spin_unlock_irqrestore(&info->lock, flags);
 	return 1;
 }
 
@@ -1538,8 +1538,8 @@ static void mgslpc_flush_chars(struct tty_struct *tty)
 	unsigned long flags;
 
 	if (debug_level >= DEBUG_LEVEL_INFO)
-		printk( "%s(%d):mgslpc_flush_chars() entry on %s tx_count=%d\n",
-			__FILE__,__LINE__,info->device_name,info->tx_count);
+		printk("%s(%d):mgslpc_flush_chars() entry on %s tx_count=%d\n",
+			__FILE__, __LINE__, info->device_name, info->tx_count);
 
 	if (mgslpc_paranoia_check(info, tty->name, "mgslpc_flush_chars"))
 		return;
@@ -1549,13 +1549,13 @@ static void mgslpc_flush_chars(struct tty_struct *tty)
 		return;
 
 	if (debug_level >= DEBUG_LEVEL_INFO)
-		printk( "%s(%d):mgslpc_flush_chars() entry on %s starting transmitter\n",
-			__FILE__,__LINE__,info->device_name);
+		printk("%s(%d):mgslpc_flush_chars() entry on %s starting transmitter\n",
+			__FILE__, __LINE__, info->device_name);
 
-	spin_lock_irqsave(&info->lock,flags);
+	spin_lock_irqsave(&info->lock, flags);
 	if (!info->tx_active)
-	 	tx_start(info, tty);
-	spin_unlock_irqrestore(&info->lock,flags);
+		tx_start(info, tty);
+	spin_unlock_irqrestore(&info->lock, flags);
 }
 
 /* Send a block of data
@@ -1576,8 +1576,8 @@ static int mgslpc_write(struct tty_struct * tty,
 	unsigned long flags;
 
 	if (debug_level >= DEBUG_LEVEL_INFO)
-		printk( "%s(%d):mgslpc_write(%s) count=%d\n",
-			__FILE__,__LINE__,info->device_name,count);
+		printk("%s(%d):mgslpc_write(%s) count=%d\n",
+			__FILE__, __LINE__, info->device_name, count);
 
 	if (mgslpc_paranoia_check(info, tty->name, "mgslpc_write") ||
 		!info->tx_buf)
@@ -1603,26 +1603,26 @@ static int mgslpc_write(struct tty_struct * tty,
 
 		memcpy(info->tx_buf + info->tx_put, buf, c);
 
-		spin_lock_irqsave(&info->lock,flags);
+		spin_lock_irqsave(&info->lock, flags);
 		info->tx_put = (info->tx_put + c) & (TXBUFSIZE-1);
 		info->tx_count += c;
-		spin_unlock_irqrestore(&info->lock,flags);
+		spin_unlock_irqrestore(&info->lock, flags);
 
 		buf += c;
 		count -= c;
 		ret += c;
 	}
 start:
- 	if (info->tx_count && !tty->stopped && !tty->hw_stopped) {
-		spin_lock_irqsave(&info->lock,flags);
+	if (info->tx_count && !tty->stopped && !tty->hw_stopped) {
+		spin_lock_irqsave(&info->lock, flags);
 		if (!info->tx_active)
-		 	tx_start(info, tty);
-		spin_unlock_irqrestore(&info->lock,flags);
- 	}
+			tx_start(info, tty);
+		spin_unlock_irqrestore(&info->lock, flags);
+	}
 cleanup:
 	if (debug_level >= DEBUG_LEVEL_INFO)
-		printk( "%s(%d):mgslpc_write(%s) returning=%d\n",
-			__FILE__,__LINE__,info->device_name,ret);
+		printk("%s(%d):mgslpc_write(%s) returning=%d\n",
+			__FILE__, __LINE__, info->device_name, ret);
 	return ret;
 }
 
@@ -1650,7 +1650,7 @@ static int mgslpc_write_room(struct tty_struct *tty)
 
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("%s(%d):mgslpc_write_room(%s)=%d\n",
-			 __FILE__,__LINE__, info->device_name, ret);
+			 __FILE__, __LINE__, info->device_name, ret);
 	return ret;
 }
 
@@ -1663,7 +1663,7 @@ static int mgslpc_chars_in_buffer(struct tty_struct *tty)
 
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("%s(%d):mgslpc_chars_in_buffer(%s)\n",
-			 __FILE__,__LINE__, info->device_name );
+			 __FILE__, __LINE__, info->device_name);
 
 	if (mgslpc_paranoia_check(info, tty->name, "mgslpc_chars_in_buffer"))
 		return 0;
@@ -1675,7 +1675,7 @@ static int mgslpc_chars_in_buffer(struct tty_struct *tty)
 
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("%s(%d):mgslpc_chars_in_buffer(%s)=%d\n",
-			 __FILE__,__LINE__, info->device_name, rc);
+			 __FILE__, __LINE__, info->device_name, rc);
 
 	return rc;
 }
@@ -1689,15 +1689,15 @@ static void mgslpc_flush_buffer(struct tty_struct *tty)
 
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("%s(%d):mgslpc_flush_buffer(%s) entry\n",
-			 __FILE__,__LINE__, info->device_name );
+			 __FILE__, __LINE__, info->device_name);
 
 	if (mgslpc_paranoia_check(info, tty->name, "mgslpc_flush_buffer"))
 		return;
 
-	spin_lock_irqsave(&info->lock,flags);
+	spin_lock_irqsave(&info->lock, flags);
 	info->tx_count = info->tx_put = info->tx_get = 0;
 	del_timer(&info->tx_timer);
-	spin_unlock_irqrestore(&info->lock,flags);
+	spin_unlock_irqrestore(&info->lock, flags);
 
 	wake_up_interruptible(&tty->write_wait);
 	tty_wakeup(tty);
@@ -1712,17 +1712,17 @@ static void mgslpc_send_xchar(struct tty_struct *tty, char ch)
 
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("%s(%d):mgslpc_send_xchar(%s,%d)\n",
-			 __FILE__,__LINE__, info->device_name, ch );
+			 __FILE__, __LINE__, info->device_name, ch);
 
 	if (mgslpc_paranoia_check(info, tty->name, "mgslpc_send_xchar"))
 		return;
 
 	info->x_char = ch;
 	if (ch) {
-		spin_lock_irqsave(&info->lock,flags);
+		spin_lock_irqsave(&info->lock, flags);
 		if (!info->tx_enabled)
-		 	tx_start(info, tty);
-		spin_unlock_irqrestore(&info->lock,flags);
+			tx_start(info, tty);
+		spin_unlock_irqrestore(&info->lock, flags);
 	}
 }
 
@@ -1735,7 +1735,7 @@ static void mgslpc_throttle(struct tty_struct * tty)
 
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("%s(%d):mgslpc_throttle(%s) entry\n",
-			 __FILE__,__LINE__, info->device_name );
+			 __FILE__, __LINE__, info->device_name);
 
 	if (mgslpc_paranoia_check(info, tty->name, "mgslpc_throttle"))
 		return;
@@ -1743,11 +1743,11 @@ static void mgslpc_throttle(struct tty_struct * tty)
 	if (I_IXOFF(tty))
 		mgslpc_send_xchar(tty, STOP_CHAR(tty));
 
- 	if (tty->termios.c_cflag & CRTSCTS) {
-		spin_lock_irqsave(&info->lock,flags);
+	if (tty->termios.c_cflag & CRTSCTS) {
+		spin_lock_irqsave(&info->lock, flags);
 		info->serial_signals &= ~SerialSignal_RTS;
-	 	set_signals(info);
-		spin_unlock_irqrestore(&info->lock,flags);
+		set_signals(info);
+		spin_unlock_irqrestore(&info->lock, flags);
 	}
 }
 
@@ -1760,7 +1760,7 @@ static void mgslpc_unthrottle(struct tty_struct * tty)
 
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("%s(%d):mgslpc_unthrottle(%s) entry\n",
-			 __FILE__,__LINE__, info->device_name );
+			 __FILE__, __LINE__, info->device_name);
 
 	if (mgslpc_paranoia_check(info, tty->name, "mgslpc_unthrottle"))
 		return;
@@ -1772,11 +1772,11 @@ static void mgslpc_unthrottle(struct tty_struct * tty)
 			mgslpc_send_xchar(tty, START_CHAR(tty));
 	}
 
- 	if (tty->termios.c_cflag & CRTSCTS) {
-		spin_lock_irqsave(&info->lock,flags);
+	if (tty->termios.c_cflag & CRTSCTS) {
+		spin_lock_irqsave(&info->lock, flags);
 		info->serial_signals |= SerialSignal_RTS;
-	 	set_signals(info);
-		spin_unlock_irqrestore(&info->lock,flags);
+		set_signals(info);
+		spin_unlock_irqrestore(&info->lock, flags);
 	}
 }
 
@@ -1814,33 +1814,33 @@ static int get_params(MGSLPC_INFO * info, MGSL_PARAMS __user *user_params)
  *
  * Arguments:
  *
- * 	info		pointer to device instance data
- * 	new_params	user buffer containing new serial params
+ *	info		pointer to device instance data
+ *	new_params	user buffer containing new serial params
  *
  * Returns:	0 if success, otherwise error code
  */
 static int set_params(MGSLPC_INFO * info, MGSL_PARAMS __user *new_params, struct tty_struct *tty)
 {
- 	unsigned long flags;
+	unsigned long flags;
 	MGSL_PARAMS tmp_params;
 	int err;
 
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("%s(%d):set_params %s\n", __FILE__,__LINE__,
-			info->device_name );
+			info->device_name);
 	COPY_FROM_USER(err,&tmp_params, new_params, sizeof(MGSL_PARAMS));
 	if (err) {
-		if ( debug_level >= DEBUG_LEVEL_INFO )
-			printk( "%s(%d):set_params(%s) user buffer copy failed\n",
-				__FILE__,__LINE__,info->device_name);
+		if (debug_level >= DEBUG_LEVEL_INFO)
+			printk("%s(%d):set_params(%s) user buffer copy failed\n",
+				__FILE__, __LINE__, info->device_name);
 		return -EFAULT;
 	}
 
-	spin_lock_irqsave(&info->lock,flags);
+	spin_lock_irqsave(&info->lock, flags);
 	memcpy(&info->params,&tmp_params,sizeof(MGSL_PARAMS));
-	spin_unlock_irqrestore(&info->lock,flags);
+	spin_unlock_irqrestore(&info->lock, flags);
 
- 	mgslpc_change_params(info, tty);
+	mgslpc_change_params(info, tty);
 
 	return 0;
 }
@@ -1858,13 +1858,13 @@ static int get_txidle(MGSLPC_INFO * info, int __user *idle_mode)
 
 static int set_txidle(MGSLPC_INFO * info, int idle_mode)
 {
- 	unsigned long flags;
+	unsigned long flags;
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("set_txidle(%s,%d)\n", info->device_name, idle_mode);
-	spin_lock_irqsave(&info->lock,flags);
+	spin_lock_irqsave(&info->lock, flags);
 	info->idle_mode = idle_mode;
 	tx_set_idle(info);
-	spin_unlock_irqrestore(&info->lock,flags);
+	spin_unlock_irqrestore(&info->lock, flags);
 	return 0;
 }
 
@@ -1881,11 +1881,11 @@ static int get_interface(MGSLPC_INFO * info, int __user *if_mode)
 
 static int set_interface(MGSLPC_INFO * info, int if_mode)
 {
- 	unsigned long flags;
+	unsigned long flags;
 	unsigned char val;
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("set_interface(%s,%d)\n", info->device_name, if_mode);
-	spin_lock_irqsave(&info->lock,flags);
+	spin_lock_irqsave(&info->lock, flags);
 	info->if_mode = if_mode;
 
 	val = read_reg(info, PVR) & 0x0f;
@@ -1897,18 +1897,18 @@ static int set_interface(MGSLPC_INFO * info, int if_mode)
 	}
 	write_reg(info, PVR, val);
 
-	spin_unlock_irqrestore(&info->lock,flags);
+	spin_unlock_irqrestore(&info->lock, flags);
 	return 0;
 }
 
 static int set_txenable(MGSLPC_INFO * info, int enable, struct tty_struct *tty)
 {
- 	unsigned long flags;
+	unsigned long flags;
 
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("set_txenable(%s,%d)\n", info->device_name, enable);
 
-	spin_lock_irqsave(&info->lock,flags);
+	spin_lock_irqsave(&info->lock, flags);
 	if (enable) {
 		if (!info->tx_enabled)
 			tx_start(info, tty);
@@ -1916,18 +1916,18 @@ static int set_txenable(MGSLPC_INFO * info, int enable, struct tty_struct *tty)
 		if (info->tx_enabled)
 			tx_stop(info);
 	}
-	spin_unlock_irqrestore(&info->lock,flags);
+	spin_unlock_irqrestore(&info->lock, flags);
 	return 0;
 }
 
 static int tx_abort(MGSLPC_INFO * info)
 {
- 	unsigned long flags;
+	unsigned long flags;
 
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("tx_abort(%s)\n", info->device_name);
 
-	spin_lock_irqsave(&info->lock,flags);
+	spin_lock_irqsave(&info->lock, flags);
 	if (info->tx_active && info->tx_count &&
 	    info->params.mode == MGSL_MODE_HDLC) {
 		/* clear data count so FIFO is not filled on next IRQ.
@@ -1936,18 +1936,18 @@ static int tx_abort(MGSLPC_INFO * info)
 		info->tx_count = info->tx_put = info->tx_get = 0;
 		info->tx_aborting = true;
 	}
-	spin_unlock_irqrestore(&info->lock,flags);
+	spin_unlock_irqrestore(&info->lock, flags);
 	return 0;
 }
 
 static int set_rxenable(MGSLPC_INFO * info, int enable)
 {
- 	unsigned long flags;
+	unsigned long flags;
 
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("set_rxenable(%s,%d)\n", info->device_name, enable);
 
-	spin_lock_irqsave(&info->lock,flags);
+	spin_lock_irqsave(&info->lock, flags);
 	if (enable) {
 		if (!info->rx_enabled)
 			rx_start(info);
@@ -1955,21 +1955,21 @@ static int set_rxenable(MGSLPC_INFO * info, int enable)
 		if (info->rx_enabled)
 			rx_stop(info);
 	}
-	spin_unlock_irqrestore(&info->lock,flags);
+	spin_unlock_irqrestore(&info->lock, flags);
 	return 0;
 }
 
 /* wait for specified event to occur
  *
- * Arguments:	 	info	pointer to device instance data
- * 			mask	pointer to bitmask of events to wait for
- * Return Value:	0 	if successful and bit mask updated with
+ * Arguments:		info	pointer to device instance data
+ *			mask	pointer to bitmask of events to wait for
+ * Return Value:	0	if successful and bit mask updated with
  *				of events triggerred,
- * 			otherwise error code
+ *			otherwise error code
  */
 static int wait_events(MGSLPC_INFO * info, int __user *mask_ptr)
 {
- 	unsigned long flags;
+	unsigned long flags;
 	int s;
 	int rc=0;
 	struct mgsl_icount cprev, cnow;
@@ -1985,18 +1985,18 @@ static int wait_events(MGSLPC_INFO * info, int __user *mask_ptr)
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("wait_events(%s,%d)\n", info->device_name, mask);
 
-	spin_lock_irqsave(&info->lock,flags);
+	spin_lock_irqsave(&info->lock, flags);
 
 	/* return immediately if state matches requested events */
 	get_signals(info);
 	s = info->serial_signals;
 	events = mask &
 		( ((s & SerialSignal_DSR) ? MgslEvent_DsrActive:MgslEvent_DsrInactive) +
- 		  ((s & SerialSignal_DCD) ? MgslEvent_DcdActive:MgslEvent_DcdInactive) +
+		  ((s & SerialSignal_DCD) ? MgslEvent_DcdActive:MgslEvent_DcdInactive) +
 		  ((s & SerialSignal_CTS) ? MgslEvent_CtsActive:MgslEvent_CtsInactive) +
 		  ((s & SerialSignal_RI)  ? MgslEvent_RiActive :MgslEvent_RiInactive) );
 	if (events) {
-		spin_unlock_irqrestore(&info->lock,flags);
+		spin_unlock_irqrestore(&info->lock, flags);
 		goto exit;
 	}
 
@@ -2011,7 +2011,7 @@ static int wait_events(MGSLPC_INFO * info, int __user *mask_ptr)
 	set_current_state(TASK_INTERRUPTIBLE);
 	add_wait_queue(&info->event_wait_q, &wait);
 
-	spin_unlock_irqrestore(&info->lock,flags);
+	spin_unlock_irqrestore(&info->lock, flags);
 
 
 	for(;;) {
@@ -2022,11 +2022,11 @@ static int wait_events(MGSLPC_INFO * info, int __user *mask_ptr)
 		}
 
 		/* get current irq counts */
-		spin_lock_irqsave(&info->lock,flags);
+		spin_lock_irqsave(&info->lock, flags);
 		cnow = info->icount;
 		newsigs = info->input_signal_events;
 		set_current_state(TASK_INTERRUPTIBLE);
-		spin_unlock_irqrestore(&info->lock,flags);
+		spin_unlock_irqrestore(&info->lock, flags);
 
 		/* if no change, wait aborted for some reason */
 		if (newsigs.dsr_up   == oldsigs.dsr_up   &&
@@ -2065,10 +2065,10 @@ static int wait_events(MGSLPC_INFO * info, int __user *mask_ptr)
 	set_current_state(TASK_RUNNING);
 
 	if (mask & MgslEvent_ExitHuntMode) {
-		spin_lock_irqsave(&info->lock,flags);
+		spin_lock_irqsave(&info->lock, flags);
 		if (!waitqueue_active(&info->event_wait_q))
 			irq_disable(info, CHA, IRQ_EXITHUNT);
-		spin_unlock_irqrestore(&info->lock,flags);
+		spin_unlock_irqrestore(&info->lock, flags);
 	}
 exit:
 	if (rc == 0)
@@ -2078,17 +2078,17 @@ exit:
 
 static int modem_input_wait(MGSLPC_INFO *info,int arg)
 {
- 	unsigned long flags;
+	unsigned long flags;
 	int rc;
 	struct mgsl_icount cprev, cnow;
 	DECLARE_WAITQUEUE(wait, current);
 
 	/* save current irq counts */
-	spin_lock_irqsave(&info->lock,flags);
+	spin_lock_irqsave(&info->lock, flags);
 	cprev = info->icount;
 	add_wait_queue(&info->status_event_wait_q, &wait);
 	set_current_state(TASK_INTERRUPTIBLE);
-	spin_unlock_irqrestore(&info->lock,flags);
+	spin_unlock_irqrestore(&info->lock, flags);
 
 	for(;;) {
 		schedule();
@@ -2098,10 +2098,10 @@ static int modem_input_wait(MGSLPC_INFO *info,int arg)
 		}
 
 		/* get new irq counts */
-		spin_lock_irqsave(&info->lock,flags);
+		spin_lock_irqsave(&info->lock, flags);
 		cnow = info->icount;
 		set_current_state(TASK_INTERRUPTIBLE);
-		spin_unlock_irqrestore(&info->lock,flags);
+		spin_unlock_irqrestore(&info->lock, flags);
 
 		/* if no change, wait aborted for some reason */
 		if (cnow.rng == cprev.rng && cnow.dsr == cprev.dsr &&
@@ -2132,11 +2132,11 @@ static int tiocmget(struct tty_struct *tty)
 {
 	MGSLPC_INFO *info = (MGSLPC_INFO *)tty->driver_data;
 	unsigned int result;
- 	unsigned long flags;
+	unsigned long flags;
 
-	spin_lock_irqsave(&info->lock,flags);
- 	get_signals(info);
-	spin_unlock_irqrestore(&info->lock,flags);
+	spin_lock_irqsave(&info->lock, flags);
+	get_signals(info);
+	spin_unlock_irqrestore(&info->lock, flags);
 
 	result = ((info->serial_signals & SerialSignal_RTS) ? TIOCM_RTS:0) +
 		((info->serial_signals & SerialSignal_DTR) ? TIOCM_DTR:0) +
@@ -2147,7 +2147,7 @@ static int tiocmget(struct tty_struct *tty)
 
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("%s(%d):%s tiocmget() value=%08X\n",
-			 __FILE__,__LINE__, info->device_name, result );
+			 __FILE__, __LINE__, info->device_name, result);
 	return result;
 }
 
@@ -2157,11 +2157,11 @@ static int tiocmset(struct tty_struct *tty,
 		    unsigned int set, unsigned int clear)
 {
 	MGSLPC_INFO *info = (MGSLPC_INFO *)tty->driver_data;
- 	unsigned long flags;
+	unsigned long flags;
 
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("%s(%d):%s tiocmset(%x,%x)\n",
-			__FILE__,__LINE__,info->device_name, set, clear);
+			__FILE__, __LINE__, info->device_name, set, clear);
 
 	if (set & TIOCM_RTS)
 		info->serial_signals |= SerialSignal_RTS;
@@ -2172,9 +2172,9 @@ static int tiocmset(struct tty_struct *tty,
 	if (clear & TIOCM_DTR)
 		info->serial_signals &= ~SerialSignal_DTR;
 
-	spin_lock_irqsave(&info->lock,flags);
- 	set_signals(info);
-	spin_unlock_irqrestore(&info->lock,flags);
+	spin_lock_irqsave(&info->lock, flags);
+	set_signals(info);
+	spin_unlock_irqrestore(&info->lock, flags);
 
 	return 0;
 }
@@ -2191,17 +2191,17 @@ static int mgslpc_break(struct tty_struct *tty, int break_state)
 
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("%s(%d):mgslpc_break(%s,%d)\n",
-			 __FILE__,__LINE__, info->device_name, break_state);
+			 __FILE__, __LINE__, info->device_name, break_state);
 
 	if (mgslpc_paranoia_check(info, tty->name, "mgslpc_break"))
 		return -EINVAL;
 
-	spin_lock_irqsave(&info->lock,flags);
- 	if (break_state == -1)
+	spin_lock_irqsave(&info->lock, flags);
+	if (break_state == -1)
 		set_reg_bits(info, CHA+DAFO, BIT6);
 	else
 		clear_reg_bits(info, CHA+DAFO, BIT6);
-	spin_unlock_irqrestore(&info->lock,flags);
+	spin_unlock_irqrestore(&info->lock, flags);
 	return 0;
 }
 
@@ -2212,9 +2212,9 @@ static int mgslpc_get_icount(struct tty_struct *tty,
 	struct mgsl_icount cnow;	/* kernel counter temps */
 	unsigned long flags;
 
-	spin_lock_irqsave(&info->lock,flags);
+	spin_lock_irqsave(&info->lock, flags);
 	cnow = info->icount;
-	spin_unlock_irqrestore(&info->lock,flags);
+	spin_unlock_irqrestore(&info->lock, flags);
 
 	icount->cts = cnow.cts;
 	icount->dsr = cnow.dsr;
@@ -2235,9 +2235,9 @@ static int mgslpc_get_icount(struct tty_struct *tty,
  *
  * Arguments:
  *
- * 	tty	pointer to tty instance data
- * 	cmd	IOCTL command code
- * 	arg	command argument/context
+ *	tty	pointer to tty instance data
+ *	cmd	IOCTL command code
+ *	arg	command argument/context
  *
  * Return Value:	0 if success, otherwise error code
  */
@@ -2248,8 +2248,8 @@ static int mgslpc_ioctl(struct tty_struct *tty,
 	void __user *argp = (void __user *)arg;
 
 	if (debug_level >= DEBUG_LEVEL_INFO)
-		printk("%s(%d):mgslpc_ioctl %s cmd=%08X\n", __FILE__,__LINE__,
-			info->device_name, cmd );
+		printk("%s(%d):mgslpc_ioctl %s cmd=%08X\n", __FILE__, __LINE__,
+			info->device_name, cmd);
 
 	if (mgslpc_paranoia_check(info, tty->name, "mgslpc_ioctl"))
 		return -ENODEV;
@@ -2295,8 +2295,8 @@ static int mgslpc_ioctl(struct tty_struct *tty,
  *
  * Arguments:
  *
- * 	tty		pointer to tty structure
- * 	termios		pointer to buffer to hold returned old termios
+ *	tty		pointer to tty structure
+ *	termios		pointer to buffer to hold returned old termios
  */
 static void mgslpc_set_termios(struct tty_struct *tty, struct ktermios *old_termios)
 {
@@ -2304,8 +2304,8 @@ static void mgslpc_set_termios(struct tty_struct *tty, struct ktermios *old_term
 	unsigned long flags;
 
 	if (debug_level >= DEBUG_LEVEL_INFO)
-		printk("%s(%d):mgslpc_set_termios %s\n", __FILE__,__LINE__,
-			tty->driver->name );
+		printk("%s(%d):mgslpc_set_termios %s\n", __FILE__, __LINE__,
+			tty->driver->name);
 
 	/* just return if nothing has changed */
 	if ((tty->termios.c_cflag == old_termios->c_cflag)
@@ -2319,22 +2319,22 @@ static void mgslpc_set_termios(struct tty_struct *tty, struct ktermios *old_term
 	if (old_termios->c_cflag & CBAUD &&
 	    !(tty->termios.c_cflag & CBAUD)) {
 		info->serial_signals &= ~(SerialSignal_RTS + SerialSignal_DTR);
-		spin_lock_irqsave(&info->lock,flags);
-	 	set_signals(info);
-		spin_unlock_irqrestore(&info->lock,flags);
+		spin_lock_irqsave(&info->lock, flags);
+		set_signals(info);
+		spin_unlock_irqrestore(&info->lock, flags);
 	}
 
 	/* Handle transition away from B0 status */
 	if (!(old_termios->c_cflag & CBAUD) &&
 	    tty->termios.c_cflag & CBAUD) {
 		info->serial_signals |= SerialSignal_DTR;
- 		if (!(tty->termios.c_cflag & CRTSCTS) ||
- 		    !test_bit(TTY_THROTTLED, &tty->flags)) {
+		if (!(tty->termios.c_cflag & CRTSCTS) ||
+		    !test_bit(TTY_THROTTLED, &tty->flags)) {
 			info->serial_signals |= SerialSignal_RTS;
- 		}
-		spin_lock_irqsave(&info->lock,flags);
-	 	set_signals(info);
-		spin_unlock_irqrestore(&info->lock,flags);
+		}
+		spin_lock_irqsave(&info->lock, flags);
+		set_signals(info);
+		spin_unlock_irqrestore(&info->lock, flags);
 	}
 
 	/* Handle turning off CRTSCTS */
@@ -2355,15 +2355,15 @@ static void mgslpc_close(struct tty_struct *tty, struct file * filp)
 
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("%s(%d):mgslpc_close(%s) entry, count=%d\n",
-			 __FILE__,__LINE__, info->device_name, port->count);
+			 __FILE__, __LINE__, info->device_name, port->count);
 
 	WARN_ON(!port->count);
 
 	if (tty_port_close_start(port, tty, filp) == 0)
 		goto cleanup;
 
- 	if (port->flags & ASYNC_INITIALIZED)
- 		mgslpc_wait_until_sent(tty, info->timeout);
+	if (port->flags & ASYNC_INITIALIZED)
+		mgslpc_wait_until_sent(tty, info->timeout);
 
 	mgslpc_flush_buffer(tty);
 
@@ -2374,7 +2374,7 @@ static void mgslpc_close(struct tty_struct *tty, struct file * filp)
 	tty_port_tty_set(port, NULL);
 cleanup:
 	if (debug_level >= DEBUG_LEVEL_INFO)
-		printk("%s(%d):mgslpc_close(%s) exit, count=%d\n", __FILE__,__LINE__,
+		printk("%s(%d):mgslpc_close(%s) exit, count=%d\n", __FILE__, __LINE__,
 			tty->driver->name, port->count);
 }
 
@@ -2385,12 +2385,12 @@ static void mgslpc_wait_until_sent(struct tty_struct *tty, int timeout)
 	MGSLPC_INFO * info = (MGSLPC_INFO *)tty->driver_data;
 	unsigned long orig_jiffies, char_time;
 
-	if (!info )
+	if (!info)
 		return;
 
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("%s(%d):mgslpc_wait_until_sent(%s) entry\n",
-			 __FILE__,__LINE__, info->device_name );
+			 __FILE__, __LINE__, info->device_name);
 
 	if (mgslpc_paranoia_check(info, tty->name, "mgslpc_wait_until_sent"))
 		return;
@@ -2406,8 +2406,8 @@ static void mgslpc_wait_until_sent(struct tty_struct *tty, int timeout)
 	 * Note: use tight timings here to satisfy the NIST-PCTS.
 	 */
 
-	if ( info->params.data_rate ) {
-	       	char_time = info->timeout/(32 * 5);
+	if (info->params.data_rate) {
+	     	char_time = info->timeout/(32 * 5);
 		if (!char_time)
 			char_time++;
 	} else
@@ -2438,7 +2438,7 @@ static void mgslpc_wait_until_sent(struct tty_struct *tty, int timeout)
 exit:
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("%s(%d):mgslpc_wait_until_sent(%s) exit\n",
-			 __FILE__,__LINE__, info->device_name );
+			 __FILE__, __LINE__, info->device_name);
 }
 
 /* Called by tty_hangup() when a hangup is signaled.
@@ -2450,7 +2450,7 @@ static void mgslpc_hangup(struct tty_struct *tty)
 
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("%s(%d):mgslpc_hangup(%s)\n",
-			 __FILE__,__LINE__, info->device_name );
+			 __FILE__, __LINE__, info->device_name);
 
 	if (mgslpc_paranoia_check(info, tty->name, "mgslpc_hangup"))
 		return;
@@ -2465,9 +2465,9 @@ static int carrier_raised(struct tty_port *port)
 	MGSLPC_INFO *info = container_of(port, MGSLPC_INFO, port);
 	unsigned long flags;
 
-	spin_lock_irqsave(&info->lock,flags);
- 	get_signals(info);
-	spin_unlock_irqrestore(&info->lock,flags);
+	spin_lock_irqsave(&info->lock, flags);
+	get_signals(info);
+	spin_unlock_irqrestore(&info->lock, flags);
 
 	if (info->serial_signals & SerialSignal_DCD)
 		return 1;
@@ -2479,13 +2479,13 @@ static void dtr_rts(struct tty_port *port, int onoff)
 	MGSLPC_INFO *info = container_of(port, MGSLPC_INFO, port);
 	unsigned long flags;
 
-	spin_lock_irqsave(&info->lock,flags);
+	spin_lock_irqsave(&info->lock, flags);
 	if (onoff)
 		info->serial_signals |= SerialSignal_RTS + SerialSignal_DTR;
 	else
 		info->serial_signals &= ~SerialSignal_RTS + SerialSignal_DTR;
 	set_signals(info);
-	spin_unlock_irqrestore(&info->lock,flags);
+	spin_unlock_irqrestore(&info->lock, flags);
 }
 
 
@@ -2493,14 +2493,14 @@ static int mgslpc_open(struct tty_struct *tty, struct file * filp)
 {
 	MGSLPC_INFO	*info;
 	struct tty_port *port;
-	int 			retval, line;
-	unsigned long flags;
+	int		retval, line;
+	unsigned long	flags;
 
 	/* verify range of specified line number */
 	line = tty->index;
 	if (line >= mgslpc_device_count) {
 		printk("%s(%d):mgslpc_open with invalid line #%d.\n",
-			__FILE__,__LINE__,line);
+			__FILE__, __LINE__, line);
 		return -ENODEV;
 	}
 
@@ -2517,7 +2517,7 @@ static int mgslpc_open(struct tty_struct *tty, struct file * filp)
 
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("%s(%d):mgslpc_open(%s), old ref count = %d\n",
-			 __FILE__,__LINE__,tty->driver->name, port->count);
+			 __FILE__, __LINE__, tty->driver->name, port->count);
 
 	/* If port is closing, signal caller to try again */
 	if (tty_hung_up_p(filp) || port->flags & ASYNC_CLOSING){
@@ -2552,13 +2552,13 @@ static int mgslpc_open(struct tty_struct *tty, struct file * filp)
 	if (retval) {
 		if (debug_level >= DEBUG_LEVEL_INFO)
 			printk("%s(%d):block_til_ready(%s) returned %d\n",
-				 __FILE__,__LINE__, info->device_name, retval);
+				 __FILE__, __LINE__, info->device_name, retval);
 		goto cleanup;
 	}
 
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("%s(%d):mgslpc_open(%s) success\n",
-			 __FILE__,__LINE__, info->device_name);
+			 __FILE__, __LINE__, info->device_name);
 	retval = 0;
 
 cleanup:
@@ -2578,9 +2578,9 @@ static inline void line_info(struct seq_file *m, MGSLPC_INFO *info)
 		      info->device_name, info->io_base, info->irq_level);
 
 	/* output current serial signal states */
-	spin_lock_irqsave(&info->lock,flags);
- 	get_signals(info);
-	spin_unlock_irqrestore(&info->lock,flags);
+	spin_lock_irqsave(&info->lock, flags);
+	get_signals(info);
+	spin_unlock_irqrestore(&info->lock, flags);
 
 	stat_buf[0] = 0;
 	stat_buf[1] = 0;
@@ -2642,7 +2642,7 @@ static int mgslpc_proc_show(struct seq_file *m, void *v)
 	seq_printf(m, "synclink driver:%s\n", driver_version);
 
 	info = mgslpc_device_list;
-	while( info ) {
+	while (info) {
 		line_info(m, info);
 		info = info->next_device;
 	}
@@ -2693,8 +2693,8 @@ static void rx_free_buffers(MGSLPC_INFO *info)
 
 static int claim_resources(MGSLPC_INFO *info)
 {
-	if (rx_alloc_buffers(info) < 0 ) {
-		printk( "Can't allocate rx buffer %s\n", info->device_name);
+	if (rx_alloc_buffers(info) < 0) {
+		printk("Can't allocate rx buffer %s\n", info->device_name);
 		release_resources(info);
 		return -ENODEV;
 	}
@@ -2734,7 +2734,7 @@ static int mgslpc_add_device(MGSLPC_INFO *info)
 		mgslpc_device_list = info;
 	else {
 		current_dev = mgslpc_device_list;
-		while( current_dev->next_device )
+		while (current_dev->next_device)
 			current_dev = current_dev->next_device;
 		current_dev->next_device = info;
 	}
@@ -2744,7 +2744,7 @@ static int mgslpc_add_device(MGSLPC_INFO *info)
 	else if (info->max_frame_size > 65535)
 		info->max_frame_size = 65535;
 
-	printk( "SyncLink PC Card %s:IO=%04X IRQ=%d\n",
+	printk("SyncLink PC Card %s:IO=%04X IRQ=%d\n",
 		info->device_name, info->io_base, info->irq_level);
 
 #if SYNCLINK_GENERIC_HDLC
@@ -3293,7 +3293,7 @@ static void rx_stop(MGSLPC_INFO *info)
 {
 	if (debug_level >= DEBUG_LEVEL_ISR)
 		printk("%s(%d):rx_stop(%s)\n",
-			 __FILE__,__LINE__, info->device_name );
+			 __FILE__, __LINE__, info->device_name);
 
 	/* MODE:03 RAC Receiver Active, 0=inactive */
 	clear_reg_bits(info, CHA + MODE, BIT3);
@@ -3306,7 +3306,7 @@ static void rx_start(MGSLPC_INFO *info)
 {
 	if (debug_level >= DEBUG_LEVEL_ISR)
 		printk("%s(%d):rx_start(%s)\n",
-			 __FILE__,__LINE__, info->device_name );
+			 __FILE__, __LINE__, info->device_name);
 
 	rx_reset_buffers(info);
 	info->rx_enabled = false;
@@ -3322,7 +3322,7 @@ static void tx_start(MGSLPC_INFO *info, struct tty_struct *tty)
 {
 	if (debug_level >= DEBUG_LEVEL_ISR)
 		printk("%s(%d):tx_start(%s)\n",
-			 __FILE__,__LINE__, info->device_name );
+			 __FILE__, __LINE__, info->device_name);
 
 	if (info->tx_count) {
 		/* If auto RTS enabled and RTS is inactive, then assert */
@@ -3360,7 +3360,7 @@ static void tx_stop(MGSLPC_INFO *info)
 {
 	if (debug_level >= DEBUG_LEVEL_ISR)
 		printk("%s(%d):tx_stop(%s)\n",
-			 __FILE__,__LINE__, info->device_name );
+			 __FILE__, __LINE__, info->device_name);
 
 	del_timer(&info->tx_timer);
 
@@ -3712,7 +3712,7 @@ static bool rx_get_frame(MGSLPC_INFO *info, struct tty_struct *tty)
 
 	if (debug_level >= DEBUG_LEVEL_BH)
 		printk("%s(%d):rx_get_frame(%s) status=%04X size=%d\n",
-			__FILE__,__LINE__,info->device_name,status,framesize);
+			__FILE__, __LINE__, info->device_name, status, framesize);
 
 	if (debug_level >= DEBUG_LEVEL_DATA)
 		trace_block(info, buf->data, framesize, 0);
@@ -3740,13 +3740,13 @@ static bool rx_get_frame(MGSLPC_INFO *info, struct tty_struct *tty)
 		}
 	}
 
-	spin_lock_irqsave(&info->lock,flags);
+	spin_lock_irqsave(&info->lock, flags);
 	buf->status = buf->count = 0;
 	info->rx_frame_count--;
 	info->rx_get++;
 	if (info->rx_get >= info->rx_buf_count)
 		info->rx_get = 0;
-	spin_unlock_irqrestore(&info->lock,flags);
+	spin_unlock_irqrestore(&info->lock, flags);
 
 	return true;
 }
@@ -3760,7 +3760,7 @@ static bool register_test(MGSLPC_INFO *info)
 	bool rc = true;
 	unsigned long flags;
 
-	spin_lock_irqsave(&info->lock,flags);
+	spin_lock_irqsave(&info->lock, flags);
 	reset_device(info);
 
 	for (i = 0; i < count; i++) {
@@ -3773,7 +3773,7 @@ static bool register_test(MGSLPC_INFO *info)
 		}
 	}
 
-	spin_unlock_irqrestore(&info->lock,flags);
+	spin_unlock_irqrestore(&info->lock, flags);
 	return rc;
 }
 
@@ -3782,7 +3782,7 @@ static bool irq_test(MGSLPC_INFO *info)
 	unsigned long end_time;
 	unsigned long flags;
 
-	spin_lock_irqsave(&info->lock,flags);
+	spin_lock_irqsave(&info->lock, flags);
 	reset_device(info);
 
 	info->testing_irq = true;
@@ -3796,7 +3796,7 @@ static bool irq_test(MGSLPC_INFO *info)
 	write_reg(info, CHA + TIMR, 0);	/* 512 cycles */
 	issue_command(info, CHA, CMD_START_TIMER);
 
-	spin_unlock_irqrestore(&info->lock,flags);
+	spin_unlock_irqrestore(&info->lock, flags);
 
 	end_time=100;
 	while(end_time-- && !info->irq_occurred) {
@@ -3805,9 +3805,9 @@ static bool irq_test(MGSLPC_INFO *info)
 
 	info->testing_irq = false;
 
-	spin_lock_irqsave(&info->lock,flags);
+	spin_lock_irqsave(&info->lock, flags);
 	reset_device(info);
-	spin_unlock_irqrestore(&info->lock,flags);
+	spin_unlock_irqrestore(&info->lock, flags);
 
 	return info->irq_occurred;
 }
@@ -3816,21 +3816,21 @@ static int adapter_test(MGSLPC_INFO *info)
 {
 	if (!register_test(info)) {
 		info->init_error = DiagStatus_AddressFailure;
-		printk( "%s(%d):Register test failure for device %s Addr=%04X\n",
-			__FILE__,__LINE__,info->device_name, (unsigned short)(info->io_base) );
+		printk("%s(%d):Register test failure for device %s Addr=%04X\n",
+			__FILE__, __LINE__, info->device_name, (unsigned short)(info->io_base));
 		return -ENODEV;
 	}
 
 	if (!irq_test(info)) {
 		info->init_error = DiagStatus_IrqFailure;
-		printk( "%s(%d):Interrupt test failure for device %s IRQ=%d\n",
-			__FILE__,__LINE__,info->device_name, (unsigned short)(info->irq_level) );
+		printk("%s(%d):Interrupt test failure for device %s IRQ=%d\n",
+			__FILE__, __LINE__, info->device_name, (unsigned short)(info->irq_level));
 		return -ENODEV;
 	}
 
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("%s(%d):device %s passed diagnostics\n",
-			__FILE__,__LINE__,info->device_name);
+			__FILE__, __LINE__, info->device_name);
 	return 0;
 }
 
@@ -3839,9 +3839,9 @@ static void trace_block(MGSLPC_INFO *info,const char* data, int count, int xmit)
 	int i;
 	int linecount;
 	if (xmit)
-		printk("%s tx data:\n",info->device_name);
+		printk("%s tx data:\n", info->device_name);
 	else
-		printk("%s rx data:\n",info->device_name);
+		printk("%s rx data:\n", info->device_name);
 
 	while(count) {
 		if (count > 16)
@@ -3850,12 +3850,12 @@ static void trace_block(MGSLPC_INFO *info,const char* data, int count, int xmit)
 			linecount = count;
 
 		for(i=0;i<linecount;i++)
-			printk("%02X ",(unsigned char)data[i]);
+			printk("%02X ", (unsigned char)data[i]);
 		for(;i<17;i++)
 			printk("   ");
 		for(i=0;i<linecount;i++) {
 			if (data[i]>=040 && data[i]<=0176)
-				printk("%c",data[i]);
+				printk("%c", data[i]);
 			else
 				printk(".");
 		}
@@ -3874,18 +3874,18 @@ static void tx_timeout(unsigned long context)
 	MGSLPC_INFO *info = (MGSLPC_INFO*)context;
 	unsigned long flags;
 
-	if ( debug_level >= DEBUG_LEVEL_INFO )
-		printk( "%s(%d):tx_timeout(%s)\n",
-			__FILE__,__LINE__,info->device_name);
-	if(info->tx_active &&
-	   info->params.mode == MGSL_MODE_HDLC) {
+	if (debug_level >= DEBUG_LEVEL_INFO)
+		printk("%s(%d):tx_timeout(%s)\n",
+			__FILE__, __LINE__, info->device_name);
+	if (info->tx_active &&
+	    info->params.mode == MGSL_MODE_HDLC) {
 		info->icount.txtimeout++;
 	}
-	spin_lock_irqsave(&info->lock,flags);
+	spin_lock_irqsave(&info->lock, flags);
 	info->tx_active = false;
 	info->tx_count = info->tx_put = info->tx_get = 0;
 
-	spin_unlock_irqrestore(&info->lock,flags);
+	spin_unlock_irqrestore(&info->lock, flags);
 
 #if SYNCLINK_GENERIC_HDLC
 	if (info->netcount)
@@ -3967,7 +3967,7 @@ static netdev_tx_t hdlcdev_xmit(struct sk_buff *skb,
 	unsigned long flags;
 
 	if (debug_level >= DEBUG_LEVEL_INFO)
-		printk(KERN_INFO "%s:hdlc_xmit(%s)\n",__FILE__,dev->name);
+		printk(KERN_INFO "%s:hdlc_xmit(%s)\n", __FILE__, dev->name);
 
 	/* stop sending until this frame completes */
 	netif_stop_queue(dev);
@@ -3988,13 +3988,13 @@ static netdev_tx_t hdlcdev_xmit(struct sk_buff *skb,
 	dev->trans_start = jiffies;
 
 	/* start hardware transmitter if necessary */
-	spin_lock_irqsave(&info->lock,flags);
+	spin_lock_irqsave(&info->lock, flags);
 	if (!info->tx_active) {
 		struct tty_struct *tty = tty_port_tty_get(&info->port);
-	 	tx_start(info, tty);
-	 	tty_kref_put(tty);
+		tx_start(info, tty);
+		tty_kref_put(tty);
 	}
-	spin_unlock_irqrestore(&info->lock,flags);
+	spin_unlock_irqrestore(&info->lock, flags);
 
 	return NETDEV_TX_OK;
 }
@@ -4015,10 +4015,11 @@ static int hdlcdev_open(struct net_device *dev)
 	unsigned long flags;
 
 	if (debug_level >= DEBUG_LEVEL_INFO)
-		printk("%s:hdlcdev_open(%s)\n",__FILE__,dev->name);
+		printk("%s:hdlcdev_open(%s)\n", __FILE__, dev->name);
 
 	/* generic HDLC layer open processing */
-	if ((rc = hdlc_open(dev)))
+	rc = hdlc_open(dev);
+	if (rc != 0)
 		return rc;
 
 	/* arbitrate between network and tty opens */
@@ -4033,7 +4034,8 @@ static int hdlcdev_open(struct net_device *dev)
 
 	tty = tty_port_tty_get(&info->port);
 	/* claim resources and init adapter */
-	if ((rc = startup(info, tty)) != 0) {
+	rc = startup(info, tty);
+	if (rc != 0) {
 		tty_kref_put(tty);
 		spin_lock_irqsave(&info->netlock, flags);
 		info->netcount=0;
@@ -4075,7 +4077,7 @@ static int hdlcdev_close(struct net_device *dev)
 	unsigned long flags;
 
 	if (debug_level >= DEBUG_LEVEL_INFO)
-		printk("%s:hdlcdev_close(%s)\n",__FILE__,dev->name);
+		printk("%s:hdlcdev_close(%s)\n", __FILE__, dev->name);
 
 	netif_stop_queue(dev);
 
@@ -4109,7 +4111,7 @@ static int hdlcdev_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 	unsigned int flags;
 
 	if (debug_level >= DEBUG_LEVEL_INFO)
-		printk("%s:hdlcdev_ioctl(%s)\n",__FILE__,dev->name);
+		printk("%s:hdlcdev_ioctl(%s)\n", __FILE__, dev->name);
 
 	/* return error if TTY interface open */
 	if (info->port.count)
@@ -4210,14 +4212,14 @@ static void hdlcdev_tx_timeout(struct net_device *dev)
 	unsigned long flags;
 
 	if (debug_level >= DEBUG_LEVEL_INFO)
-		printk("hdlcdev_tx_timeout(%s)\n",dev->name);
+		printk("hdlcdev_tx_timeout(%s)\n", dev->name);
 
 	dev->stats.tx_errors++;
 	dev->stats.tx_aborted_errors++;
 
-	spin_lock_irqsave(&info->lock,flags);
+	spin_lock_irqsave(&info->lock, flags);
 	tx_stop(info);
-	spin_unlock_irqrestore(&info->lock,flags);
+	spin_unlock_irqrestore(&info->lock, flags);
 
 	netif_wake_queue(dev);
 }
@@ -4248,7 +4250,7 @@ static void hdlcdev_rx(MGSLPC_INFO *info, char *buf, int size)
 	struct net_device *dev = info->netdev;
 
 	if (debug_level >= DEBUG_LEVEL_INFO)
-		printk("hdlcdev_rx(%s)\n",dev->name);
+		printk("hdlcdev_rx(%s)\n", dev->name);
 
 	if (skb == NULL) {
 		printk(KERN_NOTICE "%s: can't alloc skb, dropping packet\n", dev->name);
@@ -4291,8 +4293,9 @@ static int hdlcdev_init(MGSLPC_INFO *info)
 
 	/* allocate and initialize network and HDLC layer objects */
 
-	if (!(dev = alloc_hdlcdev(info))) {
-		printk(KERN_ERR "%s:hdlc device allocation failure\n",__FILE__);
+	dev = alloc_hdlcdev(info);
+	if (dev == NULL) {
+		printk(KERN_ERR "%s:hdlc device allocation failure\n", __FILE__);
 		return -ENOMEM;
 	}
 
@@ -4311,8 +4314,9 @@ static int hdlcdev_init(MGSLPC_INFO *info)
 	hdlc->xmit   = hdlcdev_xmit;
 
 	/* register objects with HDLC layer */
-	if ((rc = register_hdlc_device(dev))) {
-		printk(KERN_WARNING "%s:unable to register hdlc device\n",__FILE__);
+	rc = register_hdlc_device(dev);
+	if (rc) {
+		printk(KERN_WARNING "%s:unable to register hdlc device\n", __FILE__);
 		free_netdev(dev);
 		return rc;
 	}
-- 
1.7.9.5

