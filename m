Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753097AbaC2SpB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 14:45:01 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:36115 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646AbaC2So7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 14:44:59 -0400
Date: Sun, 30 Mar 2014 00:15:24 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, josh@joshtriplett.org
Subject: [PATCH 49/55] scsi: Move prototype declaration to header file
 scsi_priv.h from scsi_scan.c
Message-ID: <6ede28b6caf5d10936d9ea6c7f18d7143406d783.1396114898.git.rashika.kheria@gmail.com>
References: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move prototype declarations of functions to header file scsi_priv.h from
scsi_scan.c because they are used by more than one file.

This eliminates the following warnings in scsi_lib.c:
drivers/scsi/scsi_lib.c:466:6: warning: no previous prototype for ‘scsi_requeue_run_queue’ [-Wmissing-prototypes]
drivers/scsi/scsi_lib.c:2266:6: warning: no previous prototype for ‘scsi_evt_thread’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/scsi/scsi_priv.h |    2 ++
 drivers/scsi/scsi_scan.c |    2 --
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index f079a59..3fd3b6f 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -84,6 +84,8 @@ int scsi_noretry_cmd(struct scsi_cmnd *scmd);
 extern int scsi_maybe_unblock_host(struct scsi_device *sdev);
 extern void scsi_device_unbusy(struct scsi_device *sdev);
 extern void scsi_queue_insert(struct scsi_cmnd *cmd, int reason);
+void scsi_requeue_run_queue(struct work_struct *work);
+void scsi_evt_thread(struct work_struct *work);
 extern void scsi_next_command(struct scsi_cmnd *cmd);
 extern void scsi_io_completion(struct scsi_cmnd *, unsigned int);
 extern void scsi_run_host_queues(struct Scsi_Host *shost);
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 307a811..3a67307 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -229,8 +229,6 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
 	struct scsi_device *sdev;
 	int display_failure_msg = 1, ret;
 	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
-	extern void scsi_evt_thread(struct work_struct *work);
-	extern void scsi_requeue_run_queue(struct work_struct *work);
 
 	sdev = kzalloc(sizeof(*sdev) + shost->transportt->device_size,
 		       GFP_ATOMIC);
-- 
1.7.9.5

