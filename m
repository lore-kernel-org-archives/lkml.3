Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197AbaGaHvS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 03:51:18 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:35809 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755974AbaGaHvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 03:51:16 -0400
From: Anil Belur <askb23@gmail.com>
To: kristina.martsenko@gmail.com, andreas.dilger@intel.com,
        sarah.a.sharp@linux.intel.com, gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Anil Belur <askb23@gmail.com>
Subject: [PATCH] staging: lustre: ptlrpc: lproc_ptlrpc.c - fix dereferenceing  user space buffer
Date: Thu, 31 Jul 2014 13:21:02 +0530
Message-Id: <1406793062-24051-1-git-send-email-askb23@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- this fixes sparse warning for directly deferencing user space buffer

drivers/staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c:652:33: warning: incorrect type in argument 2 (different address spaces)
drivers/staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c:652:33:    expected void const [noderef] <asn:1>*from
drivers/staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c:652:33:    got char const *buffer

Signed-off-by: Anil Belur <askb23@gmail.com>
---
 drivers/staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c b/drivers/staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c
index 6b9c6db..455c6c7 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c
@@ -628,7 +628,8 @@ out:
  * if the optional token is omitted, the operation is performed on both the
  * regular and high-priority (if the service has one) NRS head.
  */
-static ssize_t ptlrpc_lprocfs_nrs_seq_write(struct file *file, const char *buffer,
+static ssize_t ptlrpc_lprocfs_nrs_seq_write(struct file *file,
+					const char __user *buffer,
 					size_t count, loff_t *off)
 {
 	struct ptlrpc_service *svc = ((struct seq_file *)file->private_data)->private;
-- 
1.9.1

