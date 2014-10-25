Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751384AbaJYWJq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2014 18:09:46 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:40998 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986AbaJYWJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2014 18:09:45 -0400
From: Steven Noonan <steven@uplinklabs.net>
To: linux-kernel@vger.kernel.org
Cc: Steven Noonan <steven@uplinklabs.net>, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH] compiler-gcc*.h: remove inaccurate comment about 'asm goto' miscompiles
Date: Sat, 25 Oct 2014 15:09:42 -0700
Message-Id: <1414274982-14040-1-git-send-email-steven@uplinklabs.net>
X-Mailer: git-send-email 2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The bug referenced by the comment in this commit was not completely fixed in
GCC 4.8.2, as I mentioned in a thread back in February[1]. The conclusion at
that time was to make the quirk unconditional until the bug could be found and
fixed in GCC. Unfortunately, when I submitted the patch (commit a9f18034)
I left a comment in that claimed the bug was fixed in GCC 4.8.2+.  This comment
is inaccurate, and should be removed.

[1] https://lkml.org/lkml/2014/2/12/797
Signed-off-by: Steven Noonan <steven@uplinklabs.net>
Cc: Ingo Molnar <mingo@kernel.org>
---
 include/linux/compiler-gcc4.h | 1 -
 include/linux/compiler-gcc5.h | 1 -
 2 files changed, 2 deletions(-)

diff --git a/include/linux/compiler-gcc4.h b/include/linux/compiler-gcc4.h
index 2507fd2..d1a5582 100644
--- a/include/linux/compiler-gcc4.h
+++ b/include/linux/compiler-gcc4.h
@@ -71,7 +71,6 @@
  *   http://gcc.gnu.org/bugzilla/show_bug.cgi?id=58670
  *
  * Work it around via a compiler barrier quirk suggested by Jakub Jelinek.
- * Fixed in GCC 4.8.2 and later versions.
  *
  * (asm goto is automatically volatile - the naming reflects this.)
  */
diff --git a/include/linux/compiler-gcc5.h b/include/linux/compiler-gcc5.h
index cdd1cc2..c8c5659 100644
--- a/include/linux/compiler-gcc5.h
+++ b/include/linux/compiler-gcc5.h
@@ -53,7 +53,6 @@
  *   http://gcc.gnu.org/bugzilla/show_bug.cgi?id=58670
  *
  * Work it around via a compiler barrier quirk suggested by Jakub Jelinek.
- * Fixed in GCC 4.8.2 and later versions.
  *
  * (asm goto is automatically volatile - the naming reflects this.)
  */
-- 
2.1.2

