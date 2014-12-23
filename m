Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756156AbaLWNCx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 08:02:53 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:51234 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754858AbaLWNCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 08:02:51 -0500
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andy Whitcroft <apw@canonical.com>, Joe Perches <joe@perches.com>
Subject: [PATCH] checkpatch: fix UNNECESSARY_KERN_LEVEL false positive
Date: Tue, 23 Dec 2014 14:02:43 +0100
Message-Id: <1419339763-24901-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KERN_<LEVEL> is never redundant with printk_ratelimited.

Cc: Andy Whitcroft <apw@canonical.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 scripts/checkpatch.pl | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index f0bb6d60c07b..6b3afe6a3dd3 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -4545,7 +4545,7 @@ sub process {
 		}
 
 # check for logging functions with KERN_<LEVEL>
-		if ($line !~ /printk\s*\(/ &&
+		if ($line !~ /printk(?:_ratelimited)?\s*\(/ &&
 		    $line =~ /\b$logFunctions\s*\(.*\b(KERN_[A-Z]+)\b/) {
 			my $level = $1;
 			if (WARN("UNNECESSARY_KERN_LEVEL",
-- 
1.8.3.1

