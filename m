Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751978AbaCBPHx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 10:07:53 -0500
Received: from mail-qg0-f42.google.com ([209.85.192.42]:33882 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100AbaCBPHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 10:07:52 -0500
MIME-Version: 1.0
From: Yogesh Chaudhari <mr.yogesh@gmail.com>
Date: Sun, 2 Mar 2014 20:31:18 +0530
Message-ID: <CAAOfnZp-KAFo8Q4bBW7oxe8BgUn+bSDAWuHbK6E+SF0X0Ex=Wg@mail.gmail.com>
Subject: [PATCH 1/1] scripts/checkpatch.pl: to give more detailed warning
 message in case printk is used in any patch
To: LKML <linux-kernel@vger.kernel.org>
Cc: joe@perches.com, apw@canonical.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on the discussion here:
https://lkml.org/lkml/2014/3/2/17

I would like to propose this patch to improve the warning message in
checkpatch.pl.  Comments/Suggestions on possible improvements are
welcome.


=========================================================

This patch modifies scripts/checkpatch.pl to give more detailed
warning message in case printk is used in any patch.

Signed-off-by: Yogesh Chaudhari <mr.yogesh@gmail.com>
---
 scripts/checkpatch.pl | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 464dcef..526f33aa 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2799,7 +2799,10 @@ sub process {
             my $level2 = $level;
             $level2 = "dbg" if ($level eq "debug");
             WARN("PREFER_PR_LEVEL",
-                 "Prefer netdev_$level2(netdev, ... then
dev_$level2(dev, ... then pr_$level(...  to printk(KERN_$orig ...\n" .
$herecurr);
+                 "Order of preference for printing debug messages:
+                 1. [subsystem]_$level2([subsystem]dev, ... eg
netdev_$level2(netdev, ... for netdevice object
+                 2. dev_$level2(dev, ... for drivers with struct device
+                 3. pr_$level(...  to printk(KERN_$orig ...\n" . $herecurr);
         }

         if ($line =~ /\bpr_warning\s*\(/) {





-- 
DREAM IT, CODE IT
