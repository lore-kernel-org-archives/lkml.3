Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751995AbaL1S4s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 13:56:48 -0500
Received: from mx-rz-2.rrze.uni-erlangen.de ([131.188.11.21]:42451 "EHLO
	mx-rz-2.rrze.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751752AbaL1S4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 13:56:41 -0500
X-RRZE-Submit-IP: 131.188.42.195
From: Andreas Siegling <andreas.siegling@fau.de>
To: devel@linuxdriverproject.org
Cc: linux-kernel@i4.cs.fau.de, hsweeten@visionengravers.com, abbotti@mev.co.uk,
        gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, ebru.akagunduz@gmail.com,
        chase.southwood@gmail.com, rickard_strandqvist@spectrumdigital.se,
        Andreas Siegling <andreas.siegling@fau.de>,
        Zhutao Lu <lvzhutao@gmail.com>
Subject: [PATCH 1/3] comedi: checkpatch error: tabs instead of spaces
Date: Sun, 28 Dec 2014 19:56:13 +0100
Message-Id: <1419792975-31519-2-git-send-email-andreas.siegling@fau.de>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1419792975-31519-1-git-send-email-andreas.siegling@fau.de>
References: <1419792975-31519-1-git-send-email-andreas.siegling@fau.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes all occurrences of 8 whitespaces instead of a tab.
It will remove the 8 whitespaces and replace them with a tab, thereby
the checkpatch-error:
		ERROR: code indent should use tabs where possible
is removed from all files in drivers/staging/comedi/
It also brings some consistency of indentation in the comments.

Signed-off-by: Andreas Siegling <andreas.siegling@fau.de>
Signed-off-by: Zhutao Lu <lvzhutao@gmail.com>
---
 drivers/staging/comedi/drivers/daqboard2000.c | 62 +++++++++++++--------------
 drivers/staging/comedi/drivers/das16m1.c      |  4 +-
 drivers/staging/comedi/drivers/dmm32at.c      |  2 +-
 drivers/staging/comedi/drivers/pcl818.c       | 36 ++++++++--------
 4 files changed, 52 insertions(+), 52 deletions(-)

diff --git a/drivers/staging/comedi/drivers/daqboard2000.c b/drivers/staging/comedi/drivers/daqboard2000.c
index 96697fb..4172e99 100644
--- a/drivers/staging/comedi/drivers/daqboard2000.c
+++ b/drivers/staging/comedi/drivers/daqboard2000.c
@@ -43,7 +43,7 @@ Configuration options: not applicable, uses PCI auto config
       available from http://www.plxtech.com/products/io/pci9080 
 
    2. The initialization done so far is:
-        a. program the FPGA (windows code sans a lot of error messages)
+	a. program the FPGA (windows code sans a lot of error messages)
 	b.
 
    3. Analog out seems to work OK with DAC's disabled, if DAC's are enabled,
@@ -52,52 +52,52 @@ Configuration options: not applicable, uses PCI auto config
       gives me no clues. I'll keep it simple so far.
 
    4. Analog in.
-        Each channel in the scanlist seems to be controlled by four
+	Each channel in the scanlist seems to be controlled by four
 	control words:
 
-        Word0:
-          +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
-          ! | | | ! | | | ! | | | ! | | | !
-          +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+	Word0:
+	  +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+	  ! | | | ! | | | ! | | | ! | | | !
+	  +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 
-        Word1:
-          +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
-          ! | | | ! | | | ! | | | ! | | | !
-          +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+	Word1:
+	  +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+	  ! | | | ! | | | ! | | | ! | | | !
+	  +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 	   |             |       | | | | |
-           +------+------+       | | | | +-- Digital input (??)
+	   +------+------+       | | | | +-- Digital input (??)
 		  |		 | | | +---- 10 us settling time
 		  |		 | | +------ Suspend acquisition (last to scan)
 		  |		 | +-------- Simultaneous sample and hold
 		  |		 +---------- Signed data format
 		  +------------------------- Correction offset low
 
-        Word2:
-          +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
-          ! | | | ! | | | ! | | | ! | | | !
-          +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
-           |     | |     | | | | | |     |
-           +-----+ +--+--+ +++ +++ +--+--+
-              |       |     |   |     +----- Expansion channel
+	Word2:
+	  +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+	  ! | | | ! | | | ! | | | ! | | | !
+	  +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+	   |     | |     | | | | | |     |
+	   +-----+ +--+--+ +++ +++ +--+--+
+	      |       |     |   |     +----- Expansion channel
 	      |       |     |   +----------- Expansion gain
-              |       |     +--------------- Channel (low)
+	      |       |     +--------------- Channel (low)
 	      |       +--------------------- Correction offset high
 	      +----------------------------- Correction gain low
-        Word3:
-          +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
-          ! | | | ! | | | ! | | | ! | | | !
-          +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
-           |             | | | |   | | | |
-           +------+------+ | | +-+-+ | | +-- Low bank enable
-                  |        | |   |   | +---- High bank enable
-                  |        | |   |   +------ Hi/low select
-		  |    	   | |   +---------- Gain (1,?,2,4,8,16,32,64)
-		  |    	   | +-------------- differential/single ended
-		  |    	   +---------------- Unipolar
+	Word3:
+	  +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+	  ! | | | ! | | | ! | | | ! | | | !
+	  +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+	   |             | | | |   | | | |
+	   +------+------+ | | +-+-+ | | +-- Low bank enable
+		  |	   | |   |   | +---- High bank enable
+		  |	   | |   |   +------ Hi/low select
+		  |	   | |   +---------- Gain (1,?,2,4,8,16,32,64)
+		  |	   | +-------------- differential/single ended
+		  |	   +---------------- Unipolar
 		  +------------------------- Correction gain high
 
    999. The card seems to have an incredible amount of capabilities, but
-        trying to reverse engineer them from the Windows source is beyond my
+	trying to reverse engineer them from the Windows source is beyond my
 	patience.
 
  */
diff --git a/drivers/staging/comedi/drivers/das16m1.c b/drivers/staging/comedi/drivers/das16m1.c
index 80f41b7..3895aa9 100644
--- a/drivers/staging/comedi/drivers/das16m1.c
+++ b/drivers/staging/comedi/drivers/das16m1.c
@@ -46,8 +46,8 @@ list has 2 or more channels in it, then two conditions must be satisfied:
 (2) - the list must have an even number of entries.
 
 Options:
-        [0] - base io address
-        [1] - irq (optional, but you probably want it)
+	[0] - base io address
+	[1] - irq (optional, but you probably want it)
 
 irq can be omitted, although the cmd interface will not work without it.
 */
diff --git a/drivers/staging/comedi/drivers/dmm32at.c b/drivers/staging/comedi/drivers/dmm32at.c
index 6df298a..31919b8 100644
--- a/drivers/staging/comedi/drivers/dmm32at.c
+++ b/drivers/staging/comedi/drivers/dmm32at.c
@@ -365,7 +365,7 @@ static void dmm32at_setaitimer(struct comedi_device *dev, unsigned int nansec)
 	/* enable the ai conversion interrupt and the clock to start scans */
 	outb(DMM32AT_INTCLK_ADINT |
 	     DMM32AT_INTCLK_CLKEN | DMM32AT_INTCLK_CLKSEL,
-             dev->iobase + DMM32AT_INTCLK_REG);
+	     dev->iobase + DMM32AT_INTCLK_REG);
 }
 
 static int dmm32at_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
