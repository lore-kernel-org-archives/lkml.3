Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755015AbaIDS2p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 14:28:45 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:54284 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753524AbaIDS2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 14:28:44 -0400
Message-ID: <1409855330.8301.3.camel@localhost>
Subject: [PATCH v2] staging/lustre: Different prototypes between the
 declaration and the definition
From: =?ISO-8859-1?Q?Lo=EFc?= Pellegrino <oort10@gmail.com>
To: oleg.drokin@intel.com, andreas.dilger@intel.com,
        gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org, oort10@gmail.com
Date: Thu, 04 Sep 2014 19:28:50 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-3.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Align the prototype of lprocfs_wr_uint() in the declaration with the one used 
in the definition.

The prototype is:
int lprocfs_wr_uint(struct file *file, const char __user *buffer,
                    unsigned long count, void *data)
In obdclass/lprocfs_status.c

But in lustre/include/lprocfs_status.h, the __user annotation is missing for 
the attribute buffer.

The correct prototype is the first one (the definition) since:
- This function is eventually called by the write() function pointer of an 
instance of struct file_operations
- In this function, buffer is a parameter of copy_from_user()
- Before the commit 73bb1da692d0dc3e93b9c9e29084d6a5dcbc37a6, the declaration 
and the definition had the same prototype, but only the .c has been updated.

Correcting this will remove a sparse error and add sparse warnings.
This is a task of the Eudyptula challenge.

Signed-off-by: Loïc Pellegrino <oort10@gmail.com>
---
My previous email was not formatted correctly sorry.

 drivers/staging/lustre/lustre/include/lprocfs_status.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lustre/include/lprocfs_status.h b/drivers/staging/lustre/lustre/include/lprocfs_status.h
index 05b5285..ccb6cd4 100644
--- a/drivers/staging/lustre/lustre/include/lprocfs_status.h
+++ b/drivers/staging/lustre/lustre/include/lprocfs_status.h
@@ -611,7 +611,7 @@ extern int lprocfs_rd_atomic(struct seq_file *m, void *data);
 extern int lprocfs_wr_atomic(struct file *file, const char __user *buffer,
 			     unsigned long count, void *data);
 extern int lprocfs_rd_uint(struct seq_file *m, void *data);
-extern int lprocfs_wr_uint(struct file *file, const char *buffer,
+extern int lprocfs_wr_uint(struct file *file, const char __user *buffer,
 			   unsigned long count, void *data);
 extern int lprocfs_rd_uuid(struct seq_file *m, void *data);
 extern int lprocfs_rd_name(struct seq_file *m, void *data);
-- 
1.9.3




