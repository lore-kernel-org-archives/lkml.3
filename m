Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349Ab3HVAqp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 20:46:45 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:54210 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752740Ab3HVAqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 20:46:43 -0400
From: zwu.kernel@gmail.com
To: linux-scsi@vger.kernel.org
Cc: jbottomley@parallels.com, linux-kernel@vger.kernel.org,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [PATCH] scsi: fix the build warning
Date: Thu, 22 Aug 2013 08:44:22 +0800
Message-Id: <1377132262-15744-1-git-send-email-zwu.kernel@gmail.com>
X-Mailer: git-send-email 1.7.11.7
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082200-7164-0000-0000-000000EA0942
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

  Initialize csum variable to fix the build warning.

drivers/scsi/scsi_debug.c: In function ‘dif_verify’:
drivers/scsi/scsi_debug.c:1755:3: warning: ‘csum’ may be used uninitialized in this function [-Wmaybe-uninitialized]
  LD      drivers/built-in.o
  CHK     include/generated/uapi/linux/version.h
make[2]: Nothing to be done for `all'.
make[2]: Nothing to be done for `relocs'.

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 drivers/scsi/scsi_debug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index cb4fefa..50d70c3 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -1733,7 +1733,7 @@ static int do_device_access(struct scsi_cmnd *scmd,
 
 static u16 dif_compute_csum(const void *buf, int len)
 {
-	u16 csum;
+	u16 csum = -1;
 
 	switch (scsi_debug_guard) {
 	case 1:
-- 
1.7.11.7

