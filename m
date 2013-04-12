Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873Ab3DLJtz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 05:49:55 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:19933 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752551Ab3DLJty (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 05:49:54 -0400
X-IronPort-AV: E=Sophos;i="4.87,462,1363104000"; 
   d="scan'208";a="7043470"
From: Gao feng <gaofeng@cn.fujitsu.com>
To: viro@zeniv.linux.org.uk, eparis@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-audit@redhat.com,
        akpm@linux-foundation.org, Gao feng <gaofeng@cn.fujitsu.com>
Subject: [PATCH 1/2] audit: remove duplicate export of audit_enabled
Date: Fri, 12 Apr 2013 17:34:20 +0800
Message-Id: <1365759261-21927-1-git-send-email-gaofeng@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.1.4
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/12 17:31:17,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/12 17:31:19,
	Serialize complete at 2013/04/12 17:31:19
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

audit_enabled has already been exported in
include/linux/audit.h. and kernel/audit.h
includes include/linux/audit.h, no need to
export aduit_enabled again in kernel/audit.h

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
---
 kernel/audit.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/audit.h b/kernel/audit.h
index d51cba8..d06ffc1 100644
--- a/kernel/audit.h
+++ b/kernel/audit.h
@@ -60,7 +60,6 @@ struct audit_entry {
 };
 
 #ifdef CONFIG_AUDIT
-extern int audit_enabled;
 extern int audit_ever_enabled;
 #endif
 
-- 
1.8.1.4

