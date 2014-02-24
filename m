Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228AbaBXUif (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 15:38:35 -0500
Received: from mail-qc0-f176.google.com ([209.85.216.176]:48231 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752937AbaBXUid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 15:38:33 -0500
From: Tom Rini <trini@ti.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Joe Perches <joe@perches.com>,
        Josh Triplett <josh@joshtriplett.org>
Subject: [PATCH] checkpatch.pl: Add warning for new __packed additions
Date: Mon, 24 Feb 2014 15:38:16 -0500
Message-Id: <1393274296-26179-1-git-send-email-trini@ti.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While there are valid reasons to use __packed, often the answer is that
you should be doing something else here instead.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>
Cc: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Tom Rini <trini@ti.com>
---
 scripts/checkpatch.pl |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 0ea2a1e..fef3b13 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -4010,6 +4010,11 @@ sub process {
 			WARN("PREFER_PACKED",
 			     "__packed is preferred over __attribute__((packed))\n" . $herecurr);
 		}
+# Check for new packed usage, warn to use care
+		if ($line =~ /\b(__attribute__\s*\(\s*\(.*\bpacked|__packed)\b/) {
+			WARN("NEW_PACKED",
+			     "Adding new packed members is to be done with care\n" . $herecurr);
+		}
 
 # Check for __attribute__ aligned, prefer __aligned
 		if ($realfile !~ m@\binclude/uapi/@ &&
-- 
1.7.9.5

