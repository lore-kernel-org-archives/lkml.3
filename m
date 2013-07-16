Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933685Ab3GPRhh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 13:37:37 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:36463 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933481Ab3GPRe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 13:34:58 -0400
From: Richard Henderson <rth@twiddle.net>
To: linux-kernel@vger.kernel.org
Cc: ink@jurassic.park.msu.ru, mattst88@gmail.com, linux-alpha@vger.kernel.org
Subject: [RFC PATCH 03/10] alpha: Force the user-visible HZ to a constant 1024.
Date: Tue, 16 Jul 2013 10:34:11 -0700
Message-Id: <1373996058-13399-4-git-send-email-rth@twiddle.net>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1373996058-13399-1-git-send-email-rth@twiddle.net>
References: <1373996058-13399-1-git-send-email-rth@twiddle.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This kernel/user split was done long ago for other architectures.

Signed-off-by: Richard Henderson <rth@twiddle.net>
---
 arch/alpha/include/asm/param.h      | 8 +++++---
 arch/alpha/include/uapi/asm/param.h | 7 -------
 2 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/arch/alpha/include/asm/param.h b/arch/alpha/include/asm/param.h
index bf46af5..a5b68b2 100644
--- a/arch/alpha/include/asm/param.h
+++ b/arch/alpha/include/asm/param.h
@@ -3,7 +3,9 @@
 
 #include <uapi/asm/param.h>
 
-#define HZ		CONFIG_HZ
-#define USER_HZ		HZ
-# define CLOCKS_PER_SEC	HZ	/* frequency at which times() counts */
+# undef HZ
+# define HZ		CONFIG_HZ
+# define USER_HZ	1024
+# define CLOCKS_PER_SEC	USER_HZ	/* frequency at which times() counts */
+
 #endif /* _ASM_ALPHA_PARAM_H */
diff --git a/arch/alpha/include/uapi/asm/param.h b/arch/alpha/include/uapi/asm/param.h
index 29daed8..dbcd983 100644
--- a/arch/alpha/include/uapi/asm/param.h
+++ b/arch/alpha/include/uapi/asm/param.h
@@ -1,13 +1,7 @@
 #ifndef _UAPI_ASM_ALPHA_PARAM_H
 #define _UAPI_ASM_ALPHA_PARAM_H
 
-/* ??? Gross.  I don't want to parameterize this, and supposedly the
-   hardware ignores reprogramming.  We also need userland buy-in to the 
-   change in HZ, since this is visible in the wait4 resources etc.  */
-
-#ifndef __KERNEL__
 #define HZ		1024
-#endif
 
 #define EXEC_PAGESIZE	8192
 
@@ -17,5 +11,4 @@
 
 #define MAXHOSTNAMELEN	64	/* max length of hostname */
 
-
 #endif /* _UAPI_ASM_ALPHA_PARAM_H */
-- 
1.8.1.4

