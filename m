Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180AbaDDI5A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 04:57:00 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:60894 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713AbaDDI4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 04:56:55 -0400
Message-ID: <533e73d6.a642420a.707f.ffffa00d@mx.google.com>
From: Mike Sampson <mike@sambodata.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Peng Tao <bergwolf@gmail.com>
CC: Masanari Iida <standby24x7@gmail.com>
CC: Andreas Dilger <andreas.dilger@intel.com>
CC: Kees Cook <keescook@chromium.org>
CC: devel@driverdev.osuosl.org
CC: linux-kernel@vger.kernel.org
CC: trivial@kernel.org
CC: mike@sambodata.com
Date: Fri, 4 Apr 2014 19:22:25 +1100
Subject: [PATCH] Staging: lustre: mark a variable static in workitem.c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

next-20140403: This fixes a sparse warning:
warning: symbol 'cfs_wi_data' was not declared. Should it be static?

Signed-off-by: Mike Sampson <mike@sambodata.com>

---
 drivers/staging/lustre/lustre/libcfs/workitem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lustre/libcfs/workitem.c b/drivers/staging/lustre/lustre/libcfs/workitem.c
index ba16fd5..0a03bf7 100644
--- a/drivers/staging/lustre/lustre/libcfs/workitem.c
+++ b/drivers/staging/lustre/lustre/libcfs/workitem.c
@@ -75,7 +75,7 @@ typedef struct cfs_wi_sched {
 	char			ws_name[CFS_WS_NAME_LEN];
 } cfs_wi_sched_t;
 
-struct cfs_workitem_data {
+static struct cfs_workitem_data {
 	/** serialize */
 	spinlock_t		wi_glock;
 	/** list of all schedulers */
-- 
1.9.1

