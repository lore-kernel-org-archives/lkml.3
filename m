Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149Ab3FJWV3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 18:21:29 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:48304 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751885Ab3FJWV0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 18:21:26 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 04/12] checkpatch: Warn on comparisons to jiffies
Date: Mon, 10 Jun 2013 15:20:42 -0700
Message-Id: <ed5cdcf8a11e69757788c63b2f69fbecb742d750.1370902448.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1370902448.git.joe@perches.com>
References: <cover.1370902448.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Comparing jiffies is almost always wrong and
time_before and time_after should be used instead.

Warn on any comparison to jiffies.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 576139a..c274e1d 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -3299,6 +3299,12 @@ sub process {
 			}
 		}
 
+# check for comparisons of jiffies
+		if ($line =~ /\bjiffies\s*$Compare|$Compare\s*jiffies\b/) {
+			WARN("JIFFIES_COMPARISON",
+			     "Comparing jiffies is almost always wrong; prefer time_after, time_before and friends\n" . $herecurr);
+		}
+
 # warn about #ifdefs in C files
 #		if ($line =~ /^.\s*\#\s*if(|n)def/ && ($realfile =~ /\.c$/)) {
 #			print "#ifdef in C files should be avoided\n";
-- 
1.8.1.2.459.gbcd45b4.dirty

