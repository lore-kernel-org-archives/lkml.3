Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289Ab3ESSNZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 May 2013 14:13:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35634 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752450Ab3ESSNY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 May 2013 14:13:24 -0400
Date: Sun, 19 May 2013 20:09:43 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Vasiliy Kulikov <segoon@openwall.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] do_execve_common: use current_user()
Message-ID: <20130519180943.GA24227@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trivial cleanup. do_execve_common() can use current_user() and
avoid the unnecessary "struct cred *cred" var.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/exec.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 6430195..13f9bb0 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1461,7 +1461,6 @@ static int do_execve_common(const char *filename,
 	struct files_struct *displaced;
 	bool clear_in_exec;
 	int retval;
-	const struct cred *cred = current_cred();
 
 	/*
 	 * We move the actual failure in case of RLIMIT_NPROC excess from
@@ -1470,7 +1469,7 @@ static int do_execve_common(const char *filename,
 	 * whether NPROC limit is still exceeded.
 	 */
 	if ((current->flags & PF_NPROC_EXCEEDED) &&
-	    atomic_read(&cred->user->processes) > rlimit(RLIMIT_NPROC)) {
+	    atomic_read(&current_user()->processes) > rlimit(RLIMIT_NPROC)) {
 		retval = -EAGAIN;
 		goto out_ret;
 	}
-- 
1.5.5.1


