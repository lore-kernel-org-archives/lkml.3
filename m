Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753057AbaBXQfP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 11:35:15 -0500
Received: from nm6-vm4.bullet.mail.gq1.yahoo.com ([98.136.218.195]:39294 "EHLO
	nm6-vm4.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752253AbaBXQfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 11:35:13 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=gcom1024; d=yahoo.com;
	b=MwtWSh6oZ/ihydxdCcI77RTe6fcqjk6Bs0+PLjMHFlzef0YSmF3CsjF6gposTaw38j4Pqh7LXfIHobyxcDcs7SG66N5pEOciDazZ9HQByrt2HUILO3SF1uJJXjItDsVpDhA7oyeaosaM8+W38ivF+FGq7wzCn2+wyw2+qHzt4Fw=;
X-Yahoo-Newman-Id: 905199.1362.bm@smtp233.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 0vCC4MwVM1lDL0PCugj7ZV3rKE7O974RWzMjnEI4XjG2N0f
 SLW3a.39AHSnyphWTOyFpU3wjN5AwNUvJjeg43Omphi7MJltyrmtAulXyed4
 U7TLPvodk9vEFoZPex9ICiV.ngDB6sr27NRKXUwiqailY1Z9_AMuYjaUz7Fw
 BetaCRN1f1pV8TZ2E838H_sMF1uiElSFCcCjSUEG4yECFgQE4kSfJxCSxliN
 wkals3n3XrG1DSgIMenk2Snd4cQ65AJ9rPniOeg7ES66xz0Dqxw4x5A82_q5
 S8xaOr7xE_ygPicEIskHTMHe493JCzBsfl0Ep8GKGIEVbYQV.sQp0QTZI6nN
 xkZs42iHfJQ8phsD68KGYKa.R12yJzOiGFPeudEKUHEe4gP7dc9VDM6U_Z1t
 52kmFTtbkGFJnpdL.6dcZlM5HbUDTW5lmvfHlo866kPUtI0nXG_YrLIzmdD7
 m90rJK.1r3HrFsIH2vphzKtbg7924CW1QUmn3Sc8.t3tqeaxSaaDycKrcI7K
 z0FGcyr0f_A17_AF8KZB0w1gzHcgUQ0I-
X-Yahoo-SMTP: Ua.BYCGswBCLcNpMqiQEtkMTjL08M6XQy5ZdmA--
X-Rocket-Received: from localhost.localdomain (chase.southwood@166.217.207.43 with plain [98.138.105.21])
        by smtp233.mail.gq1.yahoo.com with SMTP; 24 Feb 2014 16:35:12 +0000 UTC
From: Chase Southwood <chase.southwood@yahoo.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@yahoo.com>
Subject: [PATCH 3/3 v2] Staging: comedi: addi-data: fix a couple of lines that are too long
Date: Mon, 24 Feb 2014 10:35:09 -0600
Message-Id: <1393259709-18516-1-git-send-email-chase.southwood@yahoo.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1393039316-7274-1-git-send-email-chase.southwood@yahoo.com>
References: <1393039316-7274-1-git-send-email-chase.southwood@yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are a couple of cases where a comment being on the same line as a
statement is causing the line to be over 80 characters long.  This is an
easy fix, move these comments to the previous line.

Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
---
2: Some changes to PATCH 2/3 v2 occurred in the immediate context of
changes in this patch.  I've redone this patch after updating PATCH 2/3
so that it still applies cleanly.

 drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c
index ebc0587..6fca105 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c
@@ -565,7 +565,9 @@ static int i_APCI035_Reset(struct comedi_device *dev)
 
 	for (i_Count = 1; i_Count <= 4; i_Count++) {
 		i_WatchdogNbr = i_Count;
-		outl(0x0, devpriv->iobase + ((i_WatchdogNbr - 1) * 32) + 0);	/* stop all timers */
+
+		/* stop all timers */
+		outl(0x0, devpriv->iobase + ((i_WatchdogNbr - 1) * 32) + 0);
 	}
 	outl(0x0, devpriv->iobase + 128 + 12);	/* Disable the warning delay */
 
@@ -624,10 +626,13 @@ static void v_APCI035_Interrupt(int irq, void *d)
 
 		/* Read the digital temperature value */
 		ui_DigitalTemperature = inl(devpriv->iobase + 128 + 60);
-		send_sig(SIGIO, devpriv->tsk_Current, 0);	/*  send signal to the sample */
+
+		/*  send signal to the sample */
+		send_sig(SIGIO, devpriv->tsk_Current, 0);
 
 	} else if ((ui_StatusRegister2 & 0x1) == 0x1) {
-		send_sig(SIGIO, devpriv->tsk_Current, 0);	/*  send signal to the sample */
+		/*  send signal to the sample */
+		send_sig(SIGIO, devpriv->tsk_Current, 0);
 	}
 
 	return;
-- 
1.8.5.3

