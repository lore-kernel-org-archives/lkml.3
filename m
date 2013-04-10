Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932513Ab3DJDRQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 23:17:16 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:40093 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755821Ab3DJDRP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 23:17:15 -0400
Message-ID: <1365563834.27174.12.camel@joe-AO722>
Subject: [PATCH] checkpatch: Warn on comparisons to true and false
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@shadowen.org>, LKML <linux-kernel@vger.kernel.org>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>
Date: Tue, 09 Apr 2013 20:17:14 -0700
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Comparisons of A to true and false are better written
as A and !A.

Bleat a message on use.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 3fb6d86..080e7f6 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -3538,6 +3538,23 @@ sub process {
 			     "Using yield() is generally wrong. See yield() kernel-doc (sched/core.c)\n"  . $herecurr);
 		}
 
+# check for comparisons against true and false
+		if ($line =~ /\+\s*(.*?)($Lval)\s*(==|\!=)\s*(true|false)\b(.*)$/i) {
+			my $lead = $1;
+			my $arg = $2;
+			my $test = $3;
+			my $otype = $4;
+			my $trail = $5;
+			my $type = lc($otype);
+			my $op = "!";
+			if (("$test" eq "==" && "$type" eq "true") ||
+			    ("$test" eq "!=" && "$type" eq "false")) {
+				$op = "";
+			}
+			WARN("BOOL_COMPARISON",
+			     "Using comparison to $otype is poor style. Use '${lead}${op}${arg}${trail}'\n" . $herecurr);
+		}
+
 # check for semaphores initialized locked
 		if ($line =~ /^.\s*sema_init.+,\W?0\W?\)/) {
 			WARN("CONSIDER_COMPLETION",


