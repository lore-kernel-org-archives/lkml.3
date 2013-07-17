Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934128Ab3GQWwY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 18:52:24 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56331 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933385Ab3GQWvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 18:51:24 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Joern Engel <joern@logfs.org>, Nicholas Bellinger <nab@linux-iscsi.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 124/145] iscsi-target: Fix tfc_tpg_nacl_auth_cit configfs length overflow
Date: Wed, 17 Jul 2013 15:47:36 -0700
Message-Id: <1374101277-7915-125-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374101277-7915-1-git-send-email-kamal@canonical.com>
References: <1374101277-7915-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?J=C3=B6rn=20Engel?= <joern@logfs.org>

commit 0fbfc46fb0b2f543a8b539e94c6c293ebc0b05a6 upstream.

This patch fixes a potential buffer overflow while processing
iscsi_node_auth input for configfs attributes within NodeACL
tfc_tpg_nacl_auth_cit context.

Signed-off-by: Joern Engel <joern@logfs.org>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/target/iscsi/iscsi_target_configfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/target/iscsi/iscsi_target_configfs.c
index 78d75c8..56064a0 100644
--- a/drivers/target/iscsi/iscsi_target_configfs.c
+++ b/drivers/target/iscsi/iscsi_target_configfs.c
@@ -393,7 +393,7 @@ static ssize_t __iscsi_##prefix##_store_##name(				\
 	if (!capable(CAP_SYS_ADMIN))					\
 		return -EPERM;						\
 									\
-	snprintf(auth->name, PAGE_SIZE, "%s", page);			\
+	snprintf(auth->name, sizeof(auth->name), "%s", page);		\
 	if (!strncmp("NULL", auth->name, 4))				\
 		auth->naf_flags &= ~flags;				\
 	else								\
-- 
1.8.1.2

