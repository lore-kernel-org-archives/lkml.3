Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755027AbaEBQ2u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 12:28:50 -0400
Received: from baptiste.telenet-ops.be ([195.130.132.51]:52475 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754460AbaEBQ2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 12:28:46 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Oleg Drokin <oleg.drokin@intel.com>
Cc: devel@driverdev.osuosl.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 3/3] staging/lustre/llite: Fix unused variable warning if !CONFIG_FS_POSIX_ACL
Date: Fri,  2 May 2014 18:28:35 +0200
Message-Id: <1399048115-19506-3-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1399048115-19506-1-git-send-email-geert@linux-m68k.org>
References: <1399048115-19506-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If CONFIG_FS_POSIX_ACL=n:

drivers/staging/lustre/lustre/llite/xattr.c: In function 'll_setxattr_common':
drivers/staging/lustre/lustre/llite/xattr.c:115:27: warning: unused variable 'rce' [-Wunused-variable]

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/staging/lustre/lustre/llite/xattr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lustre/llite/xattr.c b/drivers/staging/lustre/lustre/llite/xattr.c
index 67a1de41c5b2..c6c27bbb43b4 100644
--- a/drivers/staging/lustre/lustre/llite/xattr.c
+++ b/drivers/staging/lustre/lustre/llite/xattr.c
@@ -112,8 +112,8 @@ int ll_setxattr_common(struct inode *inode, const char *name,
 	struct ptlrpc_request *req = NULL;
 	int xattr_type, rc;
 	struct obd_capa *oc;
-	struct rmtacl_ctl_entry *rce = NULL;
 #ifdef CONFIG_FS_POSIX_ACL
+	struct rmtacl_ctl_entry *rce = NULL;
 	posix_acl_xattr_header *new_value = NULL;
 	ext_acl_xattr_header *acl = NULL;
 #endif
-- 
1.7.9.5

