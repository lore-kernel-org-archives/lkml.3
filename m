Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637AbaLCXhs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 18:37:48 -0500
Received: from smtprelay0151.hostedemail.com ([216.40.44.151]:46575 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752455AbaLCXhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 18:37:47 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:69:355:379:541:599:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1543:1593:1594:1605:1711:1730:1747:1777:1792:2194:2199:2393:2559:2562:2828:2893:2904:3138:3139:3140:3141:3142:3622:3865:3866:3867:3870:3871:3873:4250:4321:4605:5007:6119:6261:7809:7875:7882:7903:9040:9149:9391:9592:10004:10400:10848:11026:11232:11473:11657:11658:11914:12043:12291:12296:12438:12517:12519:12555:12679:12683:12740:13972:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: cake81_7dd4e60255522
X-Filterd-Recvd-Size: 4704
Message-ID: <1417649863.2902.26.camel@perches.com>
Subject: Re: [PATCH v2] Staging: dgnc: Fix long line coding style issues in
 dgnc_cls.h
From: Joe Perches <joe@perches.com>
To: Sean Cleator <seancleator@hotmail.co.uk>
Cc: lidza.louina@gmail.com, markh@compro.net, gregkh@linuxfoundation.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Wed, 03 Dec 2014 15:37:43 -0800
In-Reply-To: <BLU437-SMTP3735424C7098C20996EFF8E97B0@phx.gbl>
References: <BLU437-SMTP3735424C7098C20996EFF8E97B0@phx.gbl>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-12-03 at 21:30 +0000, Sean Cleator wrote:
> A patch to fix the rest of the long line warnings in the dgnc_cls.h file
> found by the checkpatch.pl tool

checkpatch is a brainless little tool.

You should prefer to develop a readable style rather than
pay too close attention to precisely what checkpatch says.

fyi: There is this warning in the file:

 *	NOTE: THIS IS A SHARED HEADER. DO NOT CHANGE CODING STYLE!!!

I would have done changes like this:
---
 drivers/staging/dgnc/dgnc_cls.h | 45 ++++++++++++++++++++---------------------
 1 file changed, 22 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/dgnc/dgnc_cls.h b/drivers/staging/dgnc/dgnc_cls.h
index 465d79a..db05aed 100644
--- a/drivers/staging/dgnc/dgnc_cls.h
+++ b/drivers/staging/dgnc/dgnc_cls.h
@@ -25,25 +25,24 @@
 
 #include "dgnc_types.h"
 
-
-/************************************************************************
- * Per channel/port Classic UART structure				*
- ************************************************************************
- *		Base Structure Entries Usage Meanings to Host		*
- *									*
- *	W = read write		R = read only				*
- *			U = Unused.					*
- ************************************************************************/
+/*
+ * Per channel/port classic UART registers structure
+ *
+ *	Base structure entries usage - meaning to host:
+ *	W = read write
+ *	R = read only
+ *	U = unused
+ */
 
 struct cls_uart_struct {
-	u8 txrx;		/* WR  RHR/THR - Holding Reg */
-	u8 ier;		/* WR  IER - Interrupt Enable Reg */
-	u8 isr_fcr;		/* WR  ISR/FCR - Interrupt Status Reg/Fifo Control Reg */
-	u8 lcr;		/* WR  LCR - Line Control Reg */
-	u8 mcr;		/* WR  MCR - Modem Control Reg */
-	u8 lsr;		/* WR  LSR - Line Status Reg */
-	u8 msr;		/* WR  MSR - Modem Status Reg */
-	u8 spr;		/* WR  SPR - Scratch Pad Reg */
+	u8 txrx;	/* WR  RHR/THR - Holding */
+	u8 ier;		/* WR  IER - Interrupt Enable */
+	u8 isr_fcr;	/* WR  ISR/FCR - Interrupt Status / Fifo Control */
+	u8 lcr;		/* WR  LCR - Line Control */
+	u8 mcr;		/* WR  MCR - Modem Control */
+	u8 lsr;		/* WR  LSR - Line Status */
+	u8 msr;		/* WR  MSR - Modem Status */
+	u8 spr;		/* WR  SPR - Scratch Pad */
 };
 
 /* Where to read the interrupt register (8bits) */
@@ -61,12 +60,12 @@ struct cls_uart_struct {
 #define UART_16654_FCR_RXTRIGGER_56	0x80
 #define UART_16654_FCR_RXTRIGGER_60     0xC0
 
-#define UART_IIR_CTSRTS			0x20	/* Received CTS/RTS change of state */
-#define UART_IIR_RDI_TIMEOUT		0x0C    /* Receiver data TIMEOUT */
+#define UART_IIR_CTSRTS		0x20	/* Received CTS/RTS change of state */
+#define UART_IIR_RDI_TIMEOUT	0x0C    /* Receiver data TIMEOUT */
 
 /*
- * These are the EXTENDED definitions for the Exar 654's Interrupt
- * Enable Register.
+ * These are the EXTENDED definitions for the
+ * Exar 654's Interrupt Enable Register
  */
 #define UART_EXAR654_EFR_ECB      0x10    /* Enhanced control bit */
 #define UART_EXAR654_EFR_IXON     0x2     /* Receiver compares Xon1/Xoff1 */
@@ -74,8 +73,8 @@ struct cls_uart_struct {
 #define UART_EXAR654_EFR_RTSDTR   0x40    /* Auto RTS/DTR Flow Control Enable */
 #define UART_EXAR654_EFR_CTSDSR   0x80    /* Auto CTS/DSR Flow COntrol Enable */
 
-#define UART_EXAR654_XOFF_DETECT  0x1     /* Indicates whether chip saw an incoming XOFF char  */
-#define UART_EXAR654_XON_DETECT   0x2     /* Indicates whether chip saw an incoming XON char */
+#define UART_EXAR654_XOFF_DETECT  0x1     /* Incoming XOFF char seen */
+#define UART_EXAR654_XON_DETECT   0x2     /* Incoming XON char seen */
 
 #define UART_EXAR654_IER_XOFF     0x20    /* Xoff Interrupt Enable */
 #define UART_EXAR654_IER_RTSDTR   0x40    /* Output Interrupt Enable */


