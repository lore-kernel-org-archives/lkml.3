Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934156Ab3FSBxo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 21:53:44 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59195 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S934089Ab3FSBxK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 21:53:10 -0400
X-IronPort-AV: E=Sophos;i="4.87,893,1363104000"; 
   d="scan'208";a="7596294"
From: Gao feng <gaofeng@cn.fujitsu.com>
To: containers@lists.linux-foundation.org, linux-audit@redhat.com,
        linux-kernel@vger.kernel.org
Cc: eparis@redhat.com, serge.hallyn@ubuntu.com, ebiederm@xmission.com,
        sgrubb@redhat.com, aris@redhat.com, matthltc@linux.vnet.ibm.com,
        Gao feng <gaofeng@cn.fujitsu.com>
Subject: [PATCH 14/22] Audit: only allow init user namespace to change audit_failure
Date: Wed, 19 Jun 2013 09:53:46 +0800
Message-Id: <1371606834-5802-15-git-send-email-gaofeng@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1371606834-5802-1-git-send-email-gaofeng@cn.fujitsu.com>
References: <1371606834-5802-1-git-send-email-gaofeng@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/19 09:51:56,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/19 09:52:01,
	Serialize complete at 2013/06/19 09:52:01
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Setting audit_failure to AUDIT_FAIL_PANIC may
cause system panic.

We should disallow uninit user namesapce to change it.

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
---
 kernel/audit.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/audit.c b/kernel/audit.c
index 306231d..79a8b8e 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -327,6 +327,9 @@ static int audit_set_failure(int state)
 	    && state != AUDIT_FAIL_PANIC)
 		return -EINVAL;
 
+	if (current_user_ns() != &init_user_ns)
+		return -EPERM;
+
 	return audit_do_config_change("audit_failure", &audit_failure, state);
 }
 
-- 
1.8.1.4

