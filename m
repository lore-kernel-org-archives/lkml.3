Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750936Ab3G0IP5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 04:15:57 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:41726 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820Ab3G0IPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 04:15:53 -0400
From: Alexandru Juncu <alexj@rosedu.org>
To: gregkh@linuxfoundation.org, jslaby@suse.cz
Cc: linux-kernel@vger.kernel.org, Alexandru Juncu <alexj@rosedu.org>
Subject: [PATCH] TTY: synclink: replace bitmasks add operation with OR operation.
Date: Sat, 27 Jul 2013 11:14:39 +0300
Message-Id: <1374912879-18916-1-git-send-email-alexj@rosedu.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Found with coccinelle, manually fixed and verified.

Signed-off-by: Alexandru Juncu <alexj@rosedu.org>
---
 drivers/tty/synclink.c |  130 ++++++++++++++++++++++++------------------------
 1 file changed, 65 insertions(+), 65 deletions(-)

diff --git a/drivers/tty/synclink.c b/drivers/tty/synclink.c
index 8eaf1ab..e1ce141 100644
--- a/drivers/tty/synclink.c
+++ b/drivers/tty/synclink.c
@@ -577,22 +577,22 @@ struct mgsl_struct {
 
 #define SICR_RXC_ACTIVE			BIT15
 #define SICR_RXC_INACTIVE		BIT14
-#define SICR_RXC			(BIT15+BIT14)
+#define SICR_RXC			(BIT15|BIT14)
 #define SICR_TXC_ACTIVE			BIT13
 #define SICR_TXC_INACTIVE		BIT12
-#define SICR_TXC			(BIT13+BIT12)
+#define SICR_TXC			(BIT13|BIT12)
 #define SICR_RI_ACTIVE			BIT11
 #define SICR_RI_INACTIVE		BIT10
-#define SICR_RI				(BIT11+BIT10)
+#define SICR_RI				(BIT11|BIT10)
 #define SICR_DSR_ACTIVE			BIT9
 #define SICR_DSR_INACTIVE		BIT8
-#define SICR_DSR			(BIT9+BIT8)
+#define SICR_DSR			(BIT9|BIT8)
 #define SICR_DCD_ACTIVE			BIT7
 #define SICR_DCD_INACTIVE		BIT6
-#define SICR_DCD			(BIT7+BIT6)
+#define SICR_DCD			(BIT7|BIT6)
 #define SICR_CTS_ACTIVE			BIT5
 #define SICR_CTS_INACTIVE		BIT4
-#define SICR_CTS			(BIT5+BIT4)
+#define SICR_CTS			(BIT5|BIT4)
 #define SICR_RCC_UNDERFLOW		BIT3
 #define SICR_DPLL_NO_SYNC		BIT2
 #define SICR_BRG1_ZERO			BIT1
@@ -1161,7 +1161,7 @@ static void mgsl_isr_receive_status( struct mgsl_struct *info )
 {
 	u16 status = usc_InReg( info, RCSR );
 
-	if ( debug_level >= DEBUG_LEVEL_ISR )	
+	if ( debug_level >= DEBUG_LEVEL_ISR )
 		printk("%s(%d):mgsl_isr_receive_status status=%04X\n",
 			__FILE__,__LINE__,status);
 			
@@ -1181,7 +1181,7 @@ static void mgsl_isr_receive_status( struct mgsl_struct *info )
  			(usc_InReg(info, RICR) & ~RXSTATUS_ABORT_RECEIVED));
  	}
 
