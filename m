Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758548Ab3IBN6g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 09:58:36 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35100 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758291Ab3IBN6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 09:58:35 -0400
Date: Mon, 2 Sep 2013 15:58:32 +0200
From: Pavel Machek <pavel@denx.de>
To: kernel list <linux-kernel@vger.kernel.org>, balbi@ti.com,
        linux-usb@vger.kernel.org, pavel@denx.de
Subject: Fix style in s3c-hsotg.c
Message-ID: <20130902135832.GA22300@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

checkpatch.pl has some valid complaints about style in s3c-hsotg.c :
macro with if should be really enclosed in do {} while, and puts is
going to be slightly faster.

Here's suggested patch. I don't have the hardware, so it is completely
untested.

Signed-off-by: Pavel Machek, <pavel@denx.de>

diff --git a/drivers/usb/gadget/s3c-hsotg.c b/drivers/usb/gadget/s3c-hsotg.c
index af22f24..f8e762a 100644
--- a/drivers/usb/gadget/s3c-hsotg.c
+++ b/drivers/usb/gadget/s3c-hsotg.c
@@ -2091,12 +2091,14 @@ static void kill_all_requests(struct s3c_hsotg *hsotg,
 }
 
 #define call_gadget(_hs, _entry) \
+do { \
 	if ((_hs)->gadget.speed != USB_SPEED_UNKNOWN &&	\
 	    (_hs)->driver && (_hs)->driver->_entry) { \
 		spin_unlock(&_hs->lock); \
 		(_hs)->driver->_entry(&(_hs)->gadget); \
 		spin_lock(&_hs->lock); \
 		}
+} while (0)
 
 /**
  * s3c_hsotg_disconnect - disconnect service
@@ -3204,7 +3206,7 @@ static int state_show(struct seq_file *seq, void *v)
 		   readl(regs + GNPTXSTS),
 		   readl(regs + GRXSTSR));
 
-	seq_printf(seq, "\nEndpoint status:\n");
+	seq_puts(seq, "\nEndpoint status:\n");
 
 	for (idx = 0; idx < 15; idx++) {
 		u32 in, out;
@@ -3221,7 +3223,7 @@ static int state_show(struct seq_file *seq, void *v)
 		seq_printf(seq, ", DIEPTSIZ=0x%08x, DOEPTSIZ=0x%08x",
 			   in, out);
 
-		seq_printf(seq, "\n");
+		seq_puts(seq, "\n");
 	}
 
 	return 0;
@@ -3255,7 +3257,7 @@ static int fifo_show(struct seq_file *seq, void *v)
 	u32 val;
 	int idx;
 
-	seq_printf(seq, "Non-periodic FIFOs:\n");
+	seq_puts(seq, "Non-periodic FIFOs:\n");
 	seq_printf(seq, "RXFIFO: Size %d\n", readl(regs + GRXFSIZ));
 
 	val = readl(regs + GNPTXFSIZ);
@@ -3263,7 +3265,7 @@ static int fifo_show(struct seq_file *seq, void *v)
 		   val >> GNPTXFSIZ_NPTxFDep_SHIFT,
 		   val & GNPTXFSIZ_NPTxFStAddr_MASK);
 
-	seq_printf(seq, "\nPeriodic TXFIFOs:\n");
+	seq_puts(seq, "\nPeriodic TXFIFOs:\n");
 
 	for (idx = 1; idx <= 15; idx++) {
 		val = readl(regs + DPTXFSIZn(idx));
@@ -3334,7 +3336,7 @@ static int ep_show(struct seq_file *seq, void *v)
 		   readl(regs + DIEPTSIZ(index)),
 		   readl(regs + DOEPTSIZ(index)));
 
-	seq_printf(seq, "\n");
+	seq_puts(seq, "\n");
 	seq_printf(seq, "mps %d\n", ep->ep.maxpacket);
 	seq_printf(seq, "total_data=%ld\n", ep->total_data);
 
@@ -3345,7 +3347,7 @@ static int ep_show(struct seq_file *seq, void *v)
 
 	list_for_each_entry(req, &ep->queue, queue) {
 		if (--show_limit < 0) {
-			seq_printf(seq, "not showing more requests...\n");
+			seq_puts(seq, "not showing more requests...\n");
 			break;
 		}
 

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
