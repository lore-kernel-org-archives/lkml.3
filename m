Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751467AbaB1JQa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 04:16:30 -0500
Received: from nm19-vm6.bullet.mail.gq1.yahoo.com ([98.136.217.29]:44234 "EHLO
	nm19-vm6.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751100AbaB1JQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 04:16:27 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=gcom1024; d=yahoo.com;
	b=guphddG5+bfSvqcOfzdY45PjzQJRKPhMGKgfdhE8xAkdz4covOnnrJu9tGCsM1inE8IIKTz8ki3v7+hLqhslfWmepIOBq6JfG9FL3LJKBjRnK1NBWnZ8QPF0+CheSIfXsu7QHtMYoKDfOCW5tkGhfdhX0qP+nGFON/n+Ctnmsio=;
X-Yahoo-Newman-Id: 849808.7104.bm@smtp207.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: LEPU5WkVM1nzCqWNqtJ0XcL1PU1V4vz2VlxMPCxcz4xPx.5
 dqNEX6yj2.pHrVcvXmlsnr28n9v_xjZkVrLzPvms.qYiIc_Ojl49QqvgYT1F
 BJA9EgTKIa4T24ysCDQYb1QuigRxBQ8gsjD.xopAFzFXK6Brcy_BO3Ac37EC
 Y9f0GQm_spcLymCuS4IQdG5Kx6MP7g6lX43ktiQt1WBOAQ_pTnu3StfNpAJA
 njl.f8rxFv8mwHjOx2j_Pnh3fnxT.nk.Sf0hIGP_uYS3k3CCAs6aDdxnWX0W
 T0dm49D3TugZBxdpxcSAqBFtdPOoKP6BPTn0vhLEEueFFCMa1FMVnoUkgyOG
 0Y7a5at1LSlm8pN4zFj3j4gbBXwmt2piC5mjq37wbzpDnXK_7DMrrb6w94TW
 2gp8RLMt2dwxb.PdU0s4B1S756tRVyLEu1AxA2f00u446RHv5eUHGmQDg84z
 26.2NgFFkXlrJ28YB_pic3j.HUpUpONMJoK7Uoo2DA07T.yu_DkOsROJssxZ
 2dy6asjrPGuTlMbY3erLwNWLvYLAc._RoTuGk
X-Yahoo-SMTP: Ua.BYCGswBCLcNpMqiQEtkMTjL08M6XQy5ZdmA--
X-Rocket-Received: from localhost.localdomain (chase.southwood@50.129.102.163 with plain [63.250.193.228])
        by smtp207.mail.gq1.yahoo.com with SMTP; 28 Feb 2014 01:16:26 -0800 PST
From: Chase Southwood <chase.southwood@yahoo.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@yahoo.com>
Subject: [PATCH 2/2 v2] Staging: comedi: addi-data: remove unnecessary variable initializations in hwdrv_apci1564.c
Date: Fri, 28 Feb 2014 03:16:23 -0600
Message-Id: <1393578983-20533-1-git-send-email-chase.southwood@yahoo.com>
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
2: no content change; redone and resent after PATCH 1/2 changed to ensure
clean applying.

 drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
index d958d3c..c6e2d7e 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
@@ -307,7 +307,7 @@ static int i_APCI1564_ConfigTimerCounterWatchdog(struct comedi_device *dev,
 						 unsigned int *data)
 {
 	struct addi_private *devpriv = dev->private;
-	unsigned int ul_Command1 = 0;
+	unsigned int ul_Command1;
 
 	devpriv->tsk_Current = current;
 	if (data[0] == ADDIDATA_WATCHDOG) {
@@ -457,7 +457,7 @@ static int i_APCI1564_StartStopWriteTimerCounterWatchdog(struct comedi_device *d
 							 unsigned int *data)
 {
 	struct addi_private *devpriv = dev->private;
-	unsigned int ul_Command1 = 0;
+	unsigned int ul_Command1;
 
 	if (devpriv->b_TimerSelectMode == ADDIDATA_WATCHDOG) {
 		switch (data[1]) {
@@ -551,7 +551,7 @@ static int i_APCI1564_ReadTimerCounterWatchdog(struct comedi_device *dev,
 					       unsigned int *data)
 {
 	struct addi_private *devpriv = dev->private;
-	unsigned int ul_Command1 = 0;
+	unsigned int ul_Command1;
 
 	if (devpriv->b_TimerSelectMode == ADDIDATA_WATCHDOG) {
 		/*  Stores the status of the Watchdog */
@@ -649,7 +649,7 @@ static void v_APCI1564_Interrupt(int irq, void *d)
 	unsigned int ui_DO, ui_DI;
 	unsigned int ui_Timer;
 	unsigned int ui_C1, ui_C2, ui_C3, ui_C4;
-	unsigned int ul_Command2 = 0;
+	unsigned int ul_Command2;
 
 	ui_DI = inl(devpriv->i_IobaseAmcc + APCI1564_DIGITAL_IP +
 		APCI1564_DIGITAL_IP_IRQ) & 0x01;
-- 
1.8.5.3

