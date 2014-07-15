Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759034AbaGONTc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 09:19:32 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:64860 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758183AbaGONTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 09:19:30 -0400
From: sam-the-6 <asadi.samuel@gmail.com>
To: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        gregkh@linuxfoundation.org
Cc: chase.southwood@yahoo.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Sam Asadi <asadi.samuel@gmail.com>
Subject: [PATCH 94/94] Staging: comedi: 3 files revised fixed style issues
Date: Tue, 15 Jul 2014 16:19:22 +0300
Message-Id: <1405430362-7359-1-git-send-email-asadi.samuel@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sam Asadi <asadi.samuel@gmail.com>

3 files in 'staging/comedi/drivers/' revised again
and style issues fixed

Signed-off-by: Sam Asadi <asadi.samuel@gmail.com>

	modified:   drivers/staging/comedi/drivers/8253.h
	modified:   drivers/staging/comedi/drivers/8255.c
	modified:   drivers/staging/comedi/drivers/adl_pci9118.c
---
 drivers/staging/comedi/drivers/8253.h        |   34 +++---
 drivers/staging/comedi/drivers/8255.c        |  154 +++++++++++++-------------
 drivers/staging/comedi/drivers/adl_pci9118.c |  140 +++++++++++------------
 3 files changed, 167 insertions(+), 161 deletions(-)

diff --git a/drivers/staging/comedi/drivers/8253.h b/drivers/staging/comedi/drivers/8253.h
index f6b8607..31d0fc9 100644
--- a/drivers/staging/comedi/drivers/8253.h
+++ b/drivers/staging/comedi/drivers/8253.h
@@ -1,20 +1,20 @@
 /*
-    comedi/drivers/8253.h
-    Header file for 8253
-
-    COMEDI - Linux Control and Measurement Device Interface
-    Copyright (C) 2000 David A. Schleef <ds@schleef.org>
-
-    This program is free software; you can redistribute it and/or modify
-    it under the terms of the GNU General Public License as published by
-    the Free Software Foundation; either version 2 of the License, or
-    (at your option) any later version.
-
-    This program is distributed in the hope that it will be useful,
-    but WITHOUT ANY WARRANTY; without even the implied warranty of
-    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-    GNU General Public License for more details.
-*/
+ * comedi/drivers/8253.h
+ * Header file for 8253
+ *
+ * COMEDI - Linux Control and Measurement Device Interface
+ * Copyright (C) 2000 David A. Schleef <ds@schleef.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
 
 #ifndef _8253_H
 #define _8253_H
@@ -55,7 +55,7 @@ static inline void i8253_cascade_ns_to_timer(int i8253_osc_base,
 	    /* check for overflow */
 	    divider > div1 && divider > div2 &&
 	    divider * i8253_osc_base > divider &&
-	    divider * i8253_osc_base > i8253_osc_base)	{
+	    divider * i8253_osc_base > i8253_osc_base) {
 		return;
 	}
 
