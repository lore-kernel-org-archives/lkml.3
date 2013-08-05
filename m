Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437Ab3HEWKz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 18:10:55 -0400
Received: from mga01.intel.com ([192.55.52.88]:63191 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755055Ab3HEWKx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 18:10:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,821,1367996400"; 
   d="scan'208";a="381715727"
From: Andi Kleen <andi@firstfloor.org>
To: apw@canonical.com
Cc: joe@perches.com, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH] checkpatch: add a rule to check devinitconst mistakes
Date: Mon,  5 Aug 2013 15:10:51 -0700
Message-Id: <1375740651-7716-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Check for const __devinitdata and non const __devinitconst

People get this regularly wrong and it breaks the LTO builds,
as it causes a section attribute conflict.

This doesn't catch all mistakes -- spreading over multiple lines,
getting const pointers wrong, but hopefully the common ones.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 scripts/checkpatch.pl | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 2ee9eb7..5d68d9c 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2676,6 +2676,15 @@ sub process {
 			}
 		}
 
+# check for __devinitdata with const or const without __devintconst
+# XXX should scan multiple lines and handle misplaced consts for pointers
+		if ($line =~ /const/ && $line =~ /__(dev)?initdata/) {
+		    ERROR("DEVINITCONST", "const init definition must use __devinitconst");
+		}
+		if ($line =~ /__(dev)?initconst/ && $line !~ /\Wconst\W/) {
+		    ERROR("DEVINITCONST", "__devinitconst must have have const definition");
+		}
+
 # check for spacing round square brackets; allowed:
 #  1. with a type on the left -- int [] a;
 #  2. at the beginning of a line for slice initialisers -- [0...10] = 5,
-- 
1.8.3.1

