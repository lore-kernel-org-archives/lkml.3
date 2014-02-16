Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879AbaBPV5q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 16:57:46 -0500
Received: from smtprelay0014.hostedemail.com ([216.40.44.14]:44142 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753690AbaBPV5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 16:57:44 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:973:982:988:989:1260:1345:1359:1437:1534:1539:1711:1714:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3315:3350:3653:3865:3866:3867:4321:5007:6261:10004:10026:10848:11658:11914:12043:12517:12519:12555:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: store83_7c0b1e1a02108
X-Filterd-Recvd-Size: 1611
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] checkpatch: Avoid sscanf test duplicated messages
Date: Sun, 16 Feb 2014 13:57:27 -0800
Message-Id: <0c94d7e396b254ff9afde199a4b57539a4bcc97d.1392587681.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <c5b2c9b85c9c955208c5d4ca10f257496315e389.1392587681.git.joe@perches.com>
References: <c5b2c9b85c9c955208c5d4ca10f257496315e389.1392587681.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change a test of $dstat to $line to avoid possibly emitting the
sscanf warning multiple times.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 9f12213..e7c50977 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -4188,7 +4188,7 @@ sub process {
 # check for naked sscanf
 		if ($^V && $^V ge 5.10.0 &&
 		    defined $stat &&
-		    $stat =~ /\bsscanf\b/ &&
+		    $line =~ /\bsscanf\b/ &&
 		    ($stat !~ /$Ident\s*=\s*sscanf\s*$balanced_parens/ &&
 		     $stat !~ /\bsscanf\s*$balanced_parens\s*(?:$Compare)/ &&
 		     $stat !~ /(?:$Compare)\s*\bsscanf\s*$balanced_parens/)) {
-- 
1.8.1.2.459.gbcd45b4.dirty

