Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423282Ab3CWBdB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 21:33:01 -0400
Received: from mga09.intel.com ([134.134.136.24]:55320 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422824Ab3CWBZo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 21:25:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,896,1355126400"; 
   d="scan'208";a="306338471"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, x86@kernel.org,
        Andi Kleen <ak@linux.intel.com>, apw@canonical.com
Subject: [PATCH 06/29] checkpatch: Don't warn about if ((status = _xbegin()) == _XBEGIN_STARTED)
Date: Fri, 22 Mar 2013 18:25:00 -0700
Message-Id: <1364001923-10796-7-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1364001923-10796-1-git-send-email-andi@firstfloor.org>
References: <1364001923-10796-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Writing _xbegin which is like setjmp in a if is very natural.
Stop checkpatch's whining about this.

Cc: apw@canonical.com
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 scripts/checkpatch.pl |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index b28cc38..659e683 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2831,7 +2831,10 @@ sub process {
 		    $line =~ /\b(?:if|while|for)\s*\(/ && $line !~ /^.\s*#/) {
 			my ($s, $c) = ($stat, $cond);
 
-			if ($c =~ /\bif\s*\(.*[^<>!=]=[^=].*/s) {
+			# if ((status = _xbegin()) == _XBEGIN_STARTED) is natural,
+			# so don't warn about this case.
+			if ($c =~ /\bif\s*\(.*[^<>!=]=[^=].*/s &&
+			    $c !~ /_xbegin/) {
 				ERROR("ASSIGN_IN_IF",
 				      "do not use assignment in if condition\n" . $herecurr);
 			}
-- 
1.7.7.6

