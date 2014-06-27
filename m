Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164AbaF0RtP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 13:49:15 -0400
Received: from smtprelay0114.hostedemail.com ([216.40.44.114]:50173 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751755AbaF0RtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 13:49:14 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:800:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3653:3865:3866:3867:4605:5007:7652:8957:10004:10400:10848:11026:11658:11914:12043:12296:12517:12519:12555:12679:13069:13221:13229:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: bulb86_334a32146bc44
X-Filterd-Recvd-Size: 2076
Message-ID: <1403891351.9064.8.camel@joe-AO725>
Subject: [PATCH] checkpatch: Allow multiple const * types
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>,
        Hartley Sweeten <HartleyS@visionengravers.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Fri, 27 Jun 2014 10:49:11 -0700
In-Reply-To: <DC148C5AA1CEBA4E87973D432B1C2D8825ED00F7@P3PWEX4MB008.ex4.secureserver.net>
References: <DC148C5AA1CEBA4E87973D432B1C2D8825ED00F7@P3PWEX4MB008.ex4.secureserver.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

checkpatch's $Type variable does not match declarations
of multiple const * types.

This can produce false positives for things like:

$ ./scripts/checkpatch.pl -f drivers/staging/comedi/comedidev.h
WARNING: Missing a blank line after declarations
#60: FILE: drivers/staging/comedi/comedidev.h:60:
+       const struct comedi_lrange *range_table;
+       const struct comedi_lrange *const *range_table_list;

Fix the $Type variable to support matching multiple "* const" uses.

Signed-off-by: Joe Perches <joe@perches.com>
Reported-by: Hartley Sweeten <HartleyS@visionengravers.com>
---
 scripts/checkpatch.pl | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 6c7cbaf..f7ae70a 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -435,7 +435,7 @@ sub build_types {
 		  }x;
 	$Type	= qr{
 			$NonptrType
-			(?:(?:\s|\*|\[\])+\s*const|(?:\s|\*|\[\])+|(?:\s*\[\s*\])+)?
+			(?:(?:\s|\*|\[\])+\s*const|(?:\s|\*\s*(?:const\s*)?|\[\])+|(?:\s*\[\s*\])+)?
 			(?:\s+$Inline|\s+$Modifier)*
 		  }x;
 	$Declare	= qr{(?:$Storage\s+(?:$Inline\s+)?)?$Type};


