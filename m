Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752086Ab3LSCey (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 21:34:54 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:31435 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751797Ab3LSCev convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 21:34:51 -0500
X-IronPort-AV: E=Sophos;i="4.95,511,1384272000"; 
   d="scan'208";a="9287797"
From: Gao feng <gaofeng@cn.fujitsu.com>
To: linux-audit@redhat.com
Cc: linux-kernel@vger.kernel.org, Gao feng <gaofeng@cn.fujitsu.com>
Subject: [PATCH] audit: fix build error when disable audit
Date: Thu, 19 Dec 2013 10:34:29 +0800
Message-Id: <1387420469-27665-1-git-send-email-gaofeng@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/19 10:33:00,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/19 10:33:01
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernel/capability.c: In function ‘SYSC_capset’:
kernel/capability.c:280:2: warning: passing argument 1 of ‘audit_log_capset’ makes integer from pointer without a cast [enabled by default]
  audit_log_capset(new, current_cred());
  ^
In file included from kernel/capability.c:10:0:
include/linux/audit.h:400:20: note: expected ‘pid_t’ but argument is of type ‘struct cred *’
 static inline void audit_log_capset(pid_t pid, const struct cred *new,
                    ^
kernel/capability.c:280:2: error: too few arguments to function ‘audit_log_capset’
  audit_log_capset(new, current_cred());
  ^
In file included from kernel/capability.c:10:0:
include/linux/audit.h:400:20: note: declared here
 static inline void audit_log_capset(pid_t pid, const struct cred *new,
                    ^
make[1]: *** [kernel/capability.o] Error 1

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
---
 include/linux/audit.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index b4d5160..6976219 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -397,8 +397,8 @@ static inline int audit_log_bprm_fcaps(struct linux_binprm *bprm,
 {
 	return 0;
 }
-static inline void audit_log_capset(pid_t pid, const struct cred *new,
-				   const struct cred *old)
+static inline void audit_log_capset(const struct cred *new,
+				    const struct cred *old)
 { }
 static inline void audit_mmap_fd(int fd, int flags)
 { }
-- 
1.8.3.1

