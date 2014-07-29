Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473AbaG2L7q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 07:59:46 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:51685 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753240AbaG2L6v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 07:58:51 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 18/19] staging: comedi: amplc_pci230: tidy up stuct pci230_private
Date: Tue, 29 Jul 2014 12:58:26 +0100
Message-Id: <1406635107-27950-19-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1406635107-27950-1-git-send-email-abbotti@mev.co.uk>
References: <1406635107-27950-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Align the member comments a bit better in the declaration of `struct
pci230_private`.  Also remove the heading comment as it is just a
boilerplate comedi comment.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/amplc_pci230.c | 45 ++++++++++-----------------
 1 file changed, 17 insertions(+), 28 deletions(-)

diff --git a/drivers/staging/comedi/drivers/amplc_pci230.c b/drivers/staging/comedi/drivers/amplc_pci230.c
index 135ca63..d3df96b 100644
--- a/drivers/staging/comedi/drivers/amplc_pci230.c
+++ b/drivers/staging/comedi/drivers/amplc_pci230.c
@@ -508,40 +508,29 @@ static const struct pci230_board pci230_boards[] = {
 	},
 };
 
-/*
- * This structure is for data unique to this hardware driver.  If
- * several hardware drivers keep similar information in this structure,
- * feel free to suggest moving the variable to the struct comedi_device struct.
- */
 struct pci230_private {
 	spinlock_t isr_spinlock;	/* Interrupt spin lock */
 	spinlock_t res_spinlock;	/* Shared resources spin lock */
 	spinlock_t ai_stop_spinlock;	/* Spin lock for stopping AI command */
 	spinlock_t ao_stop_spinlock;	/* Spin lock for stopping AO command */
-	unsigned long state;	/* State flags */
-	unsigned long iobase1;	/* PCI230's I/O space 1 */
+	unsigned long state;		/* State flags */
+	unsigned long iobase1;		/* PCI230's I/O space 1 */
 	unsigned int ao_readback[2];	/* Used for AO readback */
-	/* Number of analogue input scans remaining.  */
-	unsigned int ai_scan_count;
-	/* Current position within analogue input scan */
-	unsigned int ai_scan_pos;
-	/* Number of analogue output scans remaining.  */
-	unsigned int ao_scan_count;
-	int intr_cpuid;		/* ID of CPU running interrupt routine. */
-	unsigned short hwver;	/* Hardware version (for '+' models). */
-	unsigned short adccon;	/* ADCCON register value. */
-	unsigned short daccon;	/* DACCON register value. */
-	/* ADC FIFO programmable interrupt level threshold (PCI230+/260+). */
-	unsigned short adcfifothresh;
-	unsigned short adcg;	/* ADCG register value. */
-	unsigned char int_en;	/* Interrupt enables bits. */
-	/* Set if bipolar input range so we know to mangle it. */
-	unsigned char ai_bipolar;
-	/* Set if bipolar output range so we know to mangle it. */
-	unsigned char ao_bipolar;
-	unsigned char ier;	/* Copy of interrupt enables/status register. */
-	unsigned char intr_running;	/* Flag set in interrupt routine. */
-	unsigned char res_owner[NUM_RESOURCES];	/* Shared resource owners. */
+	unsigned int ai_scan_count;	/* Number of AI scans remaining */
+	unsigned int ai_scan_pos;	/* Current position within AI scan */
+	unsigned int ao_scan_count;	/* Number of AO scans remaining.  */
+	int intr_cpuid;			/* ID of CPU running ISR */
+	unsigned short hwver;		/* Hardware version (for '+' models) */
+	unsigned short adccon;		/* ADCCON register value */
+	unsigned short daccon;		/* DACCON register value */
+	unsigned short adcfifothresh;	/* ADC FIFO threshold (PCI230+/260+) */
+	unsigned short adcg;		/* ADCG register value */
+	unsigned char int_en;		/* Interrupt enable bits */
+	unsigned char ai_bipolar;	/* Flag AI range is bipolar */
+	unsigned char ao_bipolar;	/* Flag AO range is bipolar */
+	unsigned char ier;		/* Copy of interrupt enable register */
+	unsigned char intr_running;	/* Flag set in interrupt routine */
+	unsigned char res_owner[NUM_RESOURCES]; /* Shared resource owners */
 };
 
 /* PCI230 clock source periods in ns */
-- 
2.0.0

