Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932141Ab3KNQpW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 11:45:22 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:35652 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757359Ab3KNQpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 11:45:08 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, James Simmons <uja.ornl@gmail.com>,
        Jeff Mahoney <jeffm@suse.com>, Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 26/26] staging/lustre/autoconf: remove LC_BI_HW_SEGMENTS test
Date: Fri, 15 Nov 2013 00:43:13 +0800
Message-Id: <1384447393-13838-27-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384447393-13838-1-git-send-email-bergwolf@gmail.com>
References: <1384447393-13838-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: James Simmons <uja.ornl@gmail.com>

bio.bi_hw_segments has been removed from the upstream kernel
since v2.6.27

We can remove the test and dead code.

Lustre-change: http://review.whamcloud.com/5370
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-2800
Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: James Simmons <uja.ornl@gmail.com>
Reviewed-by: Bob Glossman <bob.glossman@intel.com>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 .../lustre/lustre/include/linux/lustre_compat25.h  |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/staging/lustre/lustre/include/linux/lustre_compat25.h b/drivers/staging/lustre/lustre/include/linux/lustre_compat25.h
index fbe1d69..8f82522 100644
--- a/drivers/staging/lustre/lustre/include/linux/lustre_compat25.h
+++ b/drivers/staging/lustre/lustre/include/linux/lustre_compat25.h
@@ -117,10 +117,6 @@ static inline void ll_set_fs_pwd(struct fs_struct *fs, struct vfsmount *mnt,
 #define ll_d_hlist_for_each_entry(dentry, i_dentry, alias) \
 	hlist_for_each_entry(dentry, i_dentry, alias)
 
-
-#define bio_hw_segments(q, bio) 0
-
-
 #define ll_pagevec_init(pv, cold)       do {} while (0)
 #define ll_pagevec_add(pv, pg)	  (0)
 #define ll_pagevec_lru_add_file(pv)     do {} while (0)
-- 
1.7.9.5

