Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752049AbaBHH4W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 02:56:22 -0500
Received: from mga09.intel.com ([134.134.136.24]:27308 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751721AbaBHHw7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 02:52:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,805,1384329600"; 
   d="scan'208";a="480008631"
From: Andi Kleen <ak@linux.intel.com>
To: akpm@linux-foundation.org
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 11/14] asmlinkage, x86: Fix 32bit memcpy for LTO
Date: Sat,  8 Feb 2014 08:52:07 +0100
Message-Id: <1391845930-28580-11-git-send-email-ak@linux.intel.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391845930-28580-1-git-send-email-ak@linux.intel.com>
References: <1391845930-28580-1-git-send-email-ak@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These functions can be called implicitely from gcc, and thus need to be
visible.

Cc: x86@kernel.org
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/lib/memcpy_32.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/lib/memcpy_32.c b/arch/x86/lib/memcpy_32.c
index e78761d..a404b4b 100644
--- a/arch/x86/lib/memcpy_32.c
+++ b/arch/x86/lib/memcpy_32.c
@@ -4,7 +4,7 @@
 #undef memcpy
 #undef memset
 
-void *memcpy(void *to, const void *from, size_t n)
+__visible void *memcpy(void *to, const void *from, size_t n)
 {
 #ifdef CONFIG_X86_USE_3DNOW
 	return __memcpy3d(to, from, n);
@@ -14,13 +14,13 @@ void *memcpy(void *to, const void *from, size_t n)
 }
 EXPORT_SYMBOL(memcpy);
 
-void *memset(void *s, int c, size_t count)
+__visible void *memset(void *s, int c, size_t count)
 {
 	return __memset(s, c, count);
 }
 EXPORT_SYMBOL(memset);
 
-void *memmove(void *dest, const void *src, size_t n)
+__visible void *memmove(void *dest, const void *src, size_t n)
 {
 	int d0,d1,d2,d3,d4,d5;
 	char *ret = dest;
-- 
1.8.5.2

