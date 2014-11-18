Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932383AbaKRO1n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:27:43 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57203 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755125AbaKROKS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:10:18 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 182/206] quota: Properly return errors from dquot_writeback_dquots()
Date: Tue, 18 Nov 2014 15:08:57 +0100
Message-Id: <27612dd4c65590eb3eefe08905f0e6ed9803265b.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kara <jack@suse.cz>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 474d2605d119479e5aa050f738632e63589d4bb5 upstream.

Due to a switched left and right side of an assignment,
dquot_writeback_dquots() never returned error. This could result in
errors during quota writeback to not be reported to userspace properly.
Fix it.

Coverity-id: 1226884
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
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
2.1.3

