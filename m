Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358AbaA0CxN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 21:53:13 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:49218 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753159AbaA0CxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 21:53:12 -0500
Date: Sun, 26 Jan 2014 18:52:33 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mm: bring back /sys/kernel/mm
Message-ID: <alpine.LSU.2.11.1401261849120.1259@eggly.anvils>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit da29bd36224b ("mm/mm_init.c: make creation of the mm_kobj happen
earlier than device_initcall") changed to pure_initcall(mm_sysfs_init).

That's too early: mm_sysfs_init() depends on core_initcall(ksysfs_init)
to have made the kernel_kobj directory "kernel" in which to create "mm".

Make it postcore_initcall(mm_sysfs_init).  We could use core_initcall(),
and depend upon Makefile link order kernel/ mm/ fs/ ipc/ security/ ...
as core_initcall(debugfs_init) and core_initcall(securityfs_init) do;
but better not.

Signed-off-by: Hugh Dickins <hughd@google.com>
---

 mm/mm_init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- 3.13.0+/mm/mm_init.c	2014-01-23 21:51:26.004001378 -0800
+++ linux/mm/mm_init.c	2014-01-26 18:06:40.488488209 -0800
@@ -202,4 +202,4 @@ static int __init mm_sysfs_init(void)
 
 	return 0;
 }
-pure_initcall(mm_sysfs_init);
+postcore_initcall(mm_sysfs_init);
