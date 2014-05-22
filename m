Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752293AbaEVOVE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 10:21:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8921 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899AbaEVOVB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 10:21:01 -0400
From: Denys Vlasenko <dvlasenk@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Denys Vlasenko <dvlasenk@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH] Documentation/sysctl/vm.txt: clarify vfs_cache_pressure description
Date: Thu, 22 May 2014 16:20:49 +0200
Message-Id: <1400768449-16784-1-git-send-email-dvlasenk@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Existing description is worded in a way which almost encourages
setting of vfs_cache_pressure above 100, possibly way above it.

Users are left in a dark what this numeric value is - an int?
a percentage? what the scale is?

As a result, we are getting reports about noticeable performance
degradation from users who have set vfs_cache_pressure
to ridiculously high values - because they thought there is
no downside to it.

>From the code inspection it's obvious that this value is treated as
a percentage. This patch changes text to reflect this fact,
and adds a cautionary paragraph advising against setting
vfs_cache_pressure sky high.

Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
---
 Documentation/sysctl/vm.txt | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/Documentation/sysctl/vm.txt b/Documentation/sysctl/vm.txt
index dd9d0e3..2449ec54 100644
--- a/Documentation/sysctl/vm.txt
+++ b/Documentation/sysctl/vm.txt
@@ -746,8 +746,8 @@ Changing this takes effect whenever an application requests memory.
 vfs_cache_pressure
 ------------------
 
-Controls the tendency of the kernel to reclaim the memory which is used for
-caching of directory and inode objects.
+This percentage value controls the tendency of the kernel to reclaim
+the memory which is used for caching of directory and inode objects.
 
 At the default value of vfs_cache_pressure=100 the kernel will attempt to
 reclaim dentries and inodes at a "fair" rate with respect to pagecache and
@@ -757,6 +757,11 @@ never reclaim dentries and inodes due to memory pressure and this can easily
 lead to out-of-memory conditions. Increasing vfs_cache_pressure beyond 100
 causes the kernel to prefer to reclaim dentries and inodes.
 
+Increasing vfs_cache_pressure significantly beyond 100 may have negative
+performance impact. Reclaim code needs to take various locks to find freeable
+directory and inode objects. With vfs_cache_pressure=1000, it will look for
+ten times more freeable objects than there are.
+
 ==============================================================
 
 zone_reclaim_mode:
-- 
1.8.1.4

