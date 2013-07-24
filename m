Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894Ab3GXO05 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 10:26:57 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45839 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752252Ab3GXOGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 10:06:38 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Nicholas Bellinger" <nab@linux-iscsi.org>,
        "=?UTF-8?q?J=C3=B6rn=20Engel?=" <joern@logfs.org>
Date: Wed, 24 Jul 2013 15:02:45 +0100
Message-ID: <lsq.1374674565.557486956@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [73/85] iscsi-target: Fix tfc_tpg_nacl_auth_cit configfs length
 overflow
In-Reply-To: <lsq.1374674564.753305150@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.49-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Jörn Engel <joern@logfs.org>

commit 0fbfc46fb0b2f543a8b539e94c6c293ebc0b05a6 upstream.

This patch fixes a potential buffer overflow while processing
iscsi_node_auth input for configfs attributes within NodeACL
tfc_tpg_nacl_auth_cit context.

Signed-off-by: Joern Engel <joern@logfs.org>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/target/iscsi/iscsi_target_configfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/target/iscsi/iscsi_target_configfs.c
+++ b/drivers/target/iscsi/iscsi_target_configfs.c
@@ -419,7 +419,7 @@ static ssize_t __iscsi_##prefix##_store_
 	if (!capable(CAP_SYS_ADMIN))					\
 		return -EPERM;						\
 									\
-	snprintf(auth->name, PAGE_SIZE, "%s", page);			\
+	snprintf(auth->name, sizeof(auth->name), "%s", page);		\
 	if (!strncmp("NULL", auth->name, 4))				\
 		auth->naf_flags &= ~flags;				\
 	else								\

