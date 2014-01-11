Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756933AbaAKEJR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 23:09:17 -0500
Received: from nm17-vm2.bullet.mail.gq1.yahoo.com ([98.137.177.226]:44969 "EHLO
	nm17-vm2.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752647AbaAKEJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 23:09:14 -0500
X-Greylist: delayed 388 seconds by postgrey-1.27 at vger.kernel.org; Fri, 10 Jan 2014 23:09:13 EST
X-Yahoo-Newman-Id: 844822.61376.bm@smtp223.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-5
X-YMail-OSG: BNuyg3YVM1mBcSXzvQcTq141v1shjnt9n5Vkukg_e0EIO8j
 2aZIJxVV9tXKh2A9i5qKpWAyJw4dhEcKKY1OnuRQwSNA.O9mlUH6Asgm6lII
 EU2hOJ7rBk2CQxeLhCSI8LkV2IXod4Yl97CRqnXMNCPWc9TaEBEF2fib09.v
 ne8CkoKzgzP37cJjr6owdIp.ue0PCJOR7_vbg7YIQJ_JxTF3K_Dw7tGcRJgT
 yJyBUIHw9l5L2t17EPS3KA8IeDK.ksAk6MGCwhxmraPRDAtDToATvribQYNB
 TRjpwobAUmMn2NZMdYuRDaQ_51ZeTPwZxHrRdnNkFCPLFcxrFJ2efDfJgRXY
 cC1kpGj8mMQOm0raieDOsji5Hq.U2YT1G.u89PJGvksgeCf62sCMrM0SLHNJ
 rmzFHujRfWYkSl43QLNbsvrjWYjr63f4g9po.ilj4ZuF5_cN67wTdzuIqSyC
 So0J1HILxbJdkZ.2pOa_P.i0Dl7TiaWqNe1g5Wk7Y0aKRej5I80qezPum6qP
 EVT6XttNFx3TEAVDaZ8LpVwwJP8l5jqFHuJ1K5HgaUNFkPdAep5B7LIdPvjX
 TSnX6PRbnwzioG_PvykeVQmE3fIfco81dxn1u1S2I8RCYuf2z
X-Yahoo-SMTP: Ua.BYCGswBCLcNpMqiQEtkMTjL08M6XQy5ZdmA--
X-Rocket-Received: from localhost.localdomain (chase.southwood@50.103.236.80 with plain [98.139.211.125])
        by smtp223.mail.gq1.yahoo.com with SMTP; 11 Jan 2014 04:02:44 +0000 UTC
From: Chase Southwood <chase.southwood@yahoo.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@yahoo.com>
Subject: [PATCH 1/3] Staging: comedi: fix numerous brace coding style issues in ni_mio_common.c.
Date: Fri, 10 Jan 2014 22:02:33 -0600
Message-Id: <1389412953-20610-1-git-send-email-chase.southwood@yahoo.com>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch for ni_mio_common.c removes many unneccesary braces to fix
checkpatch.pl warnings.

Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
---
 drivers/staging/comedi/drivers/ni_mio_common.c | 124 +++++++++----------------
 1 file changed, 43 insertions(+), 81 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_mio_common.c b/drivers/staging/comedi/drivers/ni_mio_common.c
index eb9f517..116174a 100644
--- a/drivers/staging/comedi/drivers/ni_mio_common.c
+++ b/drivers/staging/comedi/drivers/ni_mio_common.c
@@ -451,11 +451,10 @@ static inline void ni_set_gpct_dma_channel(struct comedi_device *dev,
 {
 	unsigned bitfield;
 
-	if (mite_channel >= 0) {
+	if (mite_channel >= 0)
 		bitfield = GPCT_DMA_Select_Bits(gpct_index, mite_channel);
-	} else {
+	else
 		bitfield = 0;
-	}
 	ni_set_bitfield(dev, G0_G1_Select, GPCT_DMA_Select_Mask(gpct_index),
 			bitfield);
 }
@@ -871,9 +870,8 @@ static void mite_handle_b_linkc(struct mite_struct *mite,
 	unsigned long flags;
 
 	spin_lock_irqsave(&devpriv->mite_channel_lock, flags);
-	if (devpriv->ao_mite_chan) {
+	if (devpriv->ao_mite_chan)
 		mite_sync_output_dma(devpriv->ao_mite_chan, s->async);
-	}
 	spin_unlock_irqrestore(&devpriv->mite_channel_lock, flags);
 }
 
@@ -921,9 +919,8 @@ static void ni_handle_eos(struct comedi_device *dev, struct comedi_subdevice *s)
 #endif
 	}
 	/* handle special case of single scan using AI_End_On_End_Of_Scan */
-	if ((devpriv->ai_cmd2 & AI_End_On_End_Of_Scan)) {
+	if ((devpriv->ai_cmd2 & AI_End_On_End_Of_Scan))
 		shutdown_ai_command(dev);
-	}
 }
 
 static void shutdown_ai_command(struct comedi_device *dev)
