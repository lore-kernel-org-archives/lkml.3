Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544Ab3LaOeq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 09:34:46 -0500
Received: from smtpfb2-g21.free.fr ([212.27.42.10]:53678 "EHLO
	smtpfb2-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753230Ab3LaOeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 09:34:44 -0500
From: =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@laposte.net>
To: driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
Cc: =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@laposte.net>,
        Lidza Louina <lidza.louina@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Scott H Kilau <Scott_Kilau@digi.com>, Eng.Linux@digi.com
Subject: [PATCH linux-next 2/2] staging: dgap: fix checkpatch warnings
Date: Tue, 31 Dec 2013 11:55:09 +0100
Message-Id: <1388487309-22319-2-git-send-email-vincent.stehle@laposte.net>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1388487309-22319-1-git-send-email-vincent.stehle@laposte.net>
References: <1388487309-22319-1-git-send-email-vincent.stehle@laposte.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove a few spaces at beginning and end of line. Remove single statement
braces {}. Remove two FSF boilerplate paragraphs.

Signed-off-by: Vincent Stehlé <vincent.stehle@laposte.net>
Cc: Lidza Louina <lidza.louina@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Scott H Kilau <Scott_Kilau@digi.com>
Cc: Eng.Linux@digi.com
---

Hi,

This can be seen with e.g. linux next-20131224 arm allmodconfig.

One checkpatch warning remains after those cleanups about a >80 chars line. As
this is about a printk format string, I hesitate to break it.

Best regards,

V.

 drivers/staging/dgap/dgap_fep5.c | 105 ++++++++++++++++++---------------------
 1 file changed, 47 insertions(+), 58 deletions(-)

diff --git a/drivers/staging/dgap/dgap_fep5.c b/drivers/staging/dgap/dgap_fep5.c
index 7deea2a..f75831a 100644
--- a/drivers/staging/dgap/dgap_fep5.c
+++ b/drivers/staging/dgap/dgap_fep5.c
@@ -6,16 +6,6 @@
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2, or (at your option)
  * any later version.
- * 
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY, EXPRESS OR IMPLIED; without even the 
- * implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR 
- * PURPOSE.  See the GNU General Public License for more details.
- * 
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
- *
  *
  *	NOTE TO LINUX KERNEL HACKERS:  DO NOT REFORMAT THIS CODE!
  *
@@ -100,7 +90,7 @@ void dgap_do_config_load(uchar __user *uaddr, int len)
 		to_addr += n;
 		from_addr += n;
 		n = U2BSIZE;
-        }
+	}
 
 	dgap_config_buf[orig_len] = '\0';
 
@@ -167,9 +157,9 @@ static int dgap_usertoboard(struct board_t *brd, char *to_addr, char __user *fro
 		/* increment counts */
 		len -= n;
 		to_addr += n;
-		from_addr += n;   
+		from_addr += n;
 		n = U2BSIZE;
-        }
+	}
 	return 0;
 }
 
@@ -196,7 +186,7 @@ void dgap_do_bios_load(struct board_t *brd, uchar __user *ubios, int len)
 	 */
 	for (i = 0; i < 16; i++)
 		writeb(0, addr + POSTAREA + i);
-                                
+
 	/*
 	 * Download bios
 	 */
