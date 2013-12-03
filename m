Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755074Ab3LCOzN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 09:55:13 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:59478 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754616Ab3LCOvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 09:51:23 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 3/9] staging/lustre/ldlm: inline ldlm_proc_setup
Date: Tue,  3 Dec 2013 22:42:01 +0800
Message-Id: <1386081729-9481-5-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386081729-9481-1-git-send-email-bergwolf@gmail.com>
References: <1386081729-9481-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/include/lustre_dlm.h |    3 ++-
 drivers/staging/lustre/lustre/ldlm/ldlm_lockd.c    |    2 --
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/lustre/lustre/include/lustre_dlm.h b/drivers/staging/lustre/lustre/include/lustre_dlm.h
index bc2b82f..ec4bb5e 100644
--- a/drivers/staging/lustre/lustre/include/lustre_dlm.h
+++ b/drivers/staging/lustre/lustre/include/lustre_dlm.h
@@ -1285,10 +1285,11 @@ void ldlm_namespace_register(struct ldlm_namespace *ns, ldlm_side_t client);
 void ldlm_namespace_unregister(struct ldlm_namespace *ns, ldlm_side_t client);
 void ldlm_namespace_get(struct ldlm_namespace *ns);
 void ldlm_namespace_put(struct ldlm_namespace *ns);
-int ldlm_proc_setup(void);
 #ifdef LPROCFS
+int ldlm_proc_setup(void);
 void ldlm_proc_cleanup(void);
 #else
+static inline int ldlm_proc_setup(void) { return 0; }
 static inline void ldlm_proc_cleanup(void) {}
 #endif
 
diff --git a/drivers/staging/lustre/lustre/ldlm/ldlm_lockd.c b/drivers/staging/lustre/lustre/ldlm/ldlm_lockd.c
index 85f5e7e..3ed020e 100644
--- a/drivers/staging/lustre/lustre/ldlm/ldlm_lockd.c
+++ b/drivers/staging/lustre/lustre/ldlm/ldlm_lockd.c
@@ -1012,11 +1012,9 @@ static int ldlm_setup(void)
 	if (ldlm_state == NULL)
 		return -ENOMEM;
 
-#ifdef LPROCFS
 	rc = ldlm_proc_setup();
 	if (rc != 0)
 		GOTO(out, rc);
-#endif
 
 	memset(&conf, 0, sizeof(conf));
 	conf = (typeof(conf)) {
-- 
1.7.9.5

