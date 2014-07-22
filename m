Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756628AbaGVTXO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 15:23:14 -0400
Received: from smtprelay0153.hostedemail.com ([216.40.44.153]:60543 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756609AbaGVTXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 15:23:12 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:599:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3865:3871:3872:4321:5007:6119:7652:7903:10004:10400:10848:11232:11658:11914:12043:12517:12519:12555:12740:13069:13095:13311:13357:21063:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: ear09_902436a610f12
X-Filterd-Recvd-Size: 1761
Message-ID: <1406056988.2755.1.camel@joe-AO725>
Subject: Re: checkpatch.pl false positive
From: Joe Perches <joe@perches.com>
To: Hartley Sweeten <HartleyS@visionengravers.com>
Cc: Andy Whitcroft <apw@canonical.com>, LKML <linux-kernel@vger.kernel.org>
Date: Tue, 22 Jul 2014 12:23:08 -0700
In-Reply-To: <DC148C5AA1CEBA4E87973D432B1C2D8825F13B6F@P3PWEX4MB008.ex4.secureserver.net>
References: <DC148C5AA1CEBA4E87973D432B1C2D8825F13B6F@P3PWEX4MB008.ex4.secureserver.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2014-07-22 at 17:30 +0000, Hartley Sweeten wrote:
> Joe,
> 
> I think this is a false positive, at least the check message appears
> incorrect:
> 
> CHECK: No space is necessary after a cast
> #66: FILE: arch/arm/mach-ep93xx/include/mach/platform.h:66:
> +static inline int crunch_init(void) { return 0; }

Yeah, it's a false positive introduced by -next
commit 89da401f6cff ("checkpatch: improve "no space after cast" test")

Try this?
---
diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 2258497..644c2d5 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2418,7 +2418,7 @@ sub process {
 			}
 		}
 
-		if ($line =~ /^\+.*\(\s*$Type\s*\)[ \t]+(?!$Assignment|$Arithmetic)/) {
+		if ($line =~ /^\+.*\(\s*$Type\s*\)[ \t]+(?!$Assignment|$Arithmetic|{)/) {
 			if (CHK("SPACING",
 				"No space is necessary after a cast\n" . $herecurr) &&
 			    $fix) {