-	if (status & (RXSTATUS_EXITED_HUNT + RXSTATUS_IDLE_RECEIVED)) {
+	if (status & (RXSTATUS_EXITED_HUNT | RXSTATUS_IDLE_RECEIVED)) {
 		if (status & RXSTATUS_EXITED_HUNT)
 			info->icount.exithunt++;
 		if (status & RXSTATUS_IDLE_RECEIVED)
@@ -1463,21 +1463,21 @@ static void mgsl_isr_receive_data( struct mgsl_struct *info )
 
 		/* get the status of the received byte */
 		status = usc_InReg(info, RCSR);
-		if ( status & (RXSTATUS_FRAMING_ERROR + RXSTATUS_PARITY_ERROR +
-				RXSTATUS_OVERRUN + RXSTATUS_BREAK_RECEIVED) )
+		if ( status & (RXSTATUS_FRAMING_ERROR | RXSTATUS_PARITY_ERROR |
+				RXSTATUS_OVERRUN | RXSTATUS_BREAK_RECEIVED) )
 			usc_UnlatchRxstatusBits(info,RXSTATUS_ALL);
 		
 		icount->rx++;
 		
 		flag = 0;
-		if ( status & (RXSTATUS_FRAMING_ERROR + RXSTATUS_PARITY_ERROR +
-				RXSTATUS_OVERRUN + RXSTATUS_BREAK_RECEIVED) ) {
-			printk("rxerr=%04X\n",status);					
+		if ( status & (RXSTATUS_FRAMING_ERROR | RXSTATUS_PARITY_ERROR |
+				RXSTATUS_OVERRUN | RXSTATUS_BREAK_RECEIVED) ) {
+			printk("rxerr=%04X\n",status);
 			/* update error statistics */
 			if ( status & RXSTATUS_BREAK_RECEIVED ) {
-				status &= ~(RXSTATUS_FRAMING_ERROR + RXSTATUS_PARITY_ERROR);
+				status &= ~(RXSTATUS_FRAMING_ERROR | RXSTATUS_PARITY_ERROR);
 				icount->brk++;
-			} else if (status & RXSTATUS_PARITY_ERROR) 
+			} else if (status & RXSTATUS_PARITY_ERROR)
 				icount->parity++;
 			else if (status & RXSTATUS_FRAMING_ERROR)
 				icount->frame++;
@@ -1488,7 +1488,7 @@ static void mgsl_isr_receive_data( struct mgsl_struct *info )
 				icount->overrun++;
 			}
 
-			/* discard char if tty control flags say so */					
+			/* discard char if tty control flags say so */
 			if (status & info->ignore_status_mask)
 				continue;
 				
@@ -1545,8 +1545,8 @@ static void mgsl_isr_misc( struct mgsl_struct *info )
 		usc_EnableReceiver(info,DISABLE_UNCONDITIONAL);
 		usc_DmaCmd(info, DmaCmd_ResetRxChannel);
 		usc_UnlatchRxstatusBits(info, RXSTATUS_ALL);
-		usc_ClearIrqPendingBits(info, RECEIVE_DATA + RECEIVE_STATUS);
-		usc_DisableInterrupts(info, RECEIVE_DATA + RECEIVE_STATUS);
+		usc_ClearIrqPendingBits(info, RECEIVE_DATA | RECEIVE_STATUS);
+		usc_DisableInterrupts(info, RECEIVE_DATA | RECEIVE_STATUS);
 
 		/* schedule BH handler to restart receiver */
 		info->pending_bh |= BH_RECEIVE;
@@ -1595,7 +1595,7 @@ static void mgsl_isr_receive_dma( struct mgsl_struct *info )
 	u16 status;
 	
 	/* clear interrupt pending and IUS bit for Rx DMA IRQ */
-	usc_OutDmaReg( info, CDIR, BIT9+BIT1 );
+	usc_OutDmaReg( info, CDIR, BIT9 | BIT1 );
 
 	/* Read the receive DMA status to identify interrupt type. */
 	/* This also clears the status bits. */
@@ -1639,7 +1639,7 @@ static void mgsl_isr_transmit_dma( struct mgsl_struct *info )
 	u16 status;
 
 	/* clear interrupt pending and IUS bit for Tx DMA IRQ */
-	usc_OutDmaReg(info, CDIR, BIT8+BIT0 );
+	usc_OutDmaReg(info, CDIR, BIT8 | BIT0 );
 
 	/* Read the transmit DMA status to identify interrupt type. */
 	/* This also clears the status bits. */
@@ -1832,8 +1832,8 @@ static void shutdown(struct mgsl_struct * info)
 	usc_DisableMasterIrqBit(info);
 	usc_stop_receiver(info);
 	usc_stop_transmitter(info);
-	usc_DisableInterrupts(info,RECEIVE_DATA + RECEIVE_STATUS +
-		TRANSMIT_DATA + TRANSMIT_STATUS + IO_PIN + MISC );
+	usc_DisableInterrupts(info,RECEIVE_DATA | RECEIVE_STATUS |
+		TRANSMIT_DATA | TRANSMIT_STATUS | IO_PIN | MISC );
 	usc_DisableDmaInterrupts(info,DICR_MASTER + DICR_TRANSMIT + DICR_RECEIVE);
 
 	/* Disable DMAEN (Port 7, Bit 14) */
@@ -1886,7 +1886,7 @@ static void mgsl_program_hw(struct mgsl_struct *info)
 	info->ri_chkcount = 0;
 	info->dsr_chkcount = 0;
 
-	usc_EnableStatusIrqs(info,SICR_CTS+SICR_DSR+SICR_DCD+SICR_RI);		
+	usc_EnableStatusIrqs(info,SICR_CTS+SICR_DSR+SICR_DCD+SICR_RI);
 	usc_EnableInterrupts(info, IO_PIN);
 	usc_get_serial_signals(info);
 		
@@ -2773,7 +2773,7 @@ static int mgsl_wait_event(struct mgsl_struct * info, int __user * mask_ptr)
 		if (!waitqueue_active(&info->event_wait_q)) {
 			/* disable enable exit hunt mode/idle rcvd IRQs */
 			usc_OutReg(info, RICR, usc_InReg(info,RICR) &
-				~(RXSTATUS_EXITED_HUNT + RXSTATUS_IDLE_RECEIVED));
+				~(RXSTATUS_EXITED_HUNT | RXSTATUS_IDLE_RECEIVED));
 		}
 		spin_unlock_irqrestore(&info->irq_spinlock,flags);
 	}
