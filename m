Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180AbaBGMHQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 07:07:16 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:42032 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752998AbaBGMHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 07:07:10 -0500
Date: Fri, 7 Feb 2014 17:37:05 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Rashika Kheria <rashika.kheria@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Al Viro <viro@ZenIV.linux.org.uk>, linux-mm@kvack.org,
        josh@joshtriplett.org
Subject: [PATCH 4/9] mm: Mark function as static in process_vm_access.c
Message-ID: <cd2e33f9fd5b160ef5108273d7dbabd8259c4f07.1391167128.git.rashika.kheria@gmail.com>
References: <a7658fc8f2ab015bffe83de1448cc3db79d2a9fc.1391167128.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a7658fc8f2ab015bffe83de1448cc3db79d2a9fc.1391167128.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark function as static in process_vm_access.c because it is not used
outside this file.

This eliminates the following warning in mm/process_vm_access.c:
mm/process_vm_access.c:416:1: warning: no previous prototype for ‘compat_process_vm_rw’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 mm/process_vm_access.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/process_vm_access.c b/mm/process_vm_access.c
index fd26d04..f3aabbd 100644
--- a/mm/process_vm_access.c
+++ b/mm/process_vm_access.c
@@ -412,7 +412,7 @@ SYSCALL_DEFINE6(process_vm_writev, pid_t, pid,
 
 #ifdef CONFIG_COMPAT
 
-asmlinkage ssize_t
+static asmlinkage ssize_t
 compat_process_vm_rw(compat_pid_t pid,
 		     const struct compat_iovec __user *lvec,
 		     unsigned long liovcnt,
-- 
1.7.9.5

