Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756740AbaGaGHX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 02:07:23 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:46742 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756727AbaGaGHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 02:07:18 -0400
From: Anil Belur <askb23@gmail.com>
To: lisa@xenapiadmin.com, andreas.dilger@intel.com, bergwolf@gmail.com,
        gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Anil Belur <askb23@gmail.com>
Subject: [PATCH] staging: lustre: ldlm: ldlm_resource.c - fix dereferenceing user space buffer
Date: Thu, 31 Jul 2014 11:37:05 +0530
Message-Id: <1406786825-1196-1-git-send-email-askb23@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- this fixes sparse warning for directly deferencing user space buffer

./lustre/ldlm/ldlm_resource.c:202:35: warning: incorrect type in argument 2 (different address spaces)
./lustre/ldlm/ldlm_resource.c:202:35:    expected void const [noderef] <asn:1>*from
./lustre/ldlm/ldlm_resource.c:202:35:    got char const *buffer

Signed-off-by: Anil Belur <askb23@gmail.com>
---
 drivers/staging/lustre/lustre/ldlm/ldlm_resource.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/lustre/lustre/ldlm/ldlm_resource.c b/drivers/staging/lustre/lustre/ldlm/ldlm_resource.c
index 91d028b..efd45e5 100644
--- a/drivers/staging/lustre/lustre/ldlm/ldlm_resource.c
+++ b/drivers/staging/lustre/lustre/ldlm/ldlm_resource.c
@@ -189,8 +189,9 @@ static int lprocfs_lru_size_seq_show(struct seq_file *m, void *v)
 	return lprocfs_rd_uint(m, nr);
 }
 
-static ssize_t lprocfs_lru_size_seq_write(struct file *file, const char *buffer,
-				      size_t count, loff_t *off)
+static ssize_t lprocfs_lru_size_seq_write(struct file *file,
+					const char __user *buffer,
+					size_t count, loff_t *off)
 {
 	struct ldlm_namespace *ns = ((struct seq_file *)file->private_data)->private;
 	char dummy[MAX_STRING_SIZE + 1];
-- 
1.9.1

