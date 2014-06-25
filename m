Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758088AbaFYQy7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 12:54:59 -0400
Received: from slow1-d.mail.gandi.net ([217.70.178.86]:44888 "EHLO
	slow1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757824AbaFYQy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 12:54:57 -0400
X-Greylist: delayed 2925 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Jun 2014 12:54:57 EDT
X-Originating-IP: 50.43.32.211
Date: Wed, 25 Jun 2014 08:46:29 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Andy Whitcroft <apw@canonical.com>, Joe Perches <joe@perches.com>,
        gregkh@linux-foundation.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] scripts/checkpatch.pl: Only emit LONG_LINE for --strict
Message-ID: <20140625154629.GA21519@thin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Regardless of the long-standing debate over line width, checkpatch
should not warn about it by default.  Too many users run checkpatch and
blindly follow its recommendation by splitting long lines, which almost
invariably results in worse code.  On rare occasions, the line-width
limit encourages sensible refactoring of nested code into functions, but
more frequently it just results in painfully over-wrapped code.  Turning
this warning off by default will ensure that people who take the time to
fix up checkpatch issues in drivers (especially staging drivers) don't
waste time submitting patches that uglify code to quiet checkpatch's
line-width limit.

The on-by-default DEEP_INDENTATION warning for lines indented more than
6 levels deep makes more sense as a default, to encourage people to
refactor, since it cannot be "fixed" by simply reformatting code.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 scripts/checkpatch.pl | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 010b18e..b2eb968 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2146,8 +2146,8 @@ sub process {
 		    $line =~ /^\+\s*"[^"]*"\s*(?:\s*|,|\)\s*;)\s*$/) &&
 		    $length > $max_line_length)
 		{
-			WARN("LONG_LINE",
-			     "line over $max_line_length characters\n" . $herecurr);
+			CHK("LONG_LINE",
+			    "line over $max_line_length characters\n" . $herecurr);
 		}
 
 # Check for user-visible strings broken across lines, which breaks the ability
-- 
2.0.0

