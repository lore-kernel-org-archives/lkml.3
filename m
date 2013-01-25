Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756592Ab3AYLVm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 06:21:42 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41570 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754805Ab3AYLVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 06:21:38 -0500
Date: Fri, 25 Jan 2013 03:21:22 -0800
From: tip-bot for Sasha Levin <sasha.levin@oracle.com>
Message-ID: <tip-c91368c4889a0ee5dd06552adbb50ae54f5096fd@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, sasha.levin@oracle.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, sasha.levin@oracle.com,
        mingo@redhat.com, paulus@samba.org, linux-kernel@vger.kernel.org,
        acme@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de
In-Reply-To: <1356030701-16284-22-git-send-email-sasha.levin@oracle.com>
References: <1356030701-16284-22-git-send-email-sasha.levin@oracle.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] uprobes: remove redundant check
Git-Commit-ID: c91368c4889a0ee5dd06552adbb50ae54f5096fd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 25 Jan 2013 03:21:27 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c91368c4889a0ee5dd06552adbb50ae54f5096fd
Gitweb:     http://git.kernel.org/tip/c91368c4889a0ee5dd06552adbb50ae54f5096fd
Author:     Sasha Levin <sasha.levin@oracle.com>
AuthorDate: Thu, 20 Dec 2012 14:11:30 -0500
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 24 Jan 2013 16:40:15 -0300

uprobes: remove redundant check

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