diff --git a/drivers/staging/comedi/drivers/pcl818.c b/drivers/staging/comedi/drivers/pcl818.c
index 8edea35..525a471 100644
--- a/drivers/staging/comedi/drivers/pcl818.c
+++ b/drivers/staging/comedi/drivers/pcl818.c
@@ -45,11 +45,11 @@ A word or two about DMA. Driver support DMA operations at two ways:
     [1] - IRQ	(0=disable, 2, 3, 4, 5, 6, 7)
     [2] - DMA	(0=disable, 1, 3)
     [3] - 0, 10=10MHz clock for 8254
-              1= 1MHz clock for 8254
+	      1= 1MHz clock for 8254
     [4] - 0,  5=A/D input  -5V.. +5V
-          1, 10=A/D input -10V..+10V
+	  1, 10=A/D input -10V..+10V
     [5] - 0,  5=D/A output 0-5V  (internal reference -5V)
-          1, 10=D/A output 0-10V (internal reference -10V)
+	  1, 10=D/A output 0-10V (internal reference -10V)
 	  2    =D/A output unknown (external reference)
 
    Options for PCL-818, PCL-818H:
@@ -57,44 +57,44 @@ A word or two about DMA. Driver support DMA operations at two ways:
     [1] - IRQ	(0=disable, 2, 3, 4, 5, 6, 7)
     [2] - DMA	(0=disable, 1, 3)
     [3] - 0, 10=10MHz clock for 8254
