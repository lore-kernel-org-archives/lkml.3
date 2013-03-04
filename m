Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757398Ab3CDDuD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 22:50:03 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33146 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757220Ab3CDDon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:44:43 -0500
Message-Id: <20130304033711.019756775@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 04 Mar 2013 03:37:42 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, "H. Peter Anvin" <hpa@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>
Subject: [ 035/153] timeconst.pl: Eliminate Perl warning
In-Reply-To: <20130304033707.648729212@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "H. Peter Anvin" <hpa@linux.intel.com>

commit 63a3f603413ffe82ad775f2d62a5afff87fd94a0 upstream.

defined(@array) is deprecated in Perl and gives off a warning.
Restructure the code to remove that warning.

[ hpa: it would be interesting to revert to the timeconst.bc script.
  It appears that the failures reported by akpm during testing of
  that script was due to a known broken version of make, not a problem
  with bc.  The Makefile rules could probably be restructured to avoid
  the make bug, or it is probably old enough that it doesn't matter. ]

Reported-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/timeconst.pl |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/kernel/timeconst.pl
+++ b/kernel/timeconst.pl
@@ -369,10 +369,8 @@ if ($hz eq '--can') {
 		die "Usage: $0 HZ\n";
 	}
 
-	@val = @{$canned_values{$hz}};
-	if (!defined(@val)) {
-		@val = compute_values($hz);
-	}
+	$cv = $canned_values{$hz};
+	@val = defined($cv) ? @$cv : compute_values($hz);
 	output($hz, @val);
 }
 exit 0;


