Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751886AbaKFWiz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 17:38:55 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58523 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261AbaKFWit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:38:49 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jan Kara <jack@suse.cz>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 117/162] quota: Properly return errors from dquot_writeback_dquots()
Date: Thu,  6 Nov 2014 14:36:21 -0800
Message-Id: <1415313426-9622-118-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415313426-9622-1-git-send-email-kamal@canonical.com>
References: <1415313426-9622-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit 474d2605d119479e5aa050f738632e63589d4bb5 upstream.

Due to a switched left and right side of an assignment,
dquot_writeback_dquots() never returned error. This could result in
errors during quota writeback to not be reported to userspace properly.
Fix it.

Coverity-id: 1226884
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/quota/dquot.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index ce87c90..89da957 100644
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
1.9.1

