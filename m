Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934360Ab3EGCbk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 22:31:40 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:43453 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1760069Ab3EGCT1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 22:19:27 -0400
X-IronPort-AV: E=Sophos;i="4.87,625,1363104000"; 
   d="scan'208";a="7201760"
From: Gao feng <gaofeng@cn.fujitsu.com>
To: viro@zeniv.linux.org.uk, eparis@redhat.com, ebiederm@xmission.com,
        sgrubb@redhat.com, akpm@linux-foundation.org, serge.hallyn@ubuntu.com,
        davem@davemloft.net
Cc: netdev@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-audit@redhat.com,
        Gao feng <gaofeng@cn.fujitsu.com>
Subject: [PATCH RFC 14/48] Audit: only allow init user namespace to change audit_failure
Date: Tue, 7 May 2013 10:20:35 +0800
Message-Id: <1367893269-9308-15-git-send-email-gaofeng@cn.fujitsu.com>
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

Setting audit_failure to AUDIT_FAIL_PANIC may
cause system panic.

We should disallow uninit user namesapce to change it.

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
---
 kernel/audit.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/audit.c b/kernel/audit.c
index 8a3ea47..18cf5ce 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -345,6 +345,9 @@ static int audit_set_failure(int state, kuid_t loginuid, u32 sessionid, u32 sid)
 	    && state != AUDIT_FAIL_PANIC)
 		return -EINVAL;
 
+	if (current_user_ns() != &init_user_ns)
+		return -EPERM;
+
 	return audit_do_config_change("audit_failure", &audit_failure, state,
 				      loginuid, sessionid, sid);
 }
-- 
1.8.1.4

