Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251AbaJMUGu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 16:06:50 -0400
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:57790 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751058AbaJMUGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 16:06:49 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: As4NAHUwPFRbtA5F/2dsb2JhbABbgw5TWLd1BQFzkkGHVYEgFwF9hF8jgRo3iEIBtiWOYCyGIIolHYQ1BZFRhGqHEIFqlCeBR22BRTsvgkoBAQE
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Joe Perches <joe@perches.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/1 linux-next] scripts/checkpatch.pl: fix k[mz]alloc with multiplies check
Date: Mon, 13 Oct 2014 22:06:42 +0200
Message-Id: <1413230802-5507-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

checkpatch doesn't seem to detect any case since 

Commit e367455a9f25
("checkpatch: emit fewer kmalloc_array/kcalloc conversion warnings")

Cc: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 scripts/checkpatch.pl | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 374abf4..e18afcd 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -4875,8 +4875,8 @@ sub process {
 				$r1 = $a2;
 				$r2 = $a1;
 			}
-			if ($r1 !~ /^sizeof\b/ && $r2 =~ /^sizeof\s*\S/ &&
-			    !($r1 =~ /^$Constant$/ || $r1 =~ /^[A-Z_][A-Z0-9_]*$/)) {
+			if ($r1 !~ /^sizeof\b/ && !($r2 =~ /^sizeof\s*\S/ &&
+			    ($r1 =~ /^$Constant$/ || $r1 =~ /^[A-Z_][A-Z0-9_]*$/))) {
 				if (WARN("ALLOC_WITH_MULTIPLY",
 					 "Prefer $newfunc over $oldfunc with multiply\n" . $herecurr) &&
 				    $fix) {
-- 
1.9.3

