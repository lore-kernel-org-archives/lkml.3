Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751711AbaB1Hct (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 02:32:49 -0500
Received: from nm9-vm9.bullet.mail.gq1.yahoo.com ([98.136.218.248]:50065 "EHLO
	nm9-vm9.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751297AbaB1Hcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 02:32:48 -0500
X-Yahoo-Newman-Id: 839489.50317.bm@smtp213.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: jDPISQsVM1kxZ1G6PodYUIyAMUeskQJRYqNmL85BUC28SQf
 .cEuUDKL_e4RdUYGvlBpEsW6kWNsTYan2Uzu0hba_8l0jc1DWktT781vR0eI
 foJnuEOPvnYfL2BroZo.3ho.ncQy4zSYj6G94WfLv2AMPYgnoR6Gg0gok0B2
 n2PGS8rDBaLUqOvbJga4RHeqXMMQouw0ilWoKI2zG.dCuJ6f8ehBWXpVB.N1
 u2la_p_Lf8KiL2o5p.ZEnp9OSNZJsNZZNcvvqnR1ePjwm3L05HFCJ8ftJ7Q8
 MufFRVW7mwj7nPEYxqM3jNDbmmW9fi1hjSfjcPwc5EYYFe8daDGFTEqXiA6B
 d9vkKXovwT2SFPJgNWmq7JtFf1TQ1aP4whMklzBkcUKMUA2HYreVFrMkkGB1
 d0PIbmFRZHQ9jCr0IWXNaY1Q9Th0.FFih8mkEQa8XWIrmGsUXg1uots_xcPC
 DJ7WhR6Fhp6bNR9Czz5UeVV5UJHWcfCguxm7yyVtPx8uhLGcM4SQlpXaEX9D
 Tay1f3h0X1SYcjiYTpai6Nrp2B2nBjEvmxyBV
X-Yahoo-SMTP: Ua.BYCGswBCLcNpMqiQEtkMTjL08M6XQy5ZdmA--
X-Rocket-Received: from localhost.localdomain (chase.southwood@50.129.102.163 with plain [98.139.211.125])
        by smtp213.mail.gq1.yahoo.com with SMTP; 28 Feb 2014 07:32:47 +0000 UTC
From: Chase Southwood <chase.southwood@yahoo.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@yahoo.com>
Subject: [PATCH 2/2] Staging: comedi: addi-data: remove unnecessary variable initializations in hwdrv_apci1564.c
Date: Fri, 28 Feb 2014 01:32:41 -0600
Message-Id: <1393572761-9614-1-git-send-email-chase.southwood@yahoo.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1393572680-9521-1-git-send-email-chase.southwood@yahoo.com>
References: <1393572680-9521-1-git-send-email-chase.southwood@yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A handful of variables here were being initialized to 0 upon declaration,
however they are always then set to another value before their first use,
so initialization here is useless and we can remove it.

Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
---
 drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
index 968e26c..83e4a41 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
@@ -304,7 +304,7 @@ static int i_APCI1564_ConfigTimerCounterWatchdog(struct comedi_device *dev,
 						 unsigned int *data)
 {
 	struct addi_private *devpriv = dev->private;
-	unsigned int ul_Command1 = 0;
+	unsigned int ul_Command1;
 
 	devpriv->tsk_Current = current;
 	if (data[0] == ADDIDATA_WATCHDOG) {
@@ -462,7 +462,7 @@ static int i_APCI1564_StartStopWriteTimerCounterWatchdog(struct comedi_device *d
 							 unsigned int *data)
 {
 	struct addi_private *devpriv = dev->private;
-	unsigned int ul_Command1 = 0;
+	unsigned int ul_Command1;
 
 	if (devpriv->b_TimerSelectMode == ADDIDATA_WATCHDOG) {
 		switch (data[1]) {
@@ -560,7 +560,7 @@ static int i_APCI1564_ReadTimerCounterWatchdog(struct comedi_device *dev,
 					       unsigned int *data)
 {
 	struct addi_private *devpriv = dev->private;
-	unsigned int ul_Command1 = 0;
+	unsigned int ul_Command1;
 
 	if (devpriv->b_TimerSelectMode == ADDIDATA_WATCHDOG) {
 		/*  Stores the status of the Watchdog */
@@ -658,7 +658,7 @@ static void v_APCI1564_Interrupt(int irq, void *d)
 	unsigned int ui_DO, ui_DI;
 	unsigned int ui_Timer;
 	unsigned int ui_C1, ui_C2, ui_C3, ui_C4;
-	unsigned int ul_Command2 = 0;
+	unsigned int ul_Command2;
 
 	ui_DI = inl(devpriv->i_IobaseAmcc + APCI1564_DIGITAL_IP +
 		APCI1564_DIGITAL_IP_IRQ) & 0x01;
-- 
1.8.5.3

