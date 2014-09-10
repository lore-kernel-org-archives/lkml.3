Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751606AbaIJGD5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 02:03:57 -0400
Received: from mail-ig0-f174.google.com ([209.85.213.174]:63547 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260AbaIJGDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 02:03:55 -0400
From: Chase Southwood <chase.southwood@gmail.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@gmail.com>
Subject: [PATCH 1/4] staging: comedi: hwdrv_apci3120: clean up comments
Date: Wed, 10 Sep 2014 01:03:44 -0500
Message-Id: <658e267ed27bc964bec53b19c3c99cc863a9cfa1.1409983606.git.chase.southwood@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1409983606.git.chase.southwood@gmail.com>
References: <cover.1409983606.git.chase.southwood@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes improper comment indentation, removes dead code and
obsolete comments, and conforms remaining comments to a consistent kernel
commenting style.

Signed-off-by: Chase Southwood <chase.southwood@gmail.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
---
 .../comedi/drivers/addi-data/hwdrv_apci3120.c      | 364 +++++++--------------
 1 file changed, 117 insertions(+), 247 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3120.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3120.c
index 77cee87..bdb527f 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3120.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3120.c
@@ -241,13 +241,6 @@ static const struct comedi_lrange range_apci3120_ao = {
 
 
 /* FUNCTION DEFINITIONS */
-
-/*
-+----------------------------------------------------------------------------+
-|                           ANALOG INPUT SUBDEVICE   		                 |
-+----------------------------------------------------------------------------+
-*/
-
 static int apci3120_ai_insn_config(struct comedi_device *dev,
 				   struct comedi_subdevice *s,
 				   struct comedi_insn *insn,
@@ -260,7 +253,7 @@ static int apci3120_ai_insn_config(struct comedi_device *dev,
 	if ((data[0] != APCI3120_EOC_MODE) && (data[0] != APCI3120_EOS_MODE))
 		return -1;
 
-	/*  Check for Conversion time to be added ?? */
+	/*  Check for Conversion time to be added */
 	devpriv->ui_EocEosConversionTime = data[2];
 
 	if (data[0] == APCI3120_EOS_MODE) {
@@ -282,7 +275,6 @@ static int apci3120_ai_insn_config(struct comedi_device *dev,
 		else
 			devpriv->b_EocEosInterrupt = APCI3120_DISABLE;
 		/*  Copy channel list and Range List to devpriv */
-
 		devpriv->ui_AiNbrofChannels = data[3];
 		for (i = 0; i < devpriv->ui_AiNbrofChannels; i++)
 			devpriv->ui_AiChannelList[i] = data[4 + i];
@@ -311,7 +303,7 @@ static int apci3120_setup_chan_list(struct comedi_device *dev,
 				    char check)
 {
 	struct addi_private *devpriv = dev->private;
-	unsigned int i;		/* , differencial=0, bipolar=0; */
+	unsigned int i;
 	unsigned int gain;
 	unsigned short us_TmpValue;
 
@@ -326,7 +318,7 @@ static int apci3120_setup_chan_list(struct comedi_device *dev,
 	if (check)
 		return 1;
 
-	/* Code  to set the PA and PR...Here it set PA to 0.. */
+	/* Code  to set the PA and PR...Here it set PA to 0 */
 	devpriv->us_OutputRegister =
 		devpriv->us_OutputRegister & APCI3120_CLEAR_PA_PR;
 	devpriv->us_OutputRegister = ((n_chan - 1) & 0xf) << 8;
@@ -334,16 +326,16 @@ static int apci3120_setup_chan_list(struct comedi_device *dev,
 
 	for (i = 0; i < n_chan; i++) {
 		/*  store range list to card */
-		us_TmpValue = CR_CHAN(chanlist[i]);	/*  get channel number; */
+		us_TmpValue = CR_CHAN(chanlist[i]);	/*  get channel number */
 
 		if (CR_RANGE(chanlist[i]) < APCI3120_BIPOLAR_RANGES)
 			us_TmpValue &= ((~APCI3120_UNIPOLAR) & 0xff);	/*  set bipolar */
 		else
-			us_TmpValue |= APCI3120_UNIPOLAR;	/*  enable unipolar...... */
+			us_TmpValue |= APCI3120_UNIPOLAR;	/*  enable unipolar */
 
 		gain = CR_RANGE(chanlist[i]);	/*  get gain number */
 		us_TmpValue |= ((gain & 0x03) << 4);	/* <<4 for G0 and G1 bit in RAM */
-		us_TmpValue |= i << 8;	/* To select the RAM LOCATION.... */
+		us_TmpValue |= i << 8;	/* To select the RAM LOCATION */
 		outw(us_TmpValue, dev->iobase + APCI3120_SEQ_RAM_ADDRESS);
 	}
 	return 1;		/*  we can serve this with scan logic */
@@ -370,24 +362,21 @@ static int apci3120_ai_insn_read(struct comedi_device *dev,
 	else
 		us_ConvertTiming = (unsigned short) (devpriv->ui_EocEosConversionTime / 1000);	/*  nano to useconds */
 
-	/*  this_board->ai_read(dev,us_ConvertTiming,insn->n,&insn->chanspec,data,insn->unused[0]); */
-
 	/*  Clear software registers */
 	devpriv->b_TimerSelectMode = 0;
 	devpriv->b_ModeSelectRegister = 0;
 	devpriv->us_OutputRegister = 0;
-/* devpriv->b_DigitalOutputRegister=0; */
 
 	if (insn->unused[0] == 222) {	/*  second insn read */
 		for (i = 0; i < insn->n; i++)
 			data[i] = devpriv->ui_AiReadData[i];
 	} else {
 		devpriv->tsk_Current = current;	/*  Save the current process task structure */
-/*
- * Testing if board have the new Quartz and calculate the time value
- * to set in the timer
- */
 
+		/*
+		 * Testing if board have the new Quartz and calculate the time value
+		 * to set in the timer
+		 */
 		us_TmpValue =
 			(unsigned short) inw(devpriv->iobase + APCI3120_RD_STATUS);
 
@@ -406,9 +395,9 @@ static int apci3120_ai_insn_read(struct comedi_device *dev,
 
 		case APCI3120_EOC_MODE:
 
-/*
- * Testing the interrupt flag and set the EOC bit Clears the FIFO
- */
+			/*
+			 * Testing the interrupt flag and set the EOC bit Clears the FIFO
+			 */
 			inw(devpriv->iobase + APCI3120_RESET_FIFO);
 
 			/*  Initialize the sequence array */
@@ -556,7 +545,6 @@ static int apci3120_ai_insn_read(struct comedi_device *dev,
 			inw(devpriv->iobase + APCI3120_RD_STATUS);
 
 			/* Sets gate 0 */
-
 			devpriv->us_OutputRegister =
 				devpriv->
 				us_OutputRegister | APCI3120_ENABLE_TIMER0;
@@ -583,7 +571,7 @@ static int apci3120_ai_insn_read(struct comedi_device *dev,
 					data[i] = (unsigned int) us_TmpValue;
 				}
 
-				devpriv->b_InterruptMode = APCI3120_EOC_MODE;	/*  Restore defaults. */
+				devpriv->b_InterruptMode = APCI3120_EOC_MODE;	/*  Restore defaults */
 			}
 			break;
 
@@ -591,7 +579,7 @@ static int apci3120_ai_insn_read(struct comedi_device *dev,
 			dev_err(dev->class_dev, "inputs wrong\n");
 
 		}
-		devpriv->ui_EocEosConversionTime = 0;	/*  re initializing the variable; */
+		devpriv->ui_EocEosConversionTime = 0;	/*  re initializing the variable */
 	}
 
 	return insn->n;
@@ -623,10 +611,10 @@ static int apci3120_reset(struct comedi_device *dev)
 	devpriv->us_OutputRegister = 0;
 	outw(devpriv->us_OutputRegister, dev->iobase + APCI3120_WR_ADDRESS);
 
-/*
- * Code to set the all anolog o/p channel to 0v 8191 is decimal
- * value for zero(0 v)volt in bipolar mode(default)
- */
+	/*
+	 * Code to set the all anolog o/p channel to 0v 8191 is decimal
+	 * value for zero(0 v)volt in bipolar mode(default)
+	 */
 	outw(8191 | APCI3120_ANALOG_OP_CHANNEL_1, dev->iobase + APCI3120_ANALOG_OUTPUT_1);	/* channel 1 */
 	outw(8191 | APCI3120_ANALOG_OP_CHANNEL_2, dev->iobase + APCI3120_ANALOG_OUTPUT_1);	/* channel 2 */
 	outw(8191 | APCI3120_ANALOG_OP_CHANNEL_3, dev->iobase + APCI3120_ANALOG_OUTPUT_1);	/* channel 3 */
@@ -637,9 +625,6 @@ static int apci3120_reset(struct comedi_device *dev)
 	outw(8191 | APCI3120_ANALOG_OP_CHANNEL_7, dev->iobase + APCI3120_ANALOG_OUTPUT_2);	/* channel 7 */
 	outw(8191 | APCI3120_ANALOG_OP_CHANNEL_8, dev->iobase + APCI3120_ANALOG_OUTPUT_2);	/* channel 8 */
 
-	/*   Reset digital output to L0W */
-
-/* ES05  outb(0x0,dev->iobase+APCI3120_DIGITAL_OUTPUT); */
 	udelay(10);
 
 	inw(dev->iobase + 0);	/* make a dummy read */
@@ -689,12 +674,6 @@ static int apci3120_cancel(struct comedi_device *dev,
 	/* Disable BUS Master PCI */
 	outl(0, devpriv->i_IobaseAmcc + AMCC_OP_REG_MCSR);
 
-	/* outl(inl(devpriv->i_IobaseAmcc+AMCC_OP_REG_INTCSR)&(~AINT_WRITE_COMPL),
-	 * devpriv->i_IobaseAmcc+AMCC_OP_REG_INTCSR);  stop amcc irqs */
-
-	/* outl(inl(devpriv->i_IobaseAmcc+AMCC_OP_REG_MCSR)&(~EN_A2P_TRANSFERS),
-	 * devpriv->i_IobaseAmcc+AMCC_OP_REG_MCSR);  stop DMA */
-
 	/* Disable ext trigger */
 	apci3120_exttrig_disable(dev);
 
@@ -811,53 +790,29 @@ static int apci3120_cyclic_ai(int mode,
 		0, ui_TimerValue0, ui_ConvertTiming;
 	unsigned short us_TmpValue;
 
-	/*******************/
 	/* Resets the FIFO */
-	/*******************/
 	inb(dev->iobase + APCI3120_RESET_FIFO);
 
-	/* BEGIN JK 07.05.04: Comparison between WIN32 and Linux driver */
-	/* inw(dev->iobase+APCI3120_RD_STATUS); */
-	/* END JK 07.05.04: Comparison between WIN32 and Linux driver */
-
 	devpriv->ai_running = 1;
 
 	/*  clear software  registers */
 	devpriv->b_TimerSelectMode = 0;
 	devpriv->us_OutputRegister = 0;
 	devpriv->b_ModeSelectRegister = 0;
-	/* devpriv->b_DigitalOutputRegister=0; */
-
-	/* COMMENT JK 07.05.04: Followings calls are in i_APCI3120_StartAnalogInputAcquisition */
 
-	/****************************/
 	/* Clear Timer Write TC int */
-	/****************************/
 	outl(APCI3120_CLEAR_WRITE_TC_INT,
 		devpriv->i_IobaseAmcc + APCI3120_AMCC_OP_REG_INTCSR);
 
-	/************************************/
-	/* Clears the timer status register */
-	/************************************/
-
-	/* BEGIN JK 07.05.04: Comparison between WIN32 and Linux driver */
-	/* inw(dev->iobase+APCI3120_TIMER_STATUS_REGISTER); */
-	/* inb(dev->iobase + APCI3120_TIMER_STATUS_REGISTER); */
-	/* END JK 07.05.04: Comparison between WIN32 and Linux driver */
-
-	/**************************/
 	/* Disables All Timer     */
 	/* Sets PR and PA to 0    */
-	/**************************/
 	devpriv->us_OutputRegister = devpriv->us_OutputRegister &
 		APCI3120_DISABLE_TIMER0 &
 		APCI3120_DISABLE_TIMER1 & APCI3120_CLEAR_PA_PR;
 
 	outw(devpriv->us_OutputRegister, dev->iobase + APCI3120_WR_ADDRESS);
 
-	/*******************/
 	/* Resets the FIFO */
-	/*******************/
 	/* BEGIN JK 07.05.04: Comparison between WIN32 and Linux driver */
 	inb(devpriv->iobase + APCI3120_RESET_FIFO);
 	/* END JK 07.05.04: Comparison between WIN32 and Linux driver */
@@ -866,44 +821,21 @@ static int apci3120_cyclic_ai(int mode,
 	s->async->cur_chan = 0;
 	devpriv->ui_DmaActualBuffer = 0;
 
-	/*  value for timer2  minus -2 has to be done .....dunno y?? */
+	/* value for timer2  minus -2 has to be done */
 	ui_TimerValue2 = cmd->stop_arg - 2;
 	ui_ConvertTiming = cmd->convert_arg;
 
 	if (mode == 2)
 		ui_DelayTiming = cmd->scan_begin_arg;
 
-   /**********************************/
 	/* Initializes the sequence array */
-   /**********************************/
 	if (!apci3120_setup_chan_list(dev, s, devpriv->ui_AiNbrofChannels,
 			cmd->chanlist, 0))
 		return -EINVAL;
 
 	us_TmpValue = (unsigned short) inw(dev->iobase + APCI3120_RD_STATUS);
-/*** EL241003 : add this section in comment because floats must not be used
-	if((us_TmpValue & 0x00B0)==0x00B0)
-	 {
-		f_ConvertValue=(((float)ui_ConvertTiming * 0.002) - 2);
-		ui_TimerValue0=(unsigned int)f_ConvertValue;
-		if (mode==2)
-		{
-			f_DelayValue     = (((float)ui_DelayTiming * 0.00002) - 2);
-			ui_TimerValue1  =   (unsigned int) f_DelayValue;
-		}
-	 }
-	else
-	 {
-		f_ConvertValue=(((float)ui_ConvertTiming * 0.0012926) - 1);
-		ui_TimerValue0=(unsigned int)f_ConvertValue;
-		if (mode == 2)
-		{
-		     f_DelayValue     = (((float)ui_DelayTiming * 0.000012926) - 1);
-		     ui_TimerValue1  =   (unsigned int) f_DelayValue;
-		}
-	}
-***********************************************************************************************/
-/*** EL241003 Begin : add this section to replace floats calculation by integer calculations **/
+
+	/* EL241003 Begin: add this section to replace floats calculation by integer calculations */
 	/* EL250804: Testing if board APCI3120 have the new Quartz or if it is an APCI3001 */
 	if ((us_TmpValue & 0x00B0) == 0x00B0
 		|| !strcmp(this_board->pc_DriverName, "apci3001")) {
@@ -926,7 +858,7 @@ static int apci3120_cyclic_ai(int mode,
 			ui_TimerValue1 = ui_TimerValue1 / 1000000;
 		}
 	}
-/*** EL241003 End ******************************************************************************/
+	/* EL241003 End */
 
 	if (devpriv->b_ExttrigEnable == APCI3120_ENABLE)
 		apci3120_exttrig_enable(dev);	/*  activate EXT trigger */
@@ -985,15 +917,8 @@ static int apci3120_cyclic_ai(int mode,
 		break;
 
 	}
-	/*    ##########common for all modes################# */
-
-	/***********************/
-	/* Clears the SCAN bit */
-	/***********************/
-
+	/* common for all modes */
 	/* BEGIN JK 07.05.04: Comparison between WIN32 and Linux driver */
-	/* devpriv->b_ModeSelectRegister=devpriv->b_ModeSelectRegister | APCI3120_DISABLE_SCAN; */
-
 	devpriv->b_ModeSelectRegister = devpriv->b_ModeSelectRegister &
 		APCI3120_DISABLE_SCAN;
 	/* END JK 07.05.04: Comparison between WIN32 and Linux driver */
@@ -1015,10 +940,10 @@ static int apci3120_cyclic_ai(int mode,
 			dev->iobase + APCI3120_WRITE_MODE_SELECT);
 
 		if (cmd->stop_src == TRIG_COUNT) {
-/*
- * configure Timer2 For counting EOS Reset gate 2 of Timer 2 to
- * disable it (Set Bit D14 to 0)
- */
+			/*
+			 * configure Timer2 For counting EOS Reset gate 2 of Timer 2 to
+			 * disable it (Set Bit D14 to 0)
+			 */
 			devpriv->us_OutputRegister =
 				devpriv->
 				us_OutputRegister & APCI3120_DISABLE_TIMER2;
@@ -1083,15 +1008,9 @@ static int apci3120_cyclic_ai(int mode,
 	} else {
 		/* If DMA Enabled */
 		unsigned int scan_bytes = cmd->scan_end_arg * sizeof(short);
-
-		/* BEGIN JK 07.05.04: Comparison between WIN32 and Linux driver */
-		/* inw(dev->iobase+0); reset EOC bit */
-		/* END JK 07.05.04: Comparison between WIN32 and Linux driver */
 		devpriv->b_InterruptMode = APCI3120_DMA_MODE;
 
-		/************************************/
 		/* Disables the EOC, EOS interrupt  */
-		/************************************/
 		devpriv->b_ModeSelectRegister = devpriv->b_ModeSelectRegister &
 			APCI3120_DISABLE_EOC_INT & APCI3120_DISABLE_EOS_INT;
 
@@ -1139,17 +1058,15 @@ static int apci3120_cyclic_ai(int mode,
 
 		/* Initialize DMA */
 
-/*
- * Set Transfer count enable bit and A2P_fifo reset bit in AGCSTS
- * register 1
- */
+		/*
+		 * Set Transfer count enable bit and A2P_fifo reset bit in AGCSTS
+		 * register 1
+		 */
 		ui_Tmp = AGCSTS_TC_ENABLE | AGCSTS_RESET_A2P_FIFO;
 		outl(ui_Tmp, devpriv->i_IobaseAmcc + AMCC_OP_REG_AGCSTS);
 
 		/*  changed  since 16 bit interface for add on */
-		/*********************/
 		/* ENABLE BUS MASTER */
-		/*********************/
 		outw(APCI3120_ADD_ON_AGCSTS_LOW, devpriv->i_IobaseAddon + 0);
 		outw(APCI3120_ENABLE_TRANSFER_ADD_ON_LOW,
 			devpriv->i_IobaseAddon + 2);
@@ -1158,112 +1075,88 @@ static int apci3120_cyclic_ai(int mode,
 		outw(APCI3120_ENABLE_TRANSFER_ADD_ON_HIGH,
 			devpriv->i_IobaseAddon + 2);
 
-/*
- * TO VERIFIED BEGIN JK 07.05.04: Comparison between WIN32 and Linux
- * driver
- */
+		/*
+		 * TO VERIFIED BEGIN JK 07.05.04: Comparison between WIN32 and Linux
+		 * driver
+		 */
 		outw(0x1000, devpriv->i_IobaseAddon + 2);
 		/* END JK 07.05.04: Comparison between WIN32 and Linux driver */
 
 		/* 2 No change */
 		/* A2P FIFO MANAGEMENT */
 		/* A2P fifo reset & transfer control enable */
-
-		/***********************/
-		/* A2P FIFO MANAGEMENT */
-		/***********************/
 		outl(APCI3120_A2P_FIFO_MANAGEMENT, devpriv->i_IobaseAmcc +
 			APCI3120_AMCC_OP_MCSR);
 
-/*
- * 3
- * beginning address of dma buf The 32 bit address of dma buffer
- * is converted into two 16 bit addresses Can done by using _attach
- * and put into into an array array used may be for differnet pages
- */
+		/*
+		 * 3
+		 * beginning address of dma buf The 32 bit address of dma buffer
+		 * is converted into two 16 bit addresses Can done by using _attach
+		 * and put into into an array array used may be for differnet pages
+		 */
 
 		/*  DMA Start Address Low */
 		outw(APCI3120_ADD_ON_MWAR_LOW, devpriv->i_IobaseAddon + 0);
 		outw((devpriv->ul_DmaBufferHw[0] & 0xFFFF),
 			devpriv->i_IobaseAddon + 2);
 
-		/*************************/
 		/* DMA Start Address High */
-		/*************************/
 		outw(APCI3120_ADD_ON_MWAR_HIGH, devpriv->i_IobaseAddon + 0);
 		outw((devpriv->ul_DmaBufferHw[0] / 65536),
 			devpriv->i_IobaseAddon + 2);
 
-/*
- * 4
- * amount of bytes to be transferred set transfer count used ADDON
- * MWTC register commented testing
- * outl(devpriv->ui_DmaBufferUsesize[0],
- * devpriv->i_IobaseAddon+AMCC_OP_REG_AMWTC);
- */
+		/*
+		 * 4
+		 * amount of bytes to be transferred set transfer count used ADDON
+		 * MWTC register commented testing
+		 */
 
-		/**************************/
 		/* Nbr of acquisition LOW */
-		/**************************/
 		outw(APCI3120_ADD_ON_MWTC_LOW, devpriv->i_IobaseAddon + 0);
 		outw((devpriv->ui_DmaBufferUsesize[0] & 0xFFFF),
 			devpriv->i_IobaseAddon + 2);
 
-		/***************************/
 		/* Nbr of acquisition HIGH */
-		/***************************/
 		outw(APCI3120_ADD_ON_MWTC_HIGH, devpriv->i_IobaseAddon + 0);
 		outw((devpriv->ui_DmaBufferUsesize[0] / 65536),
 			devpriv->i_IobaseAddon + 2);
 
-/*
- * 5
- * To configure A2P FIFO testing outl(
- * FIFO_ADVANCE_ON_BYTE_2,devpriv->i_IobaseAmcc+AMCC_OP_REG_INTCSR);
- */
+		/*
+		 * 5
+		 * To configure A2P FIFO testing outl(
+		 * FIFO_ADVANCE_ON_BYTE_2,devpriv->i_IobaseAmcc+AMCC_OP_REG_INTCSR);
+		 */
 
-		/******************/
 		/* A2P FIFO RESET */
-		/******************/
-/*
- * TO VERIFY BEGIN JK 07.05.04: Comparison between WIN32 and Linux
- * driver
- */
+		/*
+		 * TO VERIFY BEGIN JK 07.05.04: Comparison between WIN32 and Linux
+		 * driver
+		 */
 		outl(0x04000000UL, devpriv->i_IobaseAmcc + AMCC_OP_REG_MCSR);
 		/* END JK 07.05.04: Comparison between WIN32 and Linux driver */
 
-/*
- * 6
- * ENABLE A2P FIFO WRITE AND ENABLE AMWEN AMWEN_ENABLE |
- * A2P_FIFO_WRITE_ENABLE (0x01|0x02)=0x03
- */
-
-		/* BEGIN JK 07.05.04: Comparison between WIN32 and Linux driver */
-		/* outw(3,devpriv->i_IobaseAddon + 4); */
-		/* END JK 07.05.04: Comparison between WIN32 and Linux driver */
-
-/*
- * 7
- * initialise end of dma interrupt AINT_WRITE_COMPL =
- * ENABLE_WRITE_TC_INT(ADDI)
- */
-		/***************************************************/
+		/*
+		 * 6
+		 * ENABLE A2P FIFO WRITE AND ENABLE AMWEN AMWEN_ENABLE |
+		 * A2P_FIFO_WRITE_ENABLE (0x01|0x02)=0x03
+		 */
+
+		/*
+		 * 7
+		 * initialise end of dma interrupt AINT_WRITE_COMPL =
+		 * ENABLE_WRITE_TC_INT(ADDI)
+		 */
 		/* A2P FIFO CONFIGURATE, END OF DMA intERRUPT INIT */
-		/***************************************************/
 		outl((APCI3120_FIFO_ADVANCE_ON_BYTE_2 |
 				APCI3120_ENABLE_WRITE_TC_INT),
 			devpriv->i_IobaseAmcc + AMCC_OP_REG_INTCSR);
 
 		/* BEGIN JK 07.05.04: Comparison between WIN32 and Linux driver */
-		/******************************************/
 		/* ENABLE A2P FIFO WRITE AND ENABLE AMWEN */
-		/******************************************/
 		outw(3, devpriv->i_IobaseAddon + 4);
 		/* END JK 07.05.04: Comparison between WIN32 and Linux driver */
 
-		/******************/
 		/* A2P FIFO RESET */
-		/******************/
 		/* BEGIN JK 07.05.04: Comparison between WIN32 and Linux driver */
 		outl(0x04000000UL,
 			devpriv->i_IobaseAmcc + APCI3120_AMCC_OP_MCSR);
@@ -1416,11 +1309,11 @@ static void apci3120_interrupt_dma(int irq, void *d)
 		outw(APCI3120_ADD_ON_MWTC_HIGH, devpriv->i_IobaseAddon + 0);
 		outw(high_word, devpriv->i_IobaseAddon + 2);
 
-/*
- * To configure A2P FIFO
- * ENABLE A2P FIFO WRITE AND ENABLE AMWEN
- * AMWEN_ENABLE | A2P_FIFO_WRITE_ENABLE (0x01|0x02)=0x03
- */
+		/*
+		 * To configure A2P FIFO
+		 * ENABLE A2P FIFO WRITE AND ENABLE AMWEN
+		 * AMWEN_ENABLE | A2P_FIFO_WRITE_ENABLE (0x01|0x02)=0x03
+		 */
 		outw(3, devpriv->i_IobaseAddon + 4);
 		/* initialise end of dma interrupt  AINT_WRITE_COMPL = ENABLE_WRITE_TC_INT(ADDI) */
 		outl((APCI3120_FIFO_ADVANCE_ON_BYTE_2 |
@@ -1450,10 +1343,10 @@ static void apci3120_interrupt_dma(int irq, void *d)
 	if (devpriv->b_DmaDoubleBuffer) {	/*  switch dma buffers */
 		devpriv->ui_DmaActualBuffer = 1 - devpriv->ui_DmaActualBuffer;
 	} else {
-/*
- * restart DMA if is not used double buffering
- * ADDED REINITIALISE THE DMA
- */
+		/*
+		 * restart DMA if is not used double buffering
+		 * ADDED REINITIALISE THE DMA
+		 */
 		ui_Tmp = AGCSTS_TC_ENABLE | AGCSTS_RESET_A2P_FIFO;
 		outl(ui_Tmp, devpriv->i_IobaseAddon + AMCC_OP_REG_AGCSTS);
 
@@ -1462,11 +1355,11 @@ static void apci3120_interrupt_dma(int irq, void *d)
 		outw(APCI3120_ENABLE_TRANSFER_ADD_ON_LOW,
 			devpriv->i_IobaseAddon + 2);
 		outw(APCI3120_ADD_ON_AGCSTS_HIGH, devpriv->i_IobaseAddon + 0);
-		outw(APCI3120_ENABLE_TRANSFER_ADD_ON_HIGH, devpriv->i_IobaseAddon + 2);	/*  */
-/*
- * A2P FIFO MANAGEMENT
- * A2P fifo reset & transfer control enable
- */
+		outw(APCI3120_ENABLE_TRANSFER_ADD_ON_HIGH, devpriv->i_IobaseAddon + 2);
+		/*
+		 * A2P FIFO MANAGEMENT
+		 * A2P fifo reset & transfer control enable
+		 */
 		outl(APCI3120_A2P_FIFO_MANAGEMENT,
 			devpriv->i_IobaseAmcc + AMCC_OP_REG_MCSR);
 
@@ -1488,11 +1381,11 @@ static void apci3120_interrupt_dma(int irq, void *d)
 		outw(APCI3120_ADD_ON_MWTC_HIGH, devpriv->i_IobaseAddon + 0);
 		outw(high_word, devpriv->i_IobaseAddon + 2);
 
-/*
- * To configure A2P FIFO
- * ENABLE A2P FIFO WRITE AND ENABLE AMWEN
- * AMWEN_ENABLE | A2P_FIFO_WRITE_ENABLE (0x01|0x02)=0x03
- */
+		/*
+		 * To configure A2P FIFO
+		 * ENABLE A2P FIFO WRITE AND ENABLE AMWEN
+		 * AMWEN_ENABLE | A2P_FIFO_WRITE_ENABLE (0x01|0x02)=0x03
+		 */
 		outw(3, devpriv->i_IobaseAddon + 4);
 		/* initialise end of dma interrupt  AINT_WRITE_COMPL = ENABLE_WRITE_TC_INT(ADDI) */
 		outl((APCI3120_FIFO_ADVANCE_ON_BYTE_2 |
@@ -1570,7 +1463,6 @@ static void apci3120_interrupt(int irq, void *d)
 		if (devpriv->b_EocEosInterrupt == APCI3120_ENABLE) {
 
 			/*  Read the AI Value */
-
 			devpriv->ui_AiReadData[0] =
 				(unsigned int) inw(devpriv->iobase + 0);
 			devpriv->b_EocEosInterrupt = APCI3120_DISABLE;
@@ -1670,7 +1562,6 @@ static void apci3120_interrupt(int irq, void *d)
 		default:
 
 			/*  disable Timer Interrupt */
-
 			devpriv->b_ModeSelectRegister =
 				devpriv->
 				b_ModeSelectRegister &
@@ -1688,17 +1579,12 @@ static void apci3120_interrupt(int irq, void *d)
 	if ((int_daq & 0x4) && (devpriv->b_InterruptMode == APCI3120_DMA_MODE)) {
 		if (devpriv->ai_running) {
 
-			/****************************/
 			/* Clear Timer Write TC int */
-			/****************************/
-
 			outl(APCI3120_CLEAR_WRITE_TC_INT,
 				devpriv->i_IobaseAmcc +
 				APCI3120_AMCC_OP_REG_INTCSR);
 
-			/************************************/
 			/* Clears the timer status register */
-			/************************************/
 			inw(dev->iobase + APCI3120_TIMER_STATUS_REGISTER);
 			/* do some data transfer */
 			apci3120_interrupt_dma(irq, d);
@@ -1741,13 +1627,12 @@ static int apci3120_config_insn_timer(struct comedi_device *dev,
 
 	ui_Timervalue2 = data[1] / 1000;	/*  convert nano seconds  to u seconds */
 
-	/* this_board->timer_config(dev, ui_Timervalue2,(unsigned char)data[0]); */
 	us_TmpValue = (unsigned short) inw(devpriv->iobase + APCI3120_RD_STATUS);
 
-/*
- * EL250804: Testing if board APCI3120 have the new Quartz or if it
- * is an APCI3001 and calculate the time value to set in the timer
- */
+	/*
+	 * EL250804: Testing if board APCI3120 have the new Quartz or if it
+	 * is an APCI3001 and calculate the time value to set in the timer
+	 */
 	if ((us_TmpValue & 0x00B0) == 0x00B0
 		|| !strcmp(this_board->pc_DriverName, "apci3001")) {
 		/* Calculate the time value to set in the timer */
@@ -1775,11 +1660,6 @@ static int apci3120_config_insn_timer(struct comedi_device *dev,
 	outb(devpriv->b_ModeSelectRegister,
 		devpriv->iobase + APCI3120_WRITE_MODE_SELECT);
 	if (data[0] == APCI3120_TIMER) {	/* initialize timer */
-		/* devpriv->b_ModeSelectRegister=devpriv->b_ModeSelectRegister |
-		 * APCI3120_ENABLE_TIMER_INT; */
-
-		/* outb(devpriv->b_ModeSelectRegister,devpriv->iobase+APCI3120_WRITE_MODE_SELECT); */
-
 		/* Set the Timer 2 in mode 2(Timer) */
 		devpriv->b_TimerSelectMode =
 			(devpriv->
@@ -1787,13 +1667,13 @@ static int apci3120_config_insn_timer(struct comedi_device *dev,
 		outb(devpriv->b_TimerSelectMode,
 			devpriv->iobase + APCI3120_TIMER_CRT1);
 
-/*
- * Configure the timer 2 for writing the LOW unsigned short of timer
- * is Delay value You must make a b_tmp variable with
- * DigitalOutPutRegister because at Address_1+APCI3120_TIMER_CRT0
- * you can set the digital output and configure the timer 2,and if
- * you don't make this, digital output are erase (Set to 0)
- */
+		/*
+		 * Configure the timer 2 for writing the LOW unsigned short of timer
+		 * is Delay value You must make a b_tmp variable with
+		 * DigitalOutPutRegister because at Address_1+APCI3120_TIMER_CRT0
+		 * you can set the digital output and configure the timer 2,and if
+		 * you don't make this, digital output are erase (Set to 0)
+		 */
 
 		/* Writing LOW unsigned short */
 		b_Tmp = ((devpriv->
@@ -1816,20 +1696,19 @@ static int apci3120_config_insn_timer(struct comedi_device *dev,
 	} else {			/*  Initialize Watch dog */
 
 		/* Set the Timer 2 in mode 5(Watchdog) */
-
 		devpriv->b_TimerSelectMode =
 			(devpriv->
 			b_TimerSelectMode & 0x0F) | APCI3120_TIMER_2_MODE_5;
 		outb(devpriv->b_TimerSelectMode,
 			devpriv->iobase + APCI3120_TIMER_CRT1);
 
-/*
- * Configure the timer 2 for writing the LOW unsigned short of timer
- * is Delay value You must make a b_tmp variable with
- * DigitalOutPutRegister because at Address_1+APCI3120_TIMER_CRT0
- * you can set the digital output and configure the timer 2,and if
- * you don't make this, digital output are erase (Set to 0)
- */
+		/*
+		 * Configure the timer 2 for writing the LOW unsigned short of timer
+		 * is Delay value You must make a b_tmp variable with
+		 * DigitalOutPutRegister because at Address_1+APCI3120_TIMER_CRT0
+		 * you can set the digital output and configure the timer 2,and if
+		 * you don't make this, digital output are erase (Set to 0)
+		 */
 
 		/* Writing LOW unsigned short */
 		b_Tmp = ((devpriv->
@@ -1898,8 +1777,6 @@ static int apci3120_write_insn_timer(struct comedi_device *dev,
 			ui_Timervalue2 = 0;
 	}
 
-	/* this_board->timer_write(dev,data[0],ui_Timervalue2); */
-
 	switch (data[0]) {
 	case APCI3120_START:
 
@@ -1937,7 +1814,7 @@ static int apci3120_write_insn_timer(struct comedi_device *dev,
 			devpriv->iobase + APCI3120_WRITE_MODE_SELECT);
 
 		if (devpriv->b_Timer2Mode == APCI3120_TIMER) {	/* start timer */
-			/* For Timer mode is  Gate2 must be activated   **timer started */
+			/* For Timer mode is  Gate2 must be activated	timer started */
 			devpriv->us_OutputRegister =
 				devpriv->
 				us_OutputRegister | APCI3120_ENABLE_TIMER2;
@@ -1979,9 +1856,6 @@ static int apci3120_write_insn_timer(struct comedi_device *dev,
 		/*  Reset FC_TIMER BIT */
 		inb(devpriv->iobase + APCI3120_TIMER_STATUS_REGISTER);
 
-		/* Disable timer */
-		/* devpriv->b_Timer2Mode=APCI3120_DISABLE;  */
-
 		break;
 
 	case 2:		/* write new value to Timer */
@@ -1990,14 +1864,13 @@ static int apci3120_write_insn_timer(struct comedi_device *dev,
 				"timer2 not configured in TIMER MODE\n");
 			return -EINVAL;
 		}
-		/*  ui_Timervalue2=data[1]; // passed as argument */
 		us_TmpValue =
 			(unsigned short) inw(devpriv->iobase + APCI3120_RD_STATUS);
 
-/*
- * EL250804: Testing if board APCI3120 have the new Quartz or if it
- * is an APCI3001 and calculate the time value to set in the timer
- */
+		/*
+		 * EL250804: Testing if board APCI3120 have the new Quartz or if it
+		 * is an APCI3001 and calculate the time value to set in the timer
+		 */
 		if ((us_TmpValue & 0x00B0) == 0x00B0
 			|| !strcmp(this_board->pc_DriverName, "apci3001")) {
 			/* Calculate the time value to set in the timer */
@@ -2053,8 +1926,6 @@ static int apci3120_read_insn_timer(struct comedi_device *dev,
 		&& (devpriv->b_Timer2Mode != APCI3120_TIMER)) {
 		dev_err(dev->class_dev, "timer2 not configured\n");
 	}
-
-	/* this_board->timer_read(dev,data); */
 	if (devpriv->b_Timer2Mode == APCI3120_TIMER) {
 
 		/* Read the LOW unsigned short of Timer 2 register */
@@ -2137,7 +2008,6 @@ static int apci3120_ao_insn_write(struct comedi_device *dev,
 	ui_Range = CR_RANGE(insn->chanspec);
 	ui_Channel = CR_CHAN(insn->chanspec);
 
-	/* this_board->ao_write(dev, ui_Range, ui_Channel,data[0]); */
 	if (ui_Range) {		/*  if 1 then unipolar */
 
 		if (data[0] != 0)
@@ -2163,17 +2033,17 @@ static int apci3120_ao_insn_write(struct comedi_device *dev,
 	} while (us_TmpValue != 0x0001);
 
 	if (ui_Channel <= 3)
-/*
- * for channel 0-3 out at the register 1 (wrDac1-8) data[i]
- * typecasted to ushort since word write is to be done
- */
+		/*
+		 * for channel 0-3 out at the register 1 (wrDac1-8) data[i]
+		 * typecasted to ushort since word write is to be done
+		 */
 		outw((unsigned short) data[0],
 			devpriv->iobase + APCI3120_ANALOG_OUTPUT_1);
 	else
-/*
- * for channel 4-7 out at the register 2 (wrDac5-8) data[i]
- * typecasted to ushort since word write is to be done
- */
+		/*
+		 * for channel 4-7 out at the register 2 (wrDac5-8) data[i]
+		 * typecasted to ushort since word write is to be done
+		 */
 		outw((unsigned short) data[0],
 			devpriv->iobase + APCI3120_ANALOG_OUTPUT_2);
 
-- 
2.1.0

