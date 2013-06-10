Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754205Ab3FJWVg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 18:21:36 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:55572 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752084Ab3FJWVf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 18:21:35 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 05/12] checkpatch: Warn on comparisons to get_jiffies_64()
Date: Mon, 10 Jun 2013 15:20:43 -0700
Message-Id: <a1bb8b6047d974a13d8d9b98bdfc3e3ae47c59ee.1370902448.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1370902448.git.joe@perches.com>
References: <cover.1370902448.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Comparing get_jiffies_64() is almost always wrong and
time_before64 and time_after64 should be used instead.

Warn on any comparison to get_jiffies_64().

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index c274e1d..f4e247b2 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -3305,6 +3305,12 @@ sub process {
 			     "Comparing jiffies is almost always wrong; prefer time_after, time_before and friends\n" . $herecurr);
 		}
 
+# check for comparisons of get_jiffies_64()
+		if ($line =~ /\bget_jiffies_64\s*\(\s*\)\s*$Compare|$Compare\s*get_jiffies_64\s*\(\s*\)/) {
+			WARN("JIFFIES_COMPARISON",
+			     "Comparing get_jiffies_64() is almost always wrong; prefer time_after64, time_before64 and friends\n" . $herecurr);
+		}
+
 # warn about #ifdefs in C files
 #		if ($line =~ /^.\s*\#\s*if(|n)def/ && ($realfile =~ /\.c$/)) {
 #			print "#ifdef in C files should be avoided\n";
-- 
1.8.1.2.459.gbcd45b4.dirty

