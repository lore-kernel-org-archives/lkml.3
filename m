Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935759Ab3BTUfT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 15:35:19 -0500
Received: from mail-gh0-f182.google.com ([209.85.160.182]:40799 "EHLO
	mail-gh0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934922Ab3BTUfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 15:35:18 -0500
From: "Raphael S.Carvalho" <raphael.scarv@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org,
        "Raphael S.Carvalho" <raphael.scarv@gmail.com>
Subject: [PATCH 1/1] kernel/fork.c: Simplifying a snippet of code.
Date: Wed, 20 Feb 2013 17:09:35 -0300
Message-Id: <1361390975-8831-1-git-send-email-raphael.scarv@gmail.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just sending this patch in order to simplify the code.
However, I'm not sure if the code was written in that way due to specific reasons.

Signed-off-by: Raphael S.Carvalho <raphael.scarv@gmail.com>
---
 kernel/fork.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index c535f33..237204d 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1341,9 +1341,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	}
 
 	p->pid = pid_nr(pid);
-	p->tgid = p->pid;
-	if (clone_flags & CLONE_THREAD)
-		p->tgid = current->tgid;
+	p->tgid = (clone_flags & CLONE_THREAD) ? current->tgid : p->pid;
 
 	p->set_child_tid = (clone_flags & CLONE_CHILD_SETTID) ? child_tidptr : NULL;
 	/*
-- 
1.7.2.5

