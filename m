Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934288Ab3EGCaB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 22:30:01 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:43453 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1760155Ab3EGCT3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 22:19:29 -0400
X-IronPort-AV: E=Sophos;i="4.87,625,1363104000"; 
   d="scan'208";a="7201765"
From: Gao feng <gaofeng@cn.fujitsu.com>
To: viro@zeniv.linux.org.uk, eparis@redhat.com, ebiederm@xmission.com,
        sgrubb@redhat.com, akpm@linux-foundation.org, serge.hallyn@ubuntu.com,
        davem@davemloft.net
Cc: netdev@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-audit@redhat.com,
        Gao feng <gaofeng@cn.fujitsu.com>
Subject: [PATCH RFC 16/48] Audit: user proper user namespace in audit_log_config_change
Date: Tue, 7 May 2013 10:20:37 +0800
Message-Id: <1367893269-9308-17-git-send-email-gaofeng@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1367893269-9308-1-git-send-email-gaofeng@cn.fujitsu.com>
References: <1367893269-9308-1-git-send-email-gaofeng@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/07 10:18:26,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/07 10:18:28,
	Serialize complete at 2013/05/07 10:18:28
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should user current_user_ns instead of init_user_ns.

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
---
 kernel/audit.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index d39296b..f5e106f 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -251,13 +251,14 @@ static int audit_log_config_change(char *function_name, int new, int old,
 				   int allow_changes)
 {
 	struct audit_buffer *ab;
+	struct user_namespace *ns = current_user_ns();
 	int rc = 0;
 
 	ab = audit_log_start(NULL, GFP_KERNEL, AUDIT_CONFIG_CHANGE);
 	if (unlikely(!ab))
 		return rc;
 	audit_log_format(ab, "%s=%d old=%d auid=%u ses=%u", function_name, new,
-			 old, from_kuid(&init_user_ns, loginuid), sessionid);
+			 old, from_kuid(ns, loginuid), sessionid);
 	if (sid) {
 		char *ctx = NULL;
 		u32 len;
-- 
1.8.1.4

