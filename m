Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752184AbaHDIuP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 04:50:15 -0400
Received: from mx02.posteo.de ([89.146.194.165]:38243 "EHLO posteo.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751360AbaHDIuO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 04:50:14 -0400
From: Martin Kepplinger <martink@posteo.de>
To: ballabio_dario@emc.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Martin Kepplinger <martink@posteo.de>
Subject: [PATCH] scsi: use correct formats in printk()
Date: Mon,  4 Aug 2014 10:48:37 +0200
Message-Id: <1407142117-23140-1-git-send-email-martink@posteo.de>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use %llu for u64 and %u for int. Not the other way round.

Signed-off-by: Martin Kepplinger <martink@posteo.de>
---
applies to -next20140801

 drivers/scsi/u14-34f.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/u14-34f.c b/drivers/scsi/u14-34f.c
index 4e76fe8..d8dcf36 100644
--- a/drivers/scsi/u14-34f.c
+++ b/drivers/scsi/u14-34f.c
@@ -1006,7 +1006,7 @@ static int port_detect \
           sh[j]->irq, dma_name, sh[j]->sg_tablesize, sh[j]->can_queue);
 
    if (sh[j]->max_id > 8 || sh[j]->max_lun > 8)
-      printk("%s: wide SCSI support enabled, max_id %u, max_lun %u.\n",
+      printk("%s: wide SCSI support enabled, max_id %u, max_lun %llu.\n",
              BN(j), sh[j]->max_id, sh[j]->max_lun);
 
    for (i = 0; i <= sh[j]->max_channel; i++)
@@ -1285,7 +1285,7 @@ static int u14_34f_queuecommand_lck(struct scsi_cmnd *SCpnt, void (*done)(struct
    cpp->cpp_index = i;
    SCpnt->host_scribble = (unsigned char *) &cpp->cpp_index;
 
-   if (do_trace) printk("%s: qcomm, mbox %d, target %d.%d:%llu.\n",
+   if (do_trace) printk("%s: qcomm, mbox %d, target %d.%d:%u.\n",
                         BN(j), i, SCpnt->device->channel, SCpnt->device->id,
                         (u8)SCpnt->device->lun);
 
-- 
1.7.10.4

