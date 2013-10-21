Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753663Ab3JUPVs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 11:21:48 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:44207 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277Ab3JUPVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 11:21:46 -0400
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 1/4] lustre/fld: remove fld_thread_key
Date: Mon, 21 Oct 2013 23:18:22 +0800
Message-Id: <1382368705-4199-1-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is left over when porting Lustre tree patch in commit (e62e5d92) and should be
removed.

Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/fld/fld_request.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/staging/lustre/lustre/fld/fld_request.c b/drivers/staging/lustre/lustre/fld/fld_request.c
index 078e98b..e47fd50 100644
--- a/drivers/staging/lustre/lustre/fld/fld_request.c
+++ b/drivers/staging/lustre/lustre/fld/fld_request.c
@@ -59,8 +59,6 @@
 #include <lustre_mdc.h>
 #include "fld_internal.h"
 
-struct lu_context_key fld_thread_key;
-
 /* TODO: these 3 functions are copies of flow-control code from mdc_lib.c
  * It should be common thing. The same about mdc RPC lock */
 static int fld_req_avail(struct client_obd *cli, struct mdc_cache_waiter *mcw)
@@ -509,14 +507,11 @@ static int __init fld_mod_init(void)
 	if (IS_ERR(fld_type_proc_dir))
 		return PTR_ERR(fld_type_proc_dir);
 
-	LU_CONTEXT_KEY_INIT(&fld_thread_key);
-	lu_context_key_register(&fld_thread_key);
 	return 0;
 }
 
 static void __exit fld_mod_exit(void)
 {
-	lu_context_key_degister(&fld_thread_key);
 	if (fld_type_proc_dir != NULL && !IS_ERR(fld_type_proc_dir)) {
 		lprocfs_remove(&fld_type_proc_dir);
 		fld_type_proc_dir = NULL;
-- 
1.7.9.5

