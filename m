Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759987Ab3B0BVk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 20:21:40 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41708 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759886Ab3BZX5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 18:57:05 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [ 006/150] timeconst.pl: Eliminate Perl warning
Date: Tue, 26 Feb 2013 15:54:23 -0800
Message-Id: <20130226235524.689029517@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235523.930663721@linuxfoundation.org>
References: <20130226235523.930663721@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

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


