Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753578AbaIAMDz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 08:03:55 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:36656 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753425AbaIAMDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 08:03:53 -0400
From: Shakil A Khan <shakilk1729@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, paulmcquad@gmail.com,
        ionut.m.alexa@gmail.com, tglx@linutronix.de, viro@zeniv.linux.org.uk,
        Shakil A Khan <shakilk1729@gmail.com>
Subject: [PATCH 3/3] linux.next: kernel/acct.c: Fix for ns(namespace) variable is used only when ACCT_VERSION is 3
Date: Mon,  1 Sep 2014 08:03:45 -0400
Message-Id: <1409573025-52281-1-git-send-email-shakilk1729@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Shakil A Khan <shakilk1729@gmail.com>
---
 kernel/acct.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/acct.c b/kernel/acct.c
index b4c667d..5f277f5 100644
--- a/kernel/acct.c
+++ b/kernel/acct.c
@@ -472,7 +472,9 @@ static void do_acct_process(struct bsd_acct_struct *acct)
 	acct_t ac;
 	unsigned long flim;
 	const struct cred *orig_cred;
+#if ACCT_VERSION == 3
 	struct pid_namespace *ns = acct->ns;
+#endif
 	struct file *file = acct->file;
 
 	/*
-- 
1.7.1

