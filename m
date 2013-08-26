Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757128Ab3HZQZh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 12:25:37 -0400
Received: from numidia.opendz.org ([98.142.220.152]:39339 "EHLO
	numidia.opendz.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105Ab3HZQZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 12:25:36 -0400
From: Djalal Harouni <tixxdz@opendz.org>
To: Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
Cc: Djalal Harouni <tixxdz@opendz.org>
Subject: [PATCH 2/2] procfs: restore 0400 permissions on /proc/*/pagemap
Date: Mon, 26 Aug 2013 17:24:00 +0100
Message-Id: <1377534240-13227-2-git-send-email-tixxdz@opendz.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1377534240-13227-1-git-send-email-tixxdz@opendz.org>
References: <1377534240-13227-1-git-send-email-tixxdz@opendz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not give an fd on privileged /proc/*/pagemap files for free.

Restore the previous 0400 mode

Signed-off-by: Djalal Harouni <tixxdz@opendz.org>
---
 fs/proc/base.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 6b162cd..93a1c89 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2605,7 +2605,7 @@ static const struct pid_entry tgid_base_stuff[] = {
 #ifdef CONFIG_PROC_PAGE_MONITOR
 	REG("clear_refs", S_IWUSR, proc_clear_refs_operations),
 	REG("smaps",      S_IRUGO, proc_pid_smaps_operations),
-	REG("pagemap",    S_IRUGO, proc_pagemap_operations),
+	REG("pagemap",    S_IRUSR, proc_pagemap_operations),
 #endif
 #ifdef CONFIG_SECURITY
 	DIR("attr",       S_IRUGO|S_IXUGO, proc_attr_dir_inode_operations, proc_attr_dir_operations),
@@ -2943,7 +2943,7 @@ static const struct pid_entry tid_base_stuff[] = {
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

