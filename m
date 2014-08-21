Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751449AbaHUB65 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 21:58:57 -0400
Received: from mail.windriver.com ([147.11.1.11]:53676 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbaHUB64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 21:58:56 -0400
From: Ying Xue <ying.xue@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: <viro@zeniv.linux.org.uk>, <jack@suse.cz>
Subject: [PATCH] acct: eliminate compile warning
Date: Thu, 21 Aug 2014 09:58:46 +0800
Message-ID: <1408586326-24579-1-git-send-email-ying.xue@windriver.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If ACCT_VERSION is not defined to 3, below warning appears:
  CC      kernel/acct.o
  kernel/acct.c: In function ‘do_acct_process’:
  kernel/acct.c:475:24: warning: unused variable ‘ns’ [-Wunused-variable]

Signed-off-by: Ying Xue <ying.xue@windriver.com>
---
 kernel/acct.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/acct.c b/kernel/acct.c
index b4c667d..bb52701 100644
--- a/kernel/acct.c
+++ b/kernel/acct.c
@@ -472,7 +472,6 @@ static void do_acct_process(struct bsd_acct_struct *acct)
 	acct_t ac;
 	unsigned long flim;
 	const struct cred *orig_cred;
-	struct pid_namespace *ns = acct->ns;
 	struct file *file = acct->file;
 
 	/*
@@ -500,9 +499,10 @@ static void do_acct_process(struct bsd_acct_struct *acct)
 	ac.ac_gid16 = ac.ac_gid;
 #endif
 #if ACCT_VERSION == 3
-	ac.ac_pid = task_tgid_nr_ns(current, ns);
+	ac.ac_pid = task_tgid_nr_ns(current, acct->ns);
 	rcu_read_lock();
-	ac.ac_ppid = task_tgid_nr_ns(rcu_dereference(current->real_parent), ns);
+	ac.ac_ppid = task_tgid_nr_ns(rcu_dereference(current->real_parent),
+				     acct->ns);
 	rcu_read_unlock();
 #endif
 	/*
-- 
1.7.9.5

