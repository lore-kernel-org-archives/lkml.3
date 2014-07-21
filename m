Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750940AbaGUXKB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 19:10:01 -0400
Received: from smtprelay0197.hostedemail.com ([216.40.44.197]:60831 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750777AbaGUXKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 19:10:00 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:1981:2194:2199:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3353:3653:3865:3866:3867:3870:3871:3872:3873:4250:4321:5007:7652:7903:10004:10400:10848:10967:11232:11658:11914:12043:12050:12296:12517:12519:12555:12663:12740:13069:13161:13221:13229:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: cent33_1c91743e2861c
X-Filterd-Recvd-Size: 2730
Message-ID: <1405984193.30871.10.camel@joe-AO725>
Subject: [PATCH] checkpatch: Fix false positive MISSING_BREAK warnings with
 --file
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Lee Jones <lee.jones@linaro.org>, LKML <linux-kernel@vger.kernel.org>
Date: Mon, 21 Jul 2014 16:09:53 -0700
In-Reply-To: <20140721143013.11ec351d47a9f822313247d2@linux-foundation.org>
References: <20140721113948.GX30888@lee--X1>
	 <1405948406.21586.10.camel@joe-AO725> <20140721132116.GZ30888@lee--X1>
	 <1405952929.27900.7.camel@joe-AO725>
	 <20140721143013.11ec351d47a9f822313247d2@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using --file mode can give false positives with MISSING_BREAK
fall-through warnings on simple but long multiple consecutive
case statements.

Look for all lines before a case statement for a switch
or a statement when using --file mode.

Fix a misspelling of preceded while there.

Signed-off-by: Joe Perches <joe@perches.com>
Reported-by: Lee Jones <lee.jones@linaro.org>
---

On Mon, 2014-07-21 at 14:30 -0700, Andrew Morton wrote:
> On Mon, 21 Jul 2014 07:28:49 -0700 Joe Perches <joe@perches.com> wrote:
> 
> > I'll fix it soon.
> 
> wanna do s/preceeded/preceded/g while you're in there?

Sure.  It might be a few days though as
a generic fix seems non-trivial.

There's a trivial --file fix, but I'm not
sure the patch one is appropriate.

In the mean time, the case range label patch
should be OK to commit.

 scripts/checkpatch.pl | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 2258497..74afc7c 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -4766,13 +4766,13 @@ sub process {
 			}
 		}
 
-# check for case / default statements not preceeded by break/fallthrough/switch
+# check for case / default statements not preceded by break/fallthrough/switch
 		if ($line =~ /^.\s*(?:case\s+(?:$Ident|$Constant)\s*(?:\.\.\.\s*(?:$Ident|$Constant)\s*)?|default):/) {
 			my $has_break = 0;
 			my $has_statement = 0;
 			my $count = 0;
 			my $prevline = $linenr;
-			while ($prevline > 1 && $count < 3 && !$has_break) {
+			while ($prevline > 1 && ($file || $count < 3) && !$has_break) {
 				$prevline--;
 				my $rline = $rawlines[$prevline - 1];
 				my $fline = $lines[$prevline - 1];


