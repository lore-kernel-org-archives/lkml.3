Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753185AbaIEXQ6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 19:16:58 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:45075 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955AbaIEXQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 19:16:57 -0400
From: behanw@converseincode.com
To: hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de, x86@kernel.org
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        =?UTF-8?q?Jan-Simon=20M=C3=B6ller?= <dl9pf@gmx.de>,
        Behan Webster <behanw@converseincode.com>
Subject: [PATCH] mm: Apply the section attribute to the variable, not its type
Date: Fri,  5 Sep 2014 16:16:45 -0700
Message-Id: <1409959005-11479-1-git-send-email-behanw@converseincode.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan-Simon Möller <dl9pf@gmx.de>

This fixes a compilation error in clang in that a linker section attribute
can't be added to a type.

arch/x86/mm/mmap.c:34:8: error: '__section__' attribute only applies to functions and global variables
struct __read_mostly va_alignment va_align = {
       ^
arch/x86/include/asm/cache.h:10:38: note: expanded from macro '__read_mostly'
#define __read_mostly __attribute__((__section__(".data..read_mostly")))
                                     ^
1 error generated.

By moving the section attribute to the variable declaration, the desired effect
is acheived.

Signed-off-by: Jan-Simon Möller <dl9pf@gmx.de>
Signed-off-by: Behan Webster <behanw@converseincode.com>
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
 
-- 
1.9.1

