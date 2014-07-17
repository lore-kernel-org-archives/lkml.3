Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757449AbaGQPwL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 11:52:11 -0400
Received: from smtprelay0136.hostedemail.com ([216.40.44.136]:34428 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934070AbaGQPwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 11:52:09 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 64,4,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:800:960:973:982:988:989:1260:1345:1359:1437:1534:1540:1711:1714:1730:1747:1777:1792:2332:2393:2559:2562:3138:3139:3140:3141:3142:3351:3653:3865:3866:3870:3871:3872:3874:5007:6261:7902:10004:10026:10848:11658:11914:12043:12517:12519:12555:13141:13221:13229:13230:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: fight91_2f904935f3b5e
X-Filterd-Recvd-Size: 1670
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>,
        Hartley Sweeten <HartleyS@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] checkpatch: Add short int to c variable types
Date: Thu, 17 Jul 2014 08:52:01 -0700
Message-Id: <5a4775d9d7ce9fc3d5df18308f26cb2afc86303e.1405609481.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1405609481.git.joe@perches.com>
References: <cover.1405609481.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

short int is one of the 6.7.2 c90 types.
Find it appropriately.

This fixes a defect in checkpatch where it suggests that a
line break after declaration is required using an input like:

	int foo;
	short int bar;

Without this change, it warns on the short int line.

Reported-by: Hartley Sweeten <HartleyS@visionengravers.com>
Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl | 1 +
 1 file changed, 1 insertion(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index f3d9a88..d81e4ab 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -356,6 +356,7 @@ our $signature_tags = qr{(?xi:
 our @typeList = (
 	qr{void},
 	qr{(?:unsigned\s+)?char},
+	qr{(?:unsigned\s+)?short\s+int},
 	qr{(?:unsigned\s+)?short},
 	qr{(?:unsigned\s+)?int},
 	qr{(?:unsigned\s+)?long},
-- 
1.8.1.2.459.gbcd45b4.dirty

