Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144Ab3LLQ4f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 11:56:35 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:24796 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959Ab3LLQyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 11:54:44 -0500
From: vegard.nossum@oracle.com
To: linux-kernel@vger.kernel.org
Cc: Vegard Nossum <vegard.nossum@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5/9] hfsplus: Known exploit detection for CVE-2012-2319
Date: Thu, 12 Dec 2013 17:52:28 +0100
Message-Id: <1386867152-24072-5-git-send-email-vegard.nossum@oracle.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1386867152-24072-1-git-send-email-vegard.nossum@oracle.com>
References: <1386867152-24072-1-git-send-email-vegard.nossum@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vegard Nossum <vegard.nossum@oracle.com>

See 6f24f892871acc47b40dd594c63606a17c714f77.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 fs/hfsplus/catalog.c |    2 ++
 fs/hfsplus/dir.c     |    3 +++
 2 files changed, 5 insertions(+)

diff --git a/fs/hfsplus/catalog.c b/fs/hfsplus/catalog.c
index 968ce41..5f47a1a 100644
--- a/fs/hfsplus/catalog.c
+++ b/fs/hfsplus/catalog.c
@@ -8,6 +8,7 @@
  * Handling of catalog records
  */
 
+#include <linux/exploit.h>
 
 #include "hfsplus_fs.h"
 #include "hfsplus_raw.h"
@@ -374,6 +375,7 @@ int hfsplus_rename_cat(u32 cnid,
 	if (err)
 		goto out;
 	if (src_fd.entrylength > sizeof(entry) || src_fd.entrylength < 0) {
+		exploit("CVE-2012-2319");
 		err = -EIO;
 		goto out;
 	}
diff --git a/fs/hfsplus/dir.c b/fs/hfsplus/dir.c
index 4a4fea0..2d5e283 100644
--- a/fs/hfsplus/dir.c
+++ b/fs/hfsplus/dir.c
@@ -9,6 +9,7 @@
  */
 
 #include <linux/errno.h>
+#include <linux/exploit.h>
 #include <linux/fs.h>
 #include <linux/slab.h>
 #include <linux/random.h>
@@ -152,6 +153,7 @@ static int hfsplus_readdir(struct file *file, struct dir_context *ctx)
 	}
 	if (ctx->pos == 1) {
 		if (fd.entrylength > sizeof(entry) || fd.entrylength < 0) {
+			exploit("CVE-2012-2319");
 			err = -EIO;
 			goto out;
 		}
@@ -186,6 +188,7 @@ static int hfsplus_readdir(struct file *file, struct dir_context *ctx)
 		}
 
 		if (fd.entrylength > sizeof(entry) || fd.entrylength < 0) {
+			exploit("CVE-2012-2319");
 			err = -EIO;
 			goto out;
 		}
-- 
1.7.10.4

