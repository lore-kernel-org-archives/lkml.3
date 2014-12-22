Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854AbaLVB1a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 20:27:30 -0500
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:58783 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753715AbaLVB10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 20:27:26 -0500
From: Simone Weiss <simone.weiss@fau.de>
To: simone.weiss@fau.de
Cc: helene.gsaenger@studium.fau.de, linux-kernel@i4.cs.fau.de,
        lidza.louina@gmail.com, markh@compro.net, gregkh@linuxfoundation.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6/6] dgnc/dgnc_driver.h: checkpatch: fixed lines  over 80 characters
Date: Mon, 22 Dec 2014 02:17:34 +0100
Message-Id: <1419211054-3052-7-git-send-email-simone.weiss@fau.de>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1419211054-3052-1-git-send-email-simone.weiss@fau.de>
References: <1419211054-3052-1-git-send-email-simone.weiss@fau.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Simone Weiss <simone.weiss@fau.de>
Signed-off-by: Helene Gsaenger <helene.gsaenger@studium.fau.de>
---
 drivers/staging/dgnc/dgnc_driver.h | 71 +++++++++++++++++++++++---------------
 1 file changed, 44 insertions(+), 27 deletions(-)

diff --git a/drivers/staging/dgnc/dgnc_driver.h b/drivers/staging/dgnc/dgnc_driver.h
index a8157eb..7c3ecde 100644
--- a/drivers/staging/dgnc/dgnc_driver.h
+++ b/drivers/staging/dgnc/dgnc_driver.h
@@ -28,10 +28,12 @@
 #define __DGNC_DRIVER_H
 
 #include <linux/types.h>	/* To pick up the varions Linux types */
-#include <linux/tty.h>	  /* To pick up the various tty structs/defines */
+#include <linux/tty.h>		/* To pick up the various tty
+				 * structs/defines */
 #include <linux/interrupt.h>	/* For irqreturn_t type */
 
-#include "dgnc_types.h"		/* Additional types needed by the Digi header files */
+#include "dgnc_types.h"		/* Additional types needed by
+				 * the Digi header files */
 #include "digi.h"		/* Digi specific ioctl header */
 #include "dgnc_kcompat.h"	/* Kernel 2.4/2.6 compat includes */
 #include "dgnc_sysfs.h"		/* Support for SYSFS */
@@ -68,7 +70,8 @@
 #define PORT_NUM(dev)	((dev) & 0x7f)
 #define IS_PRINT(dev)	(((dev) & 0xff) >= 0x80)
 
-/* MAX number of stop characters we will send when our read queue is getting full */
+/* MAX number of stop characters we will send
+ * when our read queue is getting full */
 #define MAX_STOPS_SENT 5
 
 /* 4 extra for alignment play space */
