Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933485Ab3BLRMk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 12:12:40 -0500
Received: from mail.tpi.com ([70.99.223.143]:4939 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933472Ab3BLRMi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 12:12:38 -0500
From: Tim Gardner <tim.gardner@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Tim Gardner <tim.gardner@canonical.com>, Ian Kent <raven@themaw.net>,
        autofs@vger.kernel.org
Subject: [PATCH linux-next] autofs4: autofs4_catatonic_mode(): remove redundant null check on kfree()
Date: Tue, 12 Feb 2013 10:12:18 -0700
Message-Id: <1360689138-59191-1-git-send-email-tim.gardner@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

smatch analysis:

fs/autofs4/waitq.c:46 autofs4_catatonic_mode() info: redundant null
 check on wq->name.name calling kfree()

Cc: Ian Kent <raven@themaw.net>
Cc: autofs@vger.kernel.org
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 fs/autofs4/waitq.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/autofs4/waitq.c b/fs/autofs4/waitq.c
index 03bc1d3..3db70da 100644
--- a/fs/autofs4/waitq.c
+++ b/fs/autofs4/waitq.c
@@ -42,10 +42,8 @@ void autofs4_catatonic_mode(struct autofs_sb_info *sbi)
 	while (wq) {
 		nwq = wq->next;
 		wq->status = -ENOENT; /* Magic is gone - report failure */
-		if (wq->name.name) {
-			kfree(wq->name.name);
-			wq->name.name = NULL;
-		}
+		kfree(wq->name.name);
+		wq->name.name = NULL;
 		wq->wait_ctr--;
 		wake_up_interruptible(&wq->queue);
 		wq = nwq;
-- 
1.7.9.5

