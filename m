Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752197Ab3CALq4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 06:46:56 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:58991 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751936Ab3CALqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 06:46:51 -0500
X-Sasl-enc: OsI9qb4FQZgftSUYv2I/YyVYc7QLi3DquRkywjVvcwHM 1362138411
Subject: [PATCH 2/2] autofs4 - autofs4_catatonic_mode(): remove redundant
 null check on kfree()
To: Linus Torvalds <torvalds@linux-foundation.org>
From: Ian Kent <raven@themaw.net>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        autofs mailing list <autofs@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Fri, 01 Mar 2013 19:46:48 +0800
Message-ID: <20130301114647.28560.84229.stgit@perseus.fritz.box>
In-Reply-To: <20130301114639.28560.27407.stgit@perseus.fritz.box>
References: <20130301114639.28560.27407.stgit@perseus.fritz.box>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tim Gardner <tim.gardner@canonical.com>

smatch analysis:

fs/autofs4/waitq.c:46 autofs4_catatonic_mode() info: redundant null
 check on wq->name.name calling kfree()

Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
Signed-off-by: Ian Kent <raven@themaw.net>
Cc: autofs@vger.kernel.org
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

