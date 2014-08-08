Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756729AbaHHLun (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 07:50:43 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:40077 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756458AbaHHLuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 07:50:16 -0400
X-AuditID: 85900ec0-d312bb9000001514-4d-53e4b97566db
Subject: [RFC PATCH 03/10] scsi/constants: Cleanup printk message in
 __scsi_print_command()
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
Date: Fri, 08 Aug 2014 11:50:12 +0000
Message-ID: <20140808115012.6768.44952.stgit@yuno-kbuild.novalocal>
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

All bytes in CDB should be output after linebuf is filled because
"[%s] CDB: %s\n" message is output many times in loop.

Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Doug Gilbert <dgilbert@interlog.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---
 drivers/scsi/constants.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
index 9c38b8d..5956d4d 100644
--- a/drivers/scsi/constants.c
+++ b/drivers/scsi/constants.c
@@ -413,9 +413,8 @@ void __scsi_print_command(struct scsi_device *sdev, const char *prefix,
 
 		hex_dump_to_buffer(cdb + i, linelen, 16, 1,
 				   linebuf, sizeof(linebuf), false);
-		sdev_printk(KERN_INFO, sdev, "[%s] CDB: %s\n",
-			    prefix, linebuf);
 	}
+	sdev_printk(KERN_INFO, sdev, "[%s] CDB: %s\n", prefix, linebuf);
 }
 EXPORT_SYMBOL(__scsi_print_command);
 

