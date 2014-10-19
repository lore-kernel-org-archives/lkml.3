Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751691AbaJSAc4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2014 20:32:56 -0400
Received: from mx02b.posteo.de ([89.146.230.120]:57989 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751586AbaJSAcz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2014 20:32:55 -0400
From: Martin Kepplinger <martink@posteo.de>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Martin Kepplinger <martink@posteo.de>
Subject: [PATCH 2/3] fbdev: pxa3xx-gcu: remove redundant implementation of open()
Date: Sun, 19 Oct 2014 02:30:59 +0200
Message-Id: <1413678660-29669-2-git-send-email-martink@posteo.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1413678660-29669-1-git-send-email-martink@posteo.de>
References: <5442F3D0.3070203@posteo.de>
 <1413678660-29669-1-git-send-email-martink@posteo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the miscdevice core now does the work in any case.

Signed-off-by: Martin Kepplinger <martink@posteo.de>
---
 drivers/video/fbdev/pxa3xx-gcu.c |   10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/video/fbdev/pxa3xx-gcu.c b/drivers/video/fbdev/pxa3xx-gcu.c
index 4df3657..7678a94 100644
--- a/drivers/video/fbdev/pxa3xx-gcu.c
+++ b/drivers/video/fbdev/pxa3xx-gcu.c
@@ -373,15 +373,6 @@ static inline struct pxa3xx_gcu_priv *to_pxa3xx_gcu_priv(struct file *file)
 	return container_of(dev, struct pxa3xx_gcu_priv, misc_dev);
 }
 
-/*
- * provide an empty .open callback, so the core sets file->private_data
- * for us.
- */
-static int pxa3xx_gcu_open(struct inode *inode, struct file *file)
-{
-	return 0;
-}
-
 static ssize_t
 pxa3xx_gcu_write(struct file *file, const char *buff,
 		 size_t count, loff_t *offp)
@@ -580,7 +571,6 @@ pxa3xx_gcu_free_buffers(struct device *dev,
 
 static const struct file_operations pxa3xx_gcu_miscdev_fops = {
 	.owner =		THIS_MODULE,
-	.open =			pxa3xx_gcu_open,
 	.write =		pxa3xx_gcu_write,
 	.unlocked_ioctl =	pxa3xx_gcu_ioctl,
 	.mmap =			pxa3xx_gcu_mmap,
-- 
1.7.10.4

