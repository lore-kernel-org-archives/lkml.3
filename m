Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755538Ab3KNQkm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 11:40:42 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:62434 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756201Ab3KNQjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 11:39:49 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, James Simmons <uja.ornl@gmail.com>,
        Jeff Mahoney <jeffm@suse.com>, Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 21/39] staging/lustre/autoconf: remove LC_LOCK_MAP_ACQUIRE test
Date: Fri, 15 Nov 2013 00:32:44 +0800
Message-Id: <1384446782-13741-22-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384446782-13741-1-git-send-email-bergwolf@gmail.com>
References: <1384446782-13741-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: James Simmons <uja.ornl@gmail.com>

lock_map_acquire has been in the upstream kernel since v2.6.27.
We can remove the test and dead code.

Lustre-change: http://review.whamcloud.com/5369
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-2800
Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: James Simmons <uja.ornl@gmail.com>
Reviewed-by: Bob Glossman <bob.glossman@intel.com>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/obdclass/cl_lock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lustre/obdclass/cl_lock.c b/drivers/staging/lustre/lustre/obdclass/cl_lock.c
index 749eb08..828d492 100644
--- a/drivers/staging/lustre/lustre/obdclass/cl_lock.c
+++ b/drivers/staging/lustre/lustre/obdclass/cl_lock.c
@@ -162,7 +162,7 @@ static void cl_lock_lockdep_release(const struct lu_env *env,
 				    struct cl_lock *lock)
 {
 	cl_lock_counters(env, lock)->ctc_nr_locks_acquired--;
-	lock_release(&lock->dep_map, 0, RETIP);
+	lock_map_release(&lock->dep_map);
 }
 
 #else /* !CONFIG_LOCKDEP */
-- 
1.7.9.5

