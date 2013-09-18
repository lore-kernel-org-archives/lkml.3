Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752258Ab3IRPSS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 11:18:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12848 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751958Ab3IRPSR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 11:18:17 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: linux-audit@redhat.com, linux-kernel@vger.kernel.org
Cc: Richard Guy Briggs <rgb@redhat.com>, Steve Grubb <sgrubb@redhat.com>,
        Eric Paris <eparis@redhat.com>
Subject: [PATCH] audit: remove newline accidentally added during session id helper refactor
Date: Wed, 18 Sep 2013 11:17:43 -0400
Message-Id: <0c842120dc69b8dadc143ee70c29094e1f9d5110.1379517385.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A newline was accidentally added during session ID helper refactorization in
commit 4d3fb709.  This needlessly uses up buffer space, messes up syslog
formatting and makes userspace processing less efficient.  Remove it.

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 kernel/audit.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index 3d17670..ac16540 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -1413,7 +1413,7 @@ void audit_log_session_info(struct audit_buffer *ab)
 	u32 sessionid = audit_get_sessionid(current);
 	uid_t auid = from_kuid(&init_user_ns, audit_get_loginuid(current));
 
-	audit_log_format(ab, " auid=%u ses=%u\n", auid, sessionid);
+	audit_log_format(ab, " auid=%u ses=%u", auid, sessionid);
 }
 
 void audit_log_key(struct audit_buffer *ab, char *key)
-- 
1.7.1

