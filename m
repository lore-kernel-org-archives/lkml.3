Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751390Ab3HBKRm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 06:17:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37564 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528Ab3HBKRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 06:17:39 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Joern Engel <joern@logfs.org>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [ 01/39] iscsi-target: Fix tfc_tpg_nacl_auth_cit configfs length overflow
Date: Fri,  2 Aug 2013 18:18:11 +0800
Message-Id: <20130802101456.994350228@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.4.841.g1a3f60e
In-Reply-To: <20130802101456.800497005@linuxfoundation.org>
References: <20130802101456.800497005@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joern Engel <joern@logfs.org>

commit 0fbfc46fb0b2f543a8b539e94c6c293ebc0b05a6 upstream.

This patch fixes a potential buffer overflow while processing
iscsi_node_auth input for configfs attributes within NodeACL
tfc_tpg_nacl_auth_cit context.

Signed-off-by: Joern Engel <joern@logfs.org>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/iscsi/iscsi_target_configfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/target/iscsi/iscsi_target_configfs.c
+++ b/drivers/target/iscsi/iscsi_target_configfs.c
@@ -415,7 +415,7 @@ static ssize_t __iscsi_##prefix##_store_
 	if (!capable(CAP_SYS_ADMIN))					\
 		return -EPERM;						\
 									\
-	snprintf(auth->name, PAGE_SIZE, "%s", page);			\
+	snprintf(auth->name, sizeof(auth->name), "%s", page);		\
 	if (!strncmp("NULL", auth->name, 4))				\
 		auth->naf_flags &= ~flags;				\
 	else								\


