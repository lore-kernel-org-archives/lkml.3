Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752581AbbA2BJK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:09:10 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:54400 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519AbbA2BJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:09:07 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fred Akers <knivey@botops.net>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: comedi: drivers: addi_apci_3501: Removed variables that is never used
Date: Wed, 28 Jan 2015 23:33:12 +0100
Message-Id: <1422484392-8566-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Variable ar assigned a value that is never used.
I have also removed all the code that thereby serves no purpose.

This was found using a static code analysis program called cppcheck

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/staging/comedi/drivers/addi_apci_3501.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi_apci_3501.c b/drivers/staging/comedi/drivers/addi_apci_3501.c
index a726efc..0cdcecc 100644
--- a/drivers/staging/comedi/drivers/addi_apci_3501.c
+++ b/drivers/staging/comedi/drivers/addi_apci_3501.c
@@ -267,7 +267,6 @@ static irqreturn_t apci3501_interrupt(int irq, void *d)
 	struct apci3501_private *devpriv = dev->private;
 	unsigned int ui_Timer_AOWatchdog;
 	unsigned long ul_Command1;
-	int i_temp;
 
 	/*  Disable Interrupt */
 	ul_Command1 = inl(dev->iobase + APCI3501_TIMER_CTRL_REG);
@@ -285,7 +284,7 @@ static irqreturn_t apci3501_interrupt(int irq, void *d)
 	ul_Command1 = inl(dev->iobase + APCI3501_TIMER_CTRL_REG);
 	ul_Command1 = ((ul_Command1 & 0xFFFFF9FDul) | 1 << 1);
 	outl(ul_Command1, dev->iobase + APCI3501_TIMER_CTRL_REG);
-	i_temp = inl(dev->iobase + APCI3501_TIMER_STATUS_REG) & 0x1;
+	inl(dev->iobase + APCI3501_TIMER_STATUS_REG) & 0x1;
 
 	return IRQ_HANDLED;
 }
-- 
1.7.10.4

