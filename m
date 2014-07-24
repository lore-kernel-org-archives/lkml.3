Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756377AbaGXWuv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 18:50:51 -0400
Received: from 200.180.216.87.static.jazztel.es ([87.216.180.200]:41684 "HELO
	mail.sysvalve.es" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with SMTP id S1750862AbaGXWuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 18:50:50 -0400
From: =?UTF-8?q?L=2E=20Alberto=20Gim=C3=A9nez?= <agimenez@sysvalve.es>
To: devel@driverdev.osuosl.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] staging/lustre: Fix sparse error (signature mismatch)
Date: Fri, 25 Jul 2014 00:50:25 +0200
Message-Id: <1406242226-3257-1-git-send-email-agimenez@sysvalve.es>
X-Mailer: git-send-email 2.0.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lprocfs_wr_atomic is defined in
drivers/staging/lustre/lustre/obdclass/lprocfs_status.c with its second argument
with the __user attribute:

int lprocfs_wr_atomic(struct file *file, const char __user *buffer,
              unsigned long count, void *data)

but its declaration in drivers/staging/lustre/lustre/include/lprocfs_status.h does
not include the attribute. Make declaration and definition match.

Signed-off-by: L. Alberto Giménez <agimenez@sysvalve.es>
---
 drivers/staging/lustre/lustre/include/lprocfs_status.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lustre/include/lprocfs_status.h b/drivers/staging/lustre/lustre/include/lprocfs_status.h
index 428e3e4..8344157 100644
--- a/drivers/staging/lustre/lustre/include/lprocfs_status.h
+++ b/drivers/staging/lustre/lustre/include/lprocfs_status.h
@@ -604,7 +604,7 @@ extern int lprocfs_obd_seq_create(struct obd_device *dev, const char *name,
 
 extern int lprocfs_rd_u64(struct seq_file *m, void *data);
 extern int lprocfs_rd_atomic(struct seq_file *m, void *data);
-extern int lprocfs_wr_atomic(struct file *file, const char *buffer,
+extern int lprocfs_wr_atomic(struct file *file, const char __user *buffer,
 			     unsigned long count, void *data);
 extern int lprocfs_rd_uint(struct seq_file *m, void *data);
 extern int lprocfs_wr_uint(struct file *file, const char *buffer,
-- 
2.0.1

