Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654AbaEHPKC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 11:10:02 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36120 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753969AbaEHPJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 11:09:59 -0400
Date: Thu, 8 May 2014 08:09:47 -0700
From: tip-bot for Vivek Goyal <tipbot@zytor.com>
Message-ID: <tip-a9a17104a112a67a7bf0679b734704c130eb5faa@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, vgoyal@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, vgoyal@redhat.com
In-Reply-To: <1398447972-27896-3-git-send-email-vgoyal@redhat.com>
References: <1398447972-27896-3-git-send-email-vgoyal@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/boot] x86, boot: Remove misc.h inclusion from compressed
 /string.c
Git-Commit-ID: a9a17104a112a67a7bf0679b734704c130eb5faa
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

Commit-ID:  a9a17104a112a67a7bf0679b734704c130eb5faa
Gitweb:     http://git.kernel.org/tip/a9a17104a112a67a7bf0679b734704c130eb5faa
Author:     Vivek Goyal <vgoyal@redhat.com>
AuthorDate: Fri, 25 Apr 2014 13:46:12 -0400
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 8 May 2014 08:00:06 -0700

x86, boot: Remove misc.h inclusion from compressed/string.c

Given the fact that we removed inclusion of boot.h from boot/string.c
does not look like we need misc.h inclusion in compressed/string.c. So
remove it.

misc.h was also pulling in string_32.h which in turn had macros for
memcmp and memcpy. So we don't need to #undef memcmp and memcpy anymore.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Link: http://lkml.kernel.org/r/1398447972-27896-3-git-send-email-vgoyal@redhat.com
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/boot/compressed/string.c | 4 ----
 arch/x86/boot/string.c            | 6 ------
 2 files changed, 10 deletions(-)

diff --git a/arch/x86/boot/compressed/string.c b/arch/x86/boot/compressed/string.c
index f3c57e3..00e788b 100644
--- a/arch/x86/boot/compressed/string.c
+++ b/arch/x86/boot/compressed/string.c
@@ -1,9 +1,5 @@
-#include "misc.h"
 #include "../string.c"
 
-/* misc.h might pull in string_32.h which has a macro for memcpy. undef that */
-#undef memcpy
-
 #ifdef CONFIG_X86_32
 void *memcpy(void *dest, const void *src, size_t n)
 {
diff --git a/arch/x86/boot/string.c b/arch/x86/boot/string.c
index aca52b8..493f3fd 100644
--- a/arch/x86/boot/string.c
+++ b/arch/x86/boot/string.c
@@ -15,12 +15,6 @@
 #include <linux/types.h>
 #include "ctype.h"
 
-/*
- * This file gets included in compressed/string.c which might pull in
- * string_32.h and which in turn maps memcmp to __builtin_memcmp(). Undo
- * that first.
- */
-#undef memcmp
 int memcmp(const void *s1, const void *s2, size_t len)
 {
 	u8 diff;
