Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751618AbaJOUqJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 16:46:09 -0400
Received: from smtprelay0048.hostedemail.com ([216.40.44.48]:33150 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751196AbaJOUqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 16:46:07 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:973:982:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2553:2559:2562:2828:2902:3138:3139:3140:3141:3142:3352:3872:3873:3876:4605:5007:6261:8957:10004:10400:10848:11232:11658:11914:12043:12517:12519:12555:13019:13069:13255:13311:13357:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: shock02_8c847ba150242
X-Filterd-Recvd-Size: 2228
Message-ID: <1413405964.7484.16.camel@perches.com>
Subject: [PATCH 2/3 V2] [PATCH] checkpatch: Add error on use of
 attribute((weak)) or __weak declarations
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Date: Wed, 15 Oct 2014 13:46:04 -0700
In-Reply-To: <20141015130102.43f322c4db1ed1bf736e97f1@linux-foundation.org>
References: <cover.1413400022.git.joe@perches.com>
	 <4391d882bb26278110d07b9a5e23ec44f5f8328a.1413400022.git.joe@perches.com>
	 <20141015124225.01a4cad19c4f3a198efc996e@linux-foundation.org>
	 <1413402348.7484.8.camel@perches.com>
	 <20141015125000.44353284288395e216659953@linux-foundation.org>
	 <1413402764.7484.10.camel@perches.com>
	 <20141015130102.43f322c4db1ed1bf736e97f1@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using weak declarations can have unintended link defects.
Emit an error on its use.

Signed-off-by: Joe Perches <joe@perches.com>
---
Maybe you prefer this.
It only warns on declarations.

 scripts/checkpatch.pl | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 696254e..8a577aa 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -4671,6 +4671,15 @@ sub process {
 			}
 		}
 
+# Check for __attribute__ weak, or __weak declarations (may have link issues)
+		if ($^V && $^V ge 5.10.0 &&
+		    $line =~ /(?:$Declare|$DeclareMisordered)\s*$Ident\s*$balanced_parens\s*(?:$Attribute)?\s*;/ &&
+		    ($line =~ /\b__attribute__\s*\(\s*\(.*\bweak\b/ ||
+		     $line =~ /\b__weak\b/)) {
+			ERROR("WEAK_DECLARATION",
+			      "Using weak declarations can have unintended link defects\n" . $herecurr);
+		}
+
 # check for sizeof(&)
 		if ($line =~ /\bsizeof\s*\(\s*\&/) {
 			WARN("SIZEOF_ADDRESS",
-- 
2.1.0



