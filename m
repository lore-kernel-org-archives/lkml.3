Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757050AbaBUAfO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 19:35:14 -0500
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:55551 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756211AbaBUAfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 19:35:11 -0500
From: Stewart Smith <stewart@linux.vnet.ibm.com>
To: "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Stewart Smith <stewart@linux.vnet.ibm.com>
Subject: [PATCH] scsi/sd.c: fix spun up and not ready messages to mention which disk
Date: Fri, 21 Feb 2014 11:34:43 +1100
Message-Id: <1392942883-4624-1-git-send-email-stewart@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.5.3
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14022100-5564-0000-0000-00000C1F302F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously, many years ago, this was done in series which was fine,
but things moved to be done in parallel and with many disks in a system
it can be hard to see which disk spun up and which one didn't as the
printk messages were all mixed together.

Signed-off-by: Stewart Smith <stewart@linux.vnet.ibm.com>
---
 drivers/scsi/sd.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 470954a..1436c85 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1838,7 +1838,6 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 			}
 			/* Wait 1 second for next try */
 			msleep(1000);
-			printk(".");
 
 		/*
 		 * Wait for USB flash devices with slow firmware.
@@ -1868,9 +1867,9 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 
 	if (spintime) {
 		if (scsi_status_is_good(the_result))
-			printk("ready\n");
+			sd_printk(KERN_NOTICE, sdkp, "ready\n");
 		else
-			printk("not responding...\n");
+			sd_printk(KERN_NOTICE, sdkp, "not responding...\n");
 	}
 }
 
-- 
1.8.5.3

