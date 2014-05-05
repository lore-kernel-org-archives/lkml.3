Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756315AbaEEK35 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 06:29:57 -0400
Received: from mx02.posteo.de ([89.146.194.165]:49296 "EHLO posteo.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756220AbaEEK34 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 06:29:56 -0400
From: Martin Kepplinger <martink@posteo.de>
To: gregkh@linuxfoundation.org
Cc: lidza.louina@gmail.com, driverdev-devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, Martin Kepplinger <martink@posteo.de>
Subject: [RESEND PATCH] staging: dgnc: use dev_err() instead of printk()
Date: Mon,  5 May 2014 12:29:39 +0200
Message-Id: <1399285779-7040-1-git-send-email-martink@posteo.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1398765250-16064-1-git-send-email-martink@posteo.de>
References: <1398765250-16064-1-git-send-email-martink@posteo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use dev_err() instead of printk() and remove "dgnc:" from the message.
This should provide userspace with more useful information and use
the common kernel coding style.

Signed-off-by: Martin Kepplinger <martink@posteo.de>
---
 drivers/staging/dgnc/dgnc_sysfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/dgnc/dgnc_sysfs.c b/drivers/staging/dgnc/dgnc_sysfs.c
index 946230c..88a2106 100644
--- a/drivers/staging/dgnc/dgnc_sysfs.c
+++ b/drivers/staging/dgnc/dgnc_sysfs.c
@@ -739,7 +739,7 @@ void dgnc_create_tty_sysfs(struct un_t *un, struct device *c)
 
 	ret = sysfs_create_group(&c->kobj, &dgnc_tty_attribute_group);
 	if (ret) {
-		printk(KERN_ERR "dgnc: failed to create sysfs tty device attributes.\n");
+		dev_err(c, "failed to create sysfs tty device attributes.\n");
 		sysfs_remove_group(&c->kobj, &dgnc_tty_attribute_group);
 		return;
 	}
-- 
1.7.10.4

