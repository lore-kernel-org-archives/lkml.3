Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755180Ab3KNQQH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 11:16:07 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:56435 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755027Ab3KNQPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 11:15:25 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Li Xi <pkuelelixi@gmail.com>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 15/40] staging/lustre/llog: fix return value of llog_alloc_handle
Date: Fri, 15 Nov 2013 00:13:17 +0800
Message-Id: <1384445622-12346-16-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384445622-12346-1-git-send-email-bergwolf@gmail.com>
References: <1384445622-12346-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Xi <pkuelelixi@gmail.com>

llog_open() calls llog_alloc_handle() taking NULL as the error return
value. But llog_alloc_handle() returns ERR_PTR(-ENOMEM) instead when
error.

Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3470
Lustre-change: http://review.whamcloud.com/6644
Signed-off-by: Li Xi <pkuelelixi@gmail.com>
Reviewed-by: Mike Pershin <mike.pershin@intel.com>
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/obdclass/llog.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lustre/obdclass/llog.c b/drivers/staging/lustre/lustre/obdclass/llog.c
index e390a42..67513be 100644
--- a/drivers/staging/lustre/lustre/obdclass/llog.c
+++ b/drivers/staging/lustre/lustre/obdclass/llog.c
@@ -62,7 +62,7 @@ struct llog_handle *llog_alloc_handle(void)
 
 	OBD_ALLOC_PTR(loghandle);
 	if (loghandle == NULL)
-		return ERR_PTR(-ENOMEM);
+		return NULL;
 
 	init_rwsem(&loghandle->lgh_lock);
 	spin_lock_init(&loghandle->lgh_hdr_lock);
-- 
1.7.9.5

