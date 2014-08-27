Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934760AbaH0PIa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 11:08:30 -0400
Received: from andre.telenet-ops.be ([195.130.132.53]:56376 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755362AbaH0PI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 11:08:28 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Andy Whitcroft <apw@canonical.com>, Joe Perches <joe@perches.com>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH resend] checkpatch: Enable whitespace checks for DTS files
Date: Wed, 27 Aug 2014 17:08:26 +0200
Message-Id: <1409152106-9424-1-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.9.1
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
index 31a731e06f50..ded90b6d7e17 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2338,7 +2338,7 @@ sub process {
 		}
 
 # check we are in a valid source file if not then ignore this hunk
-		next if ($realfile !~ /\.(h|c|s|S|pl|sh)$/);
+		next if ($realfile !~ /\.(h|c|s|S|pl|sh|dtsi|dts)$/);
 
 #line length limit
 		if ($line =~ /^\+/ && $prevrawline !~ /\/\*\*/ &&
@@ -2399,7 +2399,7 @@ sub process {
 		}
 
 # check we are in a valid source file C or perl if not then ignore this hunk
-		next if ($realfile !~ /\.(h|c|pl)$/);
+		next if ($realfile !~ /\.(h|c|pl|dtsi|dts)$/);
 
 # at the beginning of a line any tabs must come first and anything
 # more than 8 must use tabs.
-- 
1.9.1