-              1= 1MHz clock for 8254
+	      1= 1MHz clock for 8254
     [4] - 0,  5=D/A output 0-5V  (internal reference -5V)
-          1, 10=D/A output 0-10V (internal reference -10V)
+	  1, 10=D/A output 0-10V (internal reference -10V)
 	  2    =D/A output unknown (external reference)
 
    Options for PCL-818HD, PCL-818HG:
     [0] - IO Base
     [1] - IRQ	(0=disable, 2, 3, 4, 5, 6, 7)
     [2] - DMA/FIFO  (-1=use FIFO, 0=disable both FIFO and DMA,
-                      1=use DMA ch 1, 3=use DMA ch 3)
+		      1=use DMA ch 1, 3=use DMA ch 3)
     [3] - 0, 10=10MHz clock for 8254
-              1= 1MHz clock for 8254
+	      1= 1MHz clock for 8254
     [4] - 0,  5=D/A output 0-5V  (internal reference -5V)
-          1, 10=D/A output 0-10V (internal reference -10V)
-   	  2    =D/A output unknown (external reference)
+	  1, 10=D/A output 0-10V (internal reference -10V)
+	  2    =D/A output unknown (external reference)
 
    Options for PCL-718:
     [0] - IO Base
     [1] - IRQ	(0=disable, 2, 3, 4, 5, 6, 7)
     [2] - DMA	(0=disable, 1, 3)
     [3] - 0, 10=10MHz clock for 8254
-              1= 1MHz clock for 8254
+	      1= 1MHz clock for 8254
     [4] -     0=A/D Range is +/-10V
-	      1=             +/-5V
-	      2=             +/-2.5V
-	      3=             +/-1V
-	      4=             +/-0.5V
-	      5=  	     user defined bipolar
+	      1=	     +/-5V
+	      2=	     +/-2.5V
+	      3=	     +/-1V
+	      4=	     +/-0.5V
+	      5=	     user defined bipolar
 	      6=	     0-10V
 	      7=	     0-5V
- 	      8=	     0-2V
+	      8=	     0-2V
 	      9=	     0-1V
 	     10=	     user defined unipolar
     [5] - 0,  5=D/A outputs 0-5V  (internal reference -5V)
-          1, 10=D/A outputs 0-10V (internal reference -10V)
+	  1, 10=D/A outputs 0-10V (internal reference -10V)
 	      2=D/A outputs unknown (external reference)
     [6] - 0, 60=max  60kHz A/D sampling
-          1,100=max 100kHz A/D sampling (PCL-718 with Option 001 installed)
+	  1,100=max 100kHz A/D sampling (PCL-718 with Option 001 installed)
 
 */
 
-- 
1.9.1

