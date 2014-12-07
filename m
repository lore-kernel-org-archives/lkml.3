Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693AbaLGPl4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 10:41:56 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:39405 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310AbaLGPlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 10:41:53 -0500
From: robert.ward114@googlemail.com
To: arnd@arndb.de, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Cc: Rob Ward <robert.ward114@googlemail.com>
Subject: [PATCH 3/3] drivers: char: mem: Simplify DEVPORT configuration
Date: Sun,  7 Dec 2014 15:40:35 +0000
Message-Id: <1417966835-14012-4-git-send-email-robert.ward114@googlemail.com>
X-Mailer: git-send-email 2.2.0
In-Reply-To: <1417966835-14012-1-git-send-email-robert.ward114@googlemail.com>
References: <1417966835-14012-1-git-send-email-robert.ward114@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Ward <robert.ward114@googlemail.com>

Simplify the use of CONFIG_DEVPORT by making the port_fops
so that it includes __maybe_unused.

This enabled the multiple #ifdef's used for this structure
to be removed and brings it in line with the use of CONFIG_DEVMEM

This change should introduce no functional changes.

Signed-off-by: Rob Ward <robert.ward114@googlemail.com>
---
 drivers/char/mem.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index 4521fea..39315fe 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -539,7 +539,6 @@ static ssize_t write_kmem(struct file *file, const char __user *buf,
 	return virtr + wrote ? : err;
 }
 
-#ifdef CONFIG_DEVPORT
 static ssize_t read_port(struct file *file, char __user *buf,
 			 size_t count, loff_t *ppos)
 {
@@ -580,7 +579,6 @@ static ssize_t write_port(struct file *file, const char __user *buf,
 	*ppos = i;
 	return tmp-buf;
 }
-#endif
 
 static ssize_t read_null(struct file *file, char __user *buf,
 			 size_t count, loff_t *ppos)
@@ -735,14 +733,12 @@ static const struct file_operations null_fops = {
 	.splice_write	= splice_write_null,
 };
 
-#ifdef CONFIG_DEVPORT
-static const struct file_operations port_fops = {
+static const struct file_operations __maybe_unused port_fops = {
 	.llseek		= memory_lseek,
 	.read		= read_port,
 	.write		= write_port,
 	.open		= open_port,
 };
-#endif
 
 static const struct file_operations zero_fops = {
 	.llseek		= zero_lseek,
-- 
2.0.2

