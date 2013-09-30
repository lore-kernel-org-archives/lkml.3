Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237Ab3I3M4Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 08:56:16 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:11367 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753614Ab3I3M4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 08:56:14 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-d5-524974ed9506
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Felipe Balbi <balbi@ti.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pavel Machek <pavel@denx.de>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH] usb: gadget: s3c-hsotg: fix CodingStyle issues
Date: Mon, 30 Sep 2013 14:56:02 +0200
Message-id: <2690897.Tjz9zsoiZQ@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-52-generic-pae; KDE/4.8.5; i686; ; )
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLLMWRmVeSWpSXmKPExsVy+t9jAd23JZ5BBr+ma1ocvF9vcbbpDbvF
	5V1z2CwWLWtltji6wcXizKpb7A5sHg+m/mfymDfrBItH35ZVjB7Hb2xn8vi8SS6ANYrLJiU1
	J7MstUjfLoEr49mxwoJOyYpXF7cxNzBOFuli5OSQEDCR6NnawQRhi0lcuLeerYuRi0NIYBGj
	xOeLH5khnBYmiblNE9hAqtgErCQmtq9iBLFFBOQlJv1ZyApSxCxwgFGi9dcidpCEsIC9xKap
	K1hAbBYBVYlZrd+YQWxeAU2Jp+tWgtWICnhKfJq0FCouKPFj8j2wemagofv2T2WFsLUk1u88
	zjSBkW8WkrJZSMpmISlbwMi8ilE0tSC5oDgpPddQrzgxt7g0L10vOT93EyM4UJ9J7WBc2WBx
	iFGAg1GJh3fCco8gIdbEsuLK3EOMEhzMSiK8E7I8g4R4UxIrq1KL8uOLSnNSiw8xSnOwKInz
	Hmi1DhQSSE8sSc1OTS1ILYLJMnFwSjUwVvH/YBWUs/i84lPhRY/LhgyVPbdtOB6v4N6Yd8pB
	7eGJJ1tZqq5yeNzb4GbX5ckoUxg0MX51uJGGc8GU2oz1DqHpO7z62YqFD688nqhlUr6qLPBV
	15HbWZmq2f92ncyYq7vnwN+9hUFTfuwSdIye4bu1N3tjxkH521e3uy0qNeF6NvGZyNZ9SizF
	GYmGWsxFxYkA1Gi1WVACAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavel Machek <pavel@denx.de>

checkpatch.pl has some valid complaints about style in s3c-hsotg.c:
- macro with 'if' should be really enclosed in 'do {} while (0)'
- seq_puts() is going to be slightly faster than seq_printf()
- pr_err() is shorter than printk(KERN_ERR ...)

Signed-off-by: Pavel Machek <pavel@denx.de>
[bzolnier: minor fixes]
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/usb/gadget/s3c-hsotg.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/gadget/s3c-hsotg.c b/drivers/usb/gadget/s3c-hsotg.c
index 6bddf1a..24973d7 100644
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
+	} \
+} while (0)
 
 /**
  * s3c_hsotg_disconnect - disconnect service
@@ -2903,7 +2905,7 @@ static int s3c_hsotg_udc_start(struct usb_gadget *gadget,
 	int ret;
 
 	if (!hsotg) {
-		printk(KERN_ERR "%s: called with no device\n", __func__);
+		pr_err("%s: called with no device\n", __func__);
 		return -ENODEV;
 	}
 
@@ -3200,7 +3202,7 @@ static int state_show(struct seq_file *seq, void *v)
 		   readl(regs + GNPTXSTS),
 		   readl(regs + GRXSTSR));
 
-	seq_printf(seq, "\nEndpoint status:\n");
+	seq_puts(seq, "\nEndpoint status:\n");
 
 	for (idx = 0; idx < 15; idx++) {
 		u32 in, out;
@@ -3217,7 +3219,7 @@ static int state_show(struct seq_file *seq, void *v)
 		seq_printf(seq, ", DIEPTSIZ=0x%08x, DOEPTSIZ=0x%08x",
 			   in, out);
 
-		seq_printf(seq, "\n");
+		seq_puts(seq, "\n");
 	}
 
 	return 0;
@@ -3251,7 +3253,7 @@ static int fifo_show(struct seq_file *seq, void *v)
 	u32 val;
 	int idx;
 
-	seq_printf(seq, "Non-periodic FIFOs:\n");
+	seq_puts(seq, "Non-periodic FIFOs:\n");
 	seq_printf(seq, "RXFIFO: Size %d\n", readl(regs + GRXFSIZ));
 
 	val = readl(regs + GNPTXFSIZ);
@@ -3259,7 +3261,7 @@ static int fifo_show(struct seq_file *seq, void *v)
 		   val >> GNPTXFSIZ_NPTxFDep_SHIFT,
 		   val & GNPTXFSIZ_NPTxFStAddr_MASK);
 
-	seq_printf(seq, "\nPeriodic TXFIFOs:\n");
+	seq_puts(seq, "\nPeriodic TXFIFOs:\n");
 
 	for (idx = 1; idx <= 15; idx++) {
 		val = readl(regs + DPTXFSIZn(idx));
@@ -3330,7 +3332,7 @@ static int ep_show(struct seq_file *seq, void *v)
 		   readl(regs + DIEPTSIZ(index)),
 		   readl(regs + DOEPTSIZ(index)));
 
-	seq_printf(seq, "\n");
+	seq_puts(seq, "\n");
 	seq_printf(seq, "mps %d\n", ep->ep.maxpacket);
 	seq_printf(seq, "total_data=%ld\n", ep->total_data);
 
@@ -3341,7 +3343,7 @@ static int ep_show(struct seq_file *seq, void *v)
 
 	list_for_each_entry(req, &ep->queue, queue) {
 		if (--show_limit < 0) {
-			seq_printf(seq, "not showing more requests...\n");
+			seq_puts(seq, "not showing more requests...\n");
 			break;
 		}
 
-- 
1.8.2.3


