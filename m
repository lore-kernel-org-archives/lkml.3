Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754474AbaGKXhq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 19:37:46 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:46460 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012AbaGKXho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 19:37:44 -0400
From: Ionut Alexa <ionut.m.alexa@gmail.com>
To: mmarek@suse.cz
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Ionut Alexa <ionut.m.alexa@gmail.com>
Subject: [PATCH] kernel:dma : fix coding style errors
Date: Sat, 12 Jul 2014 02:39:10 +0300
Message-Id: <1405121950-22273-1-git-send-email-ionut.m.alexa@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed coding style errors.

Signed-off-by: Ionut Alexa <ionut.m.alexa@gmail.com>
---
 kernel/dma.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/kernel/dma.c b/kernel/dma.c
index 6c6262f..ae9ba17 100644
--- a/kernel/dma.c
+++ b/kernel/dma.c
@@ -66,7 +66,7 @@ static struct dma_chan dma_chan_busy[MAX_DMA_CHANNELS] = {
  * @dmanr: DMA channel number
  * @device_id: reserving device ID string, used in /proc/dma
  */
-int request_dma(unsigned int dmanr, const char * device_id)
+int request_dma(unsigned int dmanr, const char *device_id)
 {
 	if (dmanr >= MAX_DMA_CHANNELS)
 		return -EINVAL;
@@ -87,12 +87,12 @@ int request_dma(unsigned int dmanr, const char * device_id)
 void free_dma(unsigned int dmanr)
 {
 	if (dmanr >= MAX_DMA_CHANNELS) {
-		printk(KERN_WARNING "Trying to free DMA%d\n", dmanr);
+		pr_warn("Trying to free DMA%d\n", dmanr);
 		return;
 	}
 
 	if (xchg(&dma_chan_busy[dmanr].lock, 0) == 0) {
-		printk(KERN_WARNING "Trying to free free DMA%d\n", dmanr);
+		pr_warn("Trying to free free DMA%d\n", dmanr);
 		return;
 	}
 
@@ -152,9 +152,10 @@ static int __init proc_dma_init(void)
 	return 0;
 }
 
-__initcall(proc_dma_init);
+device_initcall(proc_dma_init);
 #endif
 
 EXPORT_SYMBOL(request_dma);
 EXPORT_SYMBOL(free_dma);
 EXPORT_SYMBOL(dma_spin_lock);
+
-- 
1.7.10.4

