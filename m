Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716AbaBVDWf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 22:22:35 -0500
Received: from nm1-vm1.bullet.mail.gq1.yahoo.com ([98.136.218.80]:42857 "EHLO
	nm1-vm1.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754566AbaBVDWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 22:22:34 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=gcom1024; d=yahoo.com;
	b=TlgEYmo3yWRDrggYF/0esG/Tt780MQHZswQLMH2bQNckEtQ1wRUdPS2N21XNRRcyrqwTVxDmqO5WMGIpNirk7tFOmtsn38k3wOulylbueppKx+u89neHErNNDej+AfSPzoU7A7e9r+C6Qs7JQofE746NZhiB1Zp8BR/ks8FNyHo=;
X-Yahoo-Newman-Id: 727067.63643.bm@smtp206.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: V5qK93cVM1nIgcMAV85lkU83W09ZuzEhX1eEGOlfEB4ekkW
 AMgcmL7VWz3MP.60tV8Y7ig61qabMKGBHz5vc.41ObkFSUthrsvjb2XHh3RX
 O5FuZgjyNpGbl.CYl18QEi6NyXpyPC7zNIZhipKu.PfvusgX4dcjAaM8rQQr
 8QZdBllKM.Ux9PO3vwXZGA22hTMInF631NxX4cZeruJSC4ZBjHcEs0T_9qMy
 Kx8LqKFgEM33T22pSo.4WfXMYPfwwkQ53g9TkuNW1T8s8rAGzjSCnx_5A8As
 G63Z2SVrSobSOKcSZZXuaRRL91lEB7CabJQq73Y.0uoMRg.3bqTttyU57.IT
 J6j4YYgW2UAHG_yjPeNQvs3njYs.Jw4Wj42YIPSbmMGSjxbEIZAGojwlWm7x
 guWemVsRGFG21.XUkThy925nrurH_G1fYbvtiGJTo7kU8J7y1MXA8D3dlIbj
 4_EomLQiTPsjPCuEhVYZAXh_76jupeYXWeotNrGcBkEQuRzH7KzEt95WDlHQ
 svpAcmsePOPjM3OxqPDmlWTS_YjCnSa3uKy7dT9HpY.TkGws-
X-Yahoo-SMTP: Ua.BYCGswBCLcNpMqiQEtkMTjL08M6XQy5ZdmA--
X-Rocket-Received: from localhost.localdomain (chase.southwood@166.217.5.107 with plain [98.139.211.125])
        by smtp206.mail.gq1.yahoo.com with SMTP; 21 Feb 2014 19:21:33 -0800 PST
From: Chase Southwood <chase.southwood@yahoo.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@yahoo.com>
Subject: [PATCH 2/3] Staging: comedi: addi-data: cleanup conditional blocks in hwdrv_apci035.c
Date: Fri, 21 Feb 2014 21:21:19 -0600
Message-Id: <1393039279-7229-1-git-send-email-chase.southwood@yahoo.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1393039229-7184-1-git-send-email-chase.southwood@yahoo.com>
References: <1393039229-7184-1-git-send-email-chase.southwood@yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There were some conditional blocks that had an unneccesary level of
indentation in them.  We can remove this to improve code clarity.

Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
---
 .../comedi/drivers/addi-data/hwdrv_apci035.c       | 31 ++++++++++------------
 1 file changed, 14 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c
index 7c40535..34e5321 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c
@@ -207,23 +207,22 @@ static int i_APCI035_ConfigTimerWatchdog(struct comedi_device *dev,
 		ui_Command =
 			(ui_Command & 0xFFF719E2UL) | ui_Mode << 13UL | 0x10UL;
 
-	} else {
-		if (data[0] == ADDIDATA_WATCHDOG) {
+	} else if (data[0] == ADDIDATA_WATCHDOG) {
 
-			/* Set the mode :             */
-			/* - Disable the hardware     */
-			/* - Disable the counter mode */
-			/* - Disable the warning      */
-			/* - Disable the reset        */
-			/* - Disable the timer mode   */
+		/* Set the mode :             */
+		/* - Disable the hardware     */
+		/* - Disable the counter mode */
+		/* - Disable the warning      */
+		/* - Disable the reset        */
+		/* - Disable the timer mode   */
 
-			ui_Command = ui_Command & 0xFFF819E2UL;
+		ui_Command = ui_Command & 0xFFF819E2UL;
 
-		} else {
-			dev_err(dev->class_dev, "The parameter for Timer/watchdog selection is in error\n");
-			return -EINVAL;
-		}
+	} else {
+		dev_err(dev->class_dev, "The parameter for Timer/watchdog selection is in error\n");
+		return -EINVAL;
 	}
+
 	outl(ui_Command, devpriv->iobase + ((i_WatchdogNbr - 1) * 32) + 12);
 	ui_Command = 0;
 	ui_Command = inl(devpriv->iobase + ((i_WatchdogNbr - 1) * 32) + 12);
@@ -628,10 +627,8 @@ static void v_APCI035_Interrupt(int irq, void *d)
 		send_sig(SIGIO, devpriv->tsk_Current, 0);	/*  send signal to the sample */
 	}
 
-	else {
-		if ((ui_StatusRegister2 & 0x1) == 0x1)
-			send_sig(SIGIO, devpriv->tsk_Current, 0);	/*  send signal to the sample */
-	}
+	else if ((ui_StatusRegister2 & 0x1) == 0x1)
+		send_sig(SIGIO, devpriv->tsk_Current, 0);	/*  send signal to the sample */
 
 	return;
 }
-- 
1.8.5.3