@@ -365,7 +355,7 @@ static void dgap_do_reset_board(struct board_t *brd)
 	int i = 0;
 
 	if (!brd || (brd->magic != DGAP_BOARD_MAGIC) || !brd->re_map_membase || !brd->re_map_port) {
-		DPR_INIT(("dgap_do_reset_board() start. bad values. brd: %p mem: %p io: %p\n", 
+		DPR_INIT(("dgap_do_reset_board() start. bad values. brd: %p mem: %p io: %p\n",
 			brd, brd ? brd->re_map_membase : 0, brd ? brd->re_map_port : 0));
 		return;
 	}
@@ -471,7 +461,7 @@ static void dgap_get_vpd(struct board_t *brd)
 
 	/*
 	 * To get to the OTPROM memory, we have to send the boards base
-         * address or'ed with 1 into the PCI Rom Address location.
+	 * address or'ed with 1 into the PCI Rom Address location.
 	 */
 	magic = brd->membase | 0x01;
 	pci_write_config_dword(brd->pdev, PCI_ROM_ADDRESS, magic);
@@ -493,7 +483,7 @@ static void dgap_get_vpd(struct board_t *brd)
 		 * for the VPD offset.
 		 */
 		while (base_offset <= EXPANSION_ROM_SIZE) {
-                
+
 			/*
 			 * Lots of magic numbers here.
 			 *
@@ -552,7 +542,7 @@ static void dgap_get_vpd(struct board_t *brd)
  */
 void dgap_poll_tasklet(unsigned long data)
 {
-        struct board_t *bd = (struct board_t *) data;
+	struct board_t *bd = (struct board_t *) data;
 	ulong  lock_flags;
 	ulong  lock_flags2;
 	char *vaddr;
@@ -817,13 +807,13 @@ out:
  *
  *=======================================================================*/
 void dgap_cmdb(struct channel_t *ch, uchar cmd, uchar byte1, uchar byte2, uint ncmds)
-{                       
+{
 	char		*vaddr = NULL;
 	struct cm_t	*cm_addr = NULL;
 	uint		count;
 	uint		n;
 	u16		head;
-        u16		tail;
+	u16		tail;
 
 	if (!ch || ch->magic != DGAP_CHANNEL_MAGIC)
 		return;
@@ -834,7 +824,7 @@ void dgap_cmdb(struct channel_t *ch, uchar cmd, uchar byte1, uchar byte2, uint n
 	if (ch->ch_bd->state == BOARD_FAILED) {
 		DPR_CORE(("%s:%d board is in failed state.\n", __FILE__, __LINE__));
 		return;
-        }               
+	}
 
 	/*
 	 * Make sure the pointers are in range before
@@ -848,13 +838,13 @@ void dgap_cmdb(struct channel_t *ch, uchar cmd, uchar byte1, uchar byte2, uint n
 	cm_addr = (struct cm_t *) (vaddr + CMDBUF);
 	head = readw(&(cm_addr->cm_head));
 
-	/* 
+	/*
 	 * Forget it if pointers out of range.
 	 */
 	if (head >= (CMDMAX - CMDSTART) || (head & 03)) {
 		DPR_CORE(("%s:%d pointers out of range, failing board!\n", __FILE__, __LINE__));
 		ch->ch_bd->state = BOARD_FAILED;
-		return; 
+		return;
 	}
 
 	/*
@@ -870,7 +860,7 @@ void dgap_cmdb(struct channel_t *ch, uchar cmd, uchar byte1, uchar byte2, uint n
 	writew(head, &(cm_addr->cm_head));
 
 	/*
-	 * Wait if necessary before updating the head  
+	 * Wait if necessary before updating the head
 	 * pointer to limit the number of outstanding
 	 * commands to the FEP.   If the time spent waiting
 	 * is outlandish, declare the FEP dead.
@@ -891,14 +881,14 @@ void dgap_cmdb(struct channel_t *ch, uchar cmd, uchar byte1, uchar byte2, uint n
 			return;
 		}
 		udelay(10);
-	}  
+	}
 }
 
 
 /*=======================================================================
  *
  *      dgap_cmdw - Sends a 1 word command to the FEP.
- *      
+ *
  *              ch      - Pointer to channel structure.
  *              cmd     - Command to be sent.
  *              word    - Integer containing word to be sent.
@@ -937,7 +927,7 @@ void dgap_cmdw(struct channel_t *ch, uchar cmd, u16 word, uint ncmds)
 	cm_addr = (struct cm_t *) (vaddr + CMDBUF);
 	head = readw(&(cm_addr->cm_head));
 
-	/* 
+	/*
 	 * Forget it if pointers out of range.
 	 */
 	if (head >= (CMDMAX - CMDSTART) || (head & 03)) {
@@ -959,7 +949,7 @@ void dgap_cmdw(struct channel_t *ch, uchar cmd, u16 word, uint ncmds)
 
 	/*
 	 * Wait if necessary before updating the head
-	 * pointer to limit the number of outstanding  
+	 * pointer to limit the number of outstanding
 	 * commands to the FEP.   If the time spent waiting
 	 * is outlandish, declare the FEP dead.
 	 */
@@ -979,7 +969,7 @@ void dgap_cmdw(struct channel_t *ch, uchar cmd, u16 word, uint ncmds)
 			return;
 		}
 		udelay(10);
-	}  
+	}
 }
 
 
@@ -987,7 +977,7 @@ void dgap_cmdw(struct channel_t *ch, uchar cmd, u16 word, uint ncmds)
 /*=======================================================================
  *
  *      dgap_cmdw_ext - Sends a extended word command to the FEP.
- *      
+ *
  *              ch      - Pointer to channel structure.
  *              cmd     - Command to be sent.
  *              word    - Integer containing word to be sent.
@@ -1026,7 +1016,7 @@ static void dgap_cmdw_ext(struct channel_t *ch, u16 cmd, u16 word, uint ncmds)
 	cm_addr = (struct cm_t *) (vaddr + CMDBUF);
 	head = readw(&(cm_addr->cm_head));
 
-	/* 
+	/*
 	 * Forget it if pointers out of range.
 	 */
 	if (head >= (CMDMAX - CMDSTART) || (head & 03)) {
@@ -1061,7 +1051,7 @@ static void dgap_cmdw_ext(struct channel_t *ch, u16 cmd, u16 word, uint ncmds)
 
 	/*
 	 * Wait if necessary before updating the head
-	 * pointer to limit the number of outstanding  
+	 * pointer to limit the number of outstanding
 	 * commands to the FEP.   If the time spent waiting
 	 * is outlandish, declare the FEP dead.
 	 */
@@ -1081,7 +1071,7 @@ static void dgap_cmdw_ext(struct channel_t *ch, u16 cmd, u16 word, uint ncmds)
 			return;
 		}
 		udelay(10);
-	}  
+	}
 }
 
 
