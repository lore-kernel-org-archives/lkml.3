Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756508Ab3B1OrR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 09:47:17 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42004 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756302Ab3B1OrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:47:06 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 033/139] timeconst.pl: Eliminate Perl warning
Date: Thu, 28 Feb 2013 14:43:03 +0000
Message-Id: <1362062689-2567-34-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
References: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.7 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/timeconst.pl | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/kernel/timeconst.pl b/kernel/timeconst.pl
index eb51d76..3f42652 100644
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
-- 
1.8.1.2

