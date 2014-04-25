Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596AbaDYRrP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 13:47:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45435 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751314AbaDYRqc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 13:46:32 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, hpa@zytor.com
Cc: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 2/2] x86/boot: Remove misc.h inclusion from compressed/string.c
Date: Fri, 25 Apr 2014 13:46:12 -0400
Message-Id: <1398447972-27896-3-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1398447972-27896-1-git-send-email-vgoyal@redhat.com>
References: <1398447972-27896-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Given the fact that we removed inclusion of boot.h from boot/string.c
does not look like we need misc.h inclusion in compressed/string.c. So
remove it.

misc.h was also pulling in string_32.h which in turn had macros for
memcmp and memcpy. So we don't need to #undef memcmp and memcpy anymore.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
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
-- 
1.9.0

