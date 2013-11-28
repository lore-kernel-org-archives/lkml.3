Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757730Ab3K1T4h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 14:56:37 -0500
Received: from mail-qa0-f52.google.com ([209.85.216.52]:56427 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757179Ab3K1Tzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 14:55:45 -0500
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: kay@vrfy.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        bhelgaas@google.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 34/34] sysfs, kernfs: remove cross inclusions of internal headers
Date: Thu, 28 Nov 2013 14:54:47 -0500
Message-Id: <1385668487-10181-35-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1385668487-10181-1-git-send-email-tj@kernel.org>
References: <20131128060518.GA5291@kroah.com>
 <1385668487-10181-1-git-send-email-tj@kernel.org>
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
index f33a784..d1ff591 100644
--- a/fs/kernfs/kernfs-internal.h
+++ b/fs/kernfs/kernfs-internal.h
@@ -48,8 +48,6 @@ struct sysfs_addrm_cxt {
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
1.8.4.2

