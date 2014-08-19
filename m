Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809AbaHSLaP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 07:30:15 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:65459 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759AbaHSLaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 07:30:11 -0400
From: Honggang Li <enjoymindful@gmail.com>
To: benjamin.romer@unisys.com, david.kershner@unisys.com,
        gregkh@linuxfoundation.org, erik.arfvidson@unisys.com,
        sparmaintainer@unisys.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Honggang Li <enjoymindful@gmail.com>
Subject: [linux-next PATCH] staging: unisys/virthba/virthba.c print u64 with %llu
Date: Tue, 19 Aug 2014 19:29:43 +0800
Message-Id: <1408447783-22287-3-git-send-email-enjoymindful@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1408447783-22287-1-git-send-email-enjoymindful@gmail.com>
References: <1408447783-22287-1-git-send-email-enjoymindful@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/staging/unisys/virthba/virthba.c:520:2: warning: format ‘%u’
expects argument of type ‘unsigned int’, but argument 4 has type ‘u64’
[-Wformat=]
drivers/staging/unisys/virthba/virthba.c:749:2: warning: format ‘%d’
expects argument of type ‘int’, but argument 5 has type ‘u64’
[-Wformat=]
drivers/staging/unisys/virthba/virthba.c:1142:4: warning: format ‘%d’
expects argument of type ‘int’, but argument 7 has type ‘u64’
[-Wformat=]
drivers/staging/unisys/virthba/virthba.c:1151:5: warning: format ‘%d’
expects argument of type ‘int’, but argument 5 has type ‘u64’
[-Wformat=]

After apply the patch:
linux-next]$ make C=1 drivers/staging/unisys/virthba/virthba.o
  CHK     include/config/kernel.release
  CHK     include/generated/uapi/linux/version.h
  CHK     include/generated/utsrelease.h
  CALL    scripts/checksyscalls.sh
  CHECK   drivers/staging/unisys/virthba/virthba.c
  CC [M]  drivers/staging/unisys/virthba/virthba.o

Signed-off-by: Honggang Li <enjoymindful@gmail.com>
---
 drivers/staging/unisys/virthba/virthba.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/unisys/virthba/virthba.c b/drivers/staging/unisys/virthba/virthba.c
index 049eeab..53615df 100644
--- a/drivers/staging/unisys/virthba/virthba.c
+++ b/drivers/staging/unisys/virthba/virthba.c
@@ -517,7 +517,7 @@ virthba_probe(struct virtpci_dev *virtpcidev, const struct pci_device_id *id)
 	    (unsigned short) (virtpcidev->scsi.max.max_io_size / PAGE_SIZE);
 	if (scsihost->sg_tablesize > MAX_PHYS_INFO)
 		scsihost->sg_tablesize = MAX_PHYS_INFO;
-	LOGINF("scsihost->max_channel=%u, max_id=%u, max_lun=%u, cmd_per_lun=%u, max_sectors=%hu, sg_tablesize=%hu\n",
+	LOGINF("scsihost->max_channel=%u, max_id=%u, max_lun=%llu, cmd_per_lun=%u, max_sectors=%hu, sg_tablesize=%hu\n",
 	     scsihost->max_channel, scsihost->max_id, scsihost->max_lun,
 	     scsihost->cmd_per_lun, scsihost->max_sectors,
 	     scsihost->sg_tablesize);
@@ -746,7 +746,7 @@ forward_taskmgmt_command(TASK_MGMT_TYPES tasktype, struct scsi_device *scsidev)
 	int notifyresult = 0xffff;
 	wait_queue_head_t notifyevent;
 
-	LOGINF("TaskMgmt:%d %d:%d:%d\n", tasktype,
+	LOGINF("TaskMgmt:%d %d:%d:%llu\n", tasktype,
 	       scsidev->channel, scsidev->id, scsidev->lun);
 
 	if (virthbainfo->serverdown || virthbainfo->serverchangingstate) {
@@ -1139,7 +1139,7 @@ do_scsi_linuxstat(struct uiscmdrsp *cmdrsp, struct scsi_cmnd *scsicmd)
 
 		if (atomic_read(&vdisk->error_count) < VIRTHBA_ERROR_COUNT) {
 			atomic_inc(&vdisk->error_count);
-			LOGERR("SCSICMD ****FAILED scsicmd:0x%p op:0x%x <%d:%d:%d:%d> 0x%x-0x%x-0x%x-0x%x-0x%x.\n",
+			LOGERR("SCSICMD ****FAILED scsicmd:0x%p op:0x%x <%d:%d:%d:%llu> 0x%x-0x%x-0x%x-0x%x-0x%x.\n",
 			       scsicmd, cmdrsp->scsi.cmnd[0],
 			       scsidev->host->host_no, scsidev->id,
 			       scsidev->channel, scsidev->lun,
@@ -1148,7 +1148,7 @@ do_scsi_linuxstat(struct uiscmdrsp *cmdrsp, struct scsi_cmnd *scsicmd)
 			       sd->AdditionalSenseCodeQualifier);
 			if (atomic_read(&vdisk->error_count) ==
 			    VIRTHBA_ERROR_COUNT) {
-				LOGERR("Throtling SCSICMD errors disk <%d:%d:%d:%d>\n",
+				LOGERR("Throtling SCSICMD errors disk <%d:%d:%d:%llu>\n",
 				     scsidev->host->host_no, scsidev->id,
 				     scsidev->channel, scsidev->lun);
 			}
-- 
1.8.3.1

