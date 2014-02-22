Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754337AbaBVDWI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 22:22:08 -0500
Received: from nm25-vm2.bullet.mail.gq1.yahoo.com ([98.136.217.113]:22641 "EHLO
	nm25-vm2.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753366AbaBVDWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 22:22:06 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=gcom1024; d=yahoo.com;
	b=Fzaw98Wzbd9Q39NqzIT7FM4oarRF1doTGjn1d+MBfiInYBwWPNuZPXokJ3Du2QDchPRrucGAAAW++REzmuKvUnS4VyQ8t7puhup0hPxZcMrsGAq0Ufql4BzLloYtsEjySianTyL9VUripgiNKITJTGlw50rZt6McCC2kZNYgCZ0=;
X-Yahoo-Newman-Id: 447642.84238.bm@smtp223.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 8A_edAwVM1m_Ab8JobKv_m38.icNHNMU_w_jM7CDe.vhcFO
 fJjIO8vdYrPDpFa8CEQtePDKXD_Prn49O99vLhNjDd6m2NC_ulyqTw4Ek9QU
 n5WjfYQKwUuqcVfAx1Zk9x2Y7nV7mPHy24JnuhrE.4UUnIoKNV37vIRf3rQP
 CJ3tBicjjVXlRjaDMxPz.HpTyzZMVhqTDRFUD7u24SglwQOMeR7.y0fNwEeq
 Q94VeDjfTgCIKoNGt87OLXSt8V2Jx.Rp4MKTKU0TRljBgCq47B6cxYeLnYYu
 snWzQhhZ8bXZNwzb_T5Nm7D2EIpVhc65.cvmMVw3x3UIE_RMS5eZOkqYzXKl
 zWQf4UUkTO..NMcwfJvdAB985Eoinuh3bkVtXEth2VEVILUms9jrMn7ITEQz
 SQgR8P4DvgdNj5lMkFnpgpxgpGo6E4JyFaPAbi12bg5VfU0WAc2t2L2O26KY
 8ilP6sPndEc95qp8IXrCLJ3uAqrWvVl_7MXUTJU3H3IeeP5GHRKexqX5225g
 yDjvPWCL6lht9FRS1plQmLPLKqJBxu9eUttvLT2.NOQ--
X-Yahoo-SMTP: Ua.BYCGswBCLcNpMqiQEtkMTjL08M6XQy5ZdmA--
X-Rocket-Received: from localhost.localdomain (chase.southwood@166.217.5.107 with plain [98.139.211.125])
        by smtp223.mail.gq1.yahoo.com with SMTP; 22 Feb 2014 03:22:05 +0000 UTC
From: Chase Southwood <chase.southwood@yahoo.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@yahoo.com>
Subject: [PATCH 3/3] Staging: comedi: addi-data: fix a couple of lines that are too long
Date: Fri, 21 Feb 2014 21:21:56 -0600
Message-Id: <1393039316-7274-1-git-send-email-chase.southwood@yahoo.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1393039229-7184-1-git-send-email-chase.southwood@yahoo.com>
References: <1393039229-7184-1-git-send-email-chase.southwood@yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are a couple of cases where a comment being on the same line as a
statement is causing the line to be over 80 characters long.  This is an
easy fix; move these comments to the previous line.

Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
---
 drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c
index 34e5321..d5c4e71 100644
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
 
@@ -624,11 +626,14 @@ static void v_APCI035_Interrupt(int irq, void *d)
 
 		/* Read the digital temperature value */
 		ui_DigitalTemperature = inl(devpriv->iobase + 128 + 60);
-		send_sig(SIGIO, devpriv->tsk_Current, 0);	/*  send signal to the sample */
+
+		/*  send signal to the sample */
+		send_sig(SIGIO, devpriv->tsk_Current, 0);
 	}
 
 	else if ((ui_StatusRegister2 & 0x1) == 0x1)
-		send_sig(SIGIO, devpriv->tsk_Current, 0);	/*  send signal to the sample */
+		/*  send signal to the sample */
+		send_sig(SIGIO, devpriv->tsk_Current, 0);
 
 	return;
 }
-- 
1.8.5.3

