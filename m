Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753207AbaFCE6l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 00:58:41 -0400
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:34173 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751698AbaFCE6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 00:58:40 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ai0OAGFVjVNXQyle/2dsb2JhbABZgwdSqwoHAQIFAZgbgQoXdIMCI4EaN4hGAdBzF4VViH0dhCoEj0WKO4E+iV2IEoF4gUI7
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Andy Whitcroft <apw@canonical.com>,
        Joe Perches <joe@perches.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH V2] scripts/checkpatch.pl: device_initcall is not the only __initcall substitute
Date: Tue,  3 Jun 2014 06:57:21 +0200
Message-Id: <1401771441-2029-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a link to init.h to find accurate initcall function
to replace obsolete __initcall

Cc: Andy Whitcroft <apw@canonical.com>
Cc: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
V2: s/accurate/appropriate
 scripts/checkpatch.pl | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 34eb216..ee28107 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -4443,10 +4443,10 @@ sub process {
 			     "$1 is obsolete, use k$3 instead\n" . $herecurr);
 		}
 
-# check for __initcall(), use device_initcall() explicitly please
+# check for __initcall(), use device_initcall() explicitly or more appropriate function please
 		if ($line =~ /^.\s*__initcall\s*\(/) {
 			WARN("USE_DEVICE_INITCALL",
-			     "please use device_initcall() instead of __initcall()\n" . $herecurr);
+			     "please use device_initcall() or more appropriate function instead of __initcall() (see include/linux/init.h)\n" . $herecurr);
 		}
 
 # check for various ops structs, ensure they are const.
-- 
1.8.4.5

