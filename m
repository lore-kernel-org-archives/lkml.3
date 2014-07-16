Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759692AbaGPN2Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 09:28:24 -0400
Received: from bart.luffy.cx ([78.47.78.131]:37904 "EHLO bart.luffy.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759509AbaGPN2V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 09:28:21 -0400
X-Greylist: delayed 509 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Jul 2014 09:28:21 EDT
From: Vincent Bernat <vincent@bernat.im>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Eli Billauer <eli.billauer@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: Vincent Bernat <vincent@bernat.im>
Subject: [PATCH] staging: xillybus: fix some coding style errors
Date: Wed, 16 Jul 2014 15:19:42 +0200
Message-Id: <1405516782-11434-1-git-send-email-vincent@bernat.im>
X-Mailer: git-send-email 2.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This includes:
 - keep "else" on the same line as the closing brace
 - don't use "else" after "return"
 - don't issue a message for an out-of-memory error
 - blank line after a declaration

Signed-off-by: Vincent Bernat <vincent@bernat.im>
---
 drivers/staging/xillybus/xillybus_core.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/xillybus/xillybus_core.c b/drivers/staging/xillybus/xillybus_core.c
index ab6502caa72c..2d59734744e5 100644
--- a/drivers/staging/xillybus/xillybus_core.c
+++ b/drivers/staging/xillybus/xillybus_core.c
@@ -138,7 +138,6 @@ irqreturn_t xillybus_isr(int irq, void *data)
 	 * guaranteed no interrupt will occur, but in theory, the cache
 	 * lines may not be updated. So a memory barrier is issued.
 	 */
-
 	smp_rmb();
 
 	buf = ep->msgbuf_addr;
@@ -546,8 +545,7 @@ static int xilly_setupchannels(struct xilly_endpoint *ep,
 			channel->rd_buffers = buffers;
 			rc = xilly_get_dma_buffers(ep, &rd_alloc, buffers,
 						   bufnum, bytebufsize);
-		}
-		else if (channelnum > 0) {
+		} else if (channelnum > 0) {
 			channel->num_wr_buffers = bufnum;
 
 			channel->seekable = seekable;
@@ -610,8 +608,8 @@ static void xilly_scan_idt(struct xilly_endpoint *endpoint,
 			"IDT device name list overflow. Aborting.\n");
 		idt_handle->chandesc = NULL;
 		return;
-	} else
-		idt_handle->chandesc = scan;
+	}
+	idt_handle->chandesc = scan;
 
 	len = endpoint->idtlen - (3 + ((int) (scan - idt)));
 
@@ -722,6 +720,7 @@ static ssize_t xillybus_read(struct file *filp, char __user *userbuf,
 
 	while (1) { /* Note that we may drop mutex within this loop */
 		int bytes_to_do = count - bytes_done;
+
 		spin_lock_irqsave(&channel->wr_spinlock, flags);
 
 		empty = channel->wr_empty;
@@ -1963,10 +1962,8 @@ struct xilly_endpoint *xillybus_init_endpoint(struct pci_dev *pdev,
 	struct xilly_endpoint *endpoint;
 
 	endpoint = devm_kzalloc(dev, sizeof(*endpoint), GFP_KERNEL);
-	if (!endpoint) {
-		dev_err(dev, "Failed to allocate memory. Aborting.\n");
+	if (!endpoint)
 		return NULL;
-	}
 
 	endpoint->pdev = pdev;
 	endpoint->dev = dev;
-- 
2.0.1

