Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752Ab3JXC6t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 22:58:49 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:29306 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753711Ab3JXC6s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 22:58:48 -0400
X-IronPort-AV: E=Sophos;i="4.93,558,1378828800"; 
   d="scan'208";a="8845238"
From: Gao feng <gaofeng@cn.fujitsu.com>
To: linux-audit@redhat.com
Cc: linux-kernel@vger.kernel.org, Gao feng <gaofeng@cn.fujitsu.com>
Subject: [PATCH] audit: remove useless code in audit_enable
Date: Thu, 24 Oct 2013 10:59:54 +0800
Message-Id: <1382583594-5426-1-git-send-email-gaofeng@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.3.1
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/10/24 10:56:12,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/10/24 10:56:13,
	Serialize complete at 2013/10/24 10:56:13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since kernel parameter is operated before
initcall, so the audit_initialized must be
AUDIT_UNINITIALIZED or DISABLED in audit_enable.

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
---
 kernel/audit.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index 50fdcba..b7269a4 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -927,17 +927,8 @@ static int __init audit_enable(char *str)
 	if (!audit_default)
 		audit_initialized = AUDIT_DISABLED;
 
-	printk(KERN_INFO "audit: %s", audit_default ? "enabled" : "disabled");
-
-	if (audit_initialized == AUDIT_INITIALIZED) {
-		audit_enabled = audit_default;
-		audit_ever_enabled |= !!audit_default;
-	} else if (audit_initialized == AUDIT_UNINITIALIZED) {
-		printk(" (after initialization)");
-	} else {
-		printk(" (until reboot)");
-	}
-	printk("\n");
+	printk(KERN_INFO "audit: %s\n", audit_default ?
+		"enabled (after initialization)" : "disabled (until reboot)");
 
 	return 1;
 }
-- 
1.8.3.1

