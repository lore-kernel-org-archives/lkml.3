Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932771AbaIIO5x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 10:57:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41117 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932592AbaIIOyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 10:54:31 -0400
Date: Tue, 9 Sep 2014 07:54:09 -0700
From: "=?UTF-8?B?dGlwLWJvdCBmb3IgSmFuLVNpbW9uIE3DtmxsZXI=?=" 
	<tipbot@zytor.com>
Message-ID: <tip-cc99535eb4049c730cac421d403d079593cb31ae@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, dl9pf@gmx.de, behanw@converseincode.com,
        akpm@linux-foundation.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, dl9pf@gmx.de, behanw@converseincode.com,
        akpm@linux-foundation.org, tglx@linutronix.de
In-Reply-To: <1409959005-11479-1-git-send-email-behanw@converseincode.com>
References: <1409959005-11479-1-git-send-email-behanw@converseincode.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/mm:
  Apply the section attribute to the variable, not its type
Git-Commit-ID: cc99535eb4049c730cac421d403d079593cb31ae
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cc99535eb4049c730cac421d403d079593cb31ae
Gitweb:     http://git.kernel.org/tip/cc99535eb4049c730cac421d403d079593cb31ae
Author:     Jan-Simon Möller <dl9pf@gmx.de>
AuthorDate: Fri, 5 Sep 2014 16:16:45 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 9 Sep 2014 07:13:39 +0200

x86/mm: Apply the section attribute to the variable, not its type

This fixes a compilation error in clang in that a linker section
attribute can't be added to a type:

  arch/x86/mm/mmap.c:34:8: error: '__section__' attribute only applies to functions and global variables struct __read_mostly
  ...

By moving the section attribute to the variable declaration, the
desired effect is achieved.

Signed-off-by: Jan-Simon Möller <dl9pf@gmx.de>
Signed-off-by: Behan Webster <behanw@converseincode.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/1409959005-11479-1-git-send-email-behanw@converseincode.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/mm/mmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/mm/mmap.c b/arch/x86/mm/mmap.c
index 25e7e13..919b912 100644
--- a/arch/x86/mm/mmap.c
+++ b/arch/x86/mm/mmap.c
@@ -31,7 +31,7 @@
 #include <linux/sched.h>
 #include <asm/elf.h>
 
-struct __read_mostly va_alignment va_align = {
+struct va_alignment __read_mostly va_align = {
 	.flags = -1,
 };
 
