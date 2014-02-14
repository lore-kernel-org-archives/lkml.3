Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752338AbaBND7v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 22:59:51 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47891 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015AbaBND7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 22:59:48 -0500
Date: Thu, 13 Feb 2014 19:59:38 -0800
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-a9143296dd612dceb0765229ccfb13fd642e2840@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        ak@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        ak@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1391845930-28580-11-git-send-email-ak@linux.intel.com>
References: <1391845930-28580-11-git-send-email-ak@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asmlinkage] asmlinkage, x86: Fix 32bit memcpy for LTO
Git-Commit-ID: a9143296dd612dceb0765229ccfb13fd642e2840
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 13 Feb 2014 19:59:44 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a9143296dd612dceb0765229ccfb13fd642e2840
Gitweb:     http://git.kernel.org/tip/a9143296dd612dceb0765229ccfb13fd642e2840
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Sat, 8 Feb 2014 08:52:07 +0100
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 13 Feb 2014 18:14:46 -0800

asmlinkage, x86: Fix 32bit memcpy for LTO

These functions can be called implicitely from gcc, and thus need to be
visible.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Link: http://lkml.kernel.org/r/1391845930-28580-11-git-send-email-ak@linux.intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
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
