Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752774AbaLDEHJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 23:07:09 -0500
Received: from mail-ig0-f180.google.com ([209.85.213.180]:55615 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752057AbaLDEHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 23:07:07 -0500
From: Brian Vandre <bvandre@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Oleg Drokin <oleg.drokin@intel.com>
Cc: Brian Vandre <bvandre@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: lustre: fld: fixed symbol was not declared
Date: Wed,  3 Dec 2014 22:06:55 -0600
Message-Id: <1417666015-7967-1-git-send-email-bvandre@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes the sparse warning:
"warning: symbol 'fld_type_proc_dir' was not declared. Should it be static?"

Also removes initialization to NULL.

Signed-off-by: Brian Vandre <bvandre@gmail.com>
---
 drivers/staging/lustre/lustre/fld/fld_request.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lustre/fld/fld_request.c b/drivers/staging/lustre/lustre/fld/fld_request.c
index 0d361ff..7801db0 100644
--- a/drivers/staging/lustre/lustre/fld/fld_request.c
+++ b/drivers/staging/lustre/lustre/fld/fld_request.c
@@ -269,7 +269,7 @@ int fld_client_del_target(struct lu_client_fld *fld, __u64 idx)
 }
 EXPORT_SYMBOL(fld_client_del_target);
 
-struct proc_dir_entry *fld_type_proc_dir = NULL;
+static struct proc_dir_entry *fld_type_proc_dir;
 
 #if defined (CONFIG_PROC_FS)
 static int fld_client_proc_init(struct lu_client_fld *fld)
-- 
1.9.1

