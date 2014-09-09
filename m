Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756870AbaIIKiz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 06:38:55 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:36162 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756410AbaIIK1S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 06:27:18 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 14/48] staging: comedi: cb_pcidas64: replace comedi_board() calls
Date: Tue,  9 Sep 2014 11:26:23 +0100
Message-Id: <1410258417-28230-15-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410258417-28230-1-git-send-email-abbotti@mev.co.uk>
References: <1410258417-28230-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The `comedi_board(dev)` inline function calls just return
`dev->board_ptr`.  Expand the inline function calls.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/cb_pcidas64.c | 66 ++++++++++++++--------------
 1 file changed, 33 insertions(+), 33 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidas64.c b/drivers/staging/comedi/drivers/cb_pcidas64.c
index 56069d6..3b6bffc 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas64.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas64.c
@@ -1038,7 +1038,7 @@ static const struct pcidas64_board pcidas64_boards[] = {
 static inline unsigned short se_diff_bit_6xxx(struct comedi_device *dev,
 					      int use_differential)
 {
-	const struct pcidas64_board *thisboard = comedi_board(dev);
+	const struct pcidas64_board *thisboard = dev->board_ptr;
 
 	if ((thisboard->layout == LAYOUT_64XX && !use_differential) ||
 	    (thisboard->layout == LAYOUT_60XX && use_differential))
@@ -1121,7 +1121,7 @@ struct pcidas64_private {
 static unsigned int ai_range_bits_6xxx(const struct comedi_device *dev,
 				       unsigned int range_index)
 {
-	const struct pcidas64_board *thisboard = comedi_board(dev);
+	const struct pcidas64_board *thisboard = dev->board_ptr;
 	const struct comedi_krange *range =
 		&thisboard->ai_range_table->range[range_index];
 	unsigned int bits = 0;
@@ -1166,7 +1166,7 @@ static unsigned int ai_range_bits_6xxx(const struct comedi_device *dev,
 static unsigned int hw_revision(const struct comedi_device *dev,
 				uint16_t hw_status_bits)
 {
-	const struct pcidas64_board *thisboard = comedi_board(dev);
+	const struct pcidas64_board *thisboard = dev->board_ptr;
 
 	if (thisboard->layout == LAYOUT_4020)
 		return (hw_status_bits >> 13) & 0x7;
@@ -1178,7 +1178,7 @@ static void set_dac_range_bits(struct comedi_device *dev,
 			       uint16_t *bits, unsigned int channel,
 			       unsigned int range)
 {
-	const struct pcidas64_board *thisboard = comedi_board(dev);
+	const struct pcidas64_board *thisboard = dev->board_ptr;
 	unsigned int code = thisboard->ao_range_code[range];
 
 	if (channel > 1)
@@ -1235,7 +1235,7 @@ static void disable_ai_interrupts(struct comedi_device *dev)
 static void enable_ai_interrupts(struct comedi_device *dev,
 				 const struct comedi_cmd *cmd)
 {
-	const struct pcidas64_board *thisboard = comedi_board(dev);
+	const struct pcidas64_board *thisboard = dev->board_ptr;
 	struct pcidas64_private *devpriv = dev->private;
 	uint32_t bits;
 	unsigned long flags;
@@ -1259,7 +1259,7 @@ static void enable_ai_interrupts(struct comedi_device *dev,
 /* initialize plx9080 chip */
 static void init_plx9080(struct comedi_device *dev)
 {
-	const struct pcidas64_board *thisboard = comedi_board(dev);
+	const struct pcidas64_board *thisboard = dev->board_ptr;
 	struct pcidas64_private *devpriv = dev->private;
 	uint32_t bits;
 	void __iomem *plx_iobase = devpriv->plx9080_iobase;
@@ -1337,7 +1337,7 @@ static void disable_ai_pacing(struct comedi_device *dev)
 static int set_ai_fifo_segment_length(struct comedi_device *dev,
 				      unsigned int num_entries)
 {
-	const struct pcidas64_board *thisboard = comedi_board(dev);
+	const struct pcidas64_board *thisboard = dev->board_ptr;
 	struct pcidas64_private *devpriv = dev->private;
 	static const int increment_size = 0x100;
 	const struct hw_fifo_info *const fifo = thisboard->ai_fifo;
@@ -1366,7 +1366,7 @@ static int set_ai_fifo_segment_length(struct comedi_device *dev,
 /* adjusts the size of hardware fifo (which determines block size for dma xfers) */
 static int set_ai_fifo_size(struct comedi_device *dev, unsigned int num_samples)
 {
-	const struct pcidas64_board *thisboard = comedi_board(dev);
+	const struct pcidas64_board *thisboard = dev->board_ptr;
 	unsigned int num_fifo_entries;
 	int retval;
 	const struct hw_fifo_info *const fifo = thisboard->ai_fifo;
@@ -1387,7 +1387,7 @@ static int set_ai_fifo_size(struct comedi_device *dev, unsigned int num_samples)
 /* query length of fifo */
 static unsigned int ai_fifo_size(struct comedi_device *dev)
 {
-	const struct pcidas64_board *thisboard = comedi_board(dev);
+	const struct pcidas64_board *thisboard = dev->board_ptr;
 	struct pcidas64_private *devpriv = dev->private;
 
 	return devpriv->ai_fifo_segment_length *
@@ -1397,7 +1397,7 @@ static unsigned int ai_fifo_size(struct comedi_device *dev)
 
 static void init_stc_registers(struct comedi_device *dev)
 {
-	const struct pcidas64_board *thisboard = comedi_board(dev);
+	const struct pcidas64_board *thisboard = dev->board_ptr;
 	struct pcidas64_private *devpriv = dev->private;
 	uint16_t bits;
 	unsigned long flags;
@@ -1443,7 +1443,7 @@ static void init_stc_registers(struct comedi_device *dev)
 
 static int alloc_and_init_dma_members(struct comedi_device *dev)
 {
-	const struct pcidas64_board *thisboard = comedi_board(dev);
+	const struct pcidas64_board *thisboard = dev->board_ptr;
 	struct pci_dev *pcidev = comedi_to_pci_dev(dev);
 	struct pcidas64_private *devpriv = dev->private;
 	int i;
@@ -1526,7 +1526,7 @@ static int alloc_and_init_dma_members(struct comedi_device *dev)
 
 static void cb_pcidas64_free_dma(struct comedi_device *dev)
 {
-	const struct pcidas64_board *thisboard = comedi_board(dev);
+	const struct pcidas64_board *thisboard = dev->board_ptr;
 	struct pci_dev *pcidev = comedi_to_pci_dev(dev);
 	struct pcidas64_private *devpriv = dev->private;
 	int i;
@@ -1706,7 +1706,7 @@ static int cb_pcidas64_ai_eoc(struct comedi_device *dev,
 			      struct comedi_insn *insn,
 			      unsigned long context)
 {
-	const struct pcidas64_board *thisboard = comedi_board(dev);
+	const struct pcidas64_board *thisboard = dev->board_ptr;
 	struct pcidas64_private *devpriv = dev->private;
 	unsigned int status;
 
@@ -1725,7 +1725,7 @@ static int cb_pcidas64_ai_eoc(struct comedi_device *dev,
 static int ai_rinsn(struct comedi_device *dev, struct comedi_subdevice *s,
 		    struct comedi_insn *insn, unsigned int *data)
 {
-	const struct pcidas64_board *thisboard = comedi_board(dev);
+	const struct pcidas64_board *thisboard = dev->board_ptr;
 	struct pcidas64_private *devpriv = dev->private;
 	unsigned int bits = 0, n;
 	unsigned int channel, range, aref;
@@ -1845,7 +1845,7 @@ static int ai_rinsn(struct comedi_device *dev, struct comedi_subdevice *s,
 static int ai_config_calibration_source(struct comedi_device *dev,
 					unsigned int *data)
 {
-	const struct pcidas64_board *thisboard = comedi_board(dev);
+	const struct pcidas64_board *thisboard = dev->board_ptr;
 	struct pcidas64_private *devpriv = dev->private;
 	unsigned int source = data[1];
 	int num_calibration_sources;
@@ -1867,7 +1867,7 @@ static int ai_config_calibration_source(struct comedi_device *dev,
 
 static int ai_config_block_size(struct comedi_device *dev, unsigned int *data)
 {
-	const struct pcidas64_board *thisboard = comedi_board(dev);
+	const struct pcidas64_board *thisboard = dev->board_ptr;
 	int fifo_size;
 	const struct hw_fifo_info *const fifo = thisboard->ai_fifo;
 	unsigned int block_size, requested_block_size;
@@ -1921,7 +1921,7 @@ static int ai_config_master_clock_4020(struct comedi_device *dev,
 /* XXX could add support for 60xx series */
 static int ai_config_master_clock(struct comedi_device *dev, unsigned int *data)
 {
-	const struct pcidas64_board *thisboard = comedi_board(dev);
+	const struct pcidas64_board *thisboard = dev->board_ptr;
 
 	switch (thisboard->layout) {
 	case LAYOUT_4020:
@@ -1979,7 +1979,7 @@ static unsigned int get_divisor(unsigned int ns, unsigned int flags)
  */
 static void check_adc_timing(struct comedi_device *dev, struct comedi_cmd *cmd)
 {
-	const struct pcidas64_board *thisboard = comedi_board(dev);
+	const struct pcidas64_board *thisboard = dev->board_ptr;
 	unsigned int convert_divisor = 0, scan_divisor;
 	static const int min_convert_divisor = 3;
 	static const int max_convert_divisor =
@@ -2027,7 +2027,7 @@ static int cb_pcidas64_ai_check_chanlist(struct comedi_device *dev,
 					 struct comedi_subdevice *s,
 					 struct comedi_cmd *cmd)
 {
-	const struct pcidas64_board *board = comedi_board(dev);
+	const struct pcidas64_board *board = dev->board_ptr;
 	unsigned int aref0 = CR_AREF(cmd->chanlist[0]);
 	int i;
 
@@ -2066,7 +2066,7 @@ static int cb_pcidas64_ai_check_chanlist(struct comedi_device *dev,
 static int ai_cmdtest(struct comedi_device *dev, struct comedi_subdevice *s,
 		      struct comedi_cmd *cmd)
 {
-	const struct pcidas64_board *thisboard = comedi_board(dev);
+	const struct pcidas64_board *thisboard = dev->board_ptr;
 	int err = 0;
 	unsigned int tmp_arg, tmp_arg2;
 	unsigned int triggers;
@@ -2216,7 +2216,7 @@ static void setup_sample_counters(struct comedi_device *dev,
 
 static inline unsigned int dma_transfer_size(struct comedi_device *dev)
 {
-	const struct pcidas64_board *thisboard = comedi_board(dev);
+	const struct pcidas64_board *thisboard = dev->board_ptr;
 	struct pcidas64_private *devpriv = dev->private;
 	unsigned int num_samples;
 
@@ -2303,7 +2303,7 @@ static void select_master_clock_4020(struct comedi_device *dev,
 static void select_master_clock(struct comedi_device *dev,
 				const struct comedi_cmd *cmd)
 {
-	const struct pcidas64_board *thisboard = comedi_board(dev);
+	const struct pcidas64_board *thisboard = dev->board_ptr;
 
 	switch (thisboard->layout) {
 	case LAYOUT_4020:
@@ -2335,7 +2335,7 @@ static inline void dma_start_sync(struct comedi_device *dev,
 
 static void set_ai_pacing(struct comedi_device *dev, struct comedi_cmd *cmd)
 {
-	const struct pcidas64_board *thisboard = comedi_board(dev);
+	const struct pcidas64_board *thisboard = dev->board_ptr;
 	struct pcidas64_private *devpriv = dev->private;
 	uint32_t convert_counter = 0, scan_counter = 0;
 
@@ -2384,7 +2384,7 @@ static int use_internal_queue_6xxx(const struct comedi_cmd *cmd)
 static int setup_channel_queue(struct comedi_device *dev,
 			       const struct comedi_cmd *cmd)
 {
-	const struct pcidas64_board *thisboard = comedi_board(dev);
+	const struct pcidas64_board *thisboard = dev->board_ptr;
 	struct pcidas64_private *devpriv = dev->private;
 	unsigned short bits;
 	int i;
@@ -2521,7 +2521,7 @@ static inline void load_first_dma_descriptor(struct comedi_device *dev,
 
 static int ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 {
-	const struct pcidas64_board *thisboard = comedi_board(dev);
+	const struct pcidas64_board *thisboard = dev->board_ptr;
 	struct pcidas64_private *devpriv = dev->private;
 	struct comedi_async *async = s->async;
 	struct comedi_cmd *cmd = &async->cmd;
@@ -2738,7 +2738,7 @@ static void pio_drain_ai_fifo_32(struct comedi_device *dev)
 /* empty fifo */
 static void pio_drain_ai_fifo(struct comedi_device *dev)
 {
-	const struct pcidas64_board *thisboard = comedi_board(dev);
+	const struct pcidas64_board *thisboard = dev->board_ptr;
 
 	if (thisboard->layout == LAYOUT_4020)
 		pio_drain_ai_fifo_32(dev);
@@ -2748,7 +2748,7 @@ static void pio_drain_ai_fifo(struct comedi_device *dev)
 
 static void drain_dma_buffers(struct comedi_device *dev, unsigned int channel)
 {
-	const struct pcidas64_board *thisboard = comedi_board(dev);
+	const struct pcidas64_board *thisboard = dev->board_ptr;
 	struct pcidas64_private *devpriv = dev->private;
 	struct comedi_async *async = dev->read_subdev->async;
 	struct comedi_cmd *cmd = &async->cmd;
@@ -2793,7 +2793,7 @@ static void handle_ai_interrupt(struct comedi_device *dev,
 				unsigned short status,
 				unsigned int plx_status)
 {
-	const struct pcidas64_board *thisboard = comedi_board(dev);
+	const struct pcidas64_board *thisboard = dev->board_ptr;
 	struct pcidas64_private *devpriv = dev->private;
 	struct comedi_subdevice *s = dev->read_subdev;
 	struct comedi_async *async = s->async;
@@ -3075,7 +3075,7 @@ static int ai_cancel(struct comedi_device *dev, struct comedi_subdevice *s)
 static int ao_winsn(struct comedi_device *dev, struct comedi_subdevice *s,
 		    struct comedi_insn *insn, unsigned int *data)
 {
-	const struct pcidas64_board *thisboard = comedi_board(dev);
+	const struct pcidas64_board *thisboard = dev->board_ptr;
 	struct pcidas64_private *devpriv = dev->private;
 	int chan = CR_CHAN(insn->chanspec);
 	int range = CR_RANGE(insn->chanspec);
@@ -3227,7 +3227,7 @@ static inline int external_ai_queue_in_use(struct comedi_device *dev,
 					   struct comedi_subdevice *s,
 					   struct comedi_cmd *cmd)
 {
-	const struct pcidas64_board *thisboard = comedi_board(dev);
+	const struct pcidas64_board *thisboard = dev->board_ptr;
 
 	if (s->busy)
 		return 0;
@@ -3311,7 +3311,7 @@ static int cb_pcidas64_ao_check_chanlist(struct comedi_device *dev,
 static int ao_cmdtest(struct comedi_device *dev, struct comedi_subdevice *s,
 		      struct comedi_cmd *cmd)
 {
-	const struct pcidas64_board *thisboard = comedi_board(dev);
+	const struct pcidas64_board *thisboard = dev->board_ptr;
 	int err = 0;
 	unsigned int tmp_arg;
 
@@ -3579,7 +3579,7 @@ static int caldac_i2c_write(struct comedi_device *dev,
 static void caldac_write(struct comedi_device *dev, unsigned int channel,
 			 unsigned int value)
 {
-	const struct pcidas64_board *thisboard = comedi_board(dev);
+	const struct pcidas64_board *thisboard = dev->board_ptr;
 	struct pcidas64_private *devpriv = dev->private;
 
 	devpriv->caldac_state[channel] = value;
@@ -3765,7 +3765,7 @@ static int eeprom_read_insn(struct comedi_device *dev,
  */
 static int setup_subdevices(struct comedi_device *dev)
 {
-	const struct pcidas64_board *thisboard = comedi_board(dev);
+	const struct pcidas64_board *thisboard = dev->board_ptr;
 	struct pcidas64_private *devpriv = dev->private;
 	struct comedi_subdevice *s;
 	int i;
-- 
2.1.0

