Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754245Ab3H1PmK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 11:42:10 -0400
Received: from dupo.coraid.com ([208.71.232.133]:50546 "EHLO coraid.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753809Ab3H1PmI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 11:42:08 -0400
Message-Id: <2e1689e4fd60ee1b3867b18f331e4ba3046949f6.1377185392.git.ecashin@coraid.com>
In-Reply-To: <cover.1377185392.git.ecashin@coraid.com>
References: <cover.1377185392.git.ecashin@coraid.com>
Subject: [PATCH 1/2] aoe: do not BUG if memory pressure prevented debugfs file creation
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, ecashin@coraid.com
From: Ed Cashin <ecashin@coraid.com>
X-Mailer: nedmail
Date: Wed, 28 Aug 2013 11:41:21 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the system has trouble allocating memory for the creation of the
aoe debugfs directory or of a file inside it, the debugfs member of
an aoedev can be NULL.

Do not treat a NULL debugfs pointer as a BUG on aoedev shutdown,
avoiding the user impact of an unecessary panic.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
---
 drivers/block/aoe/aoeblk.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/block/aoe/aoeblk.c b/drivers/block/aoe/aoeblk.c
index d63dcf0..dd73e1f 100644
--- a/drivers/block/aoe/aoeblk.c
+++ b/drivers/block/aoe/aoeblk.c
@@ -215,7 +215,6 @@ aoedisk_add_debugfs(struct aoedev *d)
 void
 aoedisk_rm_debugfs(struct aoedev *d)
 {
-	BUG_ON(d->debugfs == NULL);
 	debugfs_remove(d->debugfs);
 	d->debugfs = NULL;
 }
-- 
1.7.1

