Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758104Ab3CSJyK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 05:54:10 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:5992 "EHLO smtp4.mundo-r.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758003Ab3CSJw0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 05:52:26 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap8CANk0SFFbdWObgWdsb2JhbABDxSKBWxYOAQEWJiiCJQEFGgEMUhBRVwYTiBiyMZAhjw4Hg0ADll+UDTs
X-IPAS-Result: Ap8CANk0SFFbdWObgWdsb2JhbABDxSKBWxYOAQEWJiiCJQEFGgEMUhBRVwYTiBiyMZAhjw4Hg0ADll+UDTs
X-IronPort-AV: E=Sophos;i="4.84,870,1355094000"; 
   d="scan'208";a="18790041"
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Subject: [PATCH 1/9] staging/sb105x: coding style fixes
Date: Tue, 19 Mar 2013 10:51:22 +0100
Message-Id: <1363686690-27090-2-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363686690-27090-1-git-send-email-siglesias@igalia.com>
References: <1363686690-27090-1-git-send-email-siglesias@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No change in the logic of the driver

Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/staging/sb105x/sb_pci_mp.c |  974 +++++++++++++++++-------------------
 1 file changed, 449 insertions(+), 525 deletions(-)

diff --git a/drivers/staging/sb105x/sb_pci_mp.c b/drivers/staging/sb105x/sb_pci_mp.c
index f75ee1d..660ec9c 100644
--- a/drivers/staging/sb105x/sb_pci_mp.c
+++ b/drivers/staging/sb105x/sb_pci_mp.c
@@ -141,25 +141,24 @@ static int sb1053a_get_interface(struct mp_port *mtpt, int port_num)
 	unsigned long option_base_addr = mtpt->option_base_addr;
 	unsigned int  interface = 0;
 
-	switch (port_num)
-	{
-		case 0:
-		case 1:
-			/* set GPO[1:0] = 00 */
-			outb(0x00, option_base_addr + MP_OPTR_GPODR);
-			break;
-		case 2:
-		case 3:
-			/* set GPO[1:0] = 01 */
-			outb(0x01, option_base_addr + MP_OPTR_GPODR);
-			break;
-		case 4:
-		case 5:
-			/* set GPO[1:0] = 10 */
-			outb(0x02, option_base_addr + MP_OPTR_GPODR);
-			break;
-		default:
-			break;
+	switch (port_num) {
+	case 0:
+	case 1:
+		/* set GPO[1:0] = 00 */
+		outb(0x00, option_base_addr + MP_OPTR_GPODR);
+		break;
+	case 2:
+	case 3:
+		/* set GPO[1:0] = 01 */
+		outb(0x01, option_base_addr + MP_OPTR_GPODR);
+		break;
+	case 4:
+	case 5:
+		/* set GPO[1:0] = 10 */
+		outb(0x02, option_base_addr + MP_OPTR_GPODR);
+		break;
+	default:
+		break;
 	}
 
 	port_num &= 0x1;
@@ -172,7 +171,7 @@ static int sb1053a_get_interface(struct mp_port *mtpt, int port_num)
 
 	return (interface);
 }