@@ -173,12 +176,15 @@ struct dgnc_board {
 	uint		maxports;	/* MAX ports this board can handle */
 	unsigned char	dvid;		/* Board specific device id */
 	unsigned char	vpd[128];	/* VPD of board, if found */
-	unsigned char	serial_num[20];	/* Serial number of board, if found in VPD */
+	unsigned char	serial_num[20];	/* Serial number of board,
+					 * if found in VPD */
 
 	spinlock_t	bd_lock;	/* Used to protect board */
 
-	spinlock_t	bd_intr_lock;	/* Used to protect the poller tasklet and
-					 * the interrupt routine from each other.
+	spinlock_t	bd_intr_lock;	/*
+					 * Used to protect the poller tasklet
+					 * and the interrupt routine
+					 * from each other.
 					 */
 
 	uint		state;		/* State of card. */
@@ -197,14 +203,15 @@ struct dgnc_board {
 	ulong		membase;	/* Start of base memory of the card */
 	ulong		membase_end;	/* End of base memory of the card */
 
-	u8 __iomem		*re_map_membase;/* Remapped memory of the card */
+	u8 __iomem	*re_map_membase;/* Remapped memory of the card */
 
 	ulong		iobase;		/* Start of io base of the card */
 	ulong		iobase_end;	/* End of io base of the card */
 
 	uint		bd_uart_offset;	/* Space between each UART */
 
-	struct channel_t *channels[MAXPORTS]; /* array of pointers to our channels. */
+	struct channel_t *channels[MAXPORTS];	/* array of pointers
+						 * to our channels. */
 
 	struct tty_driver	SerialDriver;
 	char		SerialName[200];
@@ -219,10 +226,13 @@ struct dgnc_board {
 
 	uint		TtyRefCnt;
 
-	char		*flipbuf;	/* Our flip buffer, alloced if board is found */
+	char		*flipbuf;	/* Our flip buffer,
+					 * alloced if board is found */
 
-	u16		dpatype;	/* The board "type", as defined by DPA */
-	u16		dpastatus;	/* The board "status", as defined by DPA */
+	u16		dpatype;	/* The board "type",
+					 * as defined by DPA */
+	u16		dpastatus;	/* The board "status",
+					 * as defined by DPA */
 
 	/*
 	 *	Mgmt data.
@@ -315,7 +325,7 @@ struct un_t {
  ************************************************************************/
 struct channel_t {
 	int magic;			/* Channel Magic Number		*/
-	struct dgnc_board	*ch_bd;		/* Board structure pointer      */
+	struct dgnc_board	*ch_bd;	/* Board structure pointer      */
 	struct digi_t	ch_digi;	/* Transparent Print structure  */
 	struct un_t	ch_tun;		/* Terminal unit info	   */
 	struct un_t	ch_pun;		/* Printer unit info	    */
@@ -327,7 +337,8 @@ struct channel_t {
 	uint		ch_open_count;	/* open count			*/
 	uint		ch_flags;	/* Channel flags		*/
 
-	ulong		ch_close_delay;	/* How long we should drop RTS/DTR for */
+	ulong		ch_close_delay;	/* How long we should
+					 * drop RTS/DTR for */
 
 	ulong		ch_cpstime;	/* Time for CPS calculations    */
 
@@ -343,11 +354,15 @@ struct channel_t {
 
 	uint		ch_wopen;	/* Waiting for open process cnt */
 
-	unsigned char		ch_mostat;	/* FEP output modem status      */
-	unsigned char		ch_mistat;	/* FEP input modem status       */
+	unsigned char	ch_mostat;	/* FEP output modem status      */
+	unsigned char	ch_mistat;	/* FEP input modem status       */
 
-	struct neo_uart_struct __iomem *ch_neo_uart;	/* Pointer to the "mapped" UART struct */
-	struct cls_uart_struct __iomem *ch_cls_uart;	/* Pointer to the "mapped" UART struct */
+	struct neo_uart_struct __iomem *ch_neo_uart;	/* Pointer to the
+							 * "mapped" UART
+							 * struct */
+	struct cls_uart_struct __iomem *ch_cls_uart;	/* Pointer to the
+							 * "mapped" UART
+							 * struct */
 
 	unsigned char	ch_cached_lsr;	/* Cached value of the LSR register */
 
@@ -371,11 +386,12 @@ struct channel_t {
 
 	unsigned char		ch_r_watermark;	/* Receive Watermark */
 
-	ulong		ch_stop_sending_break;	/* Time we should STOP sending a break */
+	ulong		ch_stop_sending_break;	/* Time we should STOP
+						 * sending a break */
 
-	uint		ch_stops_sent;	/* How many times I have sent a stop character
-					 * to try to stop the other guy sending.
-					 */
+	uint		ch_stops_sent;	/* How many times I have sent a stop
+					 * character to try to stop the
+					 * other guy sending. */
 	ulong		ch_err_parity;	/* Count of parity errors on channel */
 	ulong		ch_err_frame;	/* Count of framing errors on channel */
 	ulong		ch_err_break;	/* Count of breaks on channel */
@@ -398,11 +414,12 @@ struct channel_t {
 /*
  * Our Global Variables.
  */
-extern uint		dgnc_Major;		/* Our driver/mgmt major	*/
-extern int		dgnc_poll_tick;		/* Poll interval - 20 ms	*/
-extern spinlock_t	dgnc_global_lock;	/* Driver global spinlock	*/
-extern uint		dgnc_NumBoards;		/* Total number of boards	*/
-extern struct dgnc_board	*dgnc_Board[MAXBOARDS];	/* Array of board structs	*/
-extern char		*dgnc_state_text[];	/* Array of state text		*/
+extern uint		dgnc_Major;		/* Our driver/mgmt major*/
+extern int		dgnc_poll_tick;		/* Poll interval - 20 ms*/
+extern spinlock_t	dgnc_global_lock;	/* Driver global spinlock*/
+extern uint		dgnc_NumBoards;		/* Total number of boards*/
+extern struct dgnc_board	*dgnc_Board[MAXBOARDS]; /* Array of
+							 * board structs*/
+extern char		*dgnc_state_text[];	/* Array of state text	*/
 
 #endif
-- 
1.9.1

