Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752018Ab3FZCih (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 22:38:37 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64163 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751327Ab3FZCig (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 22:38:36 -0400
X-IronPort-AV: E=Sophos;i="4.87,941,1363104000"; 
   d="scan'208";a="7683425"
Message-ID: <51CA5376.5070706@cn.fujitsu.com>
Date: Wed, 26 Jun 2013 10:35:34 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: ericvh@gmail.com, rminnich@sandia.gov, lucho@ionkov.net
CC: v9fs-developer@lists.sourceforge.net,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Subject: [PATCH] fs/v9fs: Remove the unused variable "err" in v9fs_vfs_getattr()
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/26 10:37:19,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/26 10:37:20,
	Serialize complete at 2013/06/26 10:37:20
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Delete the unused variable "err" in v9fs_vfs_getattr()

Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
---
 fs/9p/vfs_inode.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index d86edc8..25b018e 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -1054,13 +1054,11 @@ static int
 v9fs_vfs_getattr(struct vfsmount *mnt, struct dentry *dentry,
                 struct kstat *stat)
 {
-       int err;
        struct v9fs_session_info *v9ses;
        struct p9_fid *fid;
        struct p9_wstat *st;
 
        p9_debug(P9_DEBUG_VFS, "dentry: %p\n", dentry);
-       err = -EPERM;
        v9ses = v9fs_dentry2v9ses(dentry);
        if (v9ses->cache == CACHE_LOOSE || v9ses->cache == CACHE_FSCACHE) {
                generic_fillattr(dentry->d_inode, stat);
-- 
1.7.7
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/