@@ -987,19 +984,15 @@ static void ack_a_interrupt(struct comedi_device *dev, unsigned short a_status)
 	struct ni_private *devpriv = dev->private;
 	unsigned short ack = 0;
 
-	if (a_status & AI_SC_TC_St) {
+	if (a_status & AI_SC_TC_St)
 		ack |= AI_SC_TC_Interrupt_Ack;
-	}
-	if (a_status & AI_START1_St) {
+	if (a_status & AI_START1_St)
 		ack |= AI_START1_Interrupt_Ack;
-	}
-	if (a_status & AI_START_St) {
+	if (a_status & AI_START_St)
 		ack |= AI_START_Interrupt_Ack;
-	}
-	if (a_status & AI_STOP_St) {
+	if (a_status & AI_STOP_St)
 		/* not sure why we used to ack the START here also, instead of doing it independently. Frank Hess 2007-07-06 */
 		ack |= AI_STOP_Interrupt_Ack /*| AI_START_Interrupt_Ack */ ;
-	}
 	if (ack)
 		devpriv->stc_writew(dev, ack, Interrupt_A_Ack_Register);
 }
@@ -1015,9 +1008,8 @@ static void handle_a_interrupt(struct comedi_device *dev, unsigned short status,
 		return;
 
 #ifdef PCIDMA
-	if (ai_mite_status & CHSR_LINKC) {
+	if (ai_mite_status & CHSR_LINKC)
 		ni_sync_ai_dma(dev);
-	}
 
 	if (ai_mite_status & ~(CHSR_INT | CHSR_LINKC | CHSR_DONE | CHSR_MRDY |
 			       CHSR_DRDY | CHSR_DRQ1 | CHSR_DRQ0 | CHSR_ERROR |
@@ -1061,9 +1053,8 @@ static void handle_a_interrupt(struct comedi_device *dev, unsigned short status,
 			return;
 		}
 		if (status & AI_SC_TC_St) {
-			if (!devpriv->ai_continuous) {
+			if (!devpriv->ai_continuous)
 				shutdown_ai_command(dev);
-			}
 		}
 	}
 #ifndef PCIDMA
@@ -1082,9 +1073,8 @@ static void handle_a_interrupt(struct comedi_device *dev, unsigned short status,
 	}
 #endif /*  !PCIDMA */
 
-	if ((status & AI_STOP_St)) {
+	if ((status & AI_STOP_St))
 		ni_handle_eos(dev, s);
-	}
 
 	ni_event(dev, s);
 }
@@ -1094,27 +1084,20 @@ static void ack_b_interrupt(struct comedi_device *dev, unsigned short b_status)
 	struct ni_private *devpriv = dev->private;
 	unsigned short ack = 0;
 
-	if (b_status & AO_BC_TC_St) {
+	if (b_status & AO_BC_TC_St)
 		ack |= AO_BC_TC_Interrupt_Ack;
-	}
-	if (b_status & AO_Overrun_St) {
+	if (b_status & AO_Overrun_St)
 		ack |= AO_Error_Interrupt_Ack;
-	}
-	if (b_status & AO_START_St) {
+	if (b_status & AO_START_St)
 		ack |= AO_START_Interrupt_Ack;
-	}
-	if (b_status & AO_START1_St) {
+	if (b_status & AO_START1_St)
 		ack |= AO_START1_Interrupt_Ack;
-	}
-	if (b_status & AO_UC_TC_St) {
+	if (b_status & AO_UC_TC_St)
 		ack |= AO_UC_TC_Interrupt_Ack;
-	}
-	if (b_status & AO_UI2_TC_St) {
+	if (b_status & AO_UI2_TC_St)
 		ack |= AO_UI2_TC_Interrupt_Ack;
-	}
-	if (b_status & AO_UPDATE_St) {
+	if (b_status & AO_UPDATE_St)
 		ack |= AO_UPDATE_Interrupt_Ack;
-	}
 	if (ack)
 		devpriv->stc_writew(dev, ack, Interrupt_B_Ack_Register);
 }
