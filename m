Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208Ab3AXUK6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 15:10:58 -0500
Received: from merlin.infradead.org ([205.233.59.134]:50163 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755880Ab3AXUIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 15:08:43 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Sasha Levin <sasha.levin@oracle.com>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 29/74] uprobes: remove redundant check
Date: Thu, 24 Jan 2013 17:07:38 -0300
Message-Id: <1359058103-31645-30-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1359058103-31645-1-git-send-email-acme@infradead.org>
References: <1359058103-31645-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sasha Levin <sasha.levin@oracle.com>

We checked for uprobe==NULL earlier, no need to redo that.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1356030701-16284-22-git-send-email-sasha.levin@oracle.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 kernel/events/uprobes.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index dea7acf..30ea9a4 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -901,8 +901,7 @@ void uprobe_unregister(struct inode *inode, loff_t offset, struct uprobe_consume
 	}
 
 	mutex_unlock(uprobes_hash(inode));
-	if (uprobe)
-		put_uprobe(uprobe);
+	put_uprobe(uprobe);
 }
 
 static struct rb_node *
-- 
1.8.1.1.361.gec3ae6e

