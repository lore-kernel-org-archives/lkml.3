Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756247Ab3IYVPZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 17:15:25 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60871 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753992Ab3IYVPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 17:15:24 -0400
Date: Wed, 25 Sep 2013 23:15:22 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: balbi@ti.com, kernel list <linux-kernel@vger.kernel.org>,
        linux-usb@vger.kernel.org
Subject: Re: Fix style in s3c-hsotg.c
Message-ID: <20130925211522.GA21708@amd.pavel.ucw.cz>
References: <20130902135832.GA22300@amd.pavel.ucw.cz>
 <20130918092027.GA8325@amd.pavel.ucw.cz>
 <20130918141106.GH21559@radagast>
 <2758936.kqHJ9YzqCC@amdc1032>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2758936.kqHJ9YzqCC@amdc1032>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > No, I'll not polish patch for hardware I don't have and have little
> > > interest in.  wanted to help you, but according to your first reply,
> > > you do not really want help.
> > 
> > that's your call. Now how about you stop being such a baby and go fix
> > your mistakes to start with ? Just because I'm the maintainer of the
> > gadget framework, doesn't mean I'm the maintainer of s3c-hsotc.c file.
> > Maintainer != author too, btw.
> > 
> > Anyway, I got much better stuff to do than babysitting grown ups.
> 
> ..even if it could have been communicated in a gentler way.
> 
> Anyway s3c-hsotg.c is a driver for our hardware so I'm going to pick this
> patch up, polish it and then re-submit it later. Thanks.

Here's version that should compile. Thanks,
									Pavel

Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/drivers/usb/gadget/s3c-hsotg.c b/drivers/usb/gadget/s3c-hsotg.c
index d69b36a..c8cdde0 100644
--- a/drivers/usb/gadget/s3c-hsotg.c
+++ b/drivers/usb/gadget/s3c-hsotg.c
@@ -2092,12 +2092,14 @@ static void kill_all_requests(struct s3c_hsotg *hsotg,
 }
 
 #define call_gadget(_hs, _entry) \
+do { \
 	if ((_hs)->gadget.speed != USB_SPEED_UNKNOWN &&	\
 	    (_hs)->driver && (_hs)->driver->_entry) { \
 		spin_unlock(&_hs->lock); \
 		(_hs)->driver->_entry(&(_hs)->gadget); \
 		spin_lock(&_hs->lock); \
-		}
+		} \
+} while (0)
 
 /**
  * s3c_hsotg_disconnect - disconnect service
@@ -3205,7 +3207,7 @@ static int state_show(struct seq_file *seq, void *v)
 		   readl(regs + GNPTXSTS),
 		   readl(regs + GRXSTSR));
 
-	seq_printf(seq, "\nEndpoint status:\n");
+	seq_puts(seq, "\nEndpoint status:\n");
 
 	for (idx = 0; idx < 15; idx++) {
 		u32 in, out;
@@ -3222,7 +3224,7 @@ static int state_show(struct seq_file *seq, void *v)
 		seq_printf(seq, ", DIEPTSIZ=0x%08x, DOEPTSIZ=0x%08x",
 			   in, out);
 
-		seq_printf(seq, "\n");
+		seq_puts(seq, "\n");
 	}
 
 	return 0;
@@ -3256,7 +3258,7 @@ static int fifo_show(struct seq_file *seq, void *v)
 	u32 val;
 	int idx;
 
-	seq_printf(seq, "Non-periodic FIFOs:\n");
+	seq_puts(seq, "Non-periodic FIFOs:\n");
 	seq_printf(seq, "RXFIFO: Size %d\n", readl(regs + GRXFSIZ));
 
 	val = readl(regs + GNPTXFSIZ);
@@ -3264,7 +3266,7 @@ static int fifo_show(struct seq_file *seq, void *v)
 		   val >> GNPTXFSIZ_NPTxFDep_SHIFT,
 		   val & GNPTXFSIZ_NPTxFStAddr_MASK);
 
-	seq_printf(seq, "\nPeriodic TXFIFOs:\n");
+	seq_puts(seq, "\nPeriodic TXFIFOs:\n");
 
 	for (idx = 1; idx <= 15; idx++) {
 		val = readl(regs + DPTXFSIZn(idx));
@@ -3335,7 +3337,7 @@ static int ep_show(struct seq_file *seq, void *v)
 		   readl(regs + DIEPTSIZ(index)),
 		   readl(regs + DOEPTSIZ(index)));
 
-	seq_printf(seq, "\n");
+	seq_puts(seq, "\n");
 	seq_printf(seq, "mps %d\n", ep->ep.maxpacket);
 	seq_printf(seq, "total_data=%ld\n", ep->total_data);
 
@@ -3346,7 +3348,7 @@ static int ep_show(struct seq_file *seq, void *v)
 
 	list_for_each_entry(req, &ep->queue, queue) {
 		if (--show_limit < 0) {
-			seq_printf(seq, "not showing more requests...\n");
+			seq_puts(seq, "not showing more requests...\n");
 			break;
 		}
 


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
