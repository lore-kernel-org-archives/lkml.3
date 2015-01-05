Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980AbbAESqH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 13:46:07 -0500
Received: from smtprelay0087.hostedemail.com ([216.40.44.87]:49275 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752938AbbAESqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 13:46:05 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 64,4,0,,d41d8cd98f00b204,joe@perches.com,:::,RULES_HIT:41:355:379:541:800:960:973:982:988:989:1260:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1534:1538:1566:1593:1594:1711:1714:1730:1747:1777:1792:2332:2393:2559:2562:2828:3138:3139:3140:3141:3142:3653:3865:5007:6119:6261:7903:10004:10400:10848:11658:11914:12517:12519:12555:13069:13311:13357:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: mice67_51fad8dd98038
X-Filterd-Recvd-Size: 1196
Message-ID: <1420483562.2652.23.camel@perches.com>
Subject: [PATCH] checkpatch: Ignore __pure $Attribute
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Mon, 05 Jan 2015 10:46:02 -0800
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just like "__cold", ignore the __pure gcc attribute macro so pointer
warnings aren't generated for uses like "int * __pure fn(...)"

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl | 1 +
 1 file changed, 1 insertion(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index f0bb6d6..b6a850c 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -278,6 +278,7 @@ our $Attribute	= qr{
 			__noreturn|
 			__used|
 			__cold|
+			__pure|
 			__noclone|
 			__deprecated|
 			__read_mostly|


