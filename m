Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756803AbaHHLuz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 07:50:55 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:45784 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756563AbaHHLuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 07:50:24 -0400
X-AuditID: 85900ec0-cff26b9000001514-51-53e4b97d0864
Subject: [RFC PATCH 06/10] scsi/sd: Delete extra scsi_show_extd_sense() in
 sd_print_sense_hdr()
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
To: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        yrl.pp-manager.tt@hitachi.com, linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Doug Gilbert <dgilbert@interlog.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Christoph Hellwig <hch@lst.de>
Date: Fri, 08 Aug 2014 11:50:19 +0000
Message-ID: <20140808115019.6768.99063.stgit@yuno-kbuild.novalocal>
In-Reply-To: <20140808115004.6768.97014.stgit@yuno-kbuild.novalocal>
References: <20140808115004.6768.97014.stgit@yuno-kbuild.novalocal>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sd_print_sense_hdr() calls scsi_show_extd_sense(),
but scsi_print_sense_hdr() also calls scsi_show_extd_sense().
We can get same result, so we delete it.

Note:
Calling scsi_show_extd_sense() is introduced in fdd8b297.

Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Doug Gilbert <dgilbert@interlog.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---
 drivers/scsi/sd.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 8d7204a..22dd214 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3286,8 +3286,6 @@ static void sd_print_sense_hdr(struct scsi_disk *sdkp,
 			       struct scsi_sense_hdr *sshdr)
 {
 	scsi_print_sense_hdr(sdkp->device, sdkp->disk->disk_name, sshdr);
-	scsi_show_extd_sense(sdkp->device, sdkp->disk->disk_name,
-			     sshdr->asc, sshdr->ascq);
 }
 
 static void sd_print_result(struct scsi_disk *sdkp, int result)

