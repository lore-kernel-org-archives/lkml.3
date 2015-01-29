Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758300AbbA2Fd2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 00:33:28 -0500
Received: from mail-ie0-f172.google.com ([209.85.223.172]:57264 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755542AbbA2Fd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 00:33:27 -0500
Date: Thu, 29 Jan 2015 13:33:17 +0800
From: Simon Guo <wei.guo.simon@gmail.com>
To: Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        wei.guo.simon@gmail.com
Subject: [PATCH v2 01/02] STAGING: Fix pcl818.c coding style issue: code
 indent should use tabs where possible
Message-ID: <20150129053316.GA2508@thunderCat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct one coding style problem(detected by checkpatch.pl) in pcl818.c.
- code indent should use tabs where possible
It is fixed by reformatting the comment block to usual comment style.

And with the reformatting, following coding style problem is also fixed:
- please, no space before tabs

Signed-off-by: Simon Guo <wei.guo.simon@gmail.com>
---
 drivers/staging/comedi/drivers/pcl818.c | 189 +++++++++++++++-----------------
 1 file changed, 91 insertions(+), 98 deletions(-)

diff --git a/drivers/staging/comedi/drivers/pcl818.c b/drivers/staging/comedi/drivers/pcl818.c
index ba2e137..5d9050c 100644
--- a/drivers/staging/comedi/drivers/pcl818.c
+++ b/drivers/staging/comedi/drivers/pcl818.c
@@ -1,102 +1,95 @@
 /*
-   comedi/drivers/pcl818.c
-
-   Author:  Michal Dobes <dobes@tesnet.cz>
-
-   hardware driver for Advantech cards:
-    card:   PCL-818L, PCL-818H, PCL-818HD, PCL-818HG, PCL-818, PCL-718
-    driver: pcl818l,  pcl818h,  pcl818hd,  pcl818hg,  pcl818,  pcl718
-*/
-/*
-Driver: pcl818
-Description: Advantech PCL-818 cards, PCL-718
-Author: Michal Dobes <dobes@tesnet.cz>
-Devices: [Advantech] PCL-818L (pcl818l), PCL-818H (pcl818h),
-  PCL-818HD (pcl818hd), PCL-818HG (pcl818hg), PCL-818 (pcl818),
-  PCL-718 (pcl718)
-Status: works
-
-All cards have 16 SE/8 DIFF ADCs, one or two DACs, 16 DI and 16 DO.
-Differences are only at maximal sample speed, range list and FIFO
-support.
-The driver support AI mode 0, 1, 3 other subdevices (AO, DI, DO) support
-only mode 0. If DMA/FIFO/INT are disabled then AI support only mode 0.
-PCL-818HD and PCL-818HG support 1kword FIFO. Driver support this FIFO
-but this code is untested.
-A word or two about DMA. Driver support DMA operations at two ways:
-1) DMA uses two buffers and after one is filled then is generated
-   INT and DMA restart with second buffer. With this mode I'm unable run
-   more that 80Ksamples/secs without data dropouts on K6/233.
-2) DMA uses one buffer and run in autoinit mode and the data are
-   from DMA buffer moved on the fly with 2kHz interrupts from RTC.
-   This mode is used if the interrupt 8 is available for allocation.
-   If not, then first DMA mode is used. With this I can run at
-   full speed one card (100ksamples/secs) or two cards with
-   60ksamples/secs each (more is problem on account of ISA limitations).
-   To use this mode you must have compiled  kernel with disabled
-   "Enhanced Real Time Clock Support".
-   Maybe you can have problems if you use xntpd or similar.
-   If you've data dropouts with DMA mode 2 then:
-    a) disable IDE DMA
-    b) switch text mode console to fb.
-
-   Options for PCL-818L:
-    [0] - IO Base
-    [1] - IRQ	(0=disable, 2, 3, 4, 5, 6, 7)
-    [2] - DMA	(0=disable, 1, 3)
-    [3] - 0, 10=10MHz clock for 8254
-              1= 1MHz clock for 8254
-    [4] - 0,  5=A/D input  -5V.. +5V
-          1, 10=A/D input -10V..+10V
-    [5] - 0,  5=D/A output 0-5V  (internal reference -5V)
-          1, 10=D/A output 0-10V (internal reference -10V)
-	  2    =D/A output unknown (external reference)
-
-   Options for PCL-818, PCL-818H:
-    [0] - IO Base
-    [1] - IRQ	(0=disable, 2, 3, 4, 5, 6, 7)
-    [2] - DMA	(0=disable, 1, 3)
-    [3] - 0, 10=10MHz clock for 8254
-              1= 1MHz clock for 8254
-    [4] - 0,  5=D/A output 0-5V  (internal reference -5V)
-          1, 10=D/A output 0-10V (internal reference -10V)
-	  2    =D/A output unknown (external reference)
-
-   Options for PCL-818HD, PCL-818HG:
-    [0] - IO Base
-    [1] - IRQ	(0=disable, 2, 3, 4, 5, 6, 7)
-    [2] - DMA/FIFO  (-1=use FIFO, 0=disable both FIFO and DMA,
-                      1=use DMA ch 1, 3=use DMA ch 3)
-    [3] - 0, 10=10MHz clock for 8254
-              1= 1MHz clock for 8254
-    [4] - 0,  5=D/A output 0-5V  (internal reference -5V)
-          1, 10=D/A output 0-10V (internal reference -10V)
-   	  2    =D/A output unknown (external reference)
-
-   Options for PCL-718:
-    [0] - IO Base
-    [1] - IRQ	(0=disable, 2, 3, 4, 5, 6, 7)
-    [2] - DMA	(0=disable, 1, 3)
-    [3] - 0, 10=10MHz clock for 8254
-              1= 1MHz clock for 8254
-    [4] -     0=A/D Range is +/-10V
-	      1=             +/-5V
-	      2=             +/-2.5V
-	      3=             +/-1V
-	      4=             +/-0.5V
-	      5=  	     user defined bipolar
-	      6=	     0-10V
-	      7=	     0-5V
- 	      8=	     0-2V
-	      9=	     0-1V
-	     10=	     user defined unipolar
-    [5] - 0,  5=D/A outputs 0-5V  (internal reference -5V)
-          1, 10=D/A outputs 0-10V (internal reference -10V)
-	      2=D/A outputs unknown (external reference)
-    [6] - 0, 60=max  60kHz A/D sampling
-          1,100=max 100kHz A/D sampling (PCL-718 with Option 001 installed)
-
-*/
+ * comedi/drivers/pcl818.c
+ *
+ * Driver: pcl818
+ * Description: Advantech PCL-818 cards, PCL-718
+ * Author: Michal Dobes <dobes@tesnet.cz>
+ * Devices: [Advantech] PCL-818L (pcl818l), PCL-818H (pcl818h),
+ *   PCL-818HD (pcl818hd), PCL-818HG (pcl818hg), PCL-818 (pcl818),
+ *   PCL-718 (pcl718)
+ * Status: works
+ *
+ * All cards have 16 SE/8 DIFF ADCs, one or two DACs, 16 DI and 16 DO.
+ * Differences are only at maximal sample speed, range list and FIFO
+ * support.
+ * The driver support AI mode 0, 1, 3 other subdevices (AO, DI, DO) support
+ * only mode 0. If DMA/FIFO/INT are disabled then AI support only mode 0.
+ * PCL-818HD and PCL-818HG support 1kword FIFO. Driver support this FIFO
+ * but this code is untested.
+ * A word or two about DMA. Driver support DMA operations at two ways:
+ * 1) DMA uses two buffers and after one is filled then is generated
+ *    INT and DMA restart with second buffer. With this mode I'm unable run
+ *    more that 80Ksamples/secs without data dropouts on K6/233.
+ * 2) DMA uses one buffer and run in autoinit mode and the data are
+ *    from DMA buffer moved on the fly with 2kHz interrupts from RTC.
+ *    This mode is used if the interrupt 8 is available for allocation.
+ *    If not, then first DMA mode is used. With this I can run at
+ *    full speed one card (100ksamples/secs) or two cards with
+ *    60ksamples/secs each (more is problem on account of ISA limitations).
+ *    To use this mode you must have compiled  kernel with disabled
+ *    "Enhanced Real Time Clock Support".
+ *    Maybe you can have problems if you use xntpd or similar.
+ *    If you've data dropouts with DMA mode 2 then:
+ *     a) disable IDE DMA
+ *     b) switch text mode console to fb.
+ *
+ *  Options for PCL-818L:
+ *  [0] - IO Base
+ *  [1] - IRQ        (0=disable, 2, 3, 4, 5, 6, 7)
+ *  [2] - DMA        (0=disable, 1, 3)
+ *  [3] - 0, 10=10MHz clock for 8254
+ *            1= 1MHz clock for 8254
+ *  [4] - 0,  5=A/D input  -5V.. +5V
+ *        1, 10=A/D input -10V..+10V
+ *  [5] - 0,  5=D/A output 0-5V  (internal reference -5V)
+ *        1, 10=D/A output 0-10V (internal reference -10V)
+ *        2    =D/A output unknown (external reference)
+ *
+ *  Options for PCL-818, PCL-818H:
+ *  [0] - IO Base
+ *  [1] - IRQ        (0=disable, 2, 3, 4, 5, 6, 7)
+ *  [2] - DMA        (0=disable, 1, 3)
+ *  [3] - 0, 10=10MHz clock for 8254
+ *            1= 1MHz clock for 8254
+ *  [4] - 0,  5=D/A output 0-5V  (internal reference -5V)
+ *        1, 10=D/A output 0-10V (internal reference -10V)
+ *        2    =D/A output unknown (external reference)
+ *
+ *  Options for PCL-818HD, PCL-818HG:
+ *  [0] - IO Base
+ *  [1] - IRQ        (0=disable, 2, 3, 4, 5, 6, 7)
+ *  [2] - DMA/FIFO  (-1=use FIFO, 0=disable both FIFO and DMA,
+ *                    1=use DMA ch 1, 3=use DMA ch 3)
+ *  [3] - 0, 10=10MHz clock for 8254
+ *            1= 1MHz clock for 8254
+ *  [4] - 0,  5=D/A output 0-5V  (internal reference -5V)
+ *        1, 10=D/A output 0-10V (internal reference -10V)
+ *        2    =D/A output unknown (external reference)
+ *
+ *  Options for PCL-718:
+ *  [0] - IO Base
+ *  [1] - IRQ        (0=disable, 2, 3, 4, 5, 6, 7)
+ *  [2] - DMA        (0=disable, 1, 3)
+ *  [3] - 0, 10=10MHz clock for 8254
+ *            1= 1MHz clock for 8254
+ *  [4] -     0=A/D Range is +/-10V
+ *            1=             +/-5V
+ *            2=             +/-2.5V
+ *            3=             +/-1V
+ *            4=             +/-0.5V
+ *            5=             user defined bipolar
+ *            6=             0-10V
+ *            7=             0-5V
+ *            8=             0-2V
+ *            9=             0-1V
+ *           10=             user defined unipolar
+ *  [5] - 0,  5=D/A outputs 0-5V  (internal reference -5V)
+ *        1, 10=D/A outputs 0-10V (internal reference -10V)
+ *            2=D/A outputs unknown (external reference)
+ *  [6] - 0, 60=max  60kHz A/D sampling
+ *        1,100=max 100kHz A/D sampling (PCL-718 with Option 001 installed)
+ *
+ */
 
 #include <linux/module.h>
 #include <linux/gfp.h>
-- 
1.8.1.2

