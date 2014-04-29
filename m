Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757377AbaD2Jnw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 05:43:52 -0400
Received: from mx02.posteo.de ([89.146.194.165]:52172 "EHLO posteo.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757359AbaD2Jnv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 05:43:51 -0400
From: Martin Kepplinger <martink@posteo.de>
To: gregkh@linuxfoundation.org
Cc: lidza.louina@gmail.com, linux-kernel@vger.kernel.org,
        Martin Kepplinger <martink@posteo.de>
Subject: [PATCH] staging: dgnc: use dev_err() instead of printk()
Date: Tue, 29 Apr 2014 11:43:08 +0200
Message-Id: <1398764588-15873-1-git-send-email-martink@posteo.de>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use dev_err() insted of printk() in order to provice userspace with
more useful information and use the common kernel coding style.

Signed-off-by: Martin Kepplinger <martink@posteo.de>
---
 drivers/staging/dgnc/dgnc_sysfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/dgnc/dgnc_sysfs.c b/drivers/staging/dgnc/dgnc_sysfs.c
index 946230c..0f0e8fc 100644
--- a/drivers/staging/dgnc/dgnc_sysfs.c
+++ b/drivers/staging/dgnc/dgnc_sysfs.c
@@ -739,7 +739,7 @@ void dgnc_create_tty_sysfs(struct un_t *un, struct device *c)
 
 	ret = sysfs_create_group(&c->kobj, &dgnc_tty_attribute_group);
 	if (ret) {
-		printk(KERN_ERR "dgnc: failed to create sysfs tty device attributes.\n");
+		dev_err(c, "dgnc: failed to create sysfs tty device attributes.\n");
 		sysfs_remove_group(&c->kobj, &dgnc_tty_attribute_group);
 		return;
 	}
-- 
1.7.10.4

