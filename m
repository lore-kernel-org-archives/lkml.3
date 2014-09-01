Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753707AbaIALHD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 07:07:03 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:39050 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753380AbaIALE3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 07:04:29 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 20/28] staging: comedi: amplc_pci230: make `intr_running` a bitfield
Date: Mon,  1 Sep 2014 12:03:52 +0100
Message-Id: <1409569440-10979-21-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1409569440-10979-1-git-send-email-abbotti@mev.co.uk>
References: <1409569440-10979-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the `intr_running` member of `struct pci230_private` into a
single-bit bitfield of type `bool` to save a bit of space.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/amplc_pci230.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/comedi/drivers/amplc_pci230.c b/drivers/staging/comedi/drivers/amplc_pci230.c
index 8959820..29e6016 100644
--- a/drivers/staging/comedi/drivers/amplc_pci230.c
+++ b/drivers/staging/comedi/drivers/amplc_pci230.c
@@ -507,8 +507,8 @@ struct pci230_private {
 	unsigned short adcg;		/* ADCG register value */
 	unsigned char int_en;		/* Interrupt enable bits */
 	unsigned char ier;		/* Copy of interrupt enable register */
-	unsigned char intr_running;	/* Flag set in interrupt routine */
 	unsigned char res_owner[NUM_RESOURCES]; /* Shared resource owners */
+	bool intr_running:1;		/* Flag set in interrupt routine */
 	bool ai_bipolar:1;		/* Flag AI range is bipolar */
 	bool ao_bipolar:1;		/* Flag AO range is bipolar */
 };
@@ -2451,7 +2451,7 @@ static irqreturn_t pci230_interrupt(int irq, void *d)
 	 */
 	devpriv->ier = devpriv->int_en & ~status_int;
 	outb(devpriv->ier, dev->iobase + PCI230_INT_SCE);
-	devpriv->intr_running = 1;
+	devpriv->intr_running = true;
 	devpriv->intr_cpuid = THISCPU;
 	spin_unlock_irqrestore(&devpriv->isr_spinlock, irqflags);
 
@@ -2487,7 +2487,7 @@ static irqreturn_t pci230_interrupt(int irq, void *d)
 		devpriv->ier = devpriv->int_en;
 		outb(devpriv->ier, dev->iobase + PCI230_INT_SCE);
 	}
-	devpriv->intr_running = 0;
+	devpriv->intr_running = false;
 	spin_unlock_irqrestore(&devpriv->isr_spinlock, irqflags);
 
 	return IRQ_HANDLED;
-- 
2.0.4

