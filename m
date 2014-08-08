Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756750AbaHHLuq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 07:50:46 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:48337 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756256AbaHHLuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 07:50:12 -0400
X-AuditID: 85900ec0-cff26b9000001514-4b-53e4b970c218
Subject: [RFC PATCH 01/10] scsi/constants: Cleanup printk message in
 __scsi_print_sense()
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
Date: Fri, 08 Aug 2014 11:50:06 +0000
Message-ID: <20140808115006.6768.5118.stgit@yuno-kbuild.novalocal>
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

A device name is output like "sda: Sense Key : Medium Error [current]"
in __scsi_print_sense(), but it should be "[sda] Sense Key : Medium Error
[current]" because other printk messages output a device name like "[sda] foo."

Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Doug Gilbert <dgilbert@interlog.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---
 drivers/scsi/constants.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
index c6a7a4a..a0e8159 100644
--- a/drivers/scsi/constants.c
+++ b/drivers/scsi/constants.c
@@ -1470,7 +1470,7 @@ void __scsi_print_sense(struct scsi_device *sdev, const char *name,
 		return;
 	}
 
-	sdev_printk(KERN_INFO, sdev, "%s: Sense Key : %s %s%s\n", name,
+	sdev_printk(KERN_INFO, sdev, "[%s] Sense Key : %s %s%s\n", name,
 	       scsi_sense_key_string(sshdr.sense_key),
 	       scsi_sense_type_string(&sshdr),
 	       scsi_sense_format_string(&sshdr));