@@ -3092,7 +3092,7 @@ static void mgsl_close(struct tty_struct *tty, struct file * filp)
 		printk("%s(%d):mgsl_close(%s) entry, count=%d\n",
 			 __FILE__,__LINE__, info->device_name, info->port.count);
 
-	if (tty_port_close_start(&info->port, tty, filp) == 0)			 
+	if (tty_port_close_start(&info->port, tty, filp) == 0)
 		goto cleanup;
 
 	mutex_lock(&info->port.mutex);
@@ -4297,7 +4297,7 @@ static struct mgsl_struct* mgsl_allocate_device(void)
 		spin_lock_init(&info->irq_spinlock);
 		spin_lock_init(&info->netlock);
 		memcpy(&info->params,&default_params,sizeof(MGSL_PARAMS));
-		info->idle_mode = HDLC_TXIDLE_FLAGS;		
+		info->idle_mode = HDLC_TXIDLE_FLAGS;
 		info->num_tx_dma_buffers = 1;
 		info->num_tx_holding_buffers = 0;
 	}
@@ -4722,7 +4722,7 @@ static void usc_set_sdlc_mode( struct mgsl_struct *info )
 		else if ( info->params.flags & HDLC_FLAG_UNDERRUN_FLAG )
 			RegValue |= BIT15;
 		else if ( info->params.flags & HDLC_FLAG_UNDERRUN_CRC )
-			RegValue |= BIT15 + BIT14;
+			RegValue |= BIT15 | BIT14;
 		}
 
 		if ( info->params.preamble != HDLC_PREAMBLE_PATTERN_NONE )