diff --git a/drivers/staging/comedi/drivers/8255.c b/drivers/staging/comedi/drivers/8255.c
index de273c7..246bf30 100644
--- a/drivers/staging/comedi/drivers/8255.c
+++ b/drivers/staging/comedi/drivers/8255.c
@@ -1,73 +1,77 @@
 /*
-	comedi/drivers/8255.c
-	Driver for 8255
-
-	COMEDI - Linux Control and Measurement Device Interface
-	Copyright (C) 1998 David A. Schleef <ds@schleef.org>
-
-	This program is free software; you can redistribute it and/or modify
-	it under the terms of the GNU General Public License as published by
-	the Free Software Foundation; either version 2 of the License, or
-	(at your option) any later version.
-
-	This program is distributed in the hope that it will be useful,
-	but WITHOUT ANY WARRANTY; without even the implied warranty of
-	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-	GNU General Public License for more details.
-
-	Driver: 8255
-	Description: generic 8255 support
-	Devices: [standard] 8255 (8255)
-	Author: ds
-	Status: works
-	Updated: Fri,  7 Jun 2002 12:56:45 -0700
-
-	The classic in digital I/O.  The 8255 appears in Comedi as a single
-	digital I/O subdevice with 24 channels.  The channel 0 corresponds
-	to the 8255's port A, bit 0; channel 23 corresponds to port C, bit
-	7.  Direction configuration is done in blocks, with channels 0-7,
-	8-15, 16-19, and 20-23 making up the 4 blocks.  The only 8255 mode
-	supported is mode 0.
-
-	You should enable compilation this driver if you plan to use a board
-	that has an 8255 chip.  For multifunction boards, the main driver will
-	configure the 8255 subdevice automatically.
-
-	This driver also works independently with ISA and PCI cards that
-	directly map the 8255 registers to I/O ports, including cards with
-	multiple 8255 chips.  To configure the driver for such a card, the
-	option list should be a list of the I/O port bases for each of the
-	8255 chips.  For example,
-
-	comedi_config /dev/comedi0 8255 0x200,0x204,0x208,0x20c
-
-	Note that most PCI 8255 boards do NOT work with this driver, and
-	need a separate driver as a wrapper.  For those that do work, the
-	I/O port base address can be found in the output of 'lspci -v'.
-
-	This file contains an exported subdevice for driving an 8255.
-
-	To use this subdevice as part of another driver, you need to
-	set up the subdevice in the attach function of the driver by
-	calling:
-
-	subdev_8255_init(device, subdevice, io_function, iobase)
-
-	device and subdevice are pointers to the device and subdevice
-	structures.  io_function will be called to provide the
-	low-level input/output to the device, i.e., actual register
-	access.  io_function will be called with the value of iobase
-	as the last parameter.  If the 8255 device is mapped as 4
-	consecutive I/O ports, you can use NULL for io_function
-	and the I/O port base for iobase, and an internal function will
-	handle the register access.
-
-	In addition, if the main driver handles interrupts, you can
-	enable commands on the subdevice by calling subdev_8255_init_irq()
-	instead.  Then, when you get an interrupt that is likely to be
-	from the 8255, you should call subdev_8255_interrupt(), which
-	will copy the latched value to a Comedi buffer.
-*/
+ * comedi/drivers/8255.c
+ * Driver for 8255
+ *
+ * COMEDI - Linux Control and Measurement Device Interface
+ * Copyright (C) 1998 David A. Schleef <ds@schleef.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+/*
+ * Driver: 8255
+ * Description: generic 8255 support
+ * Devices: [standard] 8255 (8255)
+ * Author: ds
+ * Status: works
+ * Updated: Fri,  7 Jun 2002 12:56:45 -0700
+ *
+ * The classic in digital I/O.  The 8255 appears in Comedi as a single
+ * digital I/O subdevice with 24 channels.  The channel 0 corresponds
+ * to the 8255's port A, bit 0; channel 23 corresponds to port C, bit
+ * 7.  Direction configuration is done in blocks, with channels 0-7,
+ * 8-15, 16-19, and 20-23 making up the 4 blocks.  The only 8255 mode
+ * supported is mode 0.
+ *
+ * You should enable compilation this driver if you plan to use a board
+ * that has an 8255 chip.  For multifunction boards, the main driver will
+ * configure the 8255 subdevice automatically.
+ *
+ * This driver also works independently with ISA and PCI cards that
+ * directly map the 8255 registers to I/O ports, including cards with
+ * multiple 8255 chips.  To configure the driver for such a card, the
+ * option list should be a list of the I/O port bases for each of the
+ * 8255 chips.  For example,
+ *
+ * comedi_config /dev/comedi0 8255 0x200,0x204,0x208,0x20c
+ *
+ * Note that most PCI 8255 boards do NOT work with this driver, and
+ * need a separate driver as a wrapper.  For those that do work, the
+ * I/O port base address can be found in the output of 'lspci -v'.
+ */
+
+/*
+ * This file contains an exported subdevice for driving an 8255.
+ *
+ * To use this subdevice as part of another driver, you need to
+ * set up the subdevice in the attach function of the driver by
+ * calling:
+ *
+ * subdev_8255_init(device, subdevice, io_function, iobase)
+ *
+ * device and subdevice are pointers to the device and subdevice
+ * structures.  io_function will be called to provide the
+ * low-level input/output to the device, i.e., actual register
+ * access.  io_function will be called with the value of iobase
+ * as the last parameter.  If the 8255 device is mapped as 4
+ * consecutive I/O ports, you can use NULL for io_function
+ * and the I/O port base for iobase, and an internal function will
+ * handle the register access.
+ *
+ * In addition, if the main driver handles interrupts, you can
+ * enable commands on the subdevice by calling subdev_8255_init_irq()
+ * instead.  Then, when you get an interrupt that is likely to be
+ * from the 8255, you should call subdev_8255_interrupt(), which
+ * will copy the latched value to a Comedi buffer.
+ */
 
 #include <linux/module.h>
 #include "../comedidev.h"
