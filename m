Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161Ab3DLJiW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 05:38:22 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:48529 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752497Ab3DLJiV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 05:38:21 -0400
X-IronPort-AV: E=Sophos;i="4.87,462,1363104000"; 
   d="scan'208";a="7043471"
From: Gao feng <gaofeng@cn.fujitsu.com>
To: viro@zeniv.linux.org.uk, eparis@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-audit@redhat.com,
        akpm@linux-foundation.org, Gao feng <gaofeng@cn.fujitsu.com>
Subject: [PATCH 2/2] audit: remove unnecessary #if CONFIG_AUDIT
Date: Fri, 12 Apr 2013 17:34:21 +0800
Message-Id: <1365759261-21927-2-git-send-email-gaofeng@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1365759261-21927-1-git-send-email-gaofeng@cn.fujitsu.com>
References: <1365759261-21927-1-git-send-email-gaofeng@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/12 17:31:17,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/12 17:31:20,
	Serialize complete at 2013/04/12 17:31:20
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The files include kernel/audit.h are complied only
when CONFIG_AUDIT is set.

Just like audit_pid,there is no need to surround
audit_ever_enabled with CONFIG_AUDIT.

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
---
 kernel/audit.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/kernel/audit.h b/kernel/audit.h
index d06ffc1..11468d9 100644
--- a/kernel/audit.h
+++ b/kernel/audit.h
@@ -59,9 +59,7 @@ struct audit_entry {
 	struct audit_krule	rule;
 };
 
-#ifdef CONFIG_AUDIT
 extern int audit_ever_enabled;
-#endif
 
 extern int audit_pid;
 
-- 
1.8.1.4