@@ -4763,11 +4763,11 @@ static void usc_set_sdlc_mode( struct mgsl_struct *info )
 	switch ( info->params.encoding ) {
 	case HDLC_ENCODING_NRZB:               RegValue |= BIT13; break;
 	case HDLC_ENCODING_NRZI_MARK:          RegValue |= BIT14; break;
-	case HDLC_ENCODING_NRZI_SPACE:	       RegValue |= BIT14 + BIT13; break;
+	case HDLC_ENCODING_NRZI_SPACE:	       RegValue |= BIT14 | BIT13; break;
 	case HDLC_ENCODING_BIPHASE_MARK:       RegValue |= BIT15; break;
-	case HDLC_ENCODING_BIPHASE_SPACE:      RegValue |= BIT15 + BIT13; break;
-	case HDLC_ENCODING_BIPHASE_LEVEL:      RegValue |= BIT15 + BIT14; break;
-	case HDLC_ENCODING_DIFF_BIPHASE_LEVEL: RegValue |= BIT15 + BIT14 + BIT13; break;
+	case HDLC_ENCODING_BIPHASE_SPACE:      RegValue |= BIT15 | BIT13; break;
+	case HDLC_ENCODING_BIPHASE_LEVEL:      RegValue |= BIT15 | BIT14; break;
+	case HDLC_ENCODING_DIFF_BIPHASE_LEVEL: RegValue |= BIT15 | BIT14 | BIT13; break;
 	}
 
 	if ( (info->params.crc_type & HDLC_CRC_MASK) == HDLC_CRC_16_CCITT )
@@ -4838,15 +4838,15 @@ static void usc_set_sdlc_mode( struct mgsl_struct *info )
 	switch ( info->params.encoding ) {
 	case HDLC_ENCODING_NRZB:               RegValue |= BIT13; break;
 	case HDLC_ENCODING_NRZI_MARK:          RegValue |= BIT14; break;
-	case HDLC_ENCODING_NRZI_SPACE:         RegValue |= BIT14 + BIT13; break;
+	case HDLC_ENCODING_NRZI_SPACE:         RegValue |= BIT14 | BIT13; break;
 	case HDLC_ENCODING_BIPHASE_MARK:       RegValue |= BIT15; break;
-	case HDLC_ENCODING_BIPHASE_SPACE:      RegValue |= BIT15 + BIT13; break;
-	case HDLC_ENCODING_BIPHASE_LEVEL:      RegValue |= BIT15 + BIT14; break;
-	case HDLC_ENCODING_DIFF_BIPHASE_LEVEL: RegValue |= BIT15 + BIT14 + BIT13; break;
+	case HDLC_ENCODING_BIPHASE_SPACE:      RegValue |= BIT15 | BIT13; break;
+	case HDLC_ENCODING_BIPHASE_LEVEL:      RegValue |= BIT15 | BIT14; break;
+	case HDLC_ENCODING_DIFF_BIPHASE_LEVEL: RegValue |= BIT15 | BIT14 | BIT13; break;
 	}
 
 	if ( (info->params.crc_type & HDLC_CRC_MASK) == HDLC_CRC_16_CCITT )
-		RegValue |= BIT9 + BIT8;
+		RegValue |= BIT9 | BIT8;
 	else if ( (info->params.crc_type & HDLC_CRC_MASK) == HDLC_CRC_32_CCITT )
 		RegValue |= ( BIT12 | BIT10 | BIT9 | BIT8);
 
@@ -4957,7 +4957,7 @@ static void usc_set_sdlc_mode( struct mgsl_struct *info )
 
 	RegValue = 0x0000;
 
-	if ( info->params.flags & (HDLC_FLAG_RXC_DPLL + HDLC_FLAG_TXC_DPLL) ) {
+	if ( info->params.flags & (HDLC_FLAG_RXC_DPLL | HDLC_FLAG_TXC_DPLL) ) {
 		u32 XtalSpeed;
 		u32 DpllDivisor;
 		u16 Tc;
@@ -5019,7 +5019,7 @@ static void usc_set_sdlc_mode( struct mgsl_struct *info )
 		case HDLC_ENCODING_BIPHASE_MARK:
 		case HDLC_ENCODING_BIPHASE_SPACE: RegValue |= BIT9; break;
 		case HDLC_ENCODING_BIPHASE_LEVEL:
-		case HDLC_ENCODING_DIFF_BIPHASE_LEVEL: RegValue |= BIT9 + BIT8; break;
+		case HDLC_ENCODING_DIFF_BIPHASE_LEVEL: RegValue |= BIT9 | BIT8; break;
 		}
 	}
 
@@ -5056,8 +5056,8 @@ static void usc_set_sdlc_mode( struct mgsl_struct *info )
 	/* enable Master Interrupt Enable bit (MIE) */
 	usc_EnableMasterIrqBit( info );
 
