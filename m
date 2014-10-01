Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796AbaJAXG6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 19:06:58 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:39936 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525AbaJAXG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 19:06:57 -0400
Date: Thu, 2 Oct 2014 00:06:53 +0100
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] acct: fix build warning when ACCT_VERSION != 3
Message-ID: <20141001230653.GA25541@hercules>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct pid_namespace *ns is used only when ACCT_VERSION is 3.

kernel/acct.c:475:24: warning: unused variable 'ns' [-Wunused-variable]

Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/acct.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/acct.c b/kernel/acct.c
index b4c667d22e79..5f277f5c5e29 100644
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
2.1.0
