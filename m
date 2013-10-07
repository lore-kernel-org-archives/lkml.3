Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756357Ab3JGTSx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 15:18:53 -0400
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:33888 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754Ab3JGTSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 15:18:52 -0400
X-Originating-IP: 173.246.103.110
Date: Mon, 7 Oct 2013 12:18:43 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: torvalds@linux-foundation.org, gregkh@linux-foundation.org,
        Andy Whitcroft <apw@canonical.com>, Joe Perches <joe@perches.com>,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH] checkpatch: Make the 80-character limit a --strict check
 only
Message-ID: <20131007191835.GA28737@jtriplet-mobl1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 80-character limit is not a hard-and-fast rule, nor should it be
applied blindly by people running checkpatch and fixing its warnings.
Sometimes it's better to violate the 80-character "limit" in the name of
readability, and when it isn't, it's often better to refactor into a
function or otherwise restructure the code rather than just finding
increasingly awkward places to break lines.

Thus, change checkpatch's LONG_LINE warning to a --strict CHK instead.
Anyone wanting to use checkpatch to check for this can easily enough
enable --strict or turn on LONG_LINE explicitly, but it shouldn't be
part of the default warnings.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---

 scripts/checkpatch.pl | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 47016c3..ed16a68 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2017,8 +2017,8 @@ sub process {
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
1.8.4.rc3

