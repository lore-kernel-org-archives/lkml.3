Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756199Ab3CQIti (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 04:49:38 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:49619 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756099Ab3CQIth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 04:49:37 -0400
From: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
To: Corey Minyard <minyard@acm.org>
Cc: openipmi-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Alexandru Gheorghiu <gheorghiuandru@gmail.com>
Subject: [PATCH] drivers: char: ipmi: Replaced kmalloc and strcpy with kstrdup
Date: Sat, 16 Mar 2013 16:16:53 +0200
Message-Id: <1363443413-21937-1-git-send-email-gheorghiuandru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replaced calls to kmalloc followed by strcpy with a sincle call to kstrdup.
Patch found using coccinelle.

Signed-off-by: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
---
 drivers/char/ipmi/ipmi_msghandler.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_msghandler.c b/drivers/char/ipmi/ipmi_msghandler.c
index 053201b..617b443 100644
--- a/drivers/char/ipmi/ipmi_msghandler.c
+++ b/drivers/char/ipmi/ipmi_msghandler.c
@@ -2037,12 +2037,11 @@ int ipmi_smi_add_proc_entry(ipmi_smi_t smi, char *name,
 	entry = kmalloc(sizeof(*entry), GFP_KERNEL);
 	if (!entry)
 		return -ENOMEM;
-	entry->name = kmalloc(strlen(name)+1, GFP_KERNEL);
+	entry->name = kstrdup(name, GFP_KERNEL);
 	if (!entry->name) {
 		kfree(entry);
 		return -ENOMEM;
 	}
-	strcpy(entry->name, name);
 
 	file = proc_create_data(name, 0, smi->proc_dir, proc_ops, data);
 	if (!file) {
-- 
1.7.9.5

