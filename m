Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766AbaAKEDI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 23:03:08 -0500
Received: from nm28-vm10.bullet.mail.gq1.yahoo.com ([98.136.216.169]:44383
	"EHLO nm28-vm10.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751572AbaAKEDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 23:03:04 -0500
X-Yahoo-Newman-Id: 808413.88279.bm@smtp208.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: YUKq3NcVM1kBkw4YBYW6wsvyU8xrvtYxURoHE4hKLK2oqLm
 YesRq6rnnRHAJi2Mq3d5uVuu7pp86mqMevw6SdOi_5IUeHU.kTfEB3pLUrzz
 WZZmstd14tFlxrX..CKPTOzmCej6MXrHxCKSRkSnjxKUepteD1jFxlhEXXfR
 ETnIoyVXeDUAUU7N6aq6mN.8rT9AFdMkc1v1EW1eTRiM_Erx80tQaT6rW2Sb
 63Ljnl5MlFcQ8NdiY.bQrGEnTL4qI4tSaef7gvkUpQYV8hT2w4anWgPYLt8y
 klmbqWdDdFy6PcDtgfug16eywI_x3XxfYmP8c09smR5HwweoAua8tdwFBgSp
 CbUuJQxUPBLVdbP2qyWxupslsJ4Uf.5uyqYIbSpJcDLOWcpiYi8z57CXxAb3
 Z1QBnefYl5PMCCgKBHDn4zGkR9oFwIMtVLyqnknEqji3Bj.6VIAtZpvJ7CyI
 B3dRrrhwxdZi1Ld6WPefk2L8QcUOjQJ1DfKy36VIXfZ3PBc4SfzMuLaJ6kai
 EBxTs3p6DWf5ES45x2tJq6PZpoqNhnbbJyFM-
X-Yahoo-SMTP: Ua.BYCGswBCLcNpMqiQEtkMTjL08M6XQy5ZdmA--
X-Rocket-Received: from localhost.localdomain (chase.southwood@50.103.236.80 with plain [98.138.105.21])
        by smtp208.mail.gq1.yahoo.com with SMTP; 10 Jan 2014 20:03:02 -0800 PST
From: Chase Southwood <chase.southwood@yahoo.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@yahoo.com>
Subject: [PATCH 2/3] Staging: comedi: fix indentation coding style issue in ni_mio_common.c.
Date: Fri, 10 Jan 2014 22:02:57 -0600
Message-Id: <1389412977-20655-1-git-send-email-chase.southwood@yahoo.com>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch for ni_mio_common.c fixes several indentation warnings from
checkpatch.pl.

Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
---
 drivers/staging/comedi/drivers/ni_mio_common.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_mio_common.c b/drivers/staging/comedi/drivers/ni_mio_common.c
index 116174a..95f4e37 100644
--- a/drivers/staging/comedi/drivers/ni_mio_common.c
+++ b/drivers/staging/comedi/drivers/ni_mio_common.c
@@ -3652,15 +3652,15 @@ static void handle_cdio_interrupt(struct comedi_device *dev)
 
 	cdio_status = ni_readl(M_Offset_CDIO_Status);
 	if (cdio_status & (CDO_Overrun_Bit | CDO_Underflow_Bit)) {
-/* printk("cdio error: statux=0x%x\n", cdio_status); */
+		/* printk("cdio error: statux=0x%x\n", cdio_status); */
 		ni_writel(CDO_Error_Interrupt_Confirm_Bit, M_Offset_CDIO_Command);	/*  XXX just guessing this is needed and does something useful */
 		s->async->events |= COMEDI_CB_OVERFLOW;
 	}
 	if (cdio_status & CDO_FIFO_Empty_Bit) {
-/* printk("cdio fifo empty\n"); */
+		/* printk("cdio fifo empty\n"); */
 		ni_writel(CDO_Empty_FIFO_Interrupt_Enable_Clear_Bit,
 			  M_Offset_CDIO_Command);
-/* s->async->events |= COMEDI_CB_EOA; */
+		/* s->async->events |= COMEDI_CB_EOA; */
 	}
 	ni_event(dev, s);
 }
@@ -3845,7 +3845,7 @@ static int ni_serial_sw_readwrite8(struct comedi_device *dev,
 		/* Input current bit */
 		if (devpriv->stc_readw(dev,
 				       DIO_Parallel_Input_Register) & DIO_SDIN) {
-/*			printk("DIO_P_I_R: 0x%x\n", devpriv->stc_readw(dev, DIO_Parallel_Input_Register)); */
+			/* printk("DIO_P_I_R: 0x%x\n", devpriv->stc_readw(dev, DIO_Parallel_Input_Register)); */
 			input |= mask;
 		}
 	}
-- 
1.8.4.2

