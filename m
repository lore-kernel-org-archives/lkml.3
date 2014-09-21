Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751783AbaIURzP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 13:55:15 -0400
Received: from smtprelay0228.hostedemail.com ([216.40.44.228]:54010 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751311AbaIURzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 13:55:12 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1541:1711:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3352:3865:3866:3868:3871:4605:5007:6261:8556:10004:10026:10848:11026:11657:11658:11914:12043:12296:12438:12517:12519:12555:13161:13229:13311:13357:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: war97_1007815e8ad53
X-Filterd-Recvd-Size: 2269
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 1/2] powerpc: pci-ioda: Remove unnecessary return value from printk
Date: Sun, 21 Sep 2014 10:55:05 -0700
Message-Id: <66c8a7da00628a092e782b7818bf5bdea7408b34.1411320262.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1411320262.git.joe@perches.com>
References: <cover.1411320262.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The return value is unnecessary and unused, so make the functions
void instead of int.

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/powerpc/platforms/powernv/pci-ioda.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/platforms/powernv/pci-ioda.c b/arch/powerpc/platforms/powernv/pci-ioda.c
index df241b1..16bb93f 100644
--- a/arch/powerpc/platforms/powernv/pci-ioda.c
+++ b/arch/powerpc/platforms/powernv/pci-ioda.c
@@ -42,12 +42,11 @@
 #include "pci.h"
 
 #define define_pe_printk_level(func, kern_level)		\
-static int func(const struct pnv_ioda_pe *pe, const char *fmt, ...)	\
+static void func(const struct pnv_ioda_pe *pe, const char *fmt, ...)	\
 {								\
 	struct va_format vaf;					\
 	va_list args;						\
 	char pfix[32];						\
-	int r;							\
 								\
 	va_start(args, fmt);					\
 								\
@@ -61,12 +60,10 @@ static int func(const struct pnv_ioda_pe *pe, const char *fmt, ...)	\
 		sprintf(pfix, "%04x:%02x     ",			\
 			pci_domain_nr(pe->pbus),		\
 			pe->pbus->number);			\
-	r = printk(kern_level "pci %s: [PE# %.3d] %pV",		\
-		   pfix, pe->pe_number, &vaf);			\
+	printk(kern_level "pci %s: [PE# %.3d] %pV",		\
+	       pfix, pe->pe_number, &vaf);			\
 								\
 	va_end(args);						\
-								\
-	return r;						\
 }								\
 
 define_pe_printk_level(pe_err, KERN_ERR);
-- 
1.8.1.2.459.gbcd45b4.dirty

