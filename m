Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933219AbaFSPCR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 11:02:17 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:59196 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932357AbaFSPCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 11:02:16 -0400
From: Anil Belur <askb23@gmail.com>
X-Google-Original-From: Anil Belur
To: andreas.dilger@intel.com, oleg.drokin@intel.com,
        gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, hpdd-discuss@ml01.01.org,
        Anil Belur <askb23@gmail.com>
Subject: [PATCH 1/1] staging: lustre: ldlm: ldlm_resource.c replace obsolete function with kstrtoul()
Date: Fri, 20 Jun 2014 01:02:08 +1000
Message-Id: <1403190128-18039-1-git-send-email-askb23@gmail.com>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anil Belur <askb23@gmail.com>

- this change fixes the warning "WARNING: simple_strtoul is obsolete, use
kstrtoul instead"
- removed the unused var 'end' as this is no longer required for
  kstrtoul()

Signed-off-by: Anil Belur <askb23@gmail.com>
---
 drivers/staging/lustre/lustre/ldlm/ldlm_resource.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/lustre/lustre/ldlm/ldlm_resource.c b/drivers/staging/lustre/lustre/ldlm/ldlm_resource.c
index c55d72f..5070a60 100644
--- a/drivers/staging/lustre/lustre/ldlm/ldlm_resource.c
+++ b/drivers/staging/lustre/lustre/ldlm/ldlm_resource.c
@@ -194,9 +194,10 @@ static ssize_t lprocfs_lru_size_seq_write(struct file *file, const char *buffer,
 				      size_t count, loff_t *off)
 {
 	struct ldlm_namespace *ns = ((struct seq_file *)file->private_data)->private;
-	char dummy[MAX_STRING_SIZE + 1], *end;
+	char dummy[MAX_STRING_SIZE + 1];
 	unsigned long tmp;
 	int lru_resize;
+	int err;
 
 	dummy[MAX_STRING_SIZE] = '\0';
 	if (copy_from_user(dummy, buffer, MAX_STRING_SIZE))
@@ -228,8 +229,8 @@ static ssize_t lprocfs_lru_size_seq_write(struct file *file, const char *buffer,
 		return count;
 	}
 
-	tmp = simple_strtoul(dummy, &end, 0);
-	if (dummy == end) {
+	err = kstrtoul(dummy, 10, &tmp);
+	if (err != 0) {
 		CERROR("invalid value written\n");
 		return -EINVAL;
 	}
-- 
1.9.0

