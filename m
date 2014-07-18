Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761952AbaGRTlE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 15:41:04 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:34355 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754906AbaGRTlC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 15:41:02 -0400
From: Gregory Fong <gregory.0xf0@gmail.com>
To: Andy Whitcroft <apw@canonical.com>, Joe Perches <joe@perches.com>
Cc: Brian Norris <computersforpeace@gmail.com>, linux-kernel@vger.kernel.org,
        Gregory Fong <gregory.0xf0@gmail.com>
Subject: [PATCH 1/1] checkpatch.pl: 1-tab relative indent for conditionals/blocks
Date: Fri, 18 Jul 2014 12:40:47 -0700
Message-Id: <1405712447-18788-1-git-send-email-gregory.0xf0@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following would incorrectly pass checkpatch:

void foo(void)
{
        if (a) {
                something;
                somethingelse;
        } else {
                        messed_up_indentation;
                }
}

Assume single-tab indentation of blocks to catch this.
Also add "else" to the list to check.

Signed-off-by: Gregory Fong <gregory.0xf0@gmail.com>
---
 scripts/checkpatch.pl | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 182be0f..f94c364 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2523,7 +2523,8 @@ sub process {
 		}
 
 # Check relative indent for conditionals and blocks.
-		if ($line =~ /\b(?:(?:if|while|for)\s*\(|do\b)/ && $line !~ /^.\s*#/ && $line !~ /\}\s*while\s*/) {
+		if ($line =~ /\b(?:(?:if|while|for)\s*\(|do|else\b)/ &&
+		    $line !~ /^.\s*#/ && $line !~ /\}\s*while\s*/) {
 			($stat, $cond, $line_nr_next, $remain_next, $off_next) =
 				ctx_statement_block($linenr, $realcnt, 0)
 					if (!defined $stat);
@@ -2606,6 +2607,7 @@ sub process {
 			#print "line<$line> prevline<$prevline> indent<$indent> sindent<$sindent> check<$check> continuation<$continuation> s<$s> cond_lines<$cond_lines> stat_real<$stat_real> stat<$stat>\n";
 
 			if ($check && (($sindent % 8) != 0 ||
+			    ((($sindent - $indent) / 8) > 1) ||
 			    ($sindent <= $indent && $s ne ''))) {
 				WARN("SUSPECT_CODE_INDENT",
 				     "suspect code indent for conditional statements ($indent, $sindent)\n" . $herecurr . "$stat_real\n");
-- 
1.8.3.2

