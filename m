Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675Ab3LCR52 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 12:57:28 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:49768 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754317Ab3LCR5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 12:57:22 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH v2 1/4] staging/lustre: fix build error in ll_setxattr_common
Date: Wed,  4 Dec 2013 01:54:56 +0800
Message-Id: <1386093299-8837-2-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386093299-8837-1-git-send-email-bergwolf@gmail.com>
References: <1386093299-8837-1-git-send-email-bergwolf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With CONFIG_FS_POSIX_ACL off, we'll get
drivers/staging/lustre/lustre/llite/xattr.c: In function ‘ll_setxattr_common’:
drivers/staging/lustre/lustre/llite/xattr.c:187:7: error: ‘rce’ undeclared (first use in this function)
drivers/staging/lustre/lustre/llite/xattr.c:187:7: note: each undeclared identifier is reported only once for each function it appears in

It was introduced by 7fc1f83 (staging/lustre/llite: extended attribute cache)
that added new reference but didn't take care of CONFIG_FS_POSIX_ACL.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Cc: Andreas Dilger <andreas.dilger@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
---
 drivers/staging/lustre/lustre/llite/xattr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lustre/llite/xattr.c b/drivers/staging/lustre/lustre/llite/xattr.c
index ee95855..3a7d03c 100644
--- a/drivers/staging/lustre/lustre/llite/xattr.c
+++ b/drivers/staging/lustre/lustre/llite/xattr.c
@@ -112,9 +112,9 @@ int ll_setxattr_common(struct inode *inode, const char *name,
 	struct ptlrpc_request *req = NULL;
 	int xattr_type, rc;
 	struct obd_capa *oc;
+	struct rmtacl_ctl_entry *rce = NULL;
 #ifdef CONFIG_FS_POSIX_ACL
 	posix_acl_xattr_header *new_value = NULL;
-	struct rmtacl_ctl_entry *rce = NULL;
 	ext_acl_xattr_header *acl = NULL;
 #endif
 	const char *pv = value;
-- 
1.7.9.5

