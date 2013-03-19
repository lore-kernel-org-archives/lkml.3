Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751192Ab3CSJyM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 05:54:12 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:16898 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758001Ab3CSJwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 05:52:25 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap8CANk0SFFbdWObgWdsb2JhbABDxSKBWxYOAQEWJiiCJQEFGgEMUhBRVwYTiBiyMZAhjw4Hg0ADll+UDTs
X-IPAS-Result: Ap8CANk0SFFbdWObgWdsb2JhbABDxSKBWxYOAQEWJiiCJQEFGgEMUhBRVwYTiBiyMZAhjw4Hg0ADll+UDTs
X-IronPort-AV: E=Sophos;i="4.84,870,1355094000"; 
   d="scan'208";a="18790038"
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Subject: [PATCH 6/9] staging/sb105x: coding style issues
Date: Tue, 19 Mar 2013 10:51:27 +0100
Message-Id: <1363686690-27090-7-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363686690-27090-1-git-send-email-siglesias@igalia.com>
References: <1363686690-27090-1-git-send-email-siglesias@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Driver logic is not being modified

Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/staging/sb105x/sb_mp_register.h |    7 +-
 drivers/staging/sb105x/sb_pci_mp.c      |  390 ++++++++++++++-----------------
 drivers/staging/sb105x/sb_pci_mp.h      |  165 ++++++-------
 drivers/staging/sb105x/sb_ser_core.h    |  225 ++++++++++--------
 4 files changed, 378 insertions(+), 409 deletions(-)

diff --git a/drivers/staging/sb105x/sb_mp_register.h b/drivers/staging/sb105x/sb_mp_register.h
index a2087f5..864d9d4 100644
--- a/drivers/staging/sb105x/sb_mp_register.h
+++ b/drivers/staging/sb105x/sb_mp_register.h
@@ -1,4 +1,3 @@
-
 /*
  * SB105X_UART.h
  *
@@ -15,8 +14,8 @@
 #ifndef UART_SB105X_H
 #define UART_SB105X_H
 
-/* 
- * option register 
+/*
+ * option register
  */
 
 /* Device Infomation Register */
@@ -292,4 +291,4 @@
 
 #define SB105X_PUT_PSR(port,v)	outb((v),(port)->iobase + SB105X_PSR )
 
-#endif 
+#endif
diff --git a/drivers/staging/sb105x/sb_pci_mp.c b/drivers/staging/sb105x/sb_pci_mp.c
index cb27fb6..7fa6ef7 100644
--- a/drivers/staging/sb105x/sb_pci_mp.c
+++ b/drivers/staging/sb105x/sb_pci_mp.c
@@ -182,11 +182,11 @@ static int sb1054_get_register(struct sb_uart_port * port, int page, int reg)
 	unsigned int tmp = 0;
 
 	if (page <= 0) {
-		dev_err(port->dev, " page 0 can not use this fuction\n");
+		dev_err(port->dev, "page 0 can not use this fuction\n");
 		return -1;
 	}
 
