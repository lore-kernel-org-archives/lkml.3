Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756700AbaHHLuk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 07:50:40 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:45768 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756410AbaHHLuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 07:50:14 -0400
X-AuditID: 85900ec0-d1d29b9000001514-4c-53e4b972c7db
Subject: [RFC PATCH 02/10] scsi/constants: Cleanup printk message in
 scsi_decode_sense_extras()
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
Date: Fri, 08 Aug 2014 11:50:09 +0000
Message-ID: <20140808115009.6768.60285.stgit@yuno-kbuild.novalocal>
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

If sense_flags and fixed_valid are zero, the kernel does not need to
output a printk message. So, if those conditions are met, it just returns.

Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Doug Gilbert <dgilbert@interlog.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---
 drivers/scsi/constants.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
index a0e8159..9c38b8d 100644
--- a/drivers/scsi/constants.c
+++ b/drivers/scsi/constants.c
@@ -1438,6 +1438,9 @@ scsi_decode_sense_extras(struct scsi_device *sdev, const char *name,
 			sense_flags |= ucp[3] & 0xe0;
 	}
 
+	if (!sense_flags && !fixed_valid)
+		return;
+
 	res = 0;
 	memset(buff, 0, sizeof(buff));
 	blen = sizeof(buff) - 1;