@@ -1103,7 +1093,7 @@ void dgap_wmove(struct channel_t *ch, char *buf, uint cnt)
 
 	if (!ch || ch->magic != DGAP_CHANNEL_MAGIC)
 		return;
- 
+
 	/*
 	 * Check parameters.
 	 */
@@ -1173,9 +1163,9 @@ uint dgap_get_custom_baud(struct channel_t *ch)
 
 	/*
 	 * Go get from fep mem, what the fep
-	 * believes the custom baud rate is. 
+	 * believes the custom baud rate is.
 	 */
-	offset = ((((*(unsigned short *)(vaddr + ECS_SEG)) << 4) +  
+	offset = ((((*(unsigned short *)(vaddr + ECS_SEG)) << 4) +
 		(ch->ch_portnum * 0x28) + LINE_SPEED));
 
 	value = readw(vaddr + offset);
@@ -1211,7 +1201,7 @@ void dgap_firmware_reset_port(struct channel_t *ch)
 
 
 /*=======================================================================
- *      
+ *
  *      dgap_param - Set Digi parameters.
  *
  *              struct tty_struct *     - TTY for port.
@@ -1245,7 +1235,7 @@ int dgap_param(struct tty_struct *tty)
 	if (!bd || bd->magic != DGAP_BOARD_MAGIC)
 		return -ENXIO;
 
-        bs = ch->ch_bs;
+	bs = ch->ch_bs;
 	if (!bs)
 		return -ENXIO;
 
@@ -1285,13 +1275,13 @@ int dgap_param(struct tty_struct *tty)
 
 		/*
 		 * Now go get from fep mem, what the fep
-		 * believes the custom baud rate is. 
+		 * believes the custom baud rate is.
 		 */
 		ch->ch_baud_info = ch->ch_custom_speed = dgap_get_custom_baud(ch);
 
 		DPR_PARAM(("param: Got %d speed\n", ch->ch_custom_speed));
 
-		/* Handle transition from B0 */   
+		/* Handle transition from B0 */
 		if (ch->ch_flags & CH_BAUD0) {
 			ch->ch_flags &= ~(CH_BAUD0);
 			ch->ch_mval |= (D_RTS(ch)|D_DTR(ch));
@@ -1353,7 +1343,7 @@ int dgap_param(struct tty_struct *tty)
 			baud = 0;
 		}
 
-		if (baud == 0)  
+		if (baud == 0)
 			baud = 9600;
 
 		ch->ch_baud_info = baud;
@@ -1426,7 +1416,7 @@ int dgap_param(struct tty_struct *tty)
 			dgap_cmdw(ch, SCFLAG, (u16) cflag, 0);
 		}
 
-		/* Handle transition from B0 */   
+		/* Handle transition from B0 */
 		if (ch->ch_flags & CH_BAUD0) {
 			ch->ch_flags &= ~(CH_BAUD0);
 			ch->ch_mval |= (D_RTS(ch)|D_DTR(ch));
@@ -1476,7 +1466,7 @@ int dgap_param(struct tty_struct *tty)
 	if (ch->ch_digi.digi_flags & RTSPACE)
 		hflow |= D_RTS(ch);
 	if (ch->ch_digi.digi_flags & DTRPACE)
-		hflow |= D_DTR(ch);  
+		hflow |= D_DTR(ch);
 	if (ch->ch_digi.digi_flags & CTSPACE)
 		hflow |= D_CTS(ch);
 	if (ch->ch_digi.digi_flags & DSRPACE)
@@ -1489,7 +1479,7 @@ int dgap_param(struct tty_struct *tty)
 
 		/* Okay to have channel and board locks held calling this */
 		dgap_cmdb(ch, SHFLOW, (uchar) hflow, 0xff, 0);
-        }
+	}
 
 
 	/*
@@ -1508,7 +1498,7 @@ int dgap_param(struct tty_struct *tty)
 	}
 
 	/*
-	 * Set modem control lines.  
+	 * Set modem control lines.
 	 */
 
 	mval ^= ch->ch_mforce & (mval ^ ch->ch_mval);
