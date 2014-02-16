Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866AbaBPV5m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 16:57:42 -0500
Received: from smtprelay0119.hostedemail.com ([216.40.44.119]:56858 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753679AbaBPV5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 16:57:40 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:973:982:988:989:1260:1345:1359:1437:1534:1541:1711:1730:1747:1777:1792:2393:2528:2559:2562:2895:3138:3139:3140:3141:3142:3352:3653:3865:3867:3868:3870:3874:5007:6261:10004:10026:10848:11658:11914:12043:12517:12519:12555:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: badge85_7c5dd7c92830a
X-Filterd-Recvd-Size: 1848
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] checkpatch: Fix jiffies comparison and others
Date: Sun, 16 Feb 2014 13:57:28 -0800
Message-Id: <298d684f1fe77a3a7c15e56e0c0399b23ea711db.1392587681.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <c5b2c9b85c9c955208c5d4ca10f257496315e389.1392587681.git.joe@perches.com>
References: <c5b2c9b85c9c955208c5d4ca10f257496315e389.1392587681.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

checkpatch could not distinguish between a variable in a struct
named jiffies and the normal jiffies.

	foo->jiffies

would emit a "Comparing jiffies" arning.

Update the $Compare variable to do a negative look-behind for "-"
when finding a ">" so that a pointer dereference like -> isn't
a comparison.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index e7c50977..646295c 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -296,7 +296,7 @@ our $Float_int	= qr{(?i)[0-9]+e-?[0-9]+[fl]?};
 our $Float	= qr{$Float_hex|$Float_dec|$Float_int};
 our $Constant	= qr{$Float|$Binary|$Octal|$Hex|$Int};
 our $Assignment	= qr{\*\=|/=|%=|\+=|-=|<<=|>>=|&=|\^=|\|=|=};
-our $Compare    = qr{<=|>=|==|!=|<|>};
+our $Compare    = qr{<=|>=|==|!=|<|(?<!-)>};
 our $Arithmetic = qr{\+|-|\*|\/|%};
 our $Operators	= qr{
 			<=|>=|==|!=|
-- 
1.8.1.2.459.gbcd45b4.dirty

