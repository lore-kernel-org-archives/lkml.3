Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934317Ab3FSByJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 21:54:09 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:45515 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S933173Ab3FSBxJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 21:53:09 -0400
X-IronPort-AV: E=Sophos;i="4.87,893,1363104000"; 
   d="scan'208";a="7596291"
From: Gao feng <gaofeng@cn.fujitsu.com>
To: containers@lists.linux-foundation.org, linux-audit@redhat.com,
        linux-kernel@vger.kernel.org
Cc: eparis@redhat.com, serge.hallyn@ubuntu.com, ebiederm@xmission.com,
        sgrubb@redhat.com, aris@redhat.com, matthltc@linux.vnet.ibm.com,
        Gao feng <gaofeng@cn.fujitsu.com>
Subject: [PATCH 01/22] Audit: change type of audit_ever_enabled to bool
Date: Wed, 19 Jun 2013 09:53:33 +0800
Message-Id: <1371606834-5802-2-git-send-email-gaofeng@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1371606834-5802-1-git-send-email-gaofeng@cn.fujitsu.com>
References: <1371606834-5802-1-git-send-email-gaofeng@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/19 09:51:55,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/19 09:52:00,
	Serialize complete at 2013/06/19 09:52:00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's better to define audit_ever_enabled as bool.

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
---
 kernel/audit.c | 2 +-
 kernel/audit.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index 91e53d0..ad3084c 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -78,7 +78,7 @@ static int	audit_initialized;
 #define AUDIT_ON	1
 #define AUDIT_LOCKED	2
 int		audit_enabled;
-int		audit_ever_enabled;
+bool		audit_ever_enabled;
 
 EXPORT_SYMBOL_GPL(audit_enabled);
 
diff --git a/kernel/audit.h b/kernel/audit.h
index 1c95131..2258827 100644
--- a/kernel/audit.h
+++ b/kernel/audit.h
@@ -205,7 +205,7 @@ struct audit_context {
 #endif
 };
 
-extern int audit_ever_enabled;
+extern bool audit_ever_enabled;
 
 extern void audit_copy_inode(struct audit_names *name,
 			     const struct dentry *dentry,
-- 
1.8.1.4

