Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117AbaLWNbf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 08:31:35 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:64149 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755281AbaLWNbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 08:31:33 -0500
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andy Whitcroft <apw@canonical.com>, Joe Perches <joe@perches.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v2] checkpatch: fix UNNECESSARY_KERN_LEVEL false positive
Date: Tue, 23 Dec 2014 14:31:25 +0100
Message-Id: <1419341485-31575-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KERN_<LEVEL> is never redundant with printk_ratelimited or printk_once.
(Except perhaps in the sense that you could use e.g. pr_err_ratelimited
or pr_err_once, but that would apply to printk as well).

Cc: Andy Whitcroft <apw@canonical.com>
Cc: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
	v1->v2: skip printk_once too [Joe Perches]

 scripts/checkpatch.pl | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index f0bb6d60c07b..350cd692a138 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -4545,7 +4545,7 @@ sub process {
 		}
 
 # check for logging functions with KERN_<LEVEL>
-		if ($line !~ /printk\s*\(/ &&
+		if ($line !~ /printk(?:_ratelimited|_once)?\s*\(/ &&
 		    $line =~ /\b$logFunctions\s*\(.*\b(KERN_[A-Z]+)\b/) {
 			my $level = $1;
 			if (WARN("UNNECESSARY_KERN_LEVEL",
-- 
1.8.3.1