-		
+
 static int sb1054_get_register(struct sb_uart_port * port, int page, int reg)
 {
 	int ret = 0;
@@ -180,115 +179,112 @@ static int sb1054_get_register(struct sb_uart_port * port, int page, int reg)
 	unsigned int mcr = 0;
 	unsigned int tmp = 0;
 
-	if( page <= 0)
-	{
+	if (page <= 0) {
 		printk(" page 0 can not use this fuction\n");
 		return -1;
 	}
 
-	switch(page)
-	{
-		case 1:
-			lcr = SB105X_GET_LCR(port);
-			tmp = lcr | SB105X_LCR_DLAB;
-			SB105X_PUT_LCR(port, tmp);
-
-			tmp = SB105X_GET_LCR(port);
-
-			ret = SB105X_GET_REG(port,reg);
-			SB105X_PUT_LCR(port,lcr);
-			break;
-		case 2:
-			mcr = SB105X_GET_MCR(port);
-			tmp = mcr | SB105X_MCR_P2S;
-			SB105X_PUT_MCR(port,tmp);
-
-			ret = SB105X_GET_REG(port,reg);
-
-			SB105X_PUT_MCR(port,mcr);
-			break;
-		case 3:
-			lcr = SB105X_GET_LCR(port);
-			tmp = lcr | SB105X_LCR_BF;
-			SB105X_PUT_LCR(port,tmp);
-			SB105X_PUT_REG(port,SB105X_PSR,SB105X_PSR_P3KEY);
-
-			ret = SB105X_GET_REG(port,reg);
-
-			SB105X_PUT_LCR(port,lcr);
-			break;
-		case 4:
-			lcr = SB105X_GET_LCR(port);
-			tmp = lcr | SB105X_LCR_BF;
-			SB105X_PUT_LCR(port,tmp);
-			SB105X_PUT_REG(port,SB105X_PSR,SB105X_PSR_P4KEY);
-
-			ret = SB105X_GET_REG(port,reg);
-
-			SB105X_PUT_LCR(port,lcr);
-			break;
-		default:
-			printk(" error invalid page number \n");
-			return -1;
+	switch(page) {
+	case 1:
+		lcr = SB105X_GET_LCR(port);
+		tmp = lcr | SB105X_LCR_DLAB;
+		SB105X_PUT_LCR(port, tmp);
+
+		tmp = SB105X_GET_LCR(port);
+
+		ret = SB105X_GET_REG(port,reg);
+		SB105X_PUT_LCR(port,lcr);
+		break;
+	case 2:
+		mcr = SB105X_GET_MCR(port);
+		tmp = mcr | SB105X_MCR_P2S;
+		SB105X_PUT_MCR(port,tmp);
+
+		ret = SB105X_GET_REG(port,reg);
+
+		SB105X_PUT_MCR(port,mcr);
+		break;
+	case 3:
+		lcr = SB105X_GET_LCR(port);
+		tmp = lcr | SB105X_LCR_BF;
+		SB105X_PUT_LCR(port,tmp);
+		SB105X_PUT_REG(port,SB105X_PSR,SB105X_PSR_P3KEY);
+
+		ret = SB105X_GET_REG(port,reg);
+
+		SB105X_PUT_LCR(port,lcr);
+		break;
+	case 4:
+		lcr = SB105X_GET_LCR(port);
+		tmp = lcr | SB105X_LCR_BF;
+		SB105X_PUT_LCR(port,tmp);
+		SB105X_PUT_REG(port,SB105X_PSR,SB105X_PSR_P4KEY);
+
+		ret = SB105X_GET_REG(port,reg);
+
+		SB105X_PUT_LCR(port,lcr);
+		break;
+	default:
+		printk(" error invalid page number \n");
+		return -1;
 	}
 
 	return ret;
 }
 
 static int sb1054_set_register(struct sb_uart_port * port, int page, int reg, int value)
-{  
+{
 	int lcr = 0;
 	int mcr = 0;
 	int ret = 0;
 
-	if( page <= 0)
-	{
+	if (page <= 0) {
 		printk(" page 0 can not use this fuction\n");
 		return -1;
 	}
-	switch(page)
-	{
-		case 1:
-			lcr = SB105X_GET_LCR(port);
-			SB105X_PUT_LCR(port, lcr | SB105X_LCR_DLAB);
 
-			SB105X_PUT_REG(port,reg,value);
+	switch(page) {
+	case 1:
+		lcr = SB105X_GET_LCR(port);
+		SB105X_PUT_LCR(port, lcr | SB105X_LCR_DLAB);
 
-			SB105X_PUT_LCR(port, lcr);
-			ret = 1;
-			break;
-		case 2:
-			mcr = SB105X_GET_MCR(port);
-			SB105X_PUT_MCR(port, mcr | SB105X_MCR_P2S);
+		SB105X_PUT_REG(port,reg,value);
 
-			SB105X_PUT_REG(port,reg,value);
+		SB105X_PUT_LCR(port, lcr);
+		ret = 1;
+		break;
+	case 2:
+		mcr = SB105X_GET_MCR(port);
+		SB105X_PUT_MCR(port, mcr | SB105X_MCR_P2S);
 
-			SB105X_PUT_MCR(port, mcr);
-			ret = 1;
-			break;
-		case 3:
-			lcr = SB105X_GET_LCR(port);
-			SB105X_PUT_LCR(port, lcr | SB105X_LCR_BF);
-			SB105X_PUT_PSR(port, SB105X_PSR_P3KEY);
+		SB105X_PUT_REG(port,reg,value);
 
-			SB105X_PUT_REG(port,reg,value);
+		SB105X_PUT_MCR(port, mcr);
+		ret = 1;
+		break;
+	case 3:
+		lcr = SB105X_GET_LCR(port);
+		SB105X_PUT_LCR(port, lcr | SB105X_LCR_BF);
+		SB105X_PUT_PSR(port, SB105X_PSR_P3KEY);
 
-			SB105X_PUT_LCR(port, lcr);
-			ret = 1;
-			break;
-		case 4:
-			lcr = SB105X_GET_LCR(port);
-			SB105X_PUT_LCR(port, lcr | SB105X_LCR_BF);
-			SB105X_PUT_PSR(port, SB105X_PSR_P4KEY);
+		SB105X_PUT_REG(port,reg,value);
 
-			SB105X_PUT_REG(port,reg,value);
+		SB105X_PUT_LCR(port, lcr);
+		ret = 1;
+		break;
+	case 4:
+		lcr = SB105X_GET_LCR(port);
+		SB105X_PUT_LCR(port, lcr | SB105X_LCR_BF);
+		SB105X_PUT_PSR(port, SB105X_PSR_P4KEY);
 
-			SB105X_PUT_LCR(port, lcr);
-			ret = 1;
-			break;
-		default:
-			printk(" error invalid page number \n");
-			return -1;
+		SB105X_PUT_REG(port,reg,value);
+
+		SB105X_PUT_LCR(port, lcr);
+		ret = 1;
+		break;
+	default:
+		printk(" error invalid page number \n");
+		return -1;
 	}
 
 	return ret;
@@ -298,13 +294,11 @@ static int set_multidrop_mode(struct sb_uart_port *port, unsigned int mode)
 {
 	int mdr = SB105XA_MDR_NPS;
 
-	if (mode & MDMODE_ENABLE)
-	{
+	if (mode & MDMODE_ENABLE) {
 		mdr |= SB105XA_MDR_MDE;
 	}
 
-	if (1) //(mode & MDMODE_AUTO)
-	{
+	if (1) { //(mode & MDMODE_AUTO)
 		int efr = 0;
 		mdr |= SB105XA_MDR_AME;
 		efr = sb1054_get_register(port, PAGE_3, SB105X_EFR);
@@ -346,9 +340,9 @@ static void SendATCommand(struct mp_port * mtpt)
 	serial_outp(mtpt,UART_DLM,(Divisor & 0xff00)>>8); //baudrate is 4800
 
 
-	serial_outp(mtpt,UART_LCR,lineControl);	
+	serial_outp(mtpt,UART_LCR,lineControl);
 	serial_outp(mtpt,UART_LCR,0x03); // N-8-1
-	serial_outp(mtpt,UART_FCR,7); 
+	serial_outp(mtpt,UART_FCR,7);
 	serial_outp(mtpt,UART_MCR,0x3);
 	while(ch[i]){
 		while((serial_inp(mtpt,UART_LSR) & 0x60) !=0x60){
@@ -366,19 +360,15 @@ static int set_deep_fifo(struct sb_uart_port * port, int status)
 	afr_status = sb1054_get_register(port, PAGE_4, SB105X_AFR);
 
 	if(status == ENABLE)
-	{
 		afr_status |= SB105X_AFR_AFEN;
-	}
 	else
-	{
 		afr_status &= ~SB105X_AFR_AFEN;
-	}
-		
+
 	sb1054_set_register(port,PAGE_4,SB105X_AFR,afr_status);
-	sb1054_set_register(port,PAGE_4,SB105X_TTR,ttr[port->line]); 
-	sb1054_set_register(port,PAGE_4,SB105X_RTR,rtr[port->line]); 
+	sb1054_set_register(port,PAGE_4,SB105X_TTR,ttr[port->line]);
+	sb1054_set_register(port,PAGE_4,SB105X_RTR,rtr[port->line]);
 	afr_status = sb1054_get_register(port, PAGE_4, SB105X_AFR);
-		
+
 	return afr_status;
 }
 
@@ -387,35 +377,29 @@ static int get_device_type(int arg)
 	int ret;
         ret = inb(mp_devs[arg].option_reg_addr+MP_OPTR_DIR0);
         ret = (ret & 0xf0) >> 4;
-        switch (ret)
-        {
-               case DIR_UART_16C550:
-                    return PORT_16C55X;
-               case DIR_UART_16C1050:
-                    return PORT_16C105X;
-               case DIR_UART_16C1050A:
-               /*
-               if (mtpt->port.line < 2)
-               {
-                    return PORT_16C105XA;
-               }
-               else
-               {
-                   if (mtpt->device->device_id & 0x50)
-                   {
-                       return PORT_16C55X;
-                   }
-                   else
-                   {
-                       return PORT_16C105X;
-                   }
-               }*/
-               return PORT_16C105XA;
-               default:
-                    return PORT_UNKNOWN;
-        }
+        switch (ret) {
+	case DIR_UART_16C550:
+		return PORT_16C55X;
+	case DIR_UART_16C1050:
+		return PORT_16C105X;
+	case DIR_UART_16C1050A:
+#if 0
+		if (mtpt->port.line < 2) {
+			return PORT_16C105XA;
+		} else {
+			if (mtpt->device->device_id & 0x50)
+				return PORT_16C55X;
+			else
+				return PORT_16C105X;
 
+		}
+#endif
+		return PORT_16C105XA;
+	default:
+		return PORT_UNKNOWN;
+	}
 }
+
 static int get_deep_fifo(struct sb_uart_port * port)
 {
 	int afr_status = 0;
@@ -438,23 +422,22 @@ static int set_auto_rts(struct sb_uart_port *port, int status)
 	sb1054_set_register(port,PAGE_3,SB105X_EFR,efr_status);
 	efr_status = sb1054_get_register(port, PAGE_3, SB105X_EFR);
 #endif
-		
+
 //ATR
 	atr_status = sb1054_get_register(port, PAGE_3, SB105X_ATR);
-	switch(status)
-	{
-		case RS422PTP:
-			atr_status = (SB105X_ATR_TPS) | (SB105X_ATR_A80);
-			break;
-		case RS422MD:
-			atr_status = (SB105X_ATR_TPS) | (SB105X_ATR_TCMS) | (SB105X_ATR_A80);
-			break;
-		case RS485NE:
-			atr_status = (SB105X_ATR_RCMS) | (SB105X_ATR_TPS) | (SB105X_ATR_TCMS) | (SB105X_ATR_A80);
-			break;
-		case RS485ECHO:
-			atr_status = (SB105X_ATR_TPS) | (SB105X_ATR_TCMS) | (SB105X_ATR_A80);
-			break;
+	switch(status) {
+	case RS422PTP:
+		atr_status = (SB105X_ATR_TPS) | (SB105X_ATR_A80);
+		break;
+	case RS422MD:
+		atr_status = (SB105X_ATR_TPS) | (SB105X_ATR_TCMS) | (SB105X_ATR_A80);
+		break;
+	case RS485NE:
+		atr_status = (SB105X_ATR_RCMS) | (SB105X_ATR_TPS) | (SB105X_ATR_TCMS) | (SB105X_ATR_A80);
+		break;
+	case RS485ECHO:
+		atr_status = (SB105X_ATR_TPS) | (SB105X_ATR_TCMS) | (SB105X_ATR_A80);
+		break;
 	}
 
 	sb1054_set_register(port,PAGE_3,SB105X_ATR,atr_status);
@@ -534,7 +517,7 @@ static int mp_startup(struct sb_uart_state *state, int init_hw)
 			return -ENOMEM;
 
 		info->xmit.buf = (unsigned char *) page;
-			
+
 		uart_circ_clear(&info->xmit);
 	}
 
@@ -645,24 +628,23 @@ static int mp_write(struct tty_struct *tty, const unsigned char * buf, int count
 	struct circ_buf *circ;
 	int c, ret = 0;
 
-	if (!state || !state->info) {
+	if (!state || !state->info)
 		return -EL3HLT;
-	}
 
 	port = state->port;
 	circ = &state->info->xmit;
 
 	if (!circ->buf)
 		return 0;
-		
+
 	while (1) {
 		c = CIRC_SPACE_TO_END(circ->head, circ->tail, UART_XMIT_SIZE);
 		if (count < c)
 			c = count;
 		if (c <= 0)
 			break;
-	memcpy(circ->buf + circ->head, buf, c);
 
+		memcpy(circ->buf + circ->head, buf, c);
 		circ->head = (circ->head + c) & (UART_XMIT_SIZE - 1);
 		buf += c;
 		count -= c;
@@ -692,9 +674,8 @@ static void mp_flush_buffer(struct tty_struct *tty)
 	struct sb_uart_port *port;
 	unsigned long flags;
 
-	if (!state || !state->info) {
+	if (!state || !state->info)
 		return;
-	}
 
 	port = state->port;
 	spin_lock_irqsave(&port->lock, flags);
@@ -710,9 +691,9 @@ static void mp_send_xchar(struct tty_struct *tty, char ch)
 	struct sb_uart_port *port = state->port;
 	unsigned long flags;
 
-	if (port->ops->send_xchar)
+	if (port->ops->send_xchar) {
 		port->ops->send_xchar(port, ch);
-	else {
+	} else {
 		port->x_char = ch;
 		if (ch) {
 			spin_lock_irqsave(&port->lock, flags);
@@ -1094,138 +1075,129 @@ static int mp_ioctl(struct tty_struct *tty, unsigned int cmd, unsigned long arg)
 
 
 	switch (cmd) {
-		case TIOCSMULTIDROP:
-			/* set multi-drop mode enable or disable, and default operation mode is H/W mode */
-			if (info->port.type == PORT_16C105XA)
-			{
-				//arg &= ~0x6;
-				//state->port->mdmode = 0;
-				return set_multidrop_mode((struct sb_uart_port *)info, (unsigned int)arg);
-			}
-			ret = -ENOTSUPP;
-			break;
-		case GETDEEPFIFO:
-			ret = get_deep_fifo(state->port);
-			return ret;
-		case SETDEEPFIFO:
-			ret = set_deep_fifo(state->port,arg);
-			deep[state->port->line] = arg;
-			return ret;
-		case SETTTR:
-			if (info->port.type == PORT_16C105X || info->port.type == PORT_16C105XA){
-				ret = sb1054_set_register(state->port,PAGE_4,SB105X_TTR,arg);
-				ttr[state->port->line] = arg;
-			}
-			return ret;
-		case SETRTR:
-			if (info->port.type == PORT_16C105X || info->port.type == PORT_16C105XA){
-				ret = sb1054_set_register(state->port,PAGE_4,SB105X_RTR,arg);
-				rtr[state->port->line] = arg;
-			}
-			return ret;
-		case GETTTR:
-			if (info->port.type == PORT_16C105X || info->port.type == PORT_16C105XA){
-				ret = sb1054_get_register(state->port,PAGE_4,SB105X_TTR);
-			}
-			return ret;
-		case GETRTR:
-			if (info->port.type == PORT_16C105X || info->port.type == PORT_16C105XA){
-				ret = sb1054_get_register(state->port,PAGE_4,SB105X_RTR);
-			}
-			return ret;
-
-		case SETFCR:
-			if (info->port.type == PORT_16C105X || info->port.type == PORT_16C105XA){
-				ret = sb1054_set_register(state->port,PAGE_1,SB105X_FCR,arg);
-			}
-			else{
-				serial_out(info,2,arg);
-			}
-
-			return ret;
-		case TIOCSMDADDR:
-			/* set multi-drop address */
-			if (info->port.type == PORT_16C105XA)
-			{
-				state->port->mdmode |= MDMODE_ADDR;
-				return set_multidrop_addr((struct sb_uart_port *)info, (unsigned int)arg);
-			}
-			ret = -ENOTSUPP;
-			break;
+	case TIOCSMULTIDROP:
+		/* set multi-drop mode enable or disable, and default operation mode is H/W mode */
+		if (info->port.type == PORT_16C105XA)
+		{
+			//arg &= ~0x6;
+			//state->port->mdmode = 0;
+			return set_multidrop_mode((struct sb_uart_port *)info, (unsigned int)arg);
+		}
+		ret = -ENOTSUPP;
+		break;
+	case GETDEEPFIFO:
+		ret = get_deep_fifo(state->port);
+		return ret;
+	case SETDEEPFIFO:
+		ret = set_deep_fifo(state->port,arg);
+		deep[state->port->line] = arg;
+		return ret;
+	case SETTTR:
+		if (info->port.type == PORT_16C105X || info->port.type == PORT_16C105XA){
+			ret = sb1054_set_register(state->port,PAGE_4,SB105X_TTR,arg);
+			ttr[state->port->line] = arg;
+		}
+		return ret;
+	case SETRTR:
+		if (info->port.type == PORT_16C105X || info->port.type == PORT_16C105XA){
+			ret = sb1054_set_register(state->port,PAGE_4,SB105X_RTR,arg);
+			rtr[state->port->line] = arg;
+		}
+		return ret;
+	case GETTTR:
+		if (info->port.type == PORT_16C105X || info->port.type == PORT_16C105XA){
+			ret = sb1054_get_register(state->port,PAGE_4,SB105X_TTR);
+		}
+		return ret;
+	case GETRTR:
+		if (info->port.type == PORT_16C105X || info->port.type == PORT_16C105XA){
+			ret = sb1054_get_register(state->port,PAGE_4,SB105X_RTR);
+		}
+		return ret;
 
-		case TIOCGMDADDR:
-			/* set multi-drop address */
-			if ((info->port.type == PORT_16C105XA) && (state->port->mdmode & MDMODE_ADDR))
-			{
-				return get_multidrop_addr((struct sb_uart_port *)info);
-			}
-			ret = -ENOTSUPP;
-			break;
+	case SETFCR:
+		if (info->port.type == PORT_16C105X || info->port.type == PORT_16C105XA)
+			ret = sb1054_set_register(state->port,PAGE_1,SB105X_FCR,arg);
+		else
+			serial_out(info,2,arg);
 
-		case TIOCSENDADDR:
-			/* send address in multi-drop mode */
-			if ((info->port.type == PORT_16C105XA) 
-					&& (state->port->mdmode & (MDMODE_ENABLE)))
-			{
-				if (mp_chars_in_buffer(tty) > 0)
-				{
-					tty_wait_until_sent(tty, 0);
-				}
-				//while ((serial_in(info, UART_LSR) & 0x60) != 0x60);
-				//while (sb1054_get_register(state->port, PAGE_2, SB105X_TFCR) != 0);
-				while ((serial_in(info, UART_LSR) & 0x60) != 0x60);
-				serial_out(info, UART_SCR, (int)arg);
-			}
-			break;
+		return ret;
+	case TIOCSMDADDR:
+		/* set multi-drop address */
+		if (info->port.type == PORT_16C105XA)
+		{
+			state->port->mdmode |= MDMODE_ADDR;
+			return set_multidrop_addr((struct sb_uart_port *)info, (unsigned int)arg);
+		}
+		ret = -ENOTSUPP;
+		break;
+
+	case TIOCGMDADDR:
+		/* set multi-drop address */
+		if ((info->port.type == PORT_16C105XA) && (state->port->mdmode & MDMODE_ADDR))
+			return get_multidrop_addr((struct sb_uart_port *)info);
+		ret = -ENOTSUPP;
+		break;
+
+	case TIOCSENDADDR:
+		/* send address in multi-drop mode */
+		if ((info->port.type == PORT_16C105XA)
+				&& (state->port->mdmode & (MDMODE_ENABLE)))
+		{
+			if (mp_chars_in_buffer(tty) > 0)
+				tty_wait_until_sent(tty, 0);
+			//while ((serial_in(info, UART_LSR) & 0x60) != 0x60);
+			//while (sb1054_get_register(state->port, PAGE_2, SB105X_TFCR) != 0);
+			while ((serial_in(info, UART_LSR) & 0x60) != 0x60);
+			serial_out(info, UART_SCR, (int)arg);
+		}
+		break;
 
-		case TIOCGSERIAL:
-			ret = mp_get_info(state, (struct serial_struct *)arg);
-			break;
+	case TIOCGSERIAL:
+		ret = mp_get_info(state, (struct serial_struct *)arg);
+		break;
 
-		case TIOCSSERIAL:
-			ret = mp_set_info(state, (struct serial_struct *)arg);
-			break;
+	case TIOCSSERIAL:
+		ret = mp_set_info(state, (struct serial_struct *)arg);
+		break;
 
-		case TIOCSERCONFIG:
-			ret = mp_do_autoconfig(state);
-			break;
+	case TIOCSERCONFIG:
+		ret = mp_do_autoconfig(state);
+		break;
 
-		case TIOCSERGWILD: /* obsolete */
-		case TIOCSERSWILD: /* obsolete */
-			ret = 0;
-			break;
-			/* for Multiport */
-		case TIOCGNUMOFPORT: /* Get number of ports */
-			return NR_PORTS;
-		case TIOCGGETDEVID:
-			return mp_devs[arg].device_id;
-		case TIOCGGETREV:
-			return mp_devs[arg].revision;
-		case TIOCGGETNRPORTS:
-			return mp_devs[arg].nr_ports;
-		case TIOCGGETBDNO:
-			return NR_BOARD;
-		case TIOCGGETINTERFACE:
-			if (mp_devs[arg].revision == 0xc0)
-			{
-				/* for SB16C1053APCI */
-				return (sb1053a_get_interface(info, info->port.line));
-			}
-			else
-			{
-				return (inb(mp_devs[arg].option_reg_addr+MP_OPTR_IIR0+(state->port->line/8)));
-			}
-		case TIOCGGETPORTTYPE:
-			ret = get_device_type(arg);;
-			return ret;
-		case TIOCSMULTIECHO: /* set to multi-drop mode(RS422) or echo mode(RS485)*/
-			outb( ( inb(info->interface_config_addr) & ~0x03 ) | 0x01 ,  
-					info->interface_config_addr);
-			return 0;
-		case TIOCSPTPNOECHO: /* set to multi-drop mode(RS422) or echo mode(RS485) */
-			outb( ( inb(info->interface_config_addr) & ~0x03 )  ,             
-					info->interface_config_addr);
-			return 0;
+	case TIOCSERGWILD: /* obsolete */
+	case TIOCSERSWILD: /* obsolete */
+		ret = 0;
+		break;
+		/* for Multiport */
+	case TIOCGNUMOFPORT: /* Get number of ports */
+		return NR_PORTS;
+	case TIOCGGETDEVID:
+		return mp_devs[arg].device_id;
+	case TIOCGGETREV:
+		return mp_devs[arg].revision;
+	case TIOCGGETNRPORTS:
+		return mp_devs[arg].nr_ports;
+	case TIOCGGETBDNO:
+		return NR_BOARD;
+	case TIOCGGETINTERFACE:
+		if (mp_devs[arg].revision == 0xc0) {
+			/* for SB16C1053APCI */
+			return (sb1053a_get_interface(info, info->port.line));
+		} else {
+			return (inb(mp_devs[arg].option_reg_addr+MP_OPTR_IIR0+(state->port->line/8)));
+		}
+	case TIOCGGETPORTTYPE:
+		ret = get_device_type(arg);;
+		return ret;
+	case TIOCSMULTIECHO: /* set to multi-drop mode(RS422) or echo mode(RS485)*/
+		outb( ( inb(info->interface_config_addr) & ~0x03 ) | 0x01 ,
+				info->interface_config_addr);
+		return 0;
+	case TIOCSPTPNOECHO: /* set to multi-drop mode(RS422) or echo mode(RS485) */
+		outb( ( inb(info->interface_config_addr) & ~0x03 )  ,
+				info->interface_config_addr);
+		return 0;
 	}
 
 	if (ret != -ENOIOCTLCMD)
@@ -1237,13 +1209,13 @@ static int mp_ioctl(struct tty_struct *tty, unsigned int cmd, unsigned long arg)
 	}
 
 	switch (cmd) {
-		case TIOCMIWAIT:
-			ret = mp_wait_modem_status(state, arg);
-			break;
+	case TIOCMIWAIT:
+		ret = mp_wait_modem_status(state, arg);
+		break;
 
-		case TIOCGICOUNT:
-			ret = mp_get_count(state, (struct serial_icounter_struct *)arg);
-			break;
+	case TIOCGICOUNT:
+		ret = mp_get_count(state, (struct serial_icounter_struct *)arg);
+		break;
 	}
 
 	if (ret != -ENOIOCTLCMD)
@@ -1251,16 +1223,17 @@ static int mp_ioctl(struct tty_struct *tty, unsigned int cmd, unsigned long arg)
 
 	MP_STATE_LOCK(state);
 	switch (cmd) {
-		case TIOCSERGETLSR: /* Get line status register */
-			ret = mp_get_lsr_info(state, (unsigned int *)arg);
-			break;
+	case TIOCSERGETLSR: /* Get line status register */
+		ret = mp_get_lsr_info(state, (unsigned int *)arg);
+		break;
 
-		default: {
-					struct sb_uart_port *port = state->port;
-					if (port->ops->ioctl)
-						ret = port->ops->ioctl(port, cmd, arg);
-					break;
-				}
+	default:
+		{
+			struct sb_uart_port *port = state->port;
+			if (port->ops->ioctl)
+				ret = port->ops->ioctl(port, cmd, arg);
+			break;
+		}
 	}
 
 	MP_STATE_UNLOCK(state);
@@ -1365,7 +1338,7 @@ static void mp_close(struct tty_struct *tty, struct file *filp)
 	tty_ldisc_flush(tty);
 	tty->closing = 0;
 	state->info->tty = NULL;
-	if (state->info->blocked_open) 
+	if (state->info->blocked_open)
 	{
 		if (state->close_delay)
 		{
@@ -1761,7 +1734,7 @@ static int mp_register_driver(struct uart_driver *drv)
 	normal->major		= drv->major;
 	normal->minor_start	= drv->minor;
 
-	normal->num		= MAX_MP_PORT ; 
+	normal->num		= MAX_MP_PORT ;
 
 	normal->type		= TTY_DRIVER_TYPE_SERIAL;
 	normal->subtype		= SERIAL_TYPE_NORMAL;
@@ -1775,8 +1748,8 @@ static int mp_register_driver(struct uart_driver *drv)
 for (i = 0; i < drv->nr; i++) {
 	struct sb_uart_state *state = drv->state + i;
 
-	state->close_delay     = 500;   
-	state->closing_wait    = 30000; 
+	state->close_delay     = 500;
+	state->closing_wait    = 30000;
 
 	mutex_init(&state->mutex);
 	}
@@ -1929,7 +1902,7 @@ static void autoconfig(struct mp_port *mtpt, unsigned int probeflags)
 	DEBUG_AUTOCONF("iir=%d ", scratch);
 	if(mtpt->device->nr_ports >= 8)
 		b_ret = read_option_register(mtpt,(MP_OPTR_DIR0 + ((mtpt->port.line)/8)));
-	else	
+	else
 		b_ret = read_option_register(mtpt,MP_OPTR_DIR0);
 	u_type = (b_ret & 0xf0) >> 4;
 	if(mtpt->port.type == PORT_UNKNOWN )
@@ -1959,7 +1932,7 @@ static void autoconfig(struct mp_port *mtpt, unsigned int probeflags)
 					}
 				}
 				break;
-			default:	
+			default:
 				mtpt->port.type = PORT_UNKNOWN;
 				break;
 		}
@@ -2086,12 +2059,12 @@ static _INLINE_ void receive_chars(struct mp_port *mtpt, int *status )
 		{
 			ch = serial_inp(mtpt, UART_RX);
 		}
-		else if (lsr & UART_LSR_SPECIAL) 
+		else if (lsr & UART_LSR_SPECIAL)
 		{
 			flag = 0;
 			ch = serial_inp(mtpt, UART_RX);
 
-			if (lsr & UART_LSR_BI) 
+			if (lsr & UART_LSR_BI)
 			{
 
 				mtpt->port.icount.brk++;
@@ -2099,7 +2072,7 @@ static _INLINE_ void receive_chars(struct mp_port *mtpt, int *status )
 
 				if (sb_uart_handle_break(&mtpt->port))
 					goto ignore_char;
-			} 
+			}
 			if (lsr & UART_LSR_PE)
 			{
 				mtpt->port.icount.parity++;
@@ -2216,7 +2189,7 @@ static inline void multi_handle_port(struct mp_port *mtpt)
 		{
 			if (mtpt->interface >= RS485NE)
 				uart_set_mctrl(&mtpt->port, TIOCM_RTS);
-			
+
 			transmit_chars(mtpt);
 
 
@@ -2246,10 +2219,10 @@ static irqreturn_t multi_interrupt(int irq, void *dev_id)
 		unsigned int iir;
 
 		mtpt = list_entry(lhead, struct mp_port, list);
-		
+
 		iir = serial_in(mtpt, UART_IIR);
 		printk("intrrupt! port %d, iir 0x%x\n", mtpt->port.line, iir); //wlee
-		if (!(iir & UART_IIR_NO_INT)) 
+		if (!(iir & UART_IIR_NO_INT))
 		{
 			printk("interrupt handle\n");
 			spin_lock(&mtpt->port.lock);
@@ -2261,7 +2234,7 @@ static irqreturn_t multi_interrupt(int irq, void *dev_id)
 			end = lhead;
 
 		lhead = lhead->next;
-		if (lhead == iinfo->head && pass_counter++ > PASS_LIMIT) 
+		if (lhead == iinfo->head && pass_counter++ > PASS_LIMIT)
 		{
 			printk(KERN_ERR "multi: too much work for "
 					"irq%d\n", irq);
@@ -2325,9 +2298,8 @@ static void serial_unlink_irq_chain(struct mp_port *mtpt)
 	struct irq_info *i = irq_lists + mtpt->port.irq;
 
 	if (list_empty(i->head))
-	{
 		free_irq(mtpt->port.irq, i);
-	}
+
 	serial_do_unlink(i, mtpt);
 }
 
@@ -2453,9 +2425,7 @@ static int multi_startup(struct sb_uart_port *port)
 
 		mtpt->timer.data = (unsigned long)mtpt;
 		mod_timer(&mtpt->timer, jiffies + timeout);
-	} 
-	else 
-	{
+	} else {
 		retval = serial_link_irq_chain(mtpt);
 		if (retval)
 			return retval;
@@ -2470,7 +2440,7 @@ static int multi_startup(struct sb_uart_port *port)
 	multi_set_mctrl(&mtpt->port, mtpt->port.mctrl);
 	spin_unlock_irqrestore(&mtpt->port.lock, flags);
 
-	
+
 	mtpt->ier = UART_IER_RLSI | UART_IER_RDI;
 	serial_outp(mtpt, UART_IER, mtpt->ier);
 
@@ -2509,13 +2479,9 @@ static void multi_shutdown(struct sb_uart_port *port)
 	(void) serial_in(mtpt, UART_RX);
 
 	if ((!is_real_interrupt(mtpt->port.irq))||(mtpt->poll_type==TYPE_POLL))
-	{
 		del_timer_sync(&mtpt->timer);
-	}
 	else
-	{
 		serial_unlink_irq_chain(mtpt);
-	}
 }
 
 
@@ -2547,19 +2513,19 @@ static void multi_set_termios(struct sb_uart_port *port, struct MP_TERMIOS *term
 	unsigned int baud, quot;
 
 	switch (termios->c_cflag & CSIZE) {
-		case CS5:
-			cval = 0x00;
-			break;
-		case CS6:
-			cval = 0x01;
-			break;
-		case CS7:
-			cval = 0x02;
-			break;
-		default:
-		case CS8:
-			cval = 0x03;
-			break;
+	case CS5:
+		cval = 0x00;
+		break;
+	case CS6:
+		cval = 0x01;
+		break;
+	case CS7:
+		cval = 0x02;
+		break;
+	default:
+	case CS8:
+		cval = 0x03;
+		break;
 	}
 
 	if (termios->c_cflag & CSTOPB)
@@ -2646,20 +2612,16 @@ static void multi_set_termios(struct sb_uart_port *port, struct MP_TERMIOS *term
 		if (mtpt->interface != RS232)
 			set_auto_rts(port,mtpt->interface);
 
-	}
-	else
-	{
+	} else {
 		if (mtpt->interface >= RS485NE)
-		{
 			uart_clear_mctrl(&mtpt->port, TIOCM_RTS);
-		}
 	}
 
-	if(mtpt->device->device_id == PCI_DEVICE_ID_MP4M)
-	{
+	if(mtpt->device->device_id == PCI_DEVICE_ID_MP4M) {
 		SendATCommand(mtpt);
 		printk("SendATCommand\n");
-	}	
+	}
+
 	multi_set_mctrl(&mtpt->port, mtpt->port.mctrl);
 	spin_unlock_irqrestore(&mtpt->port.lock, flags);
 }
@@ -2680,9 +2642,7 @@ static void multi_pm(struct sb_uart_port *port, unsigned int state, unsigned int
 
 		if (mtpt->pm)
 			mtpt->pm(port, state, oldstate);
-	} 
-	else 
-	{
+	} else {
 		if (mtpt->capabilities & UART_STARTECH) {
 			serial_outp(mtpt, UART_LCR, 0xBF);
 			serial_outp(mtpt, UART_EFR, UART_EFR_ECB);
@@ -2789,7 +2749,7 @@ static struct uart_driver multi_reg = {
 	.dev_name       = "ttyMP",
 	.major          = SB_TTY_MP_MAJOR,
 	.minor          = 0,
-	.nr             = MAX_MP_PORT, 
+	.nr             = MAX_MP_PORT,
 	.cons           = NULL,
 };
 
@@ -2800,19 +2760,19 @@ static void __init multi_init_ports(void)
 	int i,j,k;
 	unsigned char osc;
 	unsigned char b_ret = 0;
-	static struct mp_device_t * sbdev; 
+	static struct mp_device_t * sbdev;
 
 	if (!first)
 		return;
 	first = 0;
 
-	mtpt = multi_ports; 
+	mtpt = multi_ports;
 
 	for (k=0;k<NR_BOARD;k++)
 	{
 		sbdev = &mp_devs[k];
 
-		for (i = 0; i < sbdev->nr_ports; i++, mtpt++) 
+		for (i = 0; i < sbdev->nr_ports; i++, mtpt++)
 		{
 			mtpt->device 		= sbdev;
 			mtpt->port.iobase   = sbdev->uart_access_addr + 8*i;
@@ -2834,19 +2794,16 @@ static void __init multi_init_ports(void)
 			osc = inb(sbdev->option_reg_addr + MP_OPTR_DIR0 + i/8) & 0x0F;
 			if (osc==0x0f)
 				osc = 0;
-			for(j=0;j<osc;j++)
+			for (j = 0; j < osc; j++)
 				mtpt->port.uartclk *= 2;
 			mtpt->port.flags    |= STD_COM_FLAGS | UPF_SHARE_IRQ ;
 			mtpt->port.iotype   = UPIO_PORT;
 			mtpt->port.ops      = &multi_pops;
 
-			if (sbdev->revision == 0xc0)
-			{
+			if (sbdev->revision == 0xc0) {
 				/* for SB16C1053APCI */
 				b_ret = sb1053a_get_interface(mtpt, i);
-			}
-			else
-			{
+			} else {
 				b_ret = read_option_register(mtpt,(MP_OPTR_IIR0 + i/8));
 				printk("IIR_RET = %x\n",b_ret);
 			}
@@ -2885,13 +2842,13 @@ static void __init multi_register_ports(struct uart_driver *drv)
  *  pcidev  - pci_dev structure address
  *  offset  - BAR offset PCI_BASE_ADDRESS_0 ~ PCI_BASE_ADDRESS_4
  *  address - address to be changed BAR value
- *  size	- size of address space 
+ *  size	- size of address space
  *
  * RETURNS
  *  If this function performs successful, it returns 0. Otherwise, It returns -1.
  */
-static int pci_remap_base(struct pci_dev *pcidev, unsigned int offset, 
-		unsigned int address, unsigned int size) 
+static int pci_remap_base(struct pci_dev *pcidev, unsigned int offset,
+		unsigned int address, unsigned int size)
 {
 #if 0
 	struct resource *root;
@@ -2929,18 +2886,14 @@ static int init_mp_dev(struct pci_dev *pcidev, mppcibrd_t brd)
 	sbdev->uart_access_addr = pcidev->resource[0].start & PCI_BASE_ADDRESS_IO_MASK;
 
 	/* check revision. The SB16C1053APCI's option i/o address is BAR4 */
-	if (sbdev->revision == 0xc0)
-	{
+	if (sbdev->revision == 0xc0) {
 		/* SB16C1053APCI */
 		sbdev->option_reg_addr = pcidev->resource[4].start & PCI_BASE_ADDRESS_IO_MASK;
-	}
-	else
-	{
+	} else {
 		sbdev->option_reg_addr = pcidev->resource[1].start & PCI_BASE_ADDRESS_IO_MASK;
 	}
-#if 1	
-	if (sbdev->revision == 0xc0)
-	{
+#if 1
+	if (sbdev->revision == 0xc0) {
 		outb(0x00, sbdev->option_reg_addr + MP_OPTR_GPOCR);
 		inb(sbdev->option_reg_addr + MP_OPTR_GPOCR);
 		outb(0x83, sbdev->option_reg_addr + MP_OPTR_GPOCR);
@@ -2949,151 +2902,137 @@ static int init_mp_dev(struct pci_dev *pcidev, mppcibrd_t brd)
 
 	sbdev->irq = pcidev->irq;
 
-	if ((brd.device_id & 0x0800) || !(brd.device_id &0xff00))
-	{
+	if ((brd.device_id & 0x0800) || !(brd.device_id &0xff00)) {
 		sbdev->poll_type = TYPE_INTERRUPT;
-	}
-	else
-	{
+	} else {
 		sbdev->poll_type = TYPE_POLL;
 	}
 
 	/* codes which is specific to each board*/
 	switch(brd.device_id){
-		case PCI_DEVICE_ID_MP1 :
-		case PCIE_DEVICE_ID_MP1 :
-		case PCIE_DEVICE_ID_MP1E :
-		case PCIE_DEVICE_ID_GT_MP1 :
-			sbdev->nr_ports = 1;
-			break;
-		case PCI_DEVICE_ID_MP2 :
-		case PCIE_DEVICE_ID_MP2 :
-		case PCIE_DEVICE_ID_GT_MP2 :
-		case PCIE_DEVICE_ID_MP2B :
-		case PCIE_DEVICE_ID_MP2E :
-			sbdev->nr_ports = 2;
-
-			/* serial base address remap */
-			if (sbdev->revision == 0xc0)
-			{
-				int prev_port_addr = 0;
+	case PCI_DEVICE_ID_MP1 :
+	case PCIE_DEVICE_ID_MP1 :
+	case PCIE_DEVICE_ID_MP1E :
+	case PCIE_DEVICE_ID_GT_MP1 :
+		sbdev->nr_ports = 1;
+		break;
+	case PCI_DEVICE_ID_MP2 :
+	case PCIE_DEVICE_ID_MP2 :
+	case PCIE_DEVICE_ID_GT_MP2 :
+	case PCIE_DEVICE_ID_MP2B :
+	case PCIE_DEVICE_ID_MP2E :
+		sbdev->nr_ports = 2;
+
+		/* serial base address remap */
+		if (sbdev->revision == 0xc0) {
+			int prev_port_addr = 0;
+
+			pci_read_config_dword(pcidev, PCI_BASE_ADDRESS_0, &prev_port_addr);
+			pci_remap_base(pcidev, PCI_BASE_ADDRESS_1, prev_port_addr + 8, 8);
+		}
+		break;
+	case PCI_DEVICE_ID_MP4 :
+	case PCI_DEVICE_ID_MP4A :
+	case PCIE_DEVICE_ID_MP4 :
+	case PCI_DEVICE_ID_GT_MP4 :
+	case PCI_DEVICE_ID_GT_MP4A :
+	case PCIE_DEVICE_ID_GT_MP4 :
+	case PCI_DEVICE_ID_MP4M :
+	case PCIE_DEVICE_ID_MP4B :
+		sbdev->nr_ports = 4;
+
+		if(sbdev->revision == 0x91){
+			sbdev->reserved_addr[0] = pcidev->resource[0].start & PCI_BASE_ADDRESS_IO_MASK;
+			outb(0x03 , sbdev->reserved_addr[0] + 0x01);
+			outb(0x03 , sbdev->reserved_addr[0] + 0x02);
+			outb(0x01 , sbdev->reserved_addr[0] + 0x20);
+			outb(0x00 , sbdev->reserved_addr[0] + 0x21);
+			request_region(sbdev->reserved_addr[0], 32, sbdev->name);
+			sbdev->uart_access_addr = pcidev->resource[1].start & PCI_BASE_ADDRESS_IO_MASK;
+			sbdev->option_reg_addr = pcidev->resource[2].start & PCI_BASE_ADDRESS_IO_MASK;
+		}
 
-				pci_read_config_dword(pcidev, PCI_BASE_ADDRESS_0, &prev_port_addr);
-				pci_remap_base(pcidev, PCI_BASE_ADDRESS_1, prev_port_addr + 8, 8);
-			}
-			break;
-		case PCI_DEVICE_ID_MP4 :
-		case PCI_DEVICE_ID_MP4A :
-		case PCIE_DEVICE_ID_MP4 :
-		case PCI_DEVICE_ID_GT_MP4 :
-		case PCI_DEVICE_ID_GT_MP4A :
-		case PCIE_DEVICE_ID_GT_MP4 :
-		case PCI_DEVICE_ID_MP4M :
-		case PCIE_DEVICE_ID_MP4B :
-			sbdev->nr_ports = 4;
-
-			if(sbdev->revision == 0x91){
-				sbdev->reserved_addr[0] = pcidev->resource[0].start & PCI_BASE_ADDRESS_IO_MASK;
-				outb(0x03 , sbdev->reserved_addr[0] + 0x01);
-				outb(0x03 , sbdev->reserved_addr[0] + 0x02);
-				outb(0x01 , sbdev->reserved_addr[0] + 0x20);
-				outb(0x00 , sbdev->reserved_addr[0] + 0x21);
-				request_region(sbdev->reserved_addr[0], 32, sbdev->name);
-				sbdev->uart_access_addr = pcidev->resource[1].start & PCI_BASE_ADDRESS_IO_MASK;
-				sbdev->option_reg_addr = pcidev->resource[2].start & PCI_BASE_ADDRESS_IO_MASK;
-			}
+		/* SB16C1053APCI */
+		if (sbdev->revision == 0xc0)
+		{
+			int prev_port_addr = 0;
 
-			/* SB16C1053APCI */
-			if (sbdev->revision == 0xc0)
-			{
-				int prev_port_addr = 0;
+			pci_read_config_dword(pcidev, PCI_BASE_ADDRESS_0, &prev_port_addr);
+			pci_remap_base(pcidev, PCI_BASE_ADDRESS_1, prev_port_addr + 8, 8);
+			pci_remap_base(pcidev, PCI_BASE_ADDRESS_2, prev_port_addr + 16, 8);
+			pci_remap_base(pcidev, PCI_BASE_ADDRESS_3, prev_port_addr + 24, 8);
+		}
+		break;
+	case PCI_DEVICE_ID_MP6 :
+	case PCI_DEVICE_ID_MP6A :
+	case PCI_DEVICE_ID_GT_MP6 :
+	case PCI_DEVICE_ID_GT_MP6A :
+		sbdev->nr_ports = 6;
 
-				pci_read_config_dword(pcidev, PCI_BASE_ADDRESS_0, &prev_port_addr);
-				pci_remap_base(pcidev, PCI_BASE_ADDRESS_1, prev_port_addr + 8, 8);
-				pci_remap_base(pcidev, PCI_BASE_ADDRESS_2, prev_port_addr + 16, 8);
-				pci_remap_base(pcidev, PCI_BASE_ADDRESS_3, prev_port_addr + 24, 8);
-			}
-			break;
-		case PCI_DEVICE_ID_MP6 :
-		case PCI_DEVICE_ID_MP6A :
-		case PCI_DEVICE_ID_GT_MP6 :
-		case PCI_DEVICE_ID_GT_MP6A :
-			sbdev->nr_ports = 6;
-
-			/* SB16C1053APCI */
-			if (sbdev->revision == 0xc0)
-			{
-				int prev_port_addr = 0;
+		/* SB16C1053APCI */
+		if (sbdev->revision == 0xc0) {
+			int prev_port_addr = 0;
 
-				pci_read_config_dword(pcidev, PCI_BASE_ADDRESS_0, &prev_port_addr);
-				pci_remap_base(pcidev, PCI_BASE_ADDRESS_1, prev_port_addr + 8, 8);
-				pci_remap_base(pcidev, PCI_BASE_ADDRESS_2, prev_port_addr + 16, 16);
-				pci_remap_base(pcidev, PCI_BASE_ADDRESS_3, prev_port_addr + 32, 16);
-			}
-			break;
-		case PCI_DEVICE_ID_MP8 :
-		case PCIE_DEVICE_ID_MP8 :
-		case PCI_DEVICE_ID_GT_MP8 :
-		case PCIE_DEVICE_ID_GT_MP8 :
-		case PCIE_DEVICE_ID_MP8B :
-			sbdev->nr_ports = 8;
-			break;
-		case PCI_DEVICE_ID_MP32 :
-		case PCIE_DEVICE_ID_MP32 :
-		case PCI_DEVICE_ID_GT_MP32 :
-		case PCIE_DEVICE_ID_GT_MP32 :
-			{
-				int portnum_hex=0;
-				portnum_hex = inb(sbdev->option_reg_addr);
-				sbdev->nr_ports = ((portnum_hex/16)*10) + (portnum_hex % 16);
-			}
-			break;
+			pci_read_config_dword(pcidev, PCI_BASE_ADDRESS_0, &prev_port_addr);
+			pci_remap_base(pcidev, PCI_BASE_ADDRESS_1, prev_port_addr + 8, 8);
+			pci_remap_base(pcidev, PCI_BASE_ADDRESS_2, prev_port_addr + 16, 16);
+			pci_remap_base(pcidev, PCI_BASE_ADDRESS_3, prev_port_addr + 32, 16);
+		}
+		break;
+	case PCI_DEVICE_ID_MP8 :
+	case PCIE_DEVICE_ID_MP8 :
+	case PCI_DEVICE_ID_GT_MP8 :
+	case PCIE_DEVICE_ID_GT_MP8 :
+	case PCIE_DEVICE_ID_MP8B :
+		sbdev->nr_ports = 8;
+		break;
+	case PCI_DEVICE_ID_MP32 :
+	case PCIE_DEVICE_ID_MP32 :
+	case PCI_DEVICE_ID_GT_MP32 :
+	case PCIE_DEVICE_ID_GT_MP32 :
+		{
+			int portnum_hex=0;
+			portnum_hex = inb(sbdev->option_reg_addr);
+			sbdev->nr_ports = ((portnum_hex/16)*10) + (portnum_hex % 16);
+		}
+		break;
 #ifdef CONFIG_PARPORT_PC
-		case PCI_DEVICE_ID_MP2S1P :
-			sbdev->nr_ports = 2;
+	case PCI_DEVICE_ID_MP2S1P :
+		sbdev->nr_ports = 2;
 
-			/* SB16C1053APCI */
-			if (sbdev->revision == 0xc0)
-			{
-				int prev_port_addr = 0;
+		/* SB16C1053APCI */
+		if (sbdev->revision == 0xc0) {
+			int prev_port_addr = 0;
 
-				pci_read_config_dword(pcidev, PCI_BASE_ADDRESS_0, &prev_port_addr);
-				pci_remap_base(pcidev, PCI_BASE_ADDRESS_1, prev_port_addr + 8, 8);
-			}
+			pci_read_config_dword(pcidev, PCI_BASE_ADDRESS_0, &prev_port_addr);
+			pci_remap_base(pcidev, PCI_BASE_ADDRESS_1, prev_port_addr + 8, 8);
+		}
 
-			/* add PC compatible parallel port */
-			parport_pc_probe_port(pcidev->resource[2].start, pcidev->resource[3].start, PARPORT_IRQ_NONE, PARPORT_DMA_NONE, &pcidev->dev, 0);
-			break;
-		case PCI_DEVICE_ID_MP1P :
-			/* add PC compatible parallel port */
-			parport_pc_probe_port(pcidev->resource[2].start, pcidev->resource[3].start, PARPORT_IRQ_NONE, PARPORT_DMA_NONE, &pcidev->dev, 0);
-			break;
+		/* add PC compatible parallel port */
+		parport_pc_probe_port(pcidev->resource[2].start, pcidev->resource[3].start, PARPORT_IRQ_NONE, PARPORT_DMA_NONE, &pcidev->dev, 0);
+		break;
+	case PCI_DEVICE_ID_MP1P :
+		/* add PC compatible parallel port */
+		parport_pc_probe_port(pcidev->resource[2].start, pcidev->resource[3].start, PARPORT_IRQ_NONE, PARPORT_DMA_NONE, &pcidev->dev, 0);
+		break;
 #endif
 	}
 
 	ret = request_region(sbdev->uart_access_addr, (8*sbdev->nr_ports), sbdev->name);
 
 	if (sbdev->revision == 0xc0)
-	{
 		ret = request_region(sbdev->option_reg_addr, 0x40, sbdev->name);
-	}
 	else
-	{
 		ret = request_region(sbdev->option_reg_addr, 0x20, sbdev->name);
-	}
-
 
 	NR_BOARD++;
 	NR_PORTS += sbdev->nr_ports;
 
 	/* Enable PCI interrupt */
 	addr = sbdev->option_reg_addr + MP_OPTR_IMR0;
-	for(j=0; j < (sbdev->nr_ports/8)+1; j++)
-	{
+	for ( j = 0; j < (sbdev->nr_ports/8)+1; j++) {
 		if (sbdev->poll_type == TYPE_INTERRUPT)
-		{
 			outb(0xff,addr +j);
-		}
 	}
 	sbdev++;
 
@@ -3105,62 +3044,47 @@ static int __init multi_init(void)
 	int ret, i;
 	struct pci_dev  *dev = NULL;
 
-	if(fcr_count==0)
-	{
-		for(i=0;i<256;i++)
-		{
+	if(fcr_count==0) {
+		for (i = 0; i < 256; i++)
 			fcr_arr[i] = 0x01;
-			
-		}
+
 	}
-	if(deep_count==0)
-	{
-		for(i=0;i<256;i++)
-		{
+	if(deep_count==0) {
+		for (i = 0; i < 256; i++)
 			deep[i] = 1;
-			
-		}
+
 	}
-	if(rtr_count==0)
-        {
-                for(i=0;i<256;i++)
-                {
+	if(rtr_count==0) {
+                for (i = 0; i < 256; i++)
                         rtr[i] = 0x10;
-                }
         }
-	if(ttr_count==0)
-        {
-                for(i=0;i<256;i++)
-                {
+	if(ttr_count==0) {
+                for (i = 0; i < 256; i++)
                         ttr[i] = 0x38;
-                }
         }
 
 
-printk("MULTI INIT\n");
-	for( i=0; i< mp_nrpcibrds; i++)
+	printk("MULTI INIT\n");
+	for( i = 0; i < mp_nrpcibrds; i++)
 	{
 
-		while( (dev = pci_get_device(mp_pciboards[i].vendor_id, mp_pciboards[i].device_id, dev) ) )
-
-		{
-printk("FOUND~~~\n");
+		while( (dev = pci_get_device(mp_pciboards[i].vendor_id, mp_pciboards[i].device_id, dev) ) ) {
+		printk("FOUND~~~\n");
 //	Cent OS bug fix
 //			if (mp_pciboards[i].device_id & 0x0800)
 			{
 				int status;
 	        		pci_disable_device(dev);
 	        		status = pci_enable_device(dev);
-            
-	   		     	if (status != 0)
-        			{ 
-               				printk("Multiport Board Enable Fail !\n\n");
+
+				if (status != 0) {
+					printk("Multiport Board Enable Fail !\n\n");
                				status = -ENXIO;
                 			return status;
            			}
 			}
 
-			init_mp_dev(dev, mp_pciboards[i]);	
+			init_mp_dev(dev, mp_pciboards[i]);
 		}
 	}
 
-- 
1.7.10.4

