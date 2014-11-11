Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752282AbaKKLix (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:38:53 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57623 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754168AbaKKLKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:10:41 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jan Kara <jack@suse.cz>, Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 105/170] quota: Properly return errors from dquot_writeback_dquots()
Date: Tue, 11 Nov 2014 11:07:44 +0000
Message-Id: <1415704129-12709-106-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
References: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit 474d2605d119479e5aa050f738632e63589d4bb5 upstream.

Due to a switched left and right side of an assignment,
dquot_writeback_dquots() never returned error. This could result in
errors during quota writeback to not be reported to userspace properly.
Fix it.

Coverity-id: 1226884
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/quota/dquot.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index 7f30bdc57d13..f56a35758112 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -637,7 +637,7 @@ int dquot_writeback_dquots(struct super_block *sb, int type)
 			dqstats_inc(DQST_LOOKUPS);
 			err = sb->dq_op->write_dquot(dquot);
 			if (!ret && err)
-				err = ret;
+				ret = err;
 			dqput(dquot);
 			spin_lock(&dq_list_lock);
 		}
-- 
2.1.0