@@ -99,8 +103,9 @@ static int subdev_8255_io(int dir, int port, int data, unsigned long iobase)
 	if (dir) {
 		outb(data, iobase + port);
 		return 0;
-	} else
+	} else {
 		return inb(iobase + port);
+	}
 }
 
 void subdev_8255_interrupt(struct comedi_device *dev,
@@ -304,10 +309,10 @@ int subdev_8255_init_irq(struct comedi_device *dev, struct comedi_subdevice *s,
 EXPORT_SYMBOL_GPL(subdev_8255_init_irq);
 
 /*
-
-	Start of the 8255 standalone device
-
-*/
+ *
+ * Start of the 8255 standalone device
+ *
+ */
 
 static int dev_8255_attach(struct comedi_device *dev,
 			   struct comedi_devconfig *it)
@@ -375,4 +380,3 @@ module_comedi_driver(dev_8255_driver);
 MODULE_AUTHOR("Comedi http://www.comedi.org");
 MODULE_DESCRIPTION("Comedi low-level driver");
 MODULE_LICENSE("GPL");
-
diff --git a/drivers/staging/comedi/drivers/adl_pci9118.c b/drivers/staging/comedi/drivers/adl_pci9118.c
index 7139f87..f23176e 100644
--- a/drivers/staging/comedi/drivers/adl_pci9118.c
+++ b/drivers/staging/comedi/drivers/adl_pci9118.c
@@ -1,71 +1,72 @@
 /*
- *  comedi/drivers/adl_pci9118.c
+ * comedi/drivers/adl_pci9118.c
  *
- *  hardware driver for ADLink cards:
- *   card:   PCI-9118DG, PCI-9118HG, PCI-9118HR
- *   driver: pci9118dg,  pci9118hg,  pci9118hr
+ * hardware driver for ADLink cards:
+ * card:   PCI-9118DG, PCI-9118HG, PCI-9118HR
+ * driver: pci9118dg,  pci9118hg,  pci9118hr
  *
  * Author: Michal Dobes <dobes@tesnet.cz>
  *
-*/
+ */
 
 /*
-     Driver: adl_pci9118
-     Description: Adlink PCI-9118DG, PCI-9118HG, PCI-9118HR
-     Author: Michal Dobes <dobes@tesnet.cz>
-     Devices: [ADLink] PCI-9118DG (pci9118dg), PCI-9118HG (pci9118hg),
-     PCI-9118HR (pci9118hr)
-     Status: works
-
-     This driver supports AI, AO, DI and DO subdevices.
-     AI subdevice supports cmd and insn interface,
-     other subdevices support only insn interface.
-     For AI:
-     - If cmd->scan_begin_src=TRIG_EXT then trigger input is TGIN (pin 46).
-     - If cmd->convert_src=TRIG_EXT then trigger input is EXTTRG (pin 44).
-     - If cmd->start_src/stop_src=TRIG_EXT then trigger input is TGIN (pin 46).
-     - It is not necessary to have cmd.scan_end_arg=cmd.chanlist_len but
-       cmd.scan_end_arg modulo cmd.chanlist_len must by 0.
-     - If return value of cmdtest is 5 then you've bad channel list
-       (it isn't possible mixture S.E. and DIFF inputs or bipolar and unipolar
-       ranges).
-
-     There are some hardware limitations:
-     a) You cann't use mixture of unipolar/bipoar ranges or differencial/single
-	ended inputs.
-     b) DMA transfers must have the length aligned to two samples (32 bit),
-	so there is some problems if cmd->chanlist_len is odd. This driver
-	tries bypass this with adding one sample to the end of the every scan
-	and discard it on output but this cann't be used if
-	cmd->scan_begin_src=TRIG_FOLLOW and is used flag TRIG_WAKE_EOS, then
-	driver switch to interrupt driven mode with interrupt after every
-	sample.
-     c) If isn't used DMA then you can use only mode where
-	cmd->scan_begin_src=TRIG_FOLLOW.
-
-     Configuration options:
-       [0] - PCI bus of device (optional)
-       [1] - PCI slot of device (optional)
-	     If bus/slot is not specified, then first available PCI
-	     card will be used.
-       [2] - 0= standard 8 DIFF/16 SE channels configuration
-	     n = external multiplexer connected, 1 <= n <= 256
-       [3] - 0=autoselect DMA or EOC interrupts operation
-	     1 = disable DMA mode
-	     3 = disable DMA and INT, only insn interface will work
-       [4] - sample&hold signal - card can generate signal for external
-	     S&H board
-	     0 = use SSHO(pin 45) signal is generated in onboard hardware
-		 S&H logic
-	     0 != use ADCHN7(pin 23) signal is generated from driver, number
-		  say how long delay is requested in ns and sign polarity of
-		  the hold (in this case external multiplexor can serve only
-		  128 channels)
-       [5] - 0=stop measure on all hardware errors
-	     2 | = ignore ADOR - A/D Overrun status
-	     8|=ignore Bover - A/D Burst Mode Overrun status
-	     256|=ignore nFull - A/D FIFO Full status
-*/
+ * Driver: adl_pci9118
+ * Description: Adlink PCI-9118DG, PCI-9118HG, PCI-9118HR
+ * Author: Michal Dobes <dobes@tesnet.cz>
+ * Devices: [ADLink] PCI-9118DG (pci9118dg), PCI-9118HG (pci9118hg),
+ * PCI-9118HR (pci9118hr)
+ * Status: works
+ *
+ * This driver supports AI, AO, DI and DO subdevices.
+ * AI subdevice supports cmd and insn interface,
+ * other subdevices support only insn interface.
+ * For AI:
+ *	- If cmd->scan_begin_src=TRIG_EXT then trigger input is TGIN (pin 46).
+ *	- If cmd->convert_src=TRIG_EXT then trigger input is EXTTRG (pin 44).
+ *	- If cmd->start_src/stop_src=TRIG_EXT then trigger input is TGIN
+ *	  (pin 46).
+ *	- It is not necessary to have cmd.scan_end_arg=cmd.chanlist_len but
+ *	  cmd.scan_end_arg modulo cmd.chanlist_len must by 0.
+ *	- If return value of cmdtest is 5 then you've bad channel list
+ *	  (it isn't possible mixture S.E. and DIFF inputs or bipolar and
+ *	  unipolar ranges).
+ *
+ * There are some hardware limitations:
+ *	a) You cann't use mixture of unipolar/bipoar ranges or
+ *	   differencial/single ended inputs.
+ *	b) DMA transfers must have the length aligned to two samples (32 bit),
+ *	   so there is some problems if cmd->chanlist_len is odd. This driver
+ *	   tries bypass this with adding one sample to the end of the every
+ *	   scan and discard it on output but this cann't be used if
+ *	   cmd->scan_begin_src=TRIG_FOLLOW and is used flag TRIG_WAKE_EOS, then
+ *	   driver switch to interrupt driven mode with interrupt after every
+ *	   sample.
+ *	c) If isn't used DMA then you can use only mode where
+ *	   cmd->scan_begin_src=TRIG_FOLLOW.
+ *
+ * Configuration options:
+ *	[0] - PCI bus of device (optional)
+ *	[1] - PCI slot of device (optional)
+ *	      If bus/slot is not specified, then first available PCI
+ *	      card will be used.
+ *	[2] - 0= standard 8 DIFF/16 SE channels configuration
+ *	      n = external multiplexer connected, 1 <= n <= 256
+ *	[3] - 0=autoselect DMA or EOC interrupts operation
+ *	      1 = disable DMA mode
+ *	      3 = disable DMA and INT, only insn interface will work
+ *	[4] - sample&hold signal - card can generate signal for external
+ *	      S&H board
+ *	      0 = use SSHO(pin 45) signal is generated in onboard hardware
+ *		  S&H logic
+ *	      0 != use ADCHN7(pin 23) signal is generated from driver, number
+ *		   say how long delay is requested in ns and sign polarity of
+ *		   the hold (in this case external multiplexor can serve only
+ *		   128 channels)
+ *	[5] - 0=stop measure on all hardware errors
+ *	      2 | = ignore ADOR - A/D Overrun status
+ *	      8|=ignore Bover - A/D Burst Mode Overrun status
+ *	      256|=ignore nFull - A/D FIFO Full status
+ */
 
 /*
  * FIXME
@@ -350,7 +351,7 @@ struct pci9118_private {
 						 * on external start
 						 */
 	unsigned short ao_data[2];		/* data output buffer */
