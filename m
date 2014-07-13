Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524AbaGMFeG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 01:34:06 -0400
Received: from smtprelay0177.hostedemail.com ([216.40.44.177]:60843 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751173AbaGMFd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 01:33:59 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:800:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2197:2199:2393:2559:2562:2693:2828:3138:3139:3140:3141:3142:3353:3653:3865:3868:3871:3874:4250:4321:5007:7652:7903:9010:10004:10400:10848:11026:11232:11658:11914:12043:12296:12517:12519:12555:12740:13069:13221:13229:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: mask61_5cbd7ed454449
X-Filterd-Recvd-Size: 2718
Message-ID: <1405229634.9132.38.camel@joe-AO725>
Subject: [PATCH] checkpatch: Add for_each tests to indentation and brace
 tests
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>, Greg KH <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Sat, 12 Jul 2014 22:33:54 -0700
In-Reply-To: <20140712230828.GA15827@kroah.com>
References: <20140712230828.GA15827@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All the various for_each loop macros were not tested for
trailing brace on the following lines and for bad indentation.

Add them.

Reported-by: Greg KH <gregkh@linuxfoundation.org>
Signed-off-by: Joe Perches <joe@perches.com>
---
On Sat, 2014-07-12 at 16:08 -0700, Greg KH wrote:
> The following function:
> 
> $ cat foo.c 
> 
> static int foo_init(void)
> {
> 
> 	list_for_each_entry(foo, &foo, list)
> 	{
> 		do_something_foo(foo);
> 	}
> 
> 	return 0;
> }
> 
> Will not be caught by checkpatch:
> 
> $ ./scripts/checkpatch.pl --file foo.c 
> total: 0 errors, 0 warnings, 11 lines checked
> 
> foo.c has no obvious style problems and is ready for submission.

 scripts/checkpatch.pl | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index d5ac001..5efbf50 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2698,7 +2698,7 @@ sub process {
 
 # if/while/etc brace do not go on next line, unless defining a do while loop,
 # or if that brace on the next line is for something else
-		if ($line =~ /(.*)\b((?:if|while|for|switch)\s*\(|do\b|else\b)/ && $line !~ /^.\s*\#/) {
+		if ($line =~ /(.*)\b((?:if|while|for|switch|(?:[a-z_]+|)for_each[a-z_]+)\s*\(|do\b|else\b)/ && $line !~ /^.\s*\#/) {
 			my $pre_ctx = "$1$2";
 
 			my ($level, @ctx) = ctx_statement_level($linenr, $realcnt, 0);
@@ -2744,7 +2744,7 @@ sub process {
 		}
 
 # Check relative indent for conditionals and blocks.
-		if ($line =~ /\b(?:(?:if|while|for)\s*\(|do\b)/ && $line !~ /^.\s*#/ && $line !~ /\}\s*while\s*/) {
+		if ($line =~ /\b(?:(?:if|while|for|(?:[a-z_]+|)for_each[a-z_]+)\s*\(|do\b)/ && $line !~ /^.\s*#/ && $line !~ /\}\s*while\s*/) {
 			($stat, $cond, $line_nr_next, $remain_next, $off_next) =
 				ctx_statement_block($linenr, $realcnt, 0)
 					if (!defined $stat);