@@ -1525,12 +1515,12 @@ int dgap_param(struct tty_struct *tty)
 	}
 
 	/*
-	 * Read modem signals, and then call carrier function.             
+	 * Read modem signals, and then call carrier function.
 	 */
 	ch->ch_mistat = readb(&(bs->m_stat));
 	dgap_carrier(ch);
 
-	/*      
+	/*
 	 * Set the start and stop characters.
 	 */
 	if (ch->ch_startc != ch->ch_fepstartc || ch->ch_stopc != ch->ch_fepstopc) {
@@ -1543,7 +1533,7 @@ int dgap_param(struct tty_struct *tty)
 
 	/*
 	 * Set the Auxiliary start and stop characters.
-	 */     
+	 */
 	if (ch->ch_astartc != ch->ch_fepastartc || ch->ch_astopc != ch->ch_fepastopc) {
 		ch->ch_fepastartc = ch->ch_astartc;
 		ch->ch_fepastopc = ch->ch_astopc;
@@ -1610,7 +1600,7 @@ void dgap_parity_scan(struct channel_t *ch, unsigned char *cbuf, unsigned char *
 			} else {
 				/* save value examination in next state */
 				ch->pscan_savechar = c;
-				ch->pscan_state = 2; 
+				ch->pscan_state = 2;
 			}
 			break;
 
@@ -1638,7 +1628,7 @@ void dgap_parity_scan(struct channel_t *ch, unsigned char *cbuf, unsigned char *
 
 			count += 1;
 			ch->pscan_state = 0;
-		}       
+		}
 	}
 	*len = count;
 	DPR_PSCAN(("dgap_parity_scan finish\n"));
@@ -1722,9 +1712,8 @@ static int dgap_event(struct board_t *bd)
 		/*
 		 * Make sure the interrupt is valid.
 		 */
-                if ( port >= bd->nasync) {
+		if (port >= bd->nasync)
 			goto next;
-		}
 
 		if (!(reason & (IFMODEM | IFBREAK | IFTLW | IFTEM | IFDATA))) {
 			goto next;
@@ -1780,7 +1769,7 @@ static int dgap_event(struct board_t *bd)
 		}
 
 		/*
-		 * Process Modem change signals. 
+		 * Process Modem change signals.
 		 */
 		if (reason & IFMODEM) {
 			ch->ch_mistat = modem;
@@ -1814,7 +1803,7 @@ static int dgap_event(struct board_t *bd)
 				ch->ch_tun.un_flags &= ~UN_LOW;
 
 				if (ch->ch_tun.un_flags & UN_ISOPEN) {
-					if ((ch->ch_tun.un_tty->flags & 
+					if ((ch->ch_tun.un_tty->flags &
 					   (1 << TTY_DO_WRITE_WAKEUP)) &&
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,31)
 						ch->ch_tun.un_tty->ldisc->ops->write_wakeup)
@@ -1842,7 +1831,7 @@ static int dgap_event(struct board_t *bd)
 			if (ch->ch_pun.un_flags & UN_LOW) {
 				ch->ch_pun.un_flags &= ~UN_LOW;
 				if (ch->ch_pun.un_flags & UN_ISOPEN) {
-					if ((ch->ch_pun.un_tty->flags & 
+					if ((ch->ch_pun.un_tty->flags &
 					   (1 << TTY_DO_WRITE_WAKEUP)) &&
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,31)
 						ch->ch_pun.un_tty->ldisc->ops->write_wakeup)
@@ -1880,7 +1869,7 @@ static int dgap_event(struct board_t *bd)
 			if (ch->ch_tun.un_flags & UN_EMPTY) {
 				ch->ch_tun.un_flags &= ~UN_EMPTY;
 				if (ch->ch_tun.un_flags & UN_ISOPEN) {
-					if ((ch->ch_tun.un_tty->flags & 
+					if ((ch->ch_tun.un_tty->flags &
 					   (1 << TTY_DO_WRITE_WAKEUP)) &&
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,31)
 						ch->ch_tun.un_tty->ldisc->ops->write_wakeup)
@@ -1906,7 +1895,7 @@ static int dgap_event(struct board_t *bd)
 			if (ch->ch_pun.un_flags & UN_EMPTY) {
 				ch->ch_pun.un_flags &= ~UN_EMPTY;
 				if (ch->ch_pun.un_flags & UN_ISOPEN) {
-					if ((ch->ch_pun.un_tty->flags & 
+					if ((ch->ch_pun.un_tty->flags &
 					   (1 << TTY_DO_WRITE_WAKEUP)) &&
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,31)
 						ch->ch_pun.un_tty->ldisc->ops->write_wakeup)
@@ -1946,4 +1935,4 @@ next:
 	DGAP_UNLOCK(bd->bd_lock, lock_flags);
 
 	return 0;
-}               
+}
-- 
1.8.5.2