@@ -1128,9 +1111,8 @@ static void handle_b_interrupt(struct comedi_device *dev,
 
 #ifdef PCIDMA
 	/* Currently, mite.c requires us to handle LINKC */
-	if (ao_mite_status & CHSR_LINKC) {
+	if (ao_mite_status & CHSR_LINKC)
 		mite_handle_b_linkc(devpriv->mite, dev);
-	}
 
 	if (ao_mite_status & ~(CHSR_INT | CHSR_LINKC | CHSR_DONE | CHSR_MRDY |
 			       CHSR_DRDY | CHSR_DRQ1 | CHSR_DRQ0 | CHSR_ERROR |
@@ -1214,9 +1196,8 @@ static void ni_ao_fifo_load(struct comedi_device *dev,
 		chan %= cmd->chanlist_len;
 	}
 	async->cur_chan = chan;
-	if (err == 0) {
+	if (err == 0)
 		async->events |= COMEDI_CB_OVERFLOW;
-	}
 }
 
 /*
@@ -3130,11 +3111,10 @@ static int ni_ao_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	devpriv->stc_writew(dev, devpriv->ao_mode1, AO_Mode_1_Register);
 	devpriv->ao_mode2 &= ~AO_BC_Initial_Load_Source;
 	devpriv->stc_writew(dev, devpriv->ao_mode2, AO_Mode_2_Register);
-	if (cmd->stop_src == TRIG_NONE) {
+	if (cmd->stop_src == TRIG_NONE)
 		devpriv->stc_writel(dev, 0xffffff, AO_BC_Load_A_Register);
-	} else {
+	else
 		devpriv->stc_writel(dev, 0, AO_BC_Load_A_Register);
-	}
 	devpriv->stc_writew(dev, AO_BC_Load, AO_Command_1_Register);
 	devpriv->ao_mode2 &= ~AO_UC_Initial_Load_Source;
 	devpriv->stc_writew(dev, devpriv->ao_mode2, AO_Mode_2_Register);
@@ -3395,9 +3375,8 @@ static int ni_ao_reset(struct comedi_device *dev, struct comedi_subdevice *s)
 	if (board->reg_type & ni_reg_6xxx_mask) {
 		unsigned immediate_bits = 0;
 		unsigned i;
-		for (i = 0; i < s->n_chan; ++i) {
+		for (i = 0; i < s->n_chan; ++i)
 			immediate_bits |= 1 << i;
-		}
 		ao_win_out(immediate_bits, AO_Immediate_671x);
 		ao_win_out(CLEAR_WG, AO_Misc_611x);
 	}
@@ -3571,9 +3550,8 @@ static int ni_cdio_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 		return -EIO;
 	}
 	retval = ni_request_cdo_mite_channel(dev);
-	if (retval < 0) {
+	if (retval < 0)
 		return retval;
-	}
 	s->async->inttrig = &ni_cdo_inttrig;
 	return 0;
 }
@@ -3655,9 +3633,8 @@ static void handle_cdio_interrupt(struct comedi_device *dev)
 	unsigned long flags;
 #endif
 
-	if ((board->reg_type & ni_reg_m_series_mask) == 0) {
+	if ((board->reg_type & ni_reg_m_series_mask) == 0)
 		return;
-	}
 #ifdef PCIDMA
 	spin_lock_irqsave(&devpriv->mite_channel_lock, flags);
 	if (devpriv->cdo_mite_chan) {
@@ -3752,9 +3729,8 @@ static int ni_serial_insn_config(struct comedi_device *dev,
 
 	case INSN_CONFIG_BIDIRECTIONAL_DATA:
 
-		if (devpriv->serial_interval_ns == 0) {
+		if (devpriv->serial_interval_ns == 0)
 			return -EINVAL;
-		}
 
 		byte_out = data[1] & 0xFF;
 
@@ -3847,9 +3823,8 @@ static int ni_serial_sw_readwrite8(struct comedi_device *dev,
 		   because it is a per-subdevice field, and serial is
 		   a separate subdevice from DIO. */
 		devpriv->dio_output &= ~DIO_SDOUT;
-		if (data_out & mask) {
+		if (data_out & mask)
 			devpriv->dio_output |= DIO_SDOUT;
-		}
 		devpriv->stc_writew(dev, devpriv->dio_output,
 				    DIO_Output_Register);
 
@@ -3869,8 +3844,7 @@ static int ni_serial_sw_readwrite8(struct comedi_device *dev,
 
 		/* Input current bit */
 		if (devpriv->stc_readw(dev,
-				       DIO_Parallel_Input_Register) & DIO_SDIN)
-		{
+				       DIO_Parallel_Input_Register) & DIO_SDIN) {
 /*			printk("DIO_P_I_R: 0x%x\n", devpriv->stc_readw(dev, DIO_Parallel_Input_Register)); */
 			input |= mask;
 		}
@@ -3887,9 +3861,8 @@ static void mio_common_detach(struct comedi_device *dev)
 	struct ni_private *devpriv = dev->private;
 
 	if (devpriv) {
-		if (devpriv->counter_dev) {
+		if (devpriv->counter_dev)
 			ni_gpct_device_destroy(devpriv->counter_dev);
-		}
 	}
 }
 
@@ -4252,11 +4225,10 @@ static int ni_E_init(struct comedi_device *dev)
 		s->maxdata = (1 << board->aobits) - 1;
 		s->range_table = board->ao_range_table;
 		s->insn_read = &ni_ao_insn_read;
-		if (board->reg_type & ni_reg_6xxx_mask) {
+		if (board->reg_type & ni_reg_6xxx_mask)
 			s->insn_write = &ni_ao_insn_write_671x;
-		} else {
+		else
 			s->insn_write = &ni_ao_insn_write;
-		}
 		s->insn_config = &ni_ao_insn_config;
 #ifdef PCIDMA
 		if (board->n_aochan) {
@@ -4310,11 +4282,10 @@ static int ni_E_init(struct comedi_device *dev)
 
 	/* 8255 device */
 	s = &dev->subdevices[NI_8255_DIO_SUBDEV];
-	if (board->has_8255) {
+	if (board->has_8255)
 		subdev_8255_init(dev, s, ni_8255_callback, (unsigned long)dev);
-	} else {
+	else
 		s->type = COMEDI_SUBD_UNUSED;
-	}
 
 	/* formerly general purpose counter/timer device, but no longer used */
 	s = &dev->subdevices[NI_UNUSED_SUBDEV];
@@ -4372,9 +4343,8 @@ static int ni_E_init(struct comedi_device *dev)
 		s->n_chan = 10;
 	}
 	s->maxdata = 1;
-	if (board->reg_type & ni_reg_m_series_mask) {
+	if (board->reg_type & ni_reg_m_series_mask)
 		s->insn_bits = &ni_pfi_insn_bits;
-	}
 	s->insn_config = &ni_pfi_insn_config;
 	ni_set_bits(dev, IO_Bidirection_Pin_Register, ~0, 0);
 
@@ -4414,11 +4384,10 @@ static int ni_E_init(struct comedi_device *dev)
 	s->insn_config = ni_rtsi_insn_config;
 	ni_rtsi_init(dev);
 
-	if (board->reg_type & ni_reg_m_series_mask) {
+	if (board->reg_type & ni_reg_m_series_mask)
 		counter_variant = ni_gpct_variant_m_series;
-	} else {
+	else
 		counter_variant = ni_gpct_variant_e_series;
-	}
 	devpriv->counter_dev = ni_gpct_device_construct(dev,
 							&ni_gpct_write_register,
 							&ni_gpct_read_register,
@@ -4805,9 +4774,8 @@ static void caldac_setup(struct comedi_device *dev, struct comedi_subdevice *s)
 	if (diffbits) {
 		unsigned int *maxdata_list;
 
-		if (n_chans > MAX_N_CALDACS) {
+		if (n_chans > MAX_N_CALDACS)
 			printk("BUG! MAX_N_CALDACS too small\n");
-		}
 		s->maxdata_list = maxdata_list = devpriv->caldac_maxdata_list;
 		chan = 0;
 		for (i = 0; i < n_dacs; i++) {
@@ -5155,9 +5123,8 @@ static int ni_config_filter(struct comedi_device *dev, unsigned pfi_channel,
 	struct ni_private *devpriv __maybe_unused = dev->private;
 	unsigned bits;
 
-	if ((board->reg_type & ni_reg_m_series_mask) == 0) {
+	if ((board->reg_type & ni_reg_m_series_mask) == 0)
 		return -ENOTSUPP;
-	}
 	bits = ni_readl(M_Offset_PFI_Filter);
 	bits &= ~MSeries_PFI_Filter_Select_Mask(pfi_channel);
 	bits |= MSeries_PFI_Filter_Select_Bits(pfi_channel, filter);
@@ -5238,9 +5205,8 @@ static void ni_rtsi_init(struct comedi_device *dev)
 
 	/*  Set clock mode to internal */
 	devpriv->clock_and_fout2 = MSeries_RTSI_10MHz_Bit;
-	if (ni_set_master_clock(dev, NI_MIO_INTERNAL_CLOCK, 0) < 0) {
+	if (ni_set_master_clock(dev, NI_MIO_INTERNAL_CLOCK, 0) < 0)
 		printk("ni_set_master_clock failed, bug?");
-	}
 	/*  default internal lines routing to RTSI bus lines */
 	devpriv->rtsi_trig_a_output_reg =
 	    RTSI_Trig_Output_Bits(0,
@@ -5423,9 +5389,8 @@ static int ni_mseries_set_pll_master_clock(struct comedi_device *dev,
 	devpriv->clock_source = source;
 	/* it seems to typically take a few hundred microseconds for PLL to lock */
 	for (i = 0; i < timeout; ++i) {
-		if (ni_readw(M_Offset_PLL_Status) & MSeries_PLL_Locked_Bit) {
+		if (ni_readw(M_Offset_PLL_Status) & MSeries_PLL_Locked_Bit)
 			break;
-		}
 		udelay(1);
 	}
 	if (i == timeout) {
@@ -5647,13 +5612,11 @@ static int cs5529_wait_for_idle(struct comedi_device *dev)
 
 	for (i = 0; i < timeout; i++) {
 		status = ni_ao_win_inw(dev, CAL_ADC_Status_67xx);
-		if ((status & CSS_ADC_BUSY) == 0) {
+		if ((status & CSS_ADC_BUSY) == 0)
 			break;
-		}
 		set_current_state(TASK_INTERRUPTIBLE);
-		if (schedule_timeout(1)) {
+		if (schedule_timeout(1))
 			return -EIO;
-		}
 	}
 /* printk("looped %i times waiting for idle\n", i); */
 	if (i == timeout) {
@@ -5679,9 +5642,8 @@ static void cs5529_command(struct comedi_device *dev, unsigned short value)
 		udelay(1);
 	}
 /* printk("looped %i times writing command to cs5529\n", i); */
-	if (i == timeout) {
+	if (i == timeout)
 		comedi_error(dev, "possible problem - never saw adc go busy?");
-	}
 }
 
 /* write to cs5529 register */
-- 
1.8.4.2

