Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751715Ab3DUDeZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Apr 2013 23:34:25 -0400
Received: from mga03.intel.com ([143.182.124.21]:7806 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751584Ab3DUDeY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Apr 2013 23:34:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,517,1363158000"; 
   d="scan'208";a="229799742"
From: Andi Kleen <andi@firstfloor.org>
To: apw@canonical.com
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH] checkpatch: add a rule to check devinitconst mistakes
Date: Sat, 20 Apr 2013 20:33:56 -0700
Message-Id: <1366515236-17803-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
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
 scripts/checkpatch.pl |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 4de4bc4..579f92d 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2466,6 +2466,15 @@ sub process {
 			 "missing space after $1 definition\n" . $herecurr);
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
1.7.7.6

