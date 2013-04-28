Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933135Ab3ECPql (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 11:46:41 -0400
Received: from mail-ea0-f178.google.com ([209.85.215.178]:42075 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762110Ab3ECPqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 11:46:40 -0400
From: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>, linux-kernel@vger.kernel.org,
        Alexandru Gheorghiu <gheorghiuandru@gmail.com>
Subject: [PATCH] drivers: parport: Use kmemdup
Date: Sun, 28 Apr 2013 19:54:38 +0300
Message-Id: <1367168078-22486-1-git-send-email-gheorghiuandru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Used kmemdup instead of kmalloc and memcpy.
Patch found using coccinelle.

Signed-off-by: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
---
 drivers/parport/parport_gsc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/parport/parport_gsc.c b/drivers/parport/parport_gsc.c
index 050773c..4b364c6 100644
--- a/drivers/parport/parport_gsc.c
+++ b/drivers/parport/parport_gsc.c
@@ -246,14 +246,14 @@ struct parport *parport_gsc_probe_port(unsigned long base,
 		printk (KERN_DEBUG "parport (0x%lx): no memory!\n", base);
 		return NULL;
 	}
-	ops = kmalloc (sizeof (struct parport_operations), GFP_KERNEL);
+	ops = kmemdup(&parport_gsc_ops, sizeof(struct parport_operations),
+					GFP_KERNEL);
 	if (!ops) {
 		printk (KERN_DEBUG "parport (0x%lx): no memory for ops!\n",
 			base);
 		kfree (priv);
 		return NULL;
 	}
-	memcpy (ops, &parport_gsc_ops, sizeof (struct parport_operations));
 	priv->ctr = 0xc;
 	priv->ctr_writable = 0xff;
 	priv->dma_buf = 0;
-- 
1.7.9.5

