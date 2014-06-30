Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284AbaF3Jxj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 05:53:39 -0400
Received: from baptiste.telenet-ops.be ([195.130.132.51]:43763 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754686AbaF3Jxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 05:53:37 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Andy Whitcroft <apw@canonical.com>, Joe Perches <joe@perches.com>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH] checkpatch: Enable whitespace checks for DTS files
Date: Mon, 30 Jun 2014 11:53:31 +0200
Message-Id: <1404122011-11409-1-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When run on *.dtsi or *.dts files, the whitespace checks were skipped,
while they are valid for DTS files.  Hence stop skipping them.

I ran checkpatch on all in-tree DTS files, and didn't notice any error or
warning messages that are inappropriate for DTS files.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 scripts/checkpatch.pl | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 010b18ef4ea0..9ae624942a84 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2137,7 +2137,7 @@ sub process {
 		}
 
 # check we are in a valid source file if not then ignore this hunk
-		next if ($realfile !~ /\.(h|c|s|S|pl|sh)$/);
+		next if ($realfile !~ /\.(h|c|s|S|pl|sh|dtsi|dts)$/);
 
 #line length limit
 		if ($line =~ /^\+/ && $prevrawline !~ /\/\*\*/ &&
@@ -2192,7 +2192,7 @@ sub process {
 		}
 
 # check we are in a valid source file C or perl if not then ignore this hunk
-		next if ($realfile !~ /\.(h|c|pl)$/);
+		next if ($realfile !~ /\.(h|c|pl|dtsi|dts)$/);
 
 # at the beginning of a line any tabs must come first and anything
 # more than 8 must use tabs.
-- 
1.9.1

