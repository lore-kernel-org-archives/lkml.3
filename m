Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757325AbbAHVbl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 16:31:41 -0500
Received: from smtprelay0235.hostedemail.com ([216.40.44.235]:40045 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755244AbbAHVbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 16:31:40 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:421:541:800:960:973:982:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2197:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3653:3865:3866:3867:3868:3871:3872:3873:3874:5007:6119:6261:10004:10400:10848:11232:11658:11914:12043:12517:12519:12555:13069:13221:13229:13311:13357:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: cover00_653b14215df1f
X-Filterd-Recvd-Size: 2209
Message-ID: <1420752693.11784.13.camel@perches.com>
Subject: [PATCH] checkpatch: Allow comments in macros tested for single
 statements
From: Joe Perches <joe@perches.com>
To: Valdis.Kletnieks@vt.edu, Andrew Morton <akpm@linux-foundation.org>
Cc: shirish gajera <gajerashirish@gmail.com>, kernelnewbies@kernelnewbies.org,
        LKML <linux-kernel@vger.kernel.org>
Date: Thu, 08 Jan 2015 13:31:33 -0800
In-Reply-To: <79493.1420750167@turing-police.cc.vt.edu>
References: <CAG77vrowzc04Z4_zZfCEwhF-kx=RnAnyXa0afsYL5dGsr2=Tng@mail.gmail.com>
	 <78761.1420749142@turing-police.cc.vt.edu>
	 <CAG77vrrp-N9-C4cCmLr6p_fVM_bRwYni5-ixuOry+qE7opeU3A@mail.gmail.com>
	 <79493.1420750167@turing-police.cc.vt.edu>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert all the comments to spaces before testing for
single statement macros.

Reported-by: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Signed-off-by: Joe Perches <joe@perches.com>
---
> It's interesting that the warning only popped on the one case where the
> "/* looping version */" is on a separate line, not on the #else line.
> 
> Am cc'ing Joe Perches for that question. Joe - to get you up to speed,
> checkpatch was run against drivers/staging/skein/skein_block.c, and it
> flagged one definition of the macro R256, but not the other one, or the
> two definitions each for R512 and R1024.  Any idea why?

Yup, that was it...

 scripts/checkpatch.pl | 1 +
 1 file changed, 1 insertion(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 6afc24b..6ac355e 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -4260,6 +4260,7 @@ sub process {
 			$ctx = $dstat;
 
 			$dstat =~ s/\\\n.//g;
+			$dstat =~ s/$;/ /g;
 
 			if ($dstat =~ /^\+\s*#\s*define\s+$Ident\s*${balanced_parens}\s*do\s*{(.*)\s*}\s*while\s*\(\s*0\s*\)\s*([;\s]*)\s*$/) {
 				my $stmts = $2;


