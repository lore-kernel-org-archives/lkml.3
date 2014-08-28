Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935986AbaH1BiZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 21:38:25 -0400
Received: from smtprelay0150.hostedemail.com ([216.40.44.150]:36325 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932689AbaH1BiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 21:38:24 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:800:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2197:2199:2393:2538:2559:2562:2828:3138:3139:3140:3141:3142:3352:3653:3865:3867:3868:3871:4605:5007:6119:7522:7652:7903:10004:10400:10848:11026:11658:11914:12043:12517:12519:12555:13069:13161:13229:13311:13357:13846:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: spy13_834899f75db2b
X-Filterd-Recvd-Size: 2160
Message-ID: <1409189901.25751.16.camel@joe-AO725>
Subject: [PATCH] checkpatch: Allow commit descriptions on separate line from
 commit id
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Joe Lawrence <joe.lawrence@stratus.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Wed, 27 Aug 2014 18:38:21 -0700
In-Reply-To: <20140827131135.6d789d26@jlaw-desktop.mno.stratus.com>
References: 1404338448.14741.8.camel@joe-AO725 <20140827131135.6d789d26@jlaw-desktop.mno.stratus.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The general form for commit id and description is

'Commit <12+hexdigits> ("commit description/subject line")'

But commit logs often have relatively long commit ids and
the commit description is on a separate line like:

Some explanation as to why commit <12+hexdigits>
("commit description/subject line") is improved.

Allow this form.

Signed-off-by: Joe Perches <joe@perches.com>
Suggested-by: Joe Lawrence <joe.lawrence@stratus.com
Suggested-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index d89857d..4d869dd 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2133,7 +2133,10 @@ sub process {
 # Check for improperly formed commit descriptions
 		if ($in_commit_log &&
 		    $line =~ /\bcommit\s+[0-9a-f]{5,}/i &&
-		    $line !~ /\b[Cc]ommit [0-9a-f]{12,40} \("/) {
+		    !($line =~ /\b[Cc]ommit [0-9a-f]{12,40} \("/ ||
+		      ($line =~ /\b[Cc]ommit [0-9a-f]{12,40}\s*$/ &&
+		       defined $rawlines[$linenr] &&
+		       $rawlines[$linenr] =~ /^\s*\("/))) {
 			$line =~ /\b(c)ommit\s+([0-9a-f]{5,})/i;
 			my $init_char = $1;
 			my $orig_commit = lc($2);


