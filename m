Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753443AbaLGUNh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 15:13:37 -0500
Received: from mx-rz-2.rrze.uni-erlangen.de ([131.188.11.21]:41993 "EHLO
	mx-rz-2.rrze.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753222AbaLGUNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 15:13:34 -0500
X-Greylist: delayed 442 seconds by postgrey-1.27 at vger.kernel.org; Sun, 07 Dec 2014 15:13:33 EST
X-RRZE-Submit-IP: 131.188.42.195
From: Andreas Siegling <andreas.siegling@fau.de>
To: devel@linuxdriverproject.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        gregkh@linuxfoundation.org, chase.southwood@yahoo.com,
        rickard_strandqvist@spectrumdigital.se, ebru.akagunduz@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-kernel@i4.cs.fau.de, Andreas Siegling <andreas.siegling@fau.de>,
        Zhutao Lu <lvzhutao@gmail.com>
Subject: [PATCH] comedi: indent checkpatch errors and warnings fixed
Date: Sun,  7 Dec 2014 21:03:40 +0100
Message-Id: <1417982620-26001-1-git-send-email-andreas.siegling@fau.de>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes all indent errors in drivers/staging/comedi and its
subdirectories. Since there were no other checkpatch errors, all checkpatch
errors are fixed by this patch.

It also fixes indent warnings, which were "no space before tabs",
"no spaces at the start of a line" and "missing a blank line after declarations".

Signed-off-by: Andreas Siegling <andreas.siegling@fau.de>
Signed-off-by: Zhutao Lu <lvzhutao@gmail.com>
---
 drivers/staging/comedi/drivers/comedi_bond.c  |  1 +
 drivers/staging/comedi/drivers/daqboard2000.c | 68 +++++++++++------------
 drivers/staging/comedi/drivers/das16m1.c      |  6 +-
 drivers/staging/comedi/drivers/dmm32at.c      |  2 +-
 drivers/staging/comedi/drivers/ni_at_a2150.c  | 80 +++++++++++++--------------
 drivers/staging/comedi/drivers/ni_stc.h       |  8 ++-
 drivers/staging/comedi/drivers/pcl818.c       | 36 ++++++------
 7 files changed, 103 insertions(+), 98 deletions(-)

diff --git a/drivers/staging/comedi/drivers/comedi_bond.c b/drivers/staging/comedi/drivers/comedi_bond.c
index 85b2f4a..221d381 100644
--- a/drivers/staging/comedi/drivers/comedi_bond.c
+++ b/drivers/staging/comedi/drivers/comedi_bond.c
@@ -261,6 +261,7 @@ static int do_dev_config(struct comedi_device *dev, struct comedi_devconfig *it)
 			{
 				/* Append dev:subdev to devpriv->name */
 				char buf[20];
+
 				snprintf(buf, sizeof(buf), "%u:%u ",
 					 bdev->minor, bdev->subdev);
 				strlcat(devpriv->name, buf,
diff --git a/drivers/staging/comedi/drivers/daqboard2000.c b/drivers/staging/comedi/drivers/daqboard2000.c
index 96697fb..d2eb4be 100644
--- a/drivers/staging/comedi/drivers/daqboard2000.c
+++ b/drivers/staging/comedi/drivers/daqboard2000.c
@@ -40,10 +40,10 @@ Configuration options: not applicable, uses PCI auto config
    for the card, and here are the findings so far.
 
    1. A good document that describes the PCI interface chip is 9080db-106.pdf
-      available from http://www.plxtech.com/products/io/pci9080 
+      available from http://www.plxtech.com/products/io/pci9080
 
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
-	      |       |     |   +----------- Expansion gain
-              |       |     +--------------- Channel (low)
-	      |       +--------------------- Correction offset high
+	Word2:
+	  +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+	  ! | | | ! | | | ! | | | ! | | | !
+	  +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+	   |	 | |	 | | | | | |	 |
+	   +-----+ +--+--+ +++ +++ +--+--+
+	      |	      |	    |	|     +----- Expansion channel
+	      |	      |	    |	+----------- Expansion gain
+	      |	      |	    +--------------- Channel (low)
+	      |	      +--------------------- Correction offset high
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
+	   |		 | | | |   | | | |
+	   +------+------+ | | +-+-+ | | +-- Low bank enable
+	   |		   | |	 |   | +---- High bank enable
+		  |	   | |	 |   +------ Hi/low select
+		  |	   | |	 +---------- Gain (1,?,2,4,8,16,32,64)
+		  |	   | +-------------- differential/single ended
+		  |	   +---------------- Unipolar
 		  +------------------------- Correction gain high
 
    999. The card seems to have an incredible amount of capabilities, but
-        trying to reverse engineer them from the Windows source is beyond my
+	trying to reverse engineer them from the Windows source is beyond my
 	patience.
 
  */
diff --git a/drivers/staging/comedi/drivers/das16m1.c b/drivers/staging/comedi/drivers/das16m1.c
index 80f41b7..d8852c6 100644
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
@@ -80,7 +80,7 @@ irq can be omitted, although the cmd interface will not work without it.
   89ab	8254
   cdef	8254
   400	8255
-  404-407 	8254
+  404-407	8254
 
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
diff --git a/drivers/staging/comedi/drivers/ni_at_a2150.c b/drivers/staging/comedi/drivers/ni_at_a2150.c
index 69e543a..29026e2 100644
--- a/drivers/staging/comedi/drivers/ni_at_a2150.c
+++ b/drivers/staging/comedi/drivers/ni_at_a2150.c
@@ -71,48 +71,48 @@ TRIG_WAKE_EOS
 #include "8253.h"
 #include "comedi_fc.h"
 
-#define A2150_DMA_BUFFER_SIZE	0xff00	/*  size in bytes of dma buffer */
+#define	  A2150_DMA_BUFFER_SIZE	0xff00	/*  size in bytes of dma buffer */
 
 /* Registers and bits */
-#define CONFIG_REG		0x0
-#define   CHANNEL_BITS(x)		((x) & 0x7)
-#define   CHANNEL_MASK		0x7
-#define   CLOCK_SELECT_BITS(x)		(((x) & 0x3) << 3)
-#define   CLOCK_DIVISOR_BITS(x)		(((x) & 0x3) << 5)
-#define   CLOCK_MASK		(0xf << 3)
-#define   ENABLE0_BIT		0x80	/*  enable (don't internally ground) channels 0 and 1 */
-#define   ENABLE1_BIT		0x100	/*  enable (don't internally ground) channels 2 and 3 */
-#define   AC0_BIT		0x200	/*  ac couple channels 0,1 */
-#define   AC1_BIT		0x400	/*  ac couple channels 2,3 */
-#define   APD_BIT		0x800	/*  analog power down */
-#define   DPD_BIT		0x1000	/*  digital power down */
-#define TRIGGER_REG		0x2	/*  trigger config register */
-#define   POST_TRIGGER_BITS		0x2
-#define   DELAY_TRIGGER_BITS		0x3
-#define   HW_TRIG_EN		0x10	/*  enable hardware trigger */
-#define FIFO_START_REG		0x6	/*  software start aquistion trigger */
-#define FIFO_RESET_REG		0x8	/*  clears fifo + fifo flags */
-#define FIFO_DATA_REG		0xa	/*  read data */
-#define DMA_TC_CLEAR_REG		0xe	/*  clear dma terminal count interrupt */
-#define STATUS_REG		0x12	/*  read only */
-#define   FNE_BIT		0x1	/*  fifo not empty */
-#define   OVFL_BIT		0x8	/*  fifo overflow */
-#define   EDAQ_BIT		0x10	/*  end of acquisition interrupt */
-#define   DCAL_BIT		0x20	/*  offset calibration in progress */
-#define   INTR_BIT		0x40	/*  interrupt has occurred */
-#define   DMA_TC_BIT		0x80	/*  dma terminal count interrupt has occurred */
-#define   ID_BITS(x)	(((x) >> 8) & 0x3)
-#define IRQ_DMA_CNTRL_REG		0x12	/*  write only */
-#define   DMA_CHAN_BITS(x)		((x) & 0x7)	/*  sets dma channel */
-#define   DMA_EN_BIT		0x8	/*  enables dma */
-#define   IRQ_LVL_BITS(x)		(((x) & 0xf) << 4)	/*  sets irq level */
-#define   FIFO_INTR_EN_BIT		0x100	/*  enable fifo interrupts */
-#define   FIFO_INTR_FHF_BIT		0x200	/*  interrupt fifo half full */
-#define   DMA_INTR_EN_BIT 		0x800	/*  enable interrupt on dma terminal count */
-#define   DMA_DEM_EN_BIT	0x1000	/*  enables demand mode dma */
-#define I8253_BASE_REG		0x14
-#define I8253_MODE_REG		0x17
-#define   HW_COUNT_DISABLE		0x30	/*  disable hardware counting of conversions */
+#define	  CONFIG_REG		0x0
+#define	  CHANNEL_BITS(x)	((x) & 0x7)
+#define	  CHANNEL_MASK		0x7
+#define	  CLOCK_SELECT_BITS(x)	(((x) & 0x3) << 3)
+#define	  CLOCK_DIVISOR_BITS(x)	(((x) & 0x3) << 5)
+#define	  CLOCK_MASK		(0xf << 3)
+#define	  ENABLE0_BIT		0x80	/*  enable (don't internally ground) channels 0 and 1 */
+#define	  ENABLE1_BIT		0x100	/*  enable (don't internally ground) channels 2 and 3 */
+#define	  AC0_BIT		0x200	/*  ac couple channels 0,1 */
+#define	  AC1_BIT		0x400	/*  ac couple channels 2,3 */
+#define	  APD_BIT		0x800	/*  analog power down */
+#define	  DPD_BIT		0x1000	/*  digital power down */
+#define	  TRIGGER_REG		0x2	/*  trigger config register */
+#define	  POST_TRIGGER_BITS	0x2
+#define	  DELAY_TRIGGER_BITS	0x3
+#define	  HW_TRIG_EN		0x10	/*  enable hardware trigger */
+#define	  FIFO_START_REG	0x6	/*  software start aquistion trigger */
+#define	  FIFO_RESET_REG	0x8	/*  clears fifo + fifo flags */
+#define	  FIFO_DATA_REG		0xa	/*  read data */
+#define	  DMA_TC_CLEAR_REG	0xe	/*  clear dma terminal count interrupt */
+#define	  STATUS_REG		0x12	/*  read only */
+#define	  FNE_BIT		0x1	/*  fifo not empty */
+#define	  OVFL_BIT		0x8	/*  fifo overflow */
+#define	  EDAQ_BIT		0x10	/*  end of acquisition interrupt */
+#define	  DCAL_BIT		0x20	/*  offset calibration in progress */
+#define	  INTR_BIT		0x40	/*  interrupt has occurred */
+#define	  DMA_TC_BIT		0x80	/*  dma terminal count interrupt has occurred */
+#define	  ID_BITS(x)		(((x) >> 8) & 0x3)
+#define	  IRQ_DMA_CNTRL_REG	0x12	/*  write only */
+#define	  DMA_CHAN_BITS(x)	((x) & 0x7)	/*  sets dma channel */
+#define	  DMA_EN_BIT		0x8	/*  enables dma */
+#define	  IRQ_LVL_BITS(x)	(((x) & 0xf) << 4)	/*  sets irq level */
+#define	  FIFO_INTR_EN_BIT	0x100	/*  enable fifo interrupts */
+#define	  FIFO_INTR_FHF_BIT	0x200	/*  interrupt fifo half full */
+#define	  DMA_INTR_EN_BIT	0x800	/*  enable interrupt on dma terminal count */
+#define	  DMA_DEM_EN_BIT	0x1000	/*  enables demand mode dma */
+#define	  I8253_BASE_REG	0x14
+#define	  I8253_MODE_REG	0x17
+#define	  HW_COUNT_DISABLE	0x30	/*  disable hardware counting of conversions */
 
 struct a2150_board {
 	const char *name;
diff --git a/drivers/staging/comedi/drivers/ni_stc.h b/drivers/staging/comedi/drivers/ni_stc.h
index 131e904..20913ac 100644
--- a/drivers/staging/comedi/drivers/ni_stc.h
+++ b/drivers/staging/comedi/drivers/ni_stc.h
@@ -166,7 +166,7 @@ enum Interrupt_B_Ack_Bits {
 #define AI_SCAN_IN_PROG_Pulse			_bit4
 #define AI_EXTMUX_CLK_Pulse			_bit3
 #define AI_LOCALMUX_CLK_Pulse			_bit2
-#define AI_SC_TC_Pulse			 	_bit1
+#define AI_SC_TC_Pulse				_bit1
 #define AI_CONVERT_Pulse			_bit0
 
 #define AO_Command_1_Register		9
@@ -326,6 +326,7 @@ static inline unsigned RTSI_Output_Bit(unsigned channel, int is_mseries)
 {
 	unsigned max_channel;
 	unsigned base_bit_shift;
+
 	if (is_mseries) {
 		base_bit_shift = 8;
 		max_channel = 7;
@@ -642,7 +643,7 @@ static unsigned AO_UPDATE_Output_Select(enum ao_update_output_selection
 #define G_Load_Source_Select		_bit7
 #define G_Reload_Source_Switching	_bit15
 #define G_Loading_On_Gate		_bit14
-#define G_Gate_Polarity 		_bit13
+#define G_Gate_Polarity			_bit13
 
 #define G_Counting_Once(a)		(((a)&0x03)<<10)
 #define G_Stop_Mode(a)			(((a)&0x03)<<5)
@@ -1142,6 +1143,7 @@ static inline unsigned MSeries_AI_Config_Bank_Bits(enum ni_reg_type reg_type,
 						   unsigned channel)
 {
 	unsigned bits = channel & 0x30;
+
 	if (reg_type == ni_reg_622x) {
 		if (channel & 0x40)
 			bits |= 0x400;
@@ -1191,6 +1193,7 @@ enum MSeries_PLL_Control_Bits {
 static inline unsigned MSeries_PLL_Divisor_Bits(unsigned divisor)
 {
 	static const unsigned max_divisor = 0x10;
+
 	if (divisor < 1 || divisor > max_divisor) {
 		pr_err("%s: bug, invalid divisor=%i\n", __func__, divisor);
 		return 0;
@@ -1201,6 +1204,7 @@ static inline unsigned MSeries_PLL_Divisor_Bits(unsigned divisor)
 static inline unsigned MSeries_PLL_Multiplier_Bits(unsigned multiplier)
 {
 	static const unsigned max_multiplier = 0x100;
+
 	if (multiplier < 1 || multiplier > max_multiplier) {
 		pr_err("%s: bug, invalid multiplier=%i\n", __func__,
 		       multiplier);
diff --git a/drivers/staging/comedi/drivers/pcl818.c b/drivers/staging/comedi/drivers/pcl818.c
index 8edea35..1b82a88 100644
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
+	  1,  10=A/D input -10V..+10V
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
+	  1,  10=D/A outputs 0-10V (internal reference -10V)
 	      2=D/A outputs unknown (external reference)
     [6] - 0, 60=max  60kHz A/D sampling
-          1,100=max 100kHz A/D sampling (PCL-718 with Option 001 installed)
+	  1,100=max 100kHz A/D sampling (PCL-718 with Option 001 installed)
 
 */
 
-- 
1.9.1

