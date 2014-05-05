Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756517AbaEELan (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 07:30:43 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:57093 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756464AbaEELal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 07:30:41 -0400
Subject: [PATCH v1.1 15/16] arcmsr: modify some character string
From: ching <ching2048@areca.com.tw>
To: jbottomley@parallels.com, dan.carpenter@oracle.com, thenzl@redhat.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 05 May 2014 19:30:35 +0800
Message-ID: <1399289435.4389.4.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-30.el6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ching<ching2048@areca.com.tw>

Revise comment and some character strings.

Signed-off-by: Ching<ching2048@areca.com.tw>
---

diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
--- a/drivers/scsi/arcmsr/arcmsr_hba.c	2014-05-02 19:54:54.000000000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c	2014-05-02 19:55:10.000000000 +0800
@@ -2,11 +2,10 @@
 *******************************************************************************
 **        O.S   : Linux
 **   FILE NAME  : arcmsr_hba.c
-**        BY    : Nick Cheng
-**   Description: SCSI RAID Device Driver for
-**                ARECA RAID Host adapter
+**        BY    : Nick Cheng, C.L. Huang
+**   Description: SCSI RAID Device Driver for Areca RAID Controller
 *******************************************************************************
-** Copyright (C) 2002 - 2005, Areca Technology Corporation All rights reserved
+** Copyright (C) 2002 - 2014, Areca Technology Corporation All rights reserved
 **
 **     Web site: www.areca.com.tw
 **       E-mail: support@areca.com.tw
@@ -70,8 +69,8 @@
 #include <scsi/scsi_transport.h>
 #include <scsi/scsicam.h>
 #include "arcmsr.h"
-MODULE_AUTHOR("Nick Cheng <support@areca.com.tw>");
-MODULE_DESCRIPTION("ARECA (ARC11xx/12xx/16xx/1880) SATA/SAS RAID Host Bus Adapter");
+MODULE_AUTHOR("Nick Cheng, C.L. Huang <support@areca.com.tw>");
+MODULE_DESCRIPTION("Areca ARC11xx/12xx/16xx/188x SAS/SATA RAID Controller Driver");
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_VERSION(ARCMSR_DRIVER_VERSION);
 
@@ -126,8 +125,7 @@ static int arcmsr_adjust_disk_queue_dept
 
 static struct scsi_host_template arcmsr_scsi_host_template = {
 	.module			= THIS_MODULE,
-	.name			= "ARCMSR ARECA SATA/SAS RAID Controller"
-				ARCMSR_DRIVER_VERSION,
+	.name			= "Areca SAS/SATA RAID driver",
 	.info			= arcmsr_info,
 	.queuecommand		= arcmsr_queue_command,
 	.eh_abort_handler		= arcmsr_abort,
@@ -3430,14 +3428,14 @@ static const char *arcmsr_info(struct Sc
 	case PCI_DEVICE_ID_ARECA_1680:
 	case PCI_DEVICE_ID_ARECA_1681:
 	case PCI_DEVICE_ID_ARECA_1880:
-		type = "SAS";
+		type = "SAS/SATA";
 		break;
 	default:
-		type = "X-TYPE";
+		type = "unknown";
+		raid6 =	0;
 		break;
 	}
-	sprintf(buf, "Areca %s Host Adapter RAID Controller%s\n %s",
-			type, raid6 ? "( RAID6 capable)" : "",
-			ARCMSR_DRIVER_VERSION);
+	sprintf(buf, "Areca %s RAID Controller %s\narcmsr version %s\n",
+		type, raid6 ? "(RAID6 capable)" : "", ARCMSR_DRIVER_VERSION);
 	return buf;
 }


