Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752409AbaFWBc7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 21:32:59 -0400
Received: from linuxhacker.ru ([217.76.32.60]:39779 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752028AbaFWBc5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 21:32:57 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Dmitry Eremin <dmitry.eremin@intel.com>,
        Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 13/18] staging/lustre/llite: Fix uninitialized variable
Date: Sun, 22 Jun 2014 21:32:17 -0400
Message-Id: <1403487142-4880-14-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1403487142-4880-1-git-send-email-green@linuxhacker.ru>
References: <1403487142-4880-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Eremin <dmitry.eremin@intel.com>

'f.f_flags' might be used uninitialized in this function.

xattr.c:248: 'f.f_flags' is declared.
xattr.c:244: lump!= ( (void* )0) is true
xattr.c:254: 'f.f_flags' is used, but is uninitialized.

Signed-off-by: Dmitry Eremin <dmitry.eremin@intel.com>
Reviewed-on: http://review.whamcloud.com/10663
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-4629
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
Reviewed-by: James Simmons <uja.ornl@gmail.com>
Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
---
 drivers/staging/lustre/lustre/llite/xattr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/lustre/lustre/llite/xattr.c b/drivers/staging/lustre/lustre/llite/xattr.c
index c6c27bb..c1eff65 100644
--- a/drivers/staging/lustre/lustre/llite/xattr.c
+++ b/drivers/staging/lustre/lustre/llite/xattr.c
@@ -246,6 +246,7 @@ int ll_setxattr(struct dentry *dentry, const char *name,
 			int lum_size = (lump->lmm_magic == LOV_USER_MAGIC_V1) ?
 				sizeof(*lump) : sizeof(struct lov_user_md_v3);
 
+			memset(&f, 0, sizeof(f)); /* f.f_flags is used below */
 			f.f_dentry = dentry;
 			rc = ll_lov_setstripe_ea_info(inode, &f, flags, lump,
 						      lum_size);
-- 
1.9.0