-	char dma_doublebuf;		/* we can use double buffering */
+	char dma_doublebuf;			/* use double buffering */
 	unsigned int dma_actbuf;		/* which buffer is used now */
 	unsigned short *dmabuf_virt[2];		/*
 						 * pointers to begin of
@@ -403,7 +404,7 @@ static int check_channel_list(struct comedi_device *dev,
 	}
 	if ((frontadd + n_chan + backadd) > s->len_chanlist) {
 		comedi_error(dev,
-		"range/channel list is too long for actual configuration!\n");
+			     "range/channel list is too long for actual configuration!\n");
 		return 0;
 	}
 
@@ -416,19 +417,19 @@ static int check_channel_list(struct comedi_device *dev,
 			if ((CR_AREF(chanlist[i]) == AREF_DIFF) !=
 			    (differencial)) {
 				comedi_error(dev,
-						"Differencial and single ended inputs can't be mixtured!");
+					     "Differencial and single ended inputs can't be mixtured!");
 				return 0;
 			}
 			if ((CR_RANGE(chanlist[i]) < PCI9118_BIPOLAR_RANGES) !=
 			    (bipolar)) {
 				comedi_error(dev,
-						"Bipolar and unipolar ranges can't be mixtured!");
+					     "Bipolar and unipolar ranges can't be mixtured!");
 				return 0;
 			}
 			if (!devpriv->usemux && differencial &&
 			    (CR_CHAN(chanlist[i]) >= this_board->n_aichand)) {
 				comedi_error(dev,
-						"If AREF_DIFF is used then is available only first 8 channels!");
+					     "If AREF_DIFF is used then is available only first 8 channels!");
 				return 0;
 			}
 		}
@@ -799,7 +800,7 @@ static void pci9118_start_pacer(struct comedi_device *dev, int mode)
 
 	outl(0x74, dev->iobase + PCI9118_CNTCTRL);
 	outl(0xb4, dev->iobase + PCI9118_CNTCTRL);
-/* outl(0x30, dev->iobase + PCI9118_CNTCTRL); */
+	/* outl(0x30, dev->iobase + PCI9118_CNTCTRL); */
 	udelay(1);
 
 	if ((mode == 1) || (mode == 2) || (mode == 4)) {
@@ -1679,7 +1680,7 @@ static int pci9118_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 						/* double timed action */
 		if (!devpriv->usedma) {
 			comedi_error(dev,
-					"cmd->scan_begin_src=TRIG_TIMER works only with bus mastering!");
+				     "cmd->scan_begin_src=TRIG_TIMER works only with bus mastering!");
 			return -EIO;
 		}
 
@@ -1743,7 +1744,7 @@ static int pci9118_reset(struct comedi_device *dev)
 	outl(devpriv->IntControlReg, dev->iobase + PCI9118_INTCTRL);
 						/* disable interrupts source */
 	outl(0x30, dev->iobase + PCI9118_CNTCTRL);
-/* outl(0xb4, dev->iobase + PCI9118_CNTCTRL); */
+	/* outl(0xb4, dev->iobase + PCI9118_CNTCTRL); */
 	pci9118_start_pacer(dev, 0);		/* stop 8254 counters */
 	devpriv->AdControlReg = 0;
 	outl(devpriv->AdControlReg, dev->iobase + PCI9118_ADCNTRL);
@@ -1796,6 +1797,7 @@ static int pci9118_reset(struct comedi_device *dev)
  * FIXME - this is pretty ineffective because all the supported board types
  * have the same device ID!
  */
+
 static const struct boardtype *pci9118_find_boardinfo(struct pci_dev *pcidev)
 {
 	unsigned int i;
-- 
1.7.10.4

