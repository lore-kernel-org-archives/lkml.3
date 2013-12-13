Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752031Ab3LMG7v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 01:59:51 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:65471 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445Ab3LMG7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 01:59:50 -0500
Date: Fri, 13 Dec 2013 12:29:42 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: josh@joshtriplett.org, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5/5] drivers: misc: Mark function jp_generic_ide_ioctl() as
 static in lkdtm.c
Message-ID: <9100647978d5025b699bfec244f35bbc8ef0f7d7.1386915618.git.rashika.kheria@gmail.com>
References: <40521f78bafae3cc4e796c540d3c497d79eeb63e.1386915618.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <40521f78bafae3cc4e796c540d3c497d79eeb63e.1386915618.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch marks the function jp_generic_ide_ioctl() as static in
lkdtm.c because it is not used outside this file.

Thus, it also eliminates the following warnings in lkdtm.c:
drivers/misc/lkdtm.c:227:5: warning: no previous prototype for ‘jp_generic_ide_ioctl’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
---
 drivers/misc/lkdtm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/lkdtm.c b/drivers/misc/lkdtm.c
index a2edb2e..79b677e 100644
--- a/drivers/misc/lkdtm.c
+++ b/drivers/misc/lkdtm.c
@@ -224,7 +224,7 @@ static int jp_scsi_dispatch_cmd(struct scsi_cmnd *cmd)
 }
 
 #ifdef CONFIG_IDE
-int jp_generic_ide_ioctl(ide_drive_t *drive, struct file *file,
+static int jp_generic_ide_ioctl(ide_drive_t *drive, struct file *file,
 			struct block_device *bdev, unsigned int cmd,
 			unsigned long arg)
 {
-- 
1.7.9.5