-	usc_ClearIrqPendingBits( info, RECEIVE_STATUS + RECEIVE_DATA +
-				TRANSMIT_STATUS + TRANSMIT_DATA + MISC);
+	usc_ClearIrqPendingBits( info, RECEIVE_STATUS | RECEIVE_DATA |
+				TRANSMIT_STATUS | TRANSMIT_DATA | MISC);
 
 	/* arm RCC underflow interrupt */
 	usc_OutReg(info, SICR, (u16)(usc_InReg(info,SICR) | BIT3));
@@ -5175,14 +5175,14 @@ static void usc_set_sdlc_mode( struct mgsl_struct *info )
 	switch ( info->params.preamble_length ) {
 	case HDLC_PREAMBLE_LENGTH_16BITS: RegValue |= BIT10; break;
 	case HDLC_PREAMBLE_LENGTH_32BITS: RegValue |= BIT11; break;
-	case HDLC_PREAMBLE_LENGTH_64BITS: RegValue |= BIT11 + BIT10; break;
+	case HDLC_PREAMBLE_LENGTH_64BITS: RegValue |= BIT11 | BIT10; break;
 	}
 
 	switch ( info->params.preamble ) {
-	case HDLC_PREAMBLE_PATTERN_FLAGS: RegValue |= BIT8 + BIT12; break;
+	case HDLC_PREAMBLE_PATTERN_FLAGS: RegValue |= BIT8 | BIT12; break;
 	case HDLC_PREAMBLE_PATTERN_ONES:  RegValue |= BIT8; break;
 	case HDLC_PREAMBLE_PATTERN_10:    RegValue |= BIT9; break;
-	case HDLC_PREAMBLE_PATTERN_01:    RegValue |= BIT9 + BIT8; break;
+	case HDLC_PREAMBLE_PATTERN_01:    RegValue |= BIT9 | BIT8; break;
 	}
 
 	usc_OutReg( info, CCR, RegValue );
