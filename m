Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753021Ab3JaGaG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 02:30:06 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:3631 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752629Ab3JaGaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 02:30:04 -0400
X-IronPort-AV: E=Sophos;i="4.93,606,1378828800"; 
   d="scan'208";a="8908047"
From: Gao feng <gaofeng@cn.fujitsu.com>
To: linux-audit@redhat.com
Cc: linux-kernel@vger.kernel.org, rgb@redhat.com,
        Gao feng <gaofeng@cn.fujitsu.com>
Subject: [PATCH v2] audit: remove useless code in audit_enable
Date: Thu, 31 Oct 2013 14:31:01 +0800
Message-Id: <1383201061-5940-1-git-send-email-gaofeng@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20131025183324.GD5059@madcap2.tricolour.ca>
References: <20131025183324.GD5059@madcap2.tricolour.ca>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/10/31 14:28:14,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/10/31 14:28:18,
	Serialize complete at 2013/10/31 14:28:18
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

change from v1:
convert "printk(KERN_INFO " to "pr_info(".
thanks Richard for pointing out.

diff --git a/kernel/audit.c b/kernel/audit.c
index 8378c5e..7c7c028 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -1038,17 +1038,8 @@ static int __init audit_enable(char *str)
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
+	pr_info("audit: %s\n", audit_default ?
+		"enabled (after initialization)" : "disabled (until reboot)");
 
 	return 1;
 }
-- 
1.8.3.1

