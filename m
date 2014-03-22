Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751176AbaCVNro (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 09:47:44 -0400
Received: from numidia.opendz.org ([98.142.220.152]:55884 "EHLO
	numidia.opendz.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782AbaCVNrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 09:47:40 -0400
X-Greylist: delayed 579 seconds by postgrey-1.27 at vger.kernel.org; Sat, 22 Mar 2014 09:47:40 EDT
From: Djalal Harouni <tixxdz@opendz.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Kees Cook <keescook@chromium.org>,
        Andy Lutomirski <luto@amacapital.net>, Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
Cc: Djalal Harouni <tixxdz@opendz.org>
Subject: [PATCH v2 1/2] procfs: make /proc/*/pagemap 0400
Date: Sat, 22 Mar 2014 14:37:40 +0100
Message-Id: <1395495460-7652-3-git-send-email-tixxdz@opendz.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1395495460-7652-1-git-send-email-tixxdz@opendz.org>
References: <1395495460-7652-1-git-send-email-tixxdz@opendz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The /proc/*/pagemap contain sensitive information and currently its
mode is 0444. Change this to 0400, so the VFS will prevent unprivileged
processes from getting file descriptors on arbitrary privileged
/proc/*/pagemap files.

This reduces the scope of address space leaking and bypasses by
protecting already running processes.

Cc: Eric W. Biederman <ebiederm@xmission.com>
Acked-by: Kees Cook <keescook@chromium.org>
Acked-by: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: Djalal Harouni <tixxdz@opendz.org>
---
 fs/proc/base.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index e69df4b..081d055 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2616,7 +2616,7 @@ static const struct pid_entry tgid_base_stuff[] = {
 #ifdef CONFIG_PROC_PAGE_MONITOR
 	REG("clear_refs", S_IWUSR, proc_clear_refs_operations),
 	REG("smaps",      S_IRUGO, proc_pid_smaps_operations),
-	REG("pagemap",    S_IRUGO, proc_pagemap_operations),
+	REG("pagemap",    S_IRUSR, proc_pagemap_operations),
 #endif
 #ifdef CONFIG_SECURITY
 	DIR("attr",       S_IRUGO|S_IXUGO, proc_attr_dir_inode_operations, proc_attr_dir_operations),
@@ -2954,7 +2954,7 @@ static const struct pid_entry tid_base_stuff[] = {
 #ifdef CONFIG_PROC_PAGE_MONITOR
 	REG("clear_refs", S_IWUSR, proc_clear_refs_operations),
 	REG("smaps",     S_IRUGO, proc_tid_smaps_operations),
-	REG("pagemap",    S_IRUGO, proc_pagemap_operations),
+	REG("pagemap",    S_IRUSR, proc_pagemap_operations),
 #endif
 #ifdef CONFIG_SECURITY
 	DIR("attr",      S_IRUGO|S_IXUGO, proc_attr_dir_inode_operations, proc_attr_dir_operations),
-- 
1.7.11.7

