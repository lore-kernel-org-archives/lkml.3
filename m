Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751814AbaCaV6S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 17:58:18 -0400
Received: from smtprelay0135.hostedemail.com ([216.40.44.135]:44762 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751669AbaCaV6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 17:58:13 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:800:960:968:973:982:988:989:1260:1345:1359:1437:1534:1541:1711:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3352:3865:3866:3871:3874:5007:6119:6261:10004:10026:10848:11658:11914:12517:12519:12555:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: spade47_d68bd90dfe45
X-Filterd-Recvd-Size: 1933
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] checkpatch: Don't warn on bitfield spaces around :
Date: Mon, 31 Mar 2014 14:58:08 -0700
Message-Id: <ca5f8159ab8b0f66202b50be5fae07c185198ee4.1396302777.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <bf056087fcb8139db3bbf6c187555ab64758f9d4.1396302777.git.joe@perches.com>
References: <bf056087fcb8139db3bbf6c187555ab64758f9d4.1396302777.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This test prevents code from being aligned around the :
for easy visual counting of bitfield lengths.

ie:
	int foo		: 1,
	int bar		: 2,
	int foobar	:29;

should be acceptable so remove the test.

Suggested-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index ac0169c..70c932b 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -3153,10 +3153,13 @@ sub process {
 				# // is a comment
 				} elsif ($op eq '//') {
 
+				#   :   when part of a bitfield
+				} elsif ($opv eq ':B') {
+					# skip the bitfield test for now
+
 				# No spaces for:
 				#   ->
-				#   :   when part of a bitfield
-				} elsif ($op eq '->' || $opv eq ':B') {
+				} elsif ($op eq '->') {
 					if ($ctx =~ /Wx.|.xW/) {
 						if (ERROR("SPACING",
 							  "spaces prohibited around that '$op' $at\n" . $hereptr)) {
-- 
1.8.1.2.459.gbcd45b4.dirty

