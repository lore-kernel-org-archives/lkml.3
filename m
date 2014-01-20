Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254AbaATM0N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 07:26:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34396 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753793AbaATMY7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 07:24:59 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 21/24] GFS2: Fix kbuild test robot reported warning
Date: Mon, 20 Jan 2014 12:23:44 +0000
Message-Id: <1390220627-1571-22-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1390220627-1571-1-git-send-email-swhiteho@redhat.com>
References: <1390220627-1571-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well I don't get the same warning locally as the kbuild
robot, but I guess this should fix the problem, anyway.
Here is the warning:

head:   2d9e72303d538024627fb1fe2cbde48aec12acc0
commit: ee2411a8db49a21bc55dc124e1b434ba194c8903 [19/20] GFS2: Clean up quota slot allocation
config: make ARCH=powerpc allmodconfig

All error/warnings:

   fs/gfs2/quota.c: In function 'gfs2_quota_init':
>> fs/gfs2/quota.c:1246:3: error: implicit declaration of function '__vmalloc' [-Werror=implicit-function-declaration]
      sdp->sd_quota_bitmap = __vmalloc(bm_size, GFP_NOFS, PAGE_KERNEL);
      ^
>> fs/gfs2/quota.c:1246:24: warning: assignment makes pointer from integer without a cast [enabled by default]
      sdp->sd_quota_bitmap = __vmalloc(bm_size, GFP_NOFS, PAGE_KERNEL);
                           ^
   fs/gfs2/quota.c: In function 'gfs2_quota_cleanup':
>> fs/gfs2/quota.c:1361:4: error: implicit declaration of function 'vfree' [-Werror=implicit-function-declaration]
       vfree(sdp->sd_quota_bitmap);

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index 02a2740..8bec0e31 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -56,6 +56,7 @@
 #include <linux/rculist_bl.h>
 #include <linux/bit_spinlock.h>
 #include <linux/jhash.h>
+#include <linux/vmalloc.h>
 
 #include "gfs2.h"
 #include "incore.h"
-- 
1.8.3.1

