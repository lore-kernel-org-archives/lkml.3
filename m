Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752046AbaB1Hay (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 02:30:54 -0500
Received: from nm27-vm8.bullet.mail.gq1.yahoo.com ([98.136.216.151]:24909 "EHLO
	nm27-vm8.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751164AbaB1Hax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 02:30:53 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=gcom1024; d=yahoo.com;
	b=eZv9KO6oveDJpg212jBkCIJh6RvW4Naky3B+xYUculCglADei8W1/ITMwCuc1aC0F/El7gPzSuAX3yPbnWnDA0ChMAK5xXQjzb5xMf5SFklk6jQERB/k70xEE5SI4mfembbnGs2uVyitIsT539MlutGbEkaeB08+zJ3YtgdK91Y=;
X-Yahoo-Newman-Id: 749663.74302.bm@smtp232.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: LT.4F1kVM1mJ8BCd7ioUt4.vzNEgKhfVBtXzaLQdskAIFRZ
 mxb4Pr5z9N7NxrXf_SaIczz3whQCjjVzeUBzivKHYM2F.xHt_auRF3fwgtZE
 ZRT2LjmEtVmXGQFSdLqB3bUhX2zoiI9ZgtiN1TuYd.9HK.Pf7CYsDVycEE2V
 BRZkzDnUPk0loGOeawMvRBgMtvq0CVf3YbKIlGZDiJpq4pK.WMoseG8t.iEW
 or_i1LXhXcHSQt.8ozkDLpcb3Qp_RrOgXQOOB2Kx.jaBu0Gd3c9IpLjUVE5X
 4HXMzOhsXoRM9gfmgYHeTtuDAMLMuhFEgC_jyU2Gb6kkiDYsKWOTnrC91ME0
 ZjJAMsZQqLjohiAB.iB1u7CGvimwv5Ato5YAzLtKaty_L9QFlDjC2ky80ImC
 eAtaEpwJ0a7MSRDOeu22OpWEpcXfi3GrLTUoJOwr1ScnoMO1BUdjuPtlnCpP
 Chu130nm26tU6koPyvivkLxZzFmJRvMJCZTkwjgfHs9par23.PGRbj.5BNcK
 .wlIML45IqQg47.CC8JGJTv5l4WP6umYScjYZ
X-Yahoo-SMTP: Ua.BYCGswBCLcNpMqiQEtkMTjL08M6XQy5ZdmA--
X-Rocket-Received: from localhost.localdomain (chase.southwood@50.129.102.163 with plain [98.138.105.21])
        by smtp232.mail.gq1.yahoo.com with SMTP; 28 Feb 2014 07:30:52 +0000 UTC
From: Chase Southwood <chase.southwood@yahoo.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@yahoo.com>
Subject: [PATCH] Staging: comedi: addi-data: remove unnecessary variable initializations in hwdrv_apci035.c
Date: Fri, 28 Feb 2014 01:30:45 -0600
Message-Id: <1393572645-9470-1-git-send-email-chase.southwood@yahoo.com>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nearly every variable in hwdrv_apci035.c is initialized to 0 when it is
declared, and then set to some other value before ever being used.  As
such, we can remove all of these initializations.  They are accomplishing
nothing.

Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
---
 .../comedi/drivers/addi-data/hwdrv_apci035.c       | 26 +++++++++++-----------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c
index 9041fdf..80cca95 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c
@@ -169,9 +169,9 @@ static int i_APCI035_ConfigTimerWatchdog(struct comedi_device *dev,
 					 unsigned int *data)
 {
 	struct addi_private *devpriv = dev->private;
-	unsigned int ui_Status = 0;
-	unsigned int ui_Command = 0;
-	unsigned int ui_Mode = 0;
+	unsigned int ui_Status;
+	unsigned int ui_Command;
+	unsigned int ui_Mode;
 
 	i_Temp = 0;
 	devpriv->tsk_Current = current;
@@ -318,8 +318,8 @@ static int i_APCI035_StartStopWriteTimerWatchdog(struct comedi_device *dev,
 						 unsigned int *data)
 {
 	struct addi_private *devpriv = dev->private;
-	unsigned int ui_Command = 0;
-	int i_Count = 0;
+	unsigned int ui_Command;
+	int i_Count;
 
 	if (data[0] == 1) {
 		ui_Command =
@@ -433,7 +433,7 @@ static int i_APCI035_ReadTimerWatchdog(struct comedi_device *dev,
 				       unsigned int *data)
 {
 	struct addi_private *devpriv = dev->private;
-	unsigned int ui_Status = 0;	/*  Status register */
+	unsigned int ui_Status;	/*  Status register */
 
 	i_WatchdogNbr = insn->unused[0];
 
@@ -526,7 +526,7 @@ static int i_APCI035_ReadAnalogInput(struct comedi_device *dev,
 				     unsigned int *data)
 {
 	struct addi_private *devpriv = dev->private;
-	unsigned int ui_CommandRegister = 0;
+	unsigned int ui_CommandRegister;
 
 	/*  Set the start */
 	ui_CommandRegister = 0x80000;
@@ -557,7 +557,7 @@ static int i_APCI035_ReadAnalogInput(struct comedi_device *dev,
 static int i_APCI035_Reset(struct comedi_device *dev)
 {
 	struct addi_private *devpriv = dev->private;
-	int i_Count = 0;
+	int i_Count;
 
 	for (i_Count = 1; i_Count <= 4; i_Count++) {
 		i_WatchdogNbr = i_Count;
@@ -591,11 +591,11 @@ static void v_APCI035_Interrupt(int irq, void *d)
 {
 	struct comedi_device *dev = d;
 	struct addi_private *devpriv = dev->private;
-	unsigned int ui_StatusRegister1 = 0;
-	unsigned int ui_StatusRegister2 = 0;
-	unsigned int ui_ReadCommand = 0;
-	unsigned int ui_ChannelNumber = 0;
-	unsigned int ui_DigitalTemperature = 0;
+	unsigned int ui_StatusRegister1;
+	unsigned int ui_StatusRegister2;
+	unsigned int ui_ReadCommand;
+	unsigned int ui_ChannelNumber;
+	unsigned int ui_DigitalTemperature;
 
 	if (i_Temp == 1) {
 		i_WatchdogNbr = i_Flag;
-- 
1.8.5.3

