Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757499AbaCDPDV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 10:03:21 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:43674 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757187AbaCDPDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 10:03:19 -0500
Date: Tue, 4 Mar 2014 20:33:08 +0530
From: yogesh <mr.yogesh@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Levente Kurusa <levex@linux.com>, Joe Perches <joe@perches.com>
Subject: [PATCH v2 1/1] Change checkpatch.pl for warning message in case of
 printk usage.
Message-ID: <20140304150308.GA6483@yogesh-Dell-System-XPS-L502X>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch modifies warning message when printk is used in a patch.
It mentions to use subsystem_dbg instead of netdev_dbg as the first
preferred format of logging debug messages.
Signed-off-by: Yogesh Chaudhari <mr.yogesh@gmail.com>
---
 scripts/checkpatch.pl | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 464dcef..81e8273 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2799,7 +2799,7 @@ sub process {
 			my $level2 = $level;
 			$level2 = "dbg" if ($level eq "debug");
 			WARN("PREFER_PR_LEVEL",
-			     "Prefer netdev_$level2(netdev, ... then dev_$level2(dev, ... then pr_$level(...  to printk(KERN_$orig ...\n" . $herecurr);
+			     "Prefer [subsystem eg: netdev]_$level2([subsystem]dev, ... then dev_$level2(dev, ... then pr_$level(...  to printk(KERN_$orig ...\n" . $herecurr);
 		}
 
 		if ($line =~ /\bpr_warning\s*\(/) {
