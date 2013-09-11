Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753693Ab3IKL0r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 07:26:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5891 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443Ab3IKL0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 07:26:44 -0400
X-Authority-Analysis: v=2.0 cv=R/aB6KtX c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=5fU4gKrdSBYA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=d1cXvnAZJkUA:10 a=4K-K1uyHAAAA:8 a=VwQbUJbxAAAA:8 a=z11f-joXAAAA:8 a=5cIBTxRJ4pZzZk2xk6UA:9 a=wATGTE7Z8MQA:10 a=CJVq-v20pXUA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042905.012783533@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:28:23 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Joern Engel <joern@logfs.org>, Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [076/251] iscsi-target: Fix tfc_tpg_nacl_auth_cit configfs length overflow
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0076-iscsi-target-Fix-tfc_tpg_nacl_auth_cit-configfs-leng.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?J=C3=B6rn=20Engel?= <joern@logfs.org>

[ Upstream commit 0fbfc46fb0b2f543a8b539e94c6c293ebc0b05a6 ]

This patch fixes a potential buffer overflow while processing
iscsi_node_auth input for configfs attributes within NodeACL
tfc_tpg_nacl_auth_cit context.

Signed-off-by: Joern Engel <joern@logfs.org>
Cc: stable@vger.kernel.org
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/target/iscsi/iscsi_target_configfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/target/iscsi/iscsi_target_configfs.c
index a7b25e7..73adddc 100644
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
1.7.10.4


