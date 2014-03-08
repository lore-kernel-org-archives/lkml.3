Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752137AbaCHS7I (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 13:59:08 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:39370 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817AbaCHS61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 13:58:27 -0500
From: Andy Lutomirski <luto@amacapital.net>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, Andy Lutomirski <luto@amacapital.net>,
        Jens Axboe <axboe@kernel.dk>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH 3/4] sr: Add a missing KERN_INFO
Date: Sat,  8 Mar 2014 10:58:14 -0800
Message-Id: <a59d550e4e551746dffd710257ec3a5362001cd3.1394304585.git.luto@amacapital.net>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <cover.1394304585.git.luto@amacapital.net>
References: <cover.1394304585.git.luto@amacapital.net>
In-Reply-To: <cover.1394304585.git.luto@amacapital.net>
References: <cover.1394304585.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The existence if scsi3-mmc capabilities is not an error.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 drivers/scsi/sr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 40d8592..67baf7f 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -887,7 +887,8 @@ static void get_capabilities(struct scsi_cd *cd)
 	cd->readcd_known = 1;
 	cd->readcd_cdda = buffer[n + 5] & 0x01;
 	/* print some capability bits */
-	printk("%s: scsi3-mmc drive: %dx/%dx %s%s%s%s%s%s\n", cd->cdi.name,
+	printk(KERN_INFO "%s: scsi3-mmc drive: %dx/%dx %s%s%s%s%s%s\n",
+	       cd->cdi.name,
 	       ((buffer[n + 14] << 8) + buffer[n + 15]) / 176,
 	       cd->cdi.speed,
 	       buffer[n + 3] & 0x01 ? "writer " : "", /* CD Writer */
-- 
1.8.5.3

