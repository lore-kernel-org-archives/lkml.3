Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794Ab3JKXGW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 19:06:22 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:42770 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004Ab3JKXGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 19:06:21 -0400
Date: Sat, 12 Oct 2013 01:06:03 +0200 (CEST)
From: Roel Kluin <roel.kluin@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: lockdep: testing '0' where '\0' intended?
Message-ID: <alpine.DEB.2.02.1310120043280.11060@Z>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not entirely sure about the assembly part, but shouldn't it...
--------
Test for the nul character rather than the '0' (== 0x30), in the
__get_user_unknown() case.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/kernel/lockdep_proc.c b/kernel/lockdep_proc.c
index b2c71c5..71b3aba 100644
--- a/kernel/lockdep_proc.c
+++ b/kernel/lockdep_proc.c
@@ -632,7 +632,7 @@ static ssize_t lock_stat_write(struct file *file, 
const char __user *buf,
 		if (get_user(c, buf))
 			return -EFAULT;
 
-		if (c != '0')
+		if (c != '\0')
 			return count;
 
 		list_for_each_entry(class, &all_lock_classes, lock_entry)

