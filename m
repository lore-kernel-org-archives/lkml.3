Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840AbaCGALI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 19:11:08 -0500
Received: from smtprelay0199.hostedemail.com ([216.40.44.199]:53577 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751190AbaCGALG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 19:11:06 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:800:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3865:3866:3873:3874:4321:4605:5007:7652:10004:10400:10450:10455:10848:11232:11658:11914:12043:12517:12519:12555:13019:13069:13095:13255:13311:13357:19904:19999,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: top65_935621f7db5c
X-Filterd-Recvd-Size: 2636
Message-ID: <1394151061.16156.16.camel@joe-AO722>
Subject: [PATCH] checkpatch: Always warn on missing blank line after
 variable declaration block
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, kys@microsoft.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, apw@canonical.com
Date: Thu, 06 Mar 2014 16:11:01 -0800
In-Reply-To: <20140306155517.0b3976316b0335d16ab25e38@linux-foundation.org>
References: <1394104358-23438-1-git-send-email-kys@microsoft.com>
	 <1394104390-23477-1-git-send-email-kys@microsoft.com>
	 <20140306.142919.763823800315842610.davem@davemloft.net>
	 <1394148520.16156.8.camel@joe-AO722>
	 <20140306153530.bd61c160ba6f7872d6967b2e@linux-foundation.org>
	 <1394149350.16156.13.camel@joe-AO722>
	 <20140306155517.0b3976316b0335d16ab25e38@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the test system wide, modify the message too.

Signed-off-by: Joe Perches <joe@perches.com>
---
> OK, let's do this for now.  Could you please cook up a followon patch
> which makes this kernel-wide?  I'll play with that for a while then I'll
> decide how much I feel like irritating people.

 scripts/checkpatch.pl | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index a6e3048..37a94f1 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2249,8 +2249,7 @@ sub process {
 		}
 
 # check for missing blank lines after declarations
-		if ($realfile =~ m@^(drivers/net/|net/)@ &&
-		    $prevline =~ /^\+\s+$Declare\s+$Ident/ &&
+		if ($prevline =~ /^\+\s+$Declare\s+$Ident/ &&
 		    !($prevline =~ /(?:$Compare|$Assignment|$Operators)\s*$/ ||
 		      $prevline =~ /(?:\{\s*|\\)$/) &&		#extended lines
 		    $sline =~ /^\+\s+/ &&			#Not at char 1
@@ -2260,7 +2259,7 @@ sub process {
 		      $sline =~ /^\+\s+(?:$|[\{\}\.\#\"\?\:\(])/ ||
 		      $sline =~ /^\+\s+\(?\s*(?:$Compare|$Assignment|$Operators)/)) {
 			WARN("SPACING",
-			     "networking uses a blank line after declarations\n" . $hereprev);
+			     "Missing a blank line after declarations\n" . $hereprev);
 		}
 
 # check for spaces at the beginning of a line.



