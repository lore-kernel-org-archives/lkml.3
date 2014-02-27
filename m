Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754521AbaB0BdS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 20:33:18 -0500
Received: from smtprelay0241.hostedemail.com ([216.40.44.241]:49787 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753978AbaB0BdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 20:33:17 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:968:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1431:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2559:2562:2828:2892:3138:3139:3140:3141:3142:3352:3865:3866:3867:3868:3870:4321:4419:5007:6119:7652:7903:10004:10400:10848:11026:11473:11658:11914:12517:12519:12555:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: cough84_731006ec13924
X-Filterd-Recvd-Size: 2338
Message-ID: <1393464789.24588.60.camel@joe-AO722>
Subject: [PATCH] err.h: Use bool for IS_ERR and IS_ERR_OR_NULL
From: Joe Perches <joe@perches.com>
To: "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed, 26 Feb 2014 17:33:09 -0800
In-Reply-To: <530E8C2E.7080307@zytor.com>
References: <530E6F76.1070605@zytor.com>
	 <1393462087.24588.50.camel@joe-AO722> <530E8C2E.7080307@zytor.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the more natural return of bool for these tests.

No difference observed in .o files produced by gcc
for x86.

Remove the dentry description of kernel pointers
left over from the 90's and 2002's cleanup move
of parts of fs.h to err.h.

Signed-off-by: Joe Perches <joe@perches.com>
---
 include/linux/err.h | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/linux/err.h b/include/linux/err.h
index 15f92e0..a729120 100644
--- a/include/linux/err.h
+++ b/include/linux/err.h
@@ -2,12 +2,13 @@
 #define _LINUX_ERR_H
 
 #include <linux/compiler.h>
+#include <linux/types.h>
 
 #include <asm/errno.h>
 
 /*
  * Kernel pointers have redundant information, so we can use a
- * scheme where we can return either an error code or a dentry
+ * scheme where we can return either an error code or a normal
  * pointer with the same return value.
  *
  * This should be a per-architecture thing, to allow different
@@ -29,12 +30,12 @@ static inline long __must_check PTR_ERR(__force const void *ptr)
 	return (long) ptr;
 }
 
-static inline long __must_check IS_ERR(__force const void *ptr)
+static inline bool __must_check IS_ERR(__force const void *ptr)
 {
 	return IS_ERR_VALUE((unsigned long)ptr);
 }
 
-static inline long __must_check IS_ERR_OR_NULL(__force const void *ptr)
+static inline bool __must_check IS_ERR_OR_NULL(__force const void *ptr)
 {
 	return !ptr || IS_ERR_VALUE((unsigned long)ptr);
 }


