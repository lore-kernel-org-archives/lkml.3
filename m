Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301AbaF0ULq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 16:11:46 -0400
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:46474 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752799AbaF0ULo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 16:11:44 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkcHALnOrVNXQCoO/2dsb2JhbABagw1Sqx0FAQEBAQEBBQFtAZkCgQ0XdYRgI4EaN4hGAcROF4VkiD1kHYQtBY96imOBRol5iDyCAIFEO4Ex
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, "Theodore Ts'o" <tytso@mit.edu>,
        Joe Perches <joe@perches.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/1] scripts/checkpatch.pl: update kmalloc_array/kcalloc conversion warning
Date: Fri, 27 Jun 2014 22:10:23 +0200
Message-Id: <1403899823-4461-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid automatic k[mz]alloc with multiplies conversions

Inspired-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 scripts/checkpatch.pl | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 182be0f..cf58a7a 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -4427,7 +4427,7 @@ sub process {
 			$newfunc = "kcalloc" if ($oldfunc eq "kzalloc");
 			if ($a1 =~ /^sizeof\s*\S/ || $a2 =~ /^sizeof\s*\S/) {
 				if (WARN("ALLOC_WITH_MULTIPLY",
-					 "Prefer $newfunc over $oldfunc with multiply\n" . $herecurr) &&
+					 "Prefer $newfunc over $oldfunc with multiply when arguments are not fixed or come from unvalidated source\n" . $herecurr) &&
 				    $fix) {
 					my $r1 = $a1;
 					my $r2 = $a2;
-- 
1.8.4.5

