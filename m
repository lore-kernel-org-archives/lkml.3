Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762910Ab3ECPHO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 11:07:14 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:63373 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761561Ab3ECPHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 11:07:12 -0400
From: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
Subject: [PATCH] drivers: parport: Use kzalloc
Date: Sun, 28 Apr 2013 19:15:00 +0300
Message-Id: <1367165700-22394-1-git-send-email-gheorghiuandru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replaced calls to kmalloc and memset with kzalloc.
Patch found using coccinelle.

Signed-off-by: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
---
 drivers/parport/share.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/parport/share.c b/drivers/parport/share.c
index a848e02..6a83ee1 100644
--- a/drivers/parport/share.c
+++ b/drivers/parport/share.c
@@ -282,14 +282,13 @@ struct parport *parport_register_port(unsigned long base, int irq, int dma,
 	int device;
 	char *name;
 
-	tmp = kmalloc(sizeof(struct parport), GFP_KERNEL);
+	tmp = kzalloc(sizeof(struct parport), GFP_KERNEL);
 	if (!tmp) {
 		printk(KERN_WARNING "parport: memory squeeze\n");
 		return NULL;
 	}
 
 	/* Init our structure */
- 	memset(tmp, 0, sizeof(struct parport));
 	tmp->base = base;
 	tmp->irq = irq;
 	tmp->dma = dma;
-- 
1.7.9.5