@@ -5221,7 +5221,7 @@ static void usc_enable_loopback(struct mgsl_struct *info, int enable)
 {
 	if (enable) {
 		/* blank external TXD output */
-		usc_OutReg(info,IOCR,usc_InReg(info,IOCR) | (BIT7+BIT6));
+		usc_OutReg(info,IOCR,usc_InReg(info,IOCR) | (BIT7 | BIT6));
 	
 		/* Clock mode Control Register (CMCR)
 		 *
@@ -5260,7 +5260,7 @@ static void usc_enable_loopback(struct mgsl_struct *info, int enable)
 		outw( 0x0300, info->io_base + CCAR );
 	} else {
 		/* enable external TXD output */
-		usc_OutReg(info,IOCR,usc_InReg(info,IOCR) & ~(BIT7+BIT6));
+		usc_OutReg(info,IOCR,usc_InReg(info,IOCR) & ~(BIT7 | BIT6));
 	
 		/* clear Internal Data loopback mode */
 		info->loopback_bits = 0;
@@ -5447,13 +5447,13 @@ static void usc_process_rxoverrun_sync( struct mgsl_struct *info )
 		usc_OutDmaReg( info, NRARU, (u16)(phys_addr >> 16) );
 
 		usc_UnlatchRxstatusBits( info, RXSTATUS_ALL );
-		usc_ClearIrqPendingBits( info, RECEIVE_DATA + RECEIVE_STATUS );
+		usc_ClearIrqPendingBits( info, RECEIVE_DATA | RECEIVE_STATUS );
 		usc_EnableInterrupts( info, RECEIVE_STATUS );
 
 		/* 1. Arm End of Buffer (EOB) Receive DMA Interrupt (BIT2 of RDIAR) */
 		/* 2. Enable Receive DMA Interrupts (BIT1 of DICR) */
 
-		usc_OutDmaReg( info, RDIAR, BIT3 + BIT2 );
+		usc_OutDmaReg( info, RDIAR, BIT3 | BIT2 );
 		usc_OutDmaReg( info, DICR, (u16)(usc_InDmaReg(info,DICR) | BIT1) );
 		usc_DmaCmd( info, DmaCmd_InitRxChannel );
 		if ( info->params.flags & HDLC_FLAG_AUTO_DCD )
@@ -5488,8 +5488,8 @@ static void usc_stop_receiver( struct mgsl_struct *info )
 	usc_DmaCmd( info, DmaCmd_ResetRxChannel );
 
 	usc_UnlatchRxstatusBits( info, RXSTATUS_ALL );
-	usc_ClearIrqPendingBits( info, RECEIVE_DATA + RECEIVE_STATUS );
-	usc_DisableInterrupts( info, RECEIVE_DATA + RECEIVE_STATUS );
+	usc_ClearIrqPendingBits( info, RECEIVE_DATA | RECEIVE_STATUS );
+	usc_DisableInterrupts( info, RECEIVE_DATA | RECEIVE_STATUS );
 
 	usc_EnableReceiver(info,DISABLE_UNCONDITIONAL);
 
@@ -5536,13 +5536,13 @@ static void usc_start_receiver( struct mgsl_struct *info )
 		usc_OutDmaReg( info, NRARU, (u16)(phys_addr >> 16) );
 
 		usc_UnlatchRxstatusBits( info, RXSTATUS_ALL );
-		usc_ClearIrqPendingBits( info, RECEIVE_DATA + RECEIVE_STATUS );
+		usc_ClearIrqPendingBits( info, RECEIVE_DATA | RECEIVE_STATUS );
 		usc_EnableInterrupts( info, RECEIVE_STATUS );
 
 		/* 1. Arm End of Buffer (EOB) Receive DMA Interrupt (BIT2 of RDIAR) */
 		/* 2. Enable Receive DMA Interrupts (BIT1 of DICR) */
 
-		usc_OutDmaReg( info, RDIAR, BIT3 + BIT2 );
+		usc_OutDmaReg( info, RDIAR, BIT3 | BIT2 );
 		usc_OutDmaReg( info, DICR, (u16)(usc_InDmaReg(info,DICR) | BIT1) );
 		usc_DmaCmd( info, DmaCmd_InitRxChannel );
 		if ( info->params.flags & HDLC_FLAG_AUTO_DCD )
@@ -5551,7 +5551,7 @@ static void usc_start_receiver( struct mgsl_struct *info )
 			usc_EnableReceiver(info,ENABLE_UNCONDITIONAL);
 	} else {
 		usc_UnlatchRxstatusBits(info, RXSTATUS_ALL);
-		usc_ClearIrqPendingBits(info, RECEIVE_DATA + RECEIVE_STATUS);
+		usc_ClearIrqPendingBits(info, RECEIVE_DATA | RECEIVE_STATUS);
 		usc_EnableInterrupts(info, RECEIVE_DATA);
 
 		usc_RTCmd( info, RTCmd_PurgeRxFifo );
@@ -5925,7 +5925,7 @@ static void usc_set_async_mode( struct mgsl_struct *info )
 	RegValue = 0;
 
 	if ( info->params.data_bits != 8 )
-		RegValue |= BIT4+BIT3+BIT2;
+		RegValue |= BIT4 | BIT3 | BIT2;
 
 	if ( info->params.parity != ASYNC_PARITY_NONE ) {
 		RegValue |= BIT5;
@@ -5982,7 +5982,7 @@ static void usc_set_async_mode( struct mgsl_struct *info )
 	RegValue = 0;
 
 	if ( info->params.data_bits != 8 )
-		RegValue |= BIT4+BIT3+BIT2;
+		RegValue |= BIT4 | BIT3 | BIT2;
 
 	if ( info->params.parity != ASYNC_PARITY_NONE ) {
 		RegValue |= BIT5;
@@ -6129,7 +6129,7 @@ static void usc_loopback_frame( struct mgsl_struct *info )
 							
 	/* WAIT FOR RECEIVE COMPLETE */
 	for (i=0 ; i<1000 ; i++)
-		if (usc_InReg( info, RCSR ) & (BIT8 + BIT4 + BIT3 + BIT1))
+		if (usc_InReg( info, RCSR ) & (BIT8 | BIT4 | BIT3 | BIT1))
 			break;
 
 	/* clear Internal Data loopback mode */
@@ -6579,8 +6579,8 @@ static bool mgsl_get_rx_frame(struct mgsl_struct *info)
 	
 	status = info->rx_buffer_list[EndIndex].status;
 
-	if ( status & (RXSTATUS_SHORT_FRAME + RXSTATUS_OVERRUN +
-			RXSTATUS_CRC_ERROR + RXSTATUS_ABORT) ) {
+	if ( status & (RXSTATUS_SHORT_FRAME | RXSTATUS_OVERRUN |
+			RXSTATUS_CRC_ERROR | RXSTATUS_ABORT) ) {
 		if ( status & RXSTATUS_SHORT_FRAME )
 			info->icount.rxshort++;
 		else if ( status & RXSTATUS_ABORT )
@@ -6762,8 +6762,8 @@ static bool mgsl_get_raw_rx_frame(struct mgsl_struct *info)
 
 		status = info->rx_buffer_list[CurrentIndex].status;
 
-		if ( status & (RXSTATUS_SHORT_FRAME + RXSTATUS_OVERRUN +
-				RXSTATUS_CRC_ERROR + RXSTATUS_ABORT) ) {
+		if ( status & (RXSTATUS_SHORT_FRAME | RXSTATUS_OVERRUN |
+				RXSTATUS_CRC_ERROR | RXSTATUS_ABORT) ) {
 			if ( status & RXSTATUS_SHORT_FRAME )
 				info->icount.rxshort++;
 			else if ( status & RXSTATUS_ABORT )
@@ -6899,7 +6899,7 @@ static void mgsl_load_tx_dma_buffer(struct mgsl_struct *info,
 		/* set CMR:13 to start transmit when
 		 * next GoAhead (abort) is received
 		 */
-	 	info->cmr_value |= BIT13;			  
+	 	info->cmr_value |= BIT13;
 	}
 		
 	/* begin loading the frame in the next available tx dma
@@ -7278,7 +7278,7 @@ static bool mgsl_dma_test( struct mgsl_struct *info )
 		
 		spin_unlock_irqrestore(&info->irq_spinlock,flags);
 
-						
+
 		/******************************/
 		/* WAIT FOR TRANSMIT COMPLETE */
 		/******************************/
@@ -7292,7 +7292,7 @@ static bool mgsl_dma_test( struct mgsl_struct *info )
 		status = usc_InReg( info, TCSR );
 		spin_unlock_irqrestore(&info->irq_spinlock,flags);
 
-		while ( !(status & (BIT6+BIT5+BIT4+BIT2+BIT1)) ) {
+		while ( !(status & (BIT6 | BIT5 | BIT4 | BIT2 | BIT1)) ) {
 			if (time_after(jiffies, EndTime)) {
 				rc = false;
 				break;
@@ -7307,7 +7307,7 @@ static bool mgsl_dma_test( struct mgsl_struct *info )
 
 	if ( rc ){
 		/* CHECK FOR TRANSMIT ERRORS */
-		if ( status & (BIT5 + BIT1) ) 
+		if ( status & (BIT5 | BIT1) )
 			rc = false;
 	}
 
@@ -7333,7 +7333,7 @@ static bool mgsl_dma_test( struct mgsl_struct *info )
 		/* CHECK FOR RECEIVE ERRORS */
 		status = info->rx_buffer_list[0].status;
 
-		if ( status & (BIT8 + BIT3 + BIT1) ) {
+		if ( status & (BIT8 | BIT3 | BIT1) ) {
 			/* receive error has occurred */
 			rc = false;
 		} else {
@@ -7605,7 +7605,7 @@ static void usc_loopmode_send_done( struct mgsl_struct * info )
 {
  	info->loopmode_send_done_requested = false;
  	/* clear CMR:13 to 0 to start echoing RxData to TxData */
- 	info->cmr_value &= ~BIT13;			  
+ 	info->cmr_value &= ~BIT13;
  	usc_OutReg(info, CMR, info->cmr_value);
 }
 
-- 
1.7.10.4

