Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754419Ab3KCJyQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 04:54:16 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:46498 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754319Ab3KCJyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 04:54:13 -0500
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: kay@vrfy.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        bhelgaas@google.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 39/39] sysfs, kernfs: remove cross inclusions of internal headers
Date: Sun,  3 Nov 2013 04:53:18 -0500
Message-Id: <1383472398-17812-40-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1383472398-17812-1-git-send-email-tj@kernel.org>
References: <1383472398-17812-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fs/kernfs/kernfs-internal.h needed to include fs/sysfs/sysfs.h because
part of kernfs core implementation was living in sysfs.

fs/sysfs/sysfs.h needed to include fs/kernfs/kernfs-internal.h because
include/linux/kernfs.h didn't expose enough interface.

The separation is complete and neither is true anymore.  Remove the
cross inclusion and make sysfs a proper user of kernfs.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/kernfs/kernfs-internal.h | 2 --
 fs/sysfs/sysfs.h            | 1 -
 2 files changed, 3 deletions(-)

diff --git a/fs/kernfs/kernfs-internal.h b/fs/kernfs/kernfs-internal.h
index ace0b81..a8ec6ed 100644
--- a/fs/kernfs/kernfs-internal.h
+++ b/fs/kernfs/kernfs-internal.h
@@ -57,8 +57,6 @@ struct sysfs_addrm_cxt {
 	struct sysfs_dirent	*removed;
 };
 
-#include "../sysfs/sysfs.h"
-
 /*
  * mount.c
  */
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 6a82311..c8e395b 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -11,7 +11,6 @@
 #ifndef __SYSFS_INTERNAL_H
 #define __SYSFS_INTERNAL_H
 
-#include "../kernfs/kernfs-internal.h"
 #include <linux/sysfs.h>
 
 /*
-- 
1.8.3.1