-	switch(page) {
+	switch (page) {
 	case 1:
 		lcr = SB105X_GET_LCR(port);
 		tmp = lcr | SB105X_LCR_DLAB;
@@ -194,40 +194,40 @@ static int sb1054_get_register(struct sb_uart_port * port, int page, int reg)
 
 		tmp = SB105X_GET_LCR(port);
 
-		ret = SB105X_GET_REG(port,reg);
-		SB105X_PUT_LCR(port,lcr);
+		ret = SB105X_GET_REG(port, reg);
+		SB105X_PUT_LCR(port, lcr);
 		break;
 	case 2:
 		mcr = SB105X_GET_MCR(port);
 		tmp = mcr | SB105X_MCR_P2S;
-		SB105X_PUT_MCR(port,tmp);
+		SB105X_PUT_MCR(port, tmp);
 
-		ret = SB105X_GET_REG(port,reg);
+		ret = SB105X_GET_REG(port, reg);
 
-		SB105X_PUT_MCR(port,mcr);
+		SB105X_PUT_MCR(port, mcr);
 		break;
 	case 3:
 		lcr = SB105X_GET_LCR(port);
 		tmp = lcr | SB105X_LCR_BF;
-		SB105X_PUT_LCR(port,tmp);
-		SB105X_PUT_REG(port,SB105X_PSR,SB105X_PSR_P3KEY);
+		SB105X_PUT_LCR(port, tmp);
+		SB105X_PUT_REG(port, SB105X_PSR,SB105X_PSR_P3KEY);
 
-		ret = SB105X_GET_REG(port,reg);
+		ret = SB105X_GET_REG(port, reg);
 
-		SB105X_PUT_LCR(port,lcr);
+		SB105X_PUT_LCR(port, lcr);
 		break;
 	case 4:
 		lcr = SB105X_GET_LCR(port);
 		tmp = lcr | SB105X_LCR_BF;
-		SB105X_PUT_LCR(port,tmp);
-		SB105X_PUT_REG(port,SB105X_PSR,SB105X_PSR_P4KEY);
+		SB105X_PUT_LCR(port, tmp);
+		SB105X_PUT_REG(port, SB105X_PSR,SB105X_PSR_P4KEY);
 
-		ret = SB105X_GET_REG(port,reg);
+		ret = SB105X_GET_REG(port, reg);
 
-		SB105X_PUT_LCR(port,lcr);
+		SB105X_PUT_LCR(port, lcr);
 		break;
 	default:
-		dev_err(port->dev, " error invalid page number \n");
+		dev_err(port->dev, "error invalid page number \n");
 		return -1;
 	}
 
@@ -241,16 +241,16 @@ static int sb1054_set_register(struct sb_uart_port * port, int page, int reg, in
 	int ret = 0;
 
 	if (page <= 0) {
-		dev_err(port->dev, " page 0 can not use this fuction\n");
+		dev_err(port->dev, "page 0 can not use this fuction\n");
 		return -1;
 	}
 
-	switch(page) {
+	switch (page) {
 	case 1:
 		lcr = SB105X_GET_LCR(port);
 		SB105X_PUT_LCR(port, lcr | SB105X_LCR_DLAB);
 
-		SB105X_PUT_REG(port,reg,value);
+		SB105X_PUT_REG(port, reg, value);
 
 		SB105X_PUT_LCR(port, lcr);
 		ret = 1;
@@ -259,7 +259,7 @@ static int sb1054_set_register(struct sb_uart_port * port, int page, int reg, in
 		mcr = SB105X_GET_MCR(port);
 		SB105X_PUT_MCR(port, mcr | SB105X_MCR_P2S);
 
-		SB105X_PUT_REG(port,reg,value);
+		SB105X_PUT_REG(port, reg, value);
 
 		SB105X_PUT_MCR(port, mcr);
 		ret = 1;
@@ -269,7 +269,7 @@ static int sb1054_set_register(struct sb_uart_port * port, int page, int reg, in
 		SB105X_PUT_LCR(port, lcr | SB105X_LCR_BF);
 		SB105X_PUT_PSR(port, SB105X_PSR_P3KEY);
 
-		SB105X_PUT_REG(port,reg,value);
+		SB105X_PUT_REG(port, reg, value);
 
 		SB105X_PUT_LCR(port, lcr);
 		ret = 1;
@@ -279,13 +279,13 @@ static int sb1054_set_register(struct sb_uart_port * port, int page, int reg, in
 		SB105X_PUT_LCR(port, lcr | SB105X_LCR_BF);
 		SB105X_PUT_PSR(port, SB105X_PSR_P4KEY);
 
-		SB105X_PUT_REG(port,reg,value);
+		SB105X_PUT_REG(port, reg, value);
 
 		SB105X_PUT_LCR(port, lcr);
 		ret = 1;
 		break;
 	default:
-		dev_err(port->dev, " error invalid page number \n");
+		dev_err(port->dev, "error invalid page number \n");
 		return -1;
 	}
 
@@ -296,9 +296,8 @@ static int set_multidrop_mode(struct sb_uart_port *port, unsigned int mode)
 {
 	int mdr = SB105XA_MDR_NPS;
 
-	if (mode & MDMODE_ENABLE) {
+	if (mode & MDMODE_ENABLE)
 		mdr |= SB105XA_MDR_MDE;
-	}
 
 	if (1) { //(mode & MDMODE_AUTO)
 		int efr = 0;
@@ -331,7 +330,7 @@ static int set_multidrop_addr(struct sb_uart_port *port, unsigned int addr)
 static void SendATCommand(struct mp_port * mtpt)
 {
 	//		      a    t	cr   lf
-	unsigned char ch[] = {0x61,0x74,0x0d,0x0a,0x0};
+	unsigned char ch[] = {0x61, 0x74, 0x0d, 0x0a, 0x0};
 	unsigned char lineControl;
 	unsigned char i=0;
 	unsigned char Divisor = 0xc;
@@ -346,8 +345,8 @@ static void SendATCommand(struct mp_port * mtpt)
 	serial_outp(mtpt,UART_LCR,0x03); // N-8-1
 	serial_outp(mtpt,UART_FCR,7);
 	serial_outp(mtpt,UART_MCR,0x3);
-	while(ch[i]){
-		while((serial_inp(mtpt,UART_LSR) & 0x60) !=0x60){
+	while(ch[i]) {
+		while((serial_inp(mtpt,UART_LSR) & 0x60) !=0x60) {
 			;
 		}
 		serial_outp(mtpt,0,ch[i++]);
@@ -366,9 +365,9 @@ static int set_deep_fifo(struct sb_uart_port * port, int status)
 	else
 		afr_status &= ~SB105X_AFR_AFEN;
 
-	sb1054_set_register(port,PAGE_4,SB105X_AFR,afr_status);
-	sb1054_set_register(port,PAGE_4,SB105X_TTR,ttr[port->line]);
-	sb1054_set_register(port,PAGE_4,SB105X_RTR,rtr[port->line]);
+	sb1054_set_register(port,PAGE_4, SB105X_AFR, afr_status);
+	sb1054_set_register(port,PAGE_4, SB105X_TTR, ttr[port->line]);
+	sb1054_set_register(port,PAGE_4, SB105X_RTR, rtr[port->line]);
 	afr_status = sb1054_get_register(port, PAGE_4, SB105X_AFR);
 
 	return afr_status;
@@ -377,9 +376,9 @@ static int set_deep_fifo(struct sb_uart_port * port, int status)
 static int get_device_type(int arg)
 {
 	int ret;
-        ret = inb(mp_devs[arg].option_reg_addr+MP_OPTR_DIR0);
-        ret = (ret & 0xf0) >> 4;
-        switch (ret) {
+	ret = inb(mp_devs[arg].option_reg_addr+MP_OPTR_DIR0);
+	ret = (ret & 0xf0) >> 4;
+	switch (ret) {
 	case DIR_UART_16C550:
 		return PORT_16C55X;
 	case DIR_UART_16C1050:
@@ -427,7 +426,7 @@ static int set_auto_rts(struct sb_uart_port *port, int status)
 
 //ATR
 	atr_status = sb1054_get_register(port, PAGE_3, SB105X_ATR);
-	switch(status) {
+	switch (status) {
 	case RS422PTP:
 		atr_status = (SB105X_ATR_TPS) | (SB105X_ATR_A80);
 		break;
@@ -518,7 +517,6 @@ static int mp_startup(struct sb_uart_state *state, int init_hw)
 			return -ENOMEM;
 
 		info->xmit.buf = (unsigned char *) page;
-
 		uart_circ_clear(&info->xmit);
 	}
 
@@ -1094,33 +1092,31 @@ static int mp_ioctl(struct tty_struct *tty, unsigned int cmd, unsigned long arg)
 		deep[state->port->line] = arg;
 		return ret;
 	case SETTTR:
-		if (info->port.type == PORT_16C105X || info->port.type == PORT_16C105XA){
-			ret = sb1054_set_register(state->port,PAGE_4,SB105X_TTR,arg);
+		if (info->port.type == PORT_16C105X || info->port.type == PORT_16C105XA) {
+			ret = sb1054_set_register(state->port, PAGE_4, SB105X_TTR, arg);
 			ttr[state->port->line] = arg;
 		}
 		return ret;
 	case SETRTR:
-		if (info->port.type == PORT_16C105X || info->port.type == PORT_16C105XA){
-			ret = sb1054_set_register(state->port,PAGE_4,SB105X_RTR,arg);
+		if (info->port.type == PORT_16C105X || info->port.type == PORT_16C105XA) {
+			ret = sb1054_set_register(state->port, PAGE_4, SB105X_RTR, arg);
 			rtr[state->port->line] = arg;
 		}
 		return ret;
 	case GETTTR:
-		if (info->port.type == PORT_16C105X || info->port.type == PORT_16C105XA){
-			ret = sb1054_get_register(state->port,PAGE_4,SB105X_TTR);
-		}
+		if (info->port.type == PORT_16C105X || info->port.type == PORT_16C105XA)
+			ret = sb1054_get_register(state->port, PAGE_4, SB105X_TTR);
 		return ret;
 	case GETRTR:
-		if (info->port.type == PORT_16C105X || info->port.type == PORT_16C105XA){
-			ret = sb1054_get_register(state->port,PAGE_4,SB105X_RTR);
-		}
+		if (info->port.type == PORT_16C105X || info->port.type == PORT_16C105XA)
+			ret = sb1054_get_register(state->port, PAGE_4, SB105X_RTR);
 		return ret;
 
 	case SETFCR:
 		if (info->port.type == PORT_16C105X || info->port.type == PORT_16C105XA)
-			ret = sb1054_set_register(state->port,PAGE_1,SB105X_FCR,arg);
+			ret = sb1054_set_register(state->port, PAGE_1, SB105X_FCR, arg);
 		else
-			serial_out(info,2,arg);
+			serial_out(info, 2, arg);
 
 		return ret;
 	case TIOCSMDADDR:
@@ -1192,11 +1188,11 @@ static int mp_ioctl(struct tty_struct *tty, unsigned int cmd, unsigned long arg)
 		ret = get_device_type(arg);;
 		return ret;
 	case TIOCSMULTIECHO: /* set to multi-drop mode(RS422) or echo mode(RS485)*/
-		outb( ( inb(info->interface_config_addr) & ~0x03 ) | 0x01 ,
+		outb( ( inb(info->interface_config_addr) & ~0x03 ) | 0x01,
 				info->interface_config_addr);
 		return 0;
 	case TIOCSPTPNOECHO: /* set to multi-drop mode(RS422) or echo mode(RS485) */
-		outb( ( inb(info->interface_config_addr) & ~0x03 )  ,
+		outb( ( inb(info->interface_config_addr) & ~0x03 ),
 				info->interface_config_addr);
 		return 0;
 	}
@@ -1329,16 +1325,13 @@ static void mp_close(struct tty_struct *tty, struct file *filp)
 	tty_ldisc_flush(tty);
 	tty->closing = 0;
 	state->info->tty = NULL;
-	if (state->info->blocked_open)
-	{
-		if (state->close_delay)
-		{
+
+	if (state->info->blocked_open) {
+		if (state->close_delay) {
 			set_current_state(TASK_INTERRUPTIBLE);
 			schedule_timeout(state->close_delay);
 		}
-	}
-	else
-	{
+	} else {
 		mp_change_pm(state, 3);
 	}
 
@@ -1434,9 +1427,8 @@ static int mp_block_til_ready(struct file *filp, struct sb_uart_state *state)
 
 		if ((filp->f_flags & O_NONBLOCK) ||
 				(info->tty->termios.c_cflag & CLOCAL) ||
-				(info->tty->flags & (1 << TTY_IO_ERROR))) {
+				(info->tty->flags & (1 << TTY_IO_ERROR)))
 			break;
-		}
 
 		if (info->tty->termios.c_cflag & CBAUD)
 			uart_set_mctrl(port, TIOCM_DTR);
@@ -1602,7 +1594,7 @@ static inline void mp_report_port(struct uart_driver *drv, struct sb_uart_port *
 			snprintf(address, sizeof(address),"MMIO 0x%lx", port->mapbase);
 			break;
 		default:
-			snprintf(address, sizeof(address),"*unknown*" );
+			snprintf(address, sizeof(address),"*unknown*");
 			strlcpy(address, "*unknown*", sizeof(address));
 			break;
 	}
@@ -1722,7 +1714,6 @@ static int mp_register_driver(struct uart_driver *drv)
 	normal->minor_start	= drv->minor;
 
 	normal->num		= MAX_MP_PORT ;
-
 	normal->type		= TTY_DRIVER_TYPE_SERIAL;
 	normal->subtype		= SERIAL_TYPE_NORMAL;
 	normal->init_termios	= tty_std_termios;
@@ -1732,13 +1723,12 @@ static int mp_register_driver(struct uart_driver *drv)
 
 	tty_set_operations(normal, &mp_ops);
 
-for (i = 0; i < drv->nr; i++) {
-	struct sb_uart_state *state = drv->state + i;
+	for (i = 0; i < drv->nr; i++) {
+		struct sb_uart_state *state = drv->state + i;
 
-	state->close_delay     = 500;
-	state->closing_wait    = 30000;
-
-	mutex_init(&state->mutex);
+		state->close_delay     = 500;
+		state->closing_wait    = 30000;
+		mutex_init(&state->mutex);
 	}
 
 	retval = tty_register_driver(normal);
@@ -1754,25 +1744,19 @@ out:
 
 void mp_unregister_driver(struct uart_driver *drv)
 {
-    struct tty_driver *normal = NULL;
-
-    normal = drv->tty_driver;
-
-    if (!normal)
-    {
-        return;
-    }
+	struct tty_driver *normal = NULL;
 
-    tty_unregister_driver(normal);
-    put_tty_driver(normal);
-    drv->tty_driver = NULL;
+	normal = drv->tty_driver;
 
+	if (!normal)
+		return;
 
-    if (drv->state)
-    {
-        kfree(drv->state);
-    }
+	tty_unregister_driver(normal);
+	put_tty_driver(normal);
+	drv->tty_driver = NULL;
 
+	if (drv->state)
+		kfree(drv->state);
 }
 
 static int mp_add_one_port(struct uart_driver *drv, struct sb_uart_port *port)
@@ -1903,20 +1887,13 @@ static void autoconfig(struct mp_port *mtpt, unsigned int probeflags)
 				mtpt->port.type = PORT_16C105X;
 				break;
 			case DIR_UART_16C1050A:
-				if (mtpt->port.line < 2)
-				{
+				if (mtpt->port.line < 2) {
 					mtpt->port.type = PORT_16C105XA;
-				}
-				else
-				{
+				} else {
 					if (mtpt->device->device_id & 0x50)
-					{
 						mtpt->port.type = PORT_16C55X;
-					}
 					else
-					{
 						mtpt->port.type = PORT_16C105X;
-					}
 				}
 				break;
 			default:
@@ -2041,45 +2018,37 @@ static inline void receive_chars(struct mp_port *mtpt, int *status )
 	//lsr &= mtpt->port.read_status_mask;
 
 	do {
-		if ((lsr & UART_LSR_PE) && (mtpt->port.mdmode & MDMODE_ENABLE))
-		{
-			ch = serial_inp(mtpt, UART_RX);
-		}
-		else if (lsr & UART_LSR_SPECIAL)
-		{
-			flag = 0;
+		if ((lsr & UART_LSR_PE) && (mtpt->port.mdmode & MDMODE_ENABLE)) {
 			ch = serial_inp(mtpt, UART_RX);
+		} else {
+			if (lsr & UART_LSR_SPECIAL) {
+				flag = 0;
+				ch = serial_inp(mtpt, UART_RX);
 
-			if (lsr & UART_LSR_BI)
-			{
-
-				mtpt->port.icount.brk++;
-				flag = TTY_BREAK;
+				if (lsr & UART_LSR_BI) {
+					mtpt->port.icount.brk++;
+					flag = TTY_BREAK;
 
-				if (sb_uart_handle_break(&mtpt->port))
-					goto ignore_char;
-			}
-			if (lsr & UART_LSR_PE)
-			{
-				mtpt->port.icount.parity++;
-				flag = TTY_PARITY;
-			}
-			if (lsr & UART_LSR_FE)
-			{
-				mtpt->port.icount.frame++;
-				flag = TTY_FRAME;
-			}
-			if (lsr & UART_LSR_OE)
-			{
-				mtpt->port.icount.overrun++;
-				flag = TTY_OVERRUN;
+					if (sb_uart_handle_break(&mtpt->port))
+						goto ignore_char;
+				}
+				if (lsr & UART_LSR_PE) {
+					mtpt->port.icount.parity++;
+					flag = TTY_PARITY;
+				}
+				if (lsr & UART_LSR_FE) {
+					mtpt->port.icount.frame++;
+					flag = TTY_FRAME;
+				}
+				if (lsr & UART_LSR_OE) {
+					mtpt->port.icount.overrun++;
+					flag = TTY_OVERRUN;
+				}
+				tty_insert_flip_char(tty, ch, flag);
+			} else {
+				ch = serial_inp(mtpt, UART_RX);
+				tty_insert_flip_char(tty, ch, 0);
 			}
-			tty_insert_flip_char(tty, ch, flag);
-		}
-		else
-		{
-			ch = serial_inp(mtpt, UART_RX);
-			tty_insert_flip_char(tty, ch, 0);
 		}
 ignore_char:
 		lsr = serial_inp(mtpt, UART_LSR);
@@ -2110,21 +2079,17 @@ static inline void transmit_chars(struct mp_port *mtpt)
 	count = uart_circ_chars_pending(xmit);
 
 	if(count > mtpt->port.fifosize)
-	{
 		count = mtpt->port.fifosize;
-	}
 
 	pr_info("[%d] mdmode: %x\n", mtpt->port.line, mtpt->port.mdmode);
 	do {
 #if 0
 		/* check multi-drop mode */
-		if ((mtpt->port.mdmode & (MDMODE_ENABLE | MDMODE_ADDR)) == (MDMODE_ENABLE | MDMODE_ADDR))
-		{
+		if ((mtpt->port.mdmode & (MDMODE_ENABLE | MDMODE_ADDR)) == (MDMODE_ENABLE | MDMODE_ADDR)) {
 			printk("send address\n");
 			/* send multi-drop address */
 			serial_out(mtpt, UART_SCR, xmit->buf[xmit->tail]);
-		}
-		else
+		} else
 #endif
 		{
 			serial_out(mtpt, UART_TX, xmit->buf[xmit->tail]);
@@ -2134,8 +2099,6 @@ static inline void transmit_chars(struct mp_port *mtpt)
 	} while (--count > 0);
 }
 
-
-
 static inline void check_modem_status(struct mp_port *mtpt)
 {
 	int status;
@@ -2207,15 +2170,16 @@ static irqreturn_t multi_interrupt(int irq, void *dev_id)
 		mtpt = list_entry(lhead, struct mp_port, list);
 
 		iir = serial_in(mtpt, UART_IIR);
-		if (!(iir & UART_IIR_NO_INT))
-		{
+		if (!(iir & UART_IIR_NO_INT)) {
 			spin_lock(&mtpt->port.lock);
 			multi_handle_port(mtpt);
 			spin_unlock(&mtpt->port.lock);
 
 			end = NULL;
-		} else if (end == NULL)
-			end = lhead;
+		} else {
+			if (end == NULL)
+				end = lhead;
+		}
 
 		lhead = lhead->next;
 		if (lhead == iinfo->head && pass_counter++ > PASS_LIMIT)
@@ -2227,9 +2191,7 @@ static irqreturn_t multi_interrupt(int irq, void *dev_id)
 	} while (lhead != end);
 
 	spin_unlock(&iinfo->lock);
-
-
-        return IRQ_HANDLED;
+	return IRQ_HANDLED;
 }
 
 static void serial_do_unlink(struct irq_info *i, struct mp_port *mtpt)
@@ -2422,7 +2384,6 @@ static int multi_startup(struct sb_uart_port *port)
 	multi_set_mctrl(&mtpt->port, mtpt->port.mctrl);
 	spin_unlock_irqrestore(&mtpt->port.lock, flags);
 
-
 	mtpt->ier = UART_IER_RLSI | UART_IER_RDI;
 	serial_outp(mtpt, UART_IER, mtpt->ier);
 
@@ -2466,8 +2427,6 @@ static void multi_shutdown(struct sb_uart_port *port)
 		serial_unlink_irq_chain(mtpt);
 }
 
-
-
 static unsigned int multi_get_divisor(struct sb_uart_port *port, unsigned int baud)
 {
 	unsigned int quot;
@@ -2484,9 +2443,6 @@ static unsigned int multi_get_divisor(struct sb_uart_port *port, unsigned int ba
 	return quot;
 }
 
-
-
-
 static void multi_set_termios(struct sb_uart_port *port, struct MP_TERMIOS *termios, struct MP_TERMIOS *old)
 {
 	struct mp_port *mtpt = (struct mp_port *)port;
@@ -2586,8 +2542,7 @@ static void multi_set_termios(struct sb_uart_port *port, struct MP_TERMIOS *term
 
 
 	if ((mtpt->port.type == PORT_16C105X)
-		|| (mtpt->port.type == PORT_16C105XA))
-	{
+		|| (mtpt->port.type == PORT_16C105XA)) {
 		if(deep[mtpt->port.line]!=0)
 			set_deep_fifo(port, ENABLE);
 
@@ -2599,9 +2554,8 @@ static void multi_set_termios(struct sb_uart_port *port, struct MP_TERMIOS *term
 			uart_clear_mctrl(&mtpt->port, TIOCM_RTS);
 	}
 
-	if(mtpt->device->device_id == PCI_DEVICE_ID_MP4M) {
+	if(mtpt->device->device_id == PCI_DEVICE_ID_MP4M)
 		SendATCommand(mtpt);
-	}
 
 	multi_set_mctrl(&mtpt->port, mtpt->port.mctrl);
 	spin_unlock_irqrestore(&mtpt->port.lock, flags);
@@ -2644,22 +2598,22 @@ static void multi_release_std_resource(struct mp_port *mtpt)
 	unsigned int size = 8 << mtpt->port.regshift;
 
 	switch (mtpt->port.iotype) {
-		case UPIO_MEM:
-			if (!mtpt->port.mapbase)
-				break;
+	case UPIO_MEM:
+		if (!mtpt->port.mapbase)
+			break;
 
-			if (mtpt->port.flags & UPF_IOREMAP) {
-				iounmap(mtpt->port.membase);
-				mtpt->port.membase = NULL;
-			}
+		if (mtpt->port.flags & UPF_IOREMAP) {
+			iounmap(mtpt->port.membase);
+			mtpt->port.membase = NULL;
+		}
 
-			release_mem_region(mtpt->port.mapbase, size);
-			break;
+		release_mem_region(mtpt->port.mapbase, size);
+		break;
 
-		case UPIO_HUB6:
-		case UPIO_PORT:
-			release_region(mtpt->port.iobase,size);
-			break;
+	case UPIO_HUB6:
+	case UPIO_PORT:
+		release_region(mtpt->port.iobase,size);
+		break;
 	}
 }
 
@@ -2692,6 +2646,7 @@ static int multi_verify_port(struct sb_uart_port *port, struct serial_struct *se
 			ser->baud_base < 9600 || ser->type < PORT_UNKNOWN ||
 			ser->type == PORT_STARTECH)
 		return -EINVAL;
+
 	return 0;
 }
 
@@ -2749,12 +2704,10 @@ static void __init multi_init_ports(void)
 
 	mtpt = multi_ports;
 
-	for (k=0;k<NR_BOARD;k++)
-	{
+	for (k = 0; k < NR_BOARD; k++) {
 		sbdev = &mp_devs[k];
 
-		for (i = 0; i < sbdev->nr_ports; i++, mtpt++)
-		{
+		for (i = 0; i < sbdev->nr_ports; i++, mtpt++) {
 			mtpt->device 		= sbdev;
 			mtpt->port.iobase   = sbdev->uart_access_addr + 8*i;
 			mtpt->port.irq      = sbdev->irq;
@@ -2785,8 +2738,8 @@ static void __init multi_init_ports(void)
 				/* for SB16C1053APCI */
 				b_ret = sb1053a_get_interface(mtpt, i);
 			} else {
-				b_ret = read_option_register(mtpt,(MP_OPTR_IIR0 + i/8));
-				pr_info("IIR_RET = %x\n",b_ret);
+				b_ret = read_option_register(mtpt, (MP_OPTR_IIR0 + i/8));
+				pr_info("IIR_RET = %x\n", b_ret);
 			}
 
 			/* default to RS232 */
@@ -2844,14 +2797,13 @@ static int pci_remap_base(struct pci_dev *pcidev, unsigned int offset,
 	pcidev->resource[index].start = address;
 	pcidev->resource[index].end	  = address + size - 1;
 
-	if (request_resource(root, &pcidev->resource[index]) != NULL)
-	{
+	if (request_resource(root, &pcidev->resource[index]) != NULL) {
 		printk(KERN_ERR "pci remap conflict!! 0x%x\n", address);
-		return (-1);
+		return -1;
 	}
 #endif
 
-	return (0);
+	return 0;
 }
 
 static int init_mp_dev(struct pci_dev *pcidev, mppcibrd_t brd)
@@ -2890,18 +2842,18 @@ static int init_mp_dev(struct pci_dev *pcidev, mppcibrd_t brd)
 	}
 
 	/* codes which is specific to each board*/
-	switch(brd.device_id){
-	case PCI_DEVICE_ID_MP1 :
-	case PCIE_DEVICE_ID_MP1 :
-	case PCIE_DEVICE_ID_MP1E :
-	case PCIE_DEVICE_ID_GT_MP1 :
+	switch (brd.device_id) {
+	case PCI_DEVICE_ID_MP1:
+	case PCIE_DEVICE_ID_MP1:
+	case PCIE_DEVICE_ID_MP1E:
+	case PCIE_DEVICE_ID_GT_MP1:
 		sbdev->nr_ports = 1;
 		break;
-	case PCI_DEVICE_ID_MP2 :
-	case PCIE_DEVICE_ID_MP2 :
-	case PCIE_DEVICE_ID_GT_MP2 :
-	case PCIE_DEVICE_ID_MP2B :
-	case PCIE_DEVICE_ID_MP2E :
+	case PCI_DEVICE_ID_MP2:
+	case PCIE_DEVICE_ID_MP2:
+	case PCIE_DEVICE_ID_GT_MP2:
+	case PCIE_DEVICE_ID_MP2B:
+	case PCIE_DEVICE_ID_MP2E:
 		sbdev->nr_ports = 2;
 
 		/* serial base address remap */
@@ -2912,17 +2864,17 @@ static int init_mp_dev(struct pci_dev *pcidev, mppcibrd_t brd)
 			pci_remap_base(pcidev, PCI_BASE_ADDRESS_1, prev_port_addr + 8, 8);
 		}
 		break;
-	case PCI_DEVICE_ID_MP4 :
-	case PCI_DEVICE_ID_MP4A :
-	case PCIE_DEVICE_ID_MP4 :
-	case PCI_DEVICE_ID_GT_MP4 :
-	case PCI_DEVICE_ID_GT_MP4A :
-	case PCIE_DEVICE_ID_GT_MP4 :
-	case PCI_DEVICE_ID_MP4M :
-	case PCIE_DEVICE_ID_MP4B :
+	case PCI_DEVICE_ID_MP4:
+	case PCI_DEVICE_ID_MP4A:
+	case PCIE_DEVICE_ID_MP4:
+	case PCI_DEVICE_ID_GT_MP4:
+	case PCI_DEVICE_ID_GT_MP4A:
+	case PCIE_DEVICE_ID_GT_MP4:
+	case PCI_DEVICE_ID_MP4M:
+	case PCIE_DEVICE_ID_MP4B:
 		sbdev->nr_ports = 4;
 
-		if(sbdev->revision == 0x91){
+		if(sbdev->revision == 0x91) {
 			sbdev->reserved_addr[0] = pcidev->resource[0].start & PCI_BASE_ADDRESS_IO_MASK;
 			outb(0x03 , sbdev->reserved_addr[0] + 0x01);
 			outb(0x03 , sbdev->reserved_addr[0] + 0x02);
@@ -2944,10 +2896,10 @@ static int init_mp_dev(struct pci_dev *pcidev, mppcibrd_t brd)
 			pci_remap_base(pcidev, PCI_BASE_ADDRESS_3, prev_port_addr + 24, 8);
 		}
 		break;
-	case PCI_DEVICE_ID_MP6 :
-	case PCI_DEVICE_ID_MP6A :
-	case PCI_DEVICE_ID_GT_MP6 :
-	case PCI_DEVICE_ID_GT_MP6A :
+	case PCI_DEVICE_ID_MP6:
+	case PCI_DEVICE_ID_MP6A:
+	case PCI_DEVICE_ID_GT_MP6:
+	case PCI_DEVICE_ID_GT_MP6A:
 		sbdev->nr_ports = 6;
 
 		/* SB16C1053APCI */
@@ -2960,17 +2912,17 @@ static int init_mp_dev(struct pci_dev *pcidev, mppcibrd_t brd)
 			pci_remap_base(pcidev, PCI_BASE_ADDRESS_3, prev_port_addr + 32, 16);
 		}
 		break;
-	case PCI_DEVICE_ID_MP8 :
-	case PCIE_DEVICE_ID_MP8 :
-	case PCI_DEVICE_ID_GT_MP8 :
-	case PCIE_DEVICE_ID_GT_MP8 :
-	case PCIE_DEVICE_ID_MP8B :
+	case PCI_DEVICE_ID_MP8:
+	case PCIE_DEVICE_ID_MP8:
+	case PCI_DEVICE_ID_GT_MP8:
+	case PCIE_DEVICE_ID_GT_MP8:
+	case PCIE_DEVICE_ID_MP8B:
 		sbdev->nr_ports = 8;
 		break;
-	case PCI_DEVICE_ID_MP32 :
-	case PCIE_DEVICE_ID_MP32 :
-	case PCI_DEVICE_ID_GT_MP32 :
-	case PCIE_DEVICE_ID_GT_MP32 :
+	case PCI_DEVICE_ID_MP32:
+	case PCIE_DEVICE_ID_MP32:
+	case PCI_DEVICE_ID_GT_MP32:
+	case PCIE_DEVICE_ID_GT_MP32:
 		{
 			int portnum_hex=0;
 			portnum_hex = inb(sbdev->option_reg_addr);
@@ -2978,7 +2930,7 @@ static int init_mp_dev(struct pci_dev *pcidev, mppcibrd_t brd)
 		}
 		break;
 #ifdef CONFIG_PARPORT_PC
-	case PCI_DEVICE_ID_MP2S1P :
+	case PCI_DEVICE_ID_MP2S1P:
 		sbdev->nr_ports = 2;
 
 		/* SB16C1053APCI */
@@ -2992,7 +2944,7 @@ static int init_mp_dev(struct pci_dev *pcidev, mppcibrd_t brd)
 		/* add PC compatible parallel port */
 		parport_pc_probe_port(pcidev->resource[2].start, pcidev->resource[3].start, PARPORT_IRQ_NONE, PARPORT_DMA_NONE, &pcidev->dev, 0);
 		break;
-	case PCI_DEVICE_ID_MP1P :
+	case PCI_DEVICE_ID_MP1P:
 		/* add PC compatible parallel port */
 		parport_pc_probe_port(pcidev->resource[2].start, pcidev->resource[3].start, PARPORT_IRQ_NONE, PARPORT_DMA_NONE, &pcidev->dev, 0);
 		break;
@@ -3028,22 +2980,19 @@ static int __init multi_init(void)
 	if(fcr_count==0) {
 		for (i = 0; i < 256; i++)
 			fcr_arr[i] = 0x01;
-
 	}
 	if(deep_count==0) {
 		for (i = 0; i < 256; i++)
 			deep[i] = 1;
-
 	}
 	if(rtr_count==0) {
-                for (i = 0; i < 256; i++)
-                        rtr[i] = 0x10;
-        }
+		for (i = 0; i < 256; i++)
+			rtr[i] = 0x10;
+	}
 	if(ttr_count==0) {
-                for (i = 0; i < 256; i++)
-                        ttr[i] = 0x38;
-        }
-
+		for (i = 0; i < 256; i++)
+			ttr[i] = 0x38;
+	}
 
 	for( i = 0; i < mp_nrpcibrds; i++)
 	{
@@ -3053,14 +3002,15 @@ static int __init multi_init(void)
 //			if (mp_pciboards[i].device_id & 0x0800)
 			{
 				int status;
-	        		pci_disable_device(dev);
-	        		status = pci_enable_device(dev);
+
+				pci_disable_device(dev);
+				status = pci_enable_device(dev);
 
 				if (status != 0) {
 					pr_err("Multiport Board Enable Fail !\n\n");
 					status = -ENXIO;
 					return status;
-           			}
+				}
 			}
 
 			init_mp_dev(dev, mp_pciboards[i]);
diff --git a/drivers/staging/sb105x/sb_pci_mp.h b/drivers/staging/sb105x/sb_pci_mp.h
index 579dd83..6df1036 100644
--- a/drivers/staging/sb105x/sb_pci_mp.h
+++ b/drivers/staging/sb105x/sb_pci_mp.h
@@ -126,7 +126,7 @@
 
 
 /* serial interface */
-#define RS232		1 
+#define RS232		1
 #define RS422PTP	2
 #define RS422MD		3
 #define RS485NE		4
@@ -134,21 +134,19 @@
 
 #define serial_inp(up, offset)      serial_in(up, offset)
 #define serial_outp(up, offset, value)  serial_out(up, offset, value)
-	
+
 #define PASS_LIMIT  256
 #define is_real_interrupt(irq)  ((irq) != 0)
 
 #define PROBE_ANY   (~0)
 
 static DEFINE_MUTEX(mp_mutex);
-#define MP_MUTEX_LOCK(x) mutex_lock(&(x)) 
-#define MP_MUTEX_UNLOCK(x) mutex_unlock(&(x)) 
-#define MP_STATE_LOCK(x) mutex_lock(&((x)->mutex)) 
-#define MP_STATE_UNLOCK(x) mutex_unlock(&((x)->mutex)) 
-        
+#define MP_MUTEX_LOCK(x) mutex_lock(&(x))
+#define MP_MUTEX_UNLOCK(x) mutex_unlock(&(x))
+#define MP_STATE_LOCK(x) mutex_lock(&((x)->mutex))
+#define MP_STATE_UNLOCK(x) mutex_unlock(&((x)->mutex))
 
 #define UART_LSR_SPECIAL    0x1E
-        
 #define HIGH_BITS_OFFSET        ((sizeof(long)-sizeof(int))*8)
 #define uart_users(state)       ((state)->count + ((state)->info ? (state)->info->blocked_open : 0))
 
@@ -179,92 +177,86 @@ static DEFINE_MUTEX(mp_mutex);
 
 
 struct mp_device_t {
-        unsigned short  device_id;
-        unsigned char   revision;
-        char            *name;
-        unsigned long   uart_access_addr;
-        unsigned long   option_reg_addr;
-        unsigned long   reserved_addr[4];
-        int             irq;
-        int             nr_ports;
-        int             poll_type;
+	unsigned short  device_id;
+	unsigned char   revision;
+	char            *name;
+	unsigned long   uart_access_addr;
+	unsigned long   option_reg_addr;
+	unsigned long   reserved_addr[4];
+	int             irq;
+	int             nr_ports;
+	int             poll_type;
 };
 
 typedef struct mppcibrd {
-        char            *name;
-        unsigned short  vendor_id;
-        unsigned short  device_id;
+	char            *name;
+	unsigned short  vendor_id;
+	unsigned short  device_id;
 } mppcibrd_t;
 
 static mppcibrd_t mp_pciboards[] = {
 
-        { "Multi-1 PCI", PCI_VENDOR_ID_MULTIPORT , PCI_DEVICE_ID_MP1} ,
-        { "Multi-2 PCI", PCI_VENDOR_ID_MULTIPORT , PCI_DEVICE_ID_MP2} ,
-        { "Multi-4 PCI", PCI_VENDOR_ID_MULTIPORT , PCI_DEVICE_ID_MP4} ,
-        { "Multi-4 PCI", PCI_VENDOR_ID_MULTIPORT , PCI_DEVICE_ID_MP4A} ,
-        { "Multi-6 PCI", PCI_VENDOR_ID_MULTIPORT , PCI_DEVICE_ID_MP6} ,
-        { "Multi-6 PCI", PCI_VENDOR_ID_MULTIPORT , PCI_DEVICE_ID_MP6A} ,
-        { "Multi-8 PCI", PCI_VENDOR_ID_MULTIPORT , PCI_DEVICE_ID_MP8} ,
-        { "Multi-32 PCI", PCI_VENDOR_ID_MULTIPORT , PCI_DEVICE_ID_MP32} ,
-
-        { "Multi-1P PCI", PCI_VENDOR_ID_MULTIPORT , PCI_DEVICE_ID_MP1P} ,
-        { "Multi-2S1P PCI", PCI_VENDOR_ID_MULTIPORT , PCI_DEVICE_ID_MP2S1P} ,
-
-        { "Multi-4(GT) PCI", PCI_VENDOR_ID_MULTIPORT , PCI_DEVICE_ID_GT_MP4} ,
-        { "Multi-4(GT) PCI", PCI_VENDOR_ID_MULTIPORT , PCI_DEVICE_ID_GT_MP4A} ,
-        { "Multi-6(GT) PCI", PCI_VENDOR_ID_MULTIPORT , PCI_DEVICE_ID_GT_MP6} ,
-        { "Multi-6(GT) PCI", PCI_VENDOR_ID_MULTIPORT , PCI_DEVICE_ID_GT_MP6A} ,
-        { "Multi-8(GT) PCI", PCI_VENDOR_ID_MULTIPORT , PCI_DEVICE_ID_GT_MP8} ,
-        { "Multi-32(GT) PCI", PCI_VENDOR_ID_MULTIPORT , PCI_DEVICE_ID_GT_MP32} ,
-
-        { "Multi-1 PCIe", PCI_VENDOR_ID_MULTIPORT , PCIE_DEVICE_ID_MP1} ,
-        { "Multi-2 PCIe", PCI_VENDOR_ID_MULTIPORT , PCIE_DEVICE_ID_MP2} ,
-        { "Multi-4 PCIe", PCI_VENDOR_ID_MULTIPORT , PCIE_DEVICE_ID_MP4} ,
-        { "Multi-8 PCIe", PCI_VENDOR_ID_MULTIPORT , PCIE_DEVICE_ID_MP8} ,
-        { "Multi-32 PCIe", PCI_VENDOR_ID_MULTIPORT , PCIE_DEVICE_ID_MP32} ,
-
-        { "Multi-1 PCIe E", PCI_VENDOR_ID_MULTIPORT , PCIE_DEVICE_ID_MP1E} ,
-        { "Multi-2 PCIe E", PCI_VENDOR_ID_MULTIPORT , PCIE_DEVICE_ID_MP2E} ,
-        { "Multi-2 PCIe B", PCI_VENDOR_ID_MULTIPORT , PCIE_DEVICE_ID_MP2B} ,
-        { "Multi-4 PCIe B", PCI_VENDOR_ID_MULTIPORT , PCIE_DEVICE_ID_MP4B} ,
-        { "Multi-8 PCIe B", PCI_VENDOR_ID_MULTIPORT , PCIE_DEVICE_ID_MP8B} ,
-
-        { "Multi-1(GT) PCIe", PCI_VENDOR_ID_MULTIPORT , PCIE_DEVICE_ID_GT_MP1} ,
-        { "Multi-2(GT) PCIe", PCI_VENDOR_ID_MULTIPORT , PCIE_DEVICE_ID_GT_MP2} ,
-        { "Multi-4(GT) PCIe", PCI_VENDOR_ID_MULTIPORT , PCIE_DEVICE_ID_GT_MP4} ,
-        { "Multi-8(GT) PCIe", PCI_VENDOR_ID_MULTIPORT , PCIE_DEVICE_ID_GT_MP8} ,
-        { "Multi-32(GT) PCIe", PCI_VENDOR_ID_MULTIPORT , PCIE_DEVICE_ID_GT_MP32} ,
-
-        { "Multi-4M PCI", PCI_VENDOR_ID_MULTIPORT , PCI_DEVICE_ID_MP4M} ,
+	{ "Multi-1 PCI", PCI_VENDOR_ID_MULTIPORT , PCI_DEVICE_ID_MP1} ,
+	{ "Multi-2 PCI", PCI_VENDOR_ID_MULTIPORT , PCI_DEVICE_ID_MP2} ,
+	{ "Multi-4 PCI", PCI_VENDOR_ID_MULTIPORT , PCI_DEVICE_ID_MP4} ,
+	{ "Multi-4 PCI", PCI_VENDOR_ID_MULTIPORT , PCI_DEVICE_ID_MP4A} ,
+	{ "Multi-6 PCI", PCI_VENDOR_ID_MULTIPORT , PCI_DEVICE_ID_MP6} ,
+	{ "Multi-6 PCI", PCI_VENDOR_ID_MULTIPORT , PCI_DEVICE_ID_MP6A} ,
+	{ "Multi-8 PCI", PCI_VENDOR_ID_MULTIPORT , PCI_DEVICE_ID_MP8} ,
+	{ "Multi-32 PCI", PCI_VENDOR_ID_MULTIPORT , PCI_DEVICE_ID_MP32} ,
+	{ "Multi-1P PCI", PCI_VENDOR_ID_MULTIPORT , PCI_DEVICE_ID_MP1P} ,
+	{ "Multi-2S1P PCI", PCI_VENDOR_ID_MULTIPORT , PCI_DEVICE_ID_MP2S1P} ,
+	{ "Multi-4(GT) PCI", PCI_VENDOR_ID_MULTIPORT , PCI_DEVICE_ID_GT_MP4} ,
+	{ "Multi-4(GT) PCI", PCI_VENDOR_ID_MULTIPORT , PCI_DEVICE_ID_GT_MP4A} ,
+	{ "Multi-6(GT) PCI", PCI_VENDOR_ID_MULTIPORT , PCI_DEVICE_ID_GT_MP6} ,
+	{ "Multi-6(GT) PCI", PCI_VENDOR_ID_MULTIPORT , PCI_DEVICE_ID_GT_MP6A} ,
+	{ "Multi-8(GT) PCI", PCI_VENDOR_ID_MULTIPORT , PCI_DEVICE_ID_GT_MP8} ,
+	{ "Multi-32(GT) PCI", PCI_VENDOR_ID_MULTIPORT , PCI_DEVICE_ID_GT_MP32} ,
+	{ "Multi-1 PCIe", PCI_VENDOR_ID_MULTIPORT , PCIE_DEVICE_ID_MP1} ,
+	{ "Multi-2 PCIe", PCI_VENDOR_ID_MULTIPORT , PCIE_DEVICE_ID_MP2} ,
+	{ "Multi-4 PCIe", PCI_VENDOR_ID_MULTIPORT , PCIE_DEVICE_ID_MP4} ,
+	{ "Multi-8 PCIe", PCI_VENDOR_ID_MULTIPORT , PCIE_DEVICE_ID_MP8} ,
+	{ "Multi-32 PCIe", PCI_VENDOR_ID_MULTIPORT , PCIE_DEVICE_ID_MP32} ,
+	{ "Multi-1 PCIe E", PCI_VENDOR_ID_MULTIPORT , PCIE_DEVICE_ID_MP1E} ,
+	{ "Multi-2 PCIe E", PCI_VENDOR_ID_MULTIPORT , PCIE_DEVICE_ID_MP2E} ,
+	{ "Multi-2 PCIe B", PCI_VENDOR_ID_MULTIPORT , PCIE_DEVICE_ID_MP2B} ,
+	{ "Multi-4 PCIe B", PCI_VENDOR_ID_MULTIPORT , PCIE_DEVICE_ID_MP4B} ,
+	{ "Multi-8 PCIe B", PCI_VENDOR_ID_MULTIPORT , PCIE_DEVICE_ID_MP8B} ,
+	{ "Multi-1(GT) PCIe", PCI_VENDOR_ID_MULTIPORT , PCIE_DEVICE_ID_GT_MP1} ,
+	{ "Multi-2(GT) PCIe", PCI_VENDOR_ID_MULTIPORT , PCIE_DEVICE_ID_GT_MP2} ,
+	{ "Multi-4(GT) PCIe", PCI_VENDOR_ID_MULTIPORT , PCIE_DEVICE_ID_GT_MP4} ,
+	{ "Multi-8(GT) PCIe", PCI_VENDOR_ID_MULTIPORT , PCIE_DEVICE_ID_GT_MP8} ,
+	{ "Multi-32(GT) PCIe", PCI_VENDOR_ID_MULTIPORT , PCIE_DEVICE_ID_GT_MP32} ,
+	{ "Multi-4M PCI", PCI_VENDOR_ID_MULTIPORT , PCI_DEVICE_ID_MP4M} ,
 };
 
 struct mp_port {
-        struct sb_uart_port port;
-
-        struct timer_list   timer;      /* "no irq" timer */
-        struct list_head    list;       /* ports on this IRQ */
-        unsigned int        capabilities;   /* port capabilities */
-        unsigned short      rev;
-        unsigned char       acr;
-        unsigned char       ier;
-        unsigned char       lcr;
-        unsigned char       mcr;
-        unsigned char       mcr_mask;   /* mask of user bits */
-        unsigned char       mcr_force;  /* mask of forced bits */
-        unsigned char       lsr_break_flag;
-
-        void            (*pm)(struct sb_uart_port *port,
-                        unsigned int state, unsigned int old);
-        struct mp_device_t *device;
-        unsigned long   interface_config_addr;
-        unsigned long   option_base_addr;
-        unsigned char   interface;
-        unsigned char   poll_type;
+	struct sb_uart_port port;
+
+	struct timer_list   timer;      /* "no irq" timer */
+	struct list_head    list;       /* ports on this IRQ */
+	unsigned int        capabilities;   /* port capabilities */
+	unsigned short      rev;
+	unsigned char       acr;
+	unsigned char       ier;
+	unsigned char       lcr;
+	unsigned char       mcr;
+	unsigned char       mcr_mask;   /* mask of user bits */
+	unsigned char       mcr_force;  /* mask of forced bits */
+	unsigned char       lsr_break_flag;
+
+	void            (*pm)(struct sb_uart_port *port,
+			unsigned int state, unsigned int old);
+	struct mp_device_t *device;
+	unsigned long   interface_config_addr;
+	unsigned long   option_base_addr;
+	unsigned char   interface;
+	unsigned char   poll_type;
 };
 
 struct irq_info {
-        spinlock_t      lock;
-        struct list_head    *head;
+	spinlock_t      lock;
+	struct list_head    *head;
 };
 
 struct sb105x_uart_config {
@@ -274,11 +266,8 @@ struct sb105x_uart_config {
 };
 
 static const struct sb105x_uart_config uart_config[] = {
-        { "unknown",    1,  0 },
-        { "16550A", 16, UART_CLEAR_FIFO | UART_USE_FIFO },
-        { "SB16C1050",    128,    UART_CLEAR_FIFO | UART_USE_FIFO | UART_STARTECH },
-        { "SB16C1050A",    128,    UART_CLEAR_FIFO | UART_USE_FIFO | UART_STARTECH },
+	{ "unknown",    1,  0 },
+	{ "16550A", 16, UART_CLEAR_FIFO | UART_USE_FIFO },
+	{ "SB16C1050",    128,    UART_CLEAR_FIFO | UART_USE_FIFO | UART_STARTECH },
+	{ "SB16C1050A",    128,    UART_CLEAR_FIFO | UART_USE_FIFO | UART_STARTECH },
 };
-
-
-
diff --git a/drivers/staging/sb105x/sb_ser_core.h b/drivers/staging/sb105x/sb_ser_core.h
index c8fb991..41111b0 100644
--- a/drivers/staging/sb105x/sb_ser_core.h
+++ b/drivers/staging/sb105x/sb_ser_core.h
@@ -205,119 +205,153 @@ void sb_uart_write_wakeup(struct sb_uart_port *port)
 void sb_uart_update_timeout(struct sb_uart_port *port, unsigned int cflag,
 			 unsigned int baud)
 {
-    unsigned int bits;
+	unsigned int bits;
 
-    switch (cflag & CSIZE)
-    {
-        case CS5:
-            bits = 7;
-            break;
+	switch (cflag & CSIZE) {
+	case CS5:
+		bits = 7;
+		break;
 
-        case CS6:
-            bits = 8;
-            break;
+	case CS6:
+		bits = 8;
+		break;
 
-        case CS7:
-            bits = 9;
-            break;
+	case CS7:
+		bits = 9;
+		break;
 
-        default:
-            bits = 10;
-            break;
-    }
-
-    if (cflag & CSTOPB)
-    {
-        bits++;
-    }
+	default:
+		bits = 10;
+		break;
+	}
 
-    if (cflag & PARENB)
-    {
-        bits++;
-    }
+	if (cflag & CSTOPB)
+		bits++;
 
-    bits = bits * port->fifosize;
+	if (cflag & PARENB)
+		bits++;
 
-    port->timeout = (HZ * bits) / baud + HZ/50;
+	bits = bits * port->fifosize;
+	port->timeout = (HZ * bits) / baud + HZ/50;
 }
+
 unsigned int sb_uart_get_baud_rate(struct sb_uart_port *port, struct MP_TERMIOS *termios,
 				struct MP_TERMIOS *old, unsigned int min,
 				unsigned int max)
 {
-        unsigned int try, baud, altbaud = 38400;
-        upf_t flags = port->flags & UPF_SPD_MASK;
-
-        if (flags == UPF_SPD_HI)
-                altbaud = 57600;
-        if (flags == UPF_SPD_VHI)
-                altbaud = 115200;
-        if (flags == UPF_SPD_SHI)
-                altbaud = 230400;
-        if (flags == UPF_SPD_WARP)
-                altbaud = 460800;
-
-        for (try = 0; try < 2; try++) {
-
-                switch (termios->c_cflag & (CBAUD | CBAUDEX))
-                {
-                	case B921600    : baud = 921600;    break;
-                	case B460800    : baud = 460800;    break;
-                	case B230400    : baud = 230400;    break;
-                	case B115200    : baud = 115200;    break;
-                	case B57600     : baud = 57600;     break;
-                	case B38400     : baud = 38400;     break;
-                	case B19200     : baud = 19200;     break;
-                	case B9600      : baud = 9600;      break;
-                	case B4800      : baud = 4800;      break;
-                	case B2400      : baud = 2400;      break;
-                	case B1800      : baud = 1800;      break;
-                	case B1200      : baud = 1200;      break;
-                	case B600       : baud = 600;       break;
-                	case B300       : baud = 300;       break;
-                        case B200       : baud = 200;       break;
-                	case B150       : baud = 150;       break;
-                	case B134       : baud = 134;       break;
-                	case B110       : baud = 110;       break;
-                	case B75        : baud = 75;        break;
-                	case B50        : baud = 50;        break;
-                	default         : baud = 9600;      break;
-                }
-
-                if (baud == 38400)
-                        baud = altbaud;
-
-                if (baud == 0)
-                        baud = 9600;
-
-                if (baud >= min && baud <= max)
-                        return baud;
-
-                termios->c_cflag &= ~CBAUD;
-                if (old) {
-                        termios->c_cflag |= old->c_cflag & CBAUD;
-                        old = NULL;
-                        continue;
-                }
-
-                termios->c_cflag |= B9600;
-        }
-
-        return 0;
+	unsigned int try, baud, altbaud = 38400;
+	upf_t flags = port->flags & UPF_SPD_MASK;
+
+	if (flags == UPF_SPD_HI)
+		altbaud = 57600;
+	if (flags == UPF_SPD_VHI)
+		altbaud = 115200;
+	if (flags == UPF_SPD_SHI)
+		altbaud = 230400;
+	if (flags == UPF_SPD_WARP)
+		altbaud = 460800;
+
+	for (try = 0; try < 2; try++) {
+
+		switch (termios->c_cflag & (CBAUD | CBAUDEX)) {
+		case B921600:
+			baud = 921600;
+			break;
+		case B460800:
+			baud = 460800;
+			break;
+		case B230400:
+			baud = 230400;
+			break;
+		case B115200:
+			baud = 115200;
+			break;
+		case B57600:
+			baud = 57600;
+			break;
+		case B38400:
+			baud = 38400;
+			break;
+		case B19200:
+			baud = 19200;
+			break;
+		case B9600:
+			baud = 9600;
+			break;
+		case B4800:
+			baud = 4800;
+			break;
+		case B2400:
+			baud = 2400;
+			break;
+		case B1800:
+			baud = 1800;
+			break;
+		case B1200:
+			baud = 1200;
+			break;
+		case B600:
+			baud = 600;
+			break;
+		case B300:
+			baud = 300;
+			break;
+		case B200:
+			baud = 200;
+			break;
+		case B150:
+			baud = 150;
+			break;
+		case B134:
+			baud = 134;
+			break;
+		case B110:
+			baud = 110;
+			break;
+		case B75:
+			baud = 75;
+			break;
+		case B50:
+			baud = 50;
+			break;
+		default:
+			baud = 9600;
+			break;
+		}
+
+		if (baud == 38400)
+			baud = altbaud;
+
+		if (baud == 0)
+			baud = 9600;
+
+		if (baud >= min && baud <= max)
+			return baud;
+
+		termios->c_cflag &= ~CBAUD;
+		if (old) {
+			termios->c_cflag |= old->c_cflag & CBAUD;
+			old = NULL;
+			continue;
+		}
+
+		termios->c_cflag |= B9600;
+	}
+
+	return 0;
 }
 unsigned int sb_uart_get_divisor(struct sb_uart_port *port, unsigned int baud)
 {
-        unsigned int quot;
+	unsigned int quot;
 
-        if (baud == 38400 && (port->flags & UPF_SPD_MASK) == UPF_SPD_CUST)
-                quot = port->custom_divisor;
-        else
-                quot = (port->uartclk + (8 * baud)) / (16 * baud);
+	if (baud == 38400 && (port->flags & UPF_SPD_MASK) == UPF_SPD_CUST)
+		quot = port->custom_divisor;
+	else
+		quot = (port->uartclk + (8 * baud)) / (16 * baud);
 
-        return quot;
+	return quot;
 }
 
-
-
 static inline int sb_uart_handle_break(struct sb_uart_port *port)
 {
 	struct sb_uart_info *info = port->info;
@@ -363,6 +397,3 @@ static inline void sb_uart_handle_cts_change(struct sb_uart_port *port, unsigned
 		}
 	}
 }
-
-
-
-- 
1.7.10.4

