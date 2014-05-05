Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046AbaEEJvU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 05:51:20 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:56682 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755458AbaEEJvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 05:51:19 -0400
Subject: [PATCH v1.1 9/16] arcmsr: modify printing adapter model number and
 F/W messages
From: ching <ching2048@areca.com.tw>
To: jbottomley@parallels.com, dan.carpenter@oracle.com, thenzl@redhat.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 05 May 2014 17:51:06 +0800
Message-ID: <1399283466.4398.36.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-30.el6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ching<ching2048@areca.com.tw>

Revise printing model name and firmware version order.

Signed-off-by: Ching<ching2048@areca.com.tw>
---

diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
--- a/drivers/scsi/arcmsr/arcmsr_hba.c	2014-05-02 19:53:06.000000000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c	2014-05-02 19:53:24.000000000 +0800
@@ -2258,10 +2258,10 @@ static bool arcmsr_get_hba_config(struct
 		iop_device_map++;
 		count--;
 	}
-	printk(KERN_NOTICE "Areca RAID Controller%d: F/W %s & Model %s\n", 
+	pr_notice("Areca RAID Controller%d: Model %s, F/W %s\n",
 		acb->host->host_no,
-		acb->firm_version,
-		acb->firm_model);
+		acb->firm_model,
+		acb->firm_version);
 	acb->signature = readl(&reg->message_rwbuffer[0]);
 	acb->firm_request_len = readl(&reg->message_rwbuffer[1]);
 	acb->firm_numbers_queue = readl(&reg->message_rwbuffer[2]);
@@ -2334,10 +2334,10 @@ static bool arcmsr_get_hbb_config(struct
 		count--;
 	}
 	
-	printk(KERN_NOTICE "Areca RAID Controller%d: F/W %s & Model %s\n",
+	pr_notice("Areca RAID Controller%d: Model %s, F/W %s\n",
 		acb->host->host_no,
-		acb->firm_version,
-		acb->firm_model);
+		acb->firm_model,
+		acb->firm_version);
 
 	acb->signature = readl(&reg->message_rwbuffer[1]);
 	/*firm_signature,1,00-03*/
@@ -2400,10 +2400,10 @@ static bool arcmsr_get_hbc_config(struct
 		iop_firm_version++;
 		count--;
 	}
-	printk(KERN_NOTICE "Areca RAID Controller%d: F/W %s & Model %s\n",
+	pr_notice("Areca RAID Controller%d: Model %s, F/W %s\n",
 		pACB->host->host_no,
-		pACB->firm_version,
-		pACB->firm_model);
+		pACB->firm_model,
+		pACB->firm_version);
 	pACB->firm_request_len = readl(&reg->msgcode_rwbuffer[1]);   /*firm_request_len,1,04-07*/
 	pACB->firm_numbers_queue = readl(&reg->msgcode_rwbuffer[2]); /*firm_numbers_queue,2,08-11*/
 	pACB->firm_sdram_size = readl(&reg->msgcode_rwbuffer[3]);    /*firm_sdram_size,3,12-15*/


