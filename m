Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753795AbaG2MD0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 08:03:26 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:51647 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751074AbaG2L6o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 07:58:44 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 01/19] staging: comedi: amplc_pci230: reformat a load of comments
Date: Tue, 29 Jul 2014 12:58:09 +0100
Message-Id: <1406635107-27950-2-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1406635107-27950-1-git-send-email-abbotti@mev.co.uk>
References: <1406635107-27950-1-git-send-email-abbotti@mev.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reformat a load of comments to fit in with the preferred coding style,
including the copyright and driver description comments at the top of
the file.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/amplc_pci230.c | 837 +++++++++++++++-----------
 1 file changed, 489 insertions(+), 348 deletions(-)

diff --git a/drivers/staging/comedi/drivers/amplc_pci230.c b/drivers/staging/comedi/drivers/amplc_pci230.c
index a61d990..cb86d04 100644
--- a/drivers/staging/comedi/drivers/amplc_pci230.c
+++ b/drivers/staging/comedi/drivers/amplc_pci230.c
@@ -1,188 +1,189 @@
- /*
-    comedi/drivers/amplc_pci230.c
-    Driver for Amplicon PCI230 and PCI260 Multifunction I/O boards.
-
-    Copyright (C) 2001 Allan Willcox <allanwillcox@ozemail.com.au>
-
-    COMEDI - Linux Control and Measurement Device Interface
-    Copyright (C) 2000 David A. Schleef <ds@schleef.org>
-
-    This program is free software; you can redistribute it and/or modify
-    it under the terms of the GNU General Public License as published by
-    the Free Software Foundation; either version 2 of the License, or
-    (at your option) any later version.
+/*
+ * comedi/drivers/amplc_pci230.c
+ * Driver for Amplicon PCI230 and PCI260 Multifunction I/O boards.
+ *
+ * Copyright (C) 2001 Allan Willcox <allanwillcox@ozemail.com.au>
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
 
-    This program is distributed in the hope that it will be useful,
-    but WITHOUT ANY WARRANTY; without even the implied warranty of
-    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-    GNU General Public License for more details.
-  */
 /*
-Driver: amplc_pci230
-Description: Amplicon PCI230, PCI260 Multifunction I/O boards
-Author: Allan Willcox <allanwillcox@ozemail.com.au>,
-  Steve D Sharples <steve.sharples@nottingham.ac.uk>,
-  Ian Abbott <abbotti@mev.co.uk>
-Updated: Wed, 22 Oct 2008 12:34:49 +0100
-Devices: [Amplicon] PCI230 (pci230 or amplc_pci230),
-  PCI230+ (pci230+ or amplc_pci230),
-  PCI260 (pci260 or amplc_pci230), PCI260+ (pci260+ or amplc_pci230)
-Status: works
-
-Configuration options:
-  [0] - PCI bus of device (optional).
-  [1] - PCI slot of device (optional).
-          If bus/slot is not specified, the first available PCI device
-          will be used.
-
-Configuring a "amplc_pci230" will match any supported card and it will
-choose the best match, picking the "+" models if possible.  Configuring
-a "pci230" will match a PCI230 or PCI230+ card and it will be treated as
-a PCI230.  Configuring a "pci260" will match a PCI260 or PCI260+ card
-and it will be treated as a PCI260.  Configuring a "pci230+" will match
-a PCI230+ card.  Configuring a "pci260+" will match a PCI260+ card.
-
-Subdevices:
-
-                PCI230(+)    PCI260(+)
-                ---------    ---------
-  Subdevices       3            1
-        0          AI           AI
-	1          AO
-	2          DIO
-
-AI Subdevice:
-
-  The AI subdevice has 16 single-ended channels or 8 differential
-  channels.
-
-  The PCI230 and PCI260 cards have 12-bit resolution.  The PCI230+ and
-  PCI260+ cards have 16-bit resolution.
-
-  For differential mode, use inputs 2N and 2N+1 for channel N (e.g. use
-  inputs 14 and 15 for channel 7).  If the card is physically a PCI230
-  or PCI260 then it actually uses a "pseudo-differential" mode where the
-  inputs are sampled a few microseconds apart.  The PCI230+ and PCI260+
-  use true differential sampling.  Another difference is that if the
-  card is physically a PCI230 or PCI260, the inverting input is 2N,
-  whereas for a PCI230+ or PCI260+ the inverting input is 2N+1.  So if a
-  PCI230 is physically replaced by a PCI230+ (or a PCI260 with a
-  PCI260+) and differential mode is used, the differential inputs need
-  to be physically swapped on the connector.
-
-  The following input ranges are supported:
-
-    0 => [-10, +10] V
-    1 => [-5, +5] V
-    2 => [-2.5, +2.5] V
-    3 => [-1.25, +1.25] V
-    4 => [0, 10] V
-    5 => [0, 5] V
-    6 => [0, 2.5] V
-
-AI Commands:
-
-  +=========+==============+===========+============+==========+
-  |start_src|scan_begin_src|convert_src|scan_end_src| stop_src |
-  +=========+==============+===========+============+==========+
-  |TRIG_NOW | TRIG_FOLLOW  |TRIG_TIMER | TRIG_COUNT |TRIG_NONE |
-  |TRIG_INT |              |TRIG_EXT(3)|            |TRIG_COUNT|
-  |         |              |TRIG_INT   |            |          |
-  |         |--------------|-----------|            |          |
-  |         | TRIG_TIMER(1)|TRIG_TIMER |            |          |
-  |         | TRIG_EXT(2)  |           |            |          |
-  |         | TRIG_INT     |           |            |          |
-  +---------+--------------+-----------+------------+----------+
-
-  Note 1: If AI command and AO command are used simultaneously, only
-          one may have scan_begin_src == TRIG_TIMER.
-
-  Note 2: For PCI230 and PCI230+, scan_begin_src == TRIG_EXT uses
-          DIO channel 16 (pin 49) which will need to be configured as
-          a digital input.  For PCI260+, the EXTTRIG/EXTCONVCLK input
-          (pin 17) is used instead.  For PCI230, scan_begin_src ==
-          TRIG_EXT is not supported.  The trigger is a rising edge
-          on the input.
-
-  Note 3: For convert_src == TRIG_EXT, the EXTTRIG/EXTCONVCLK input
-          (pin 25 on PCI230(+), pin 17 on PCI260(+)) is used.  The
-          convert_arg value is interpreted as follows:
-
-            convert_arg == (CR_EDGE | 0) => rising edge
-            convert_arg == (CR_EDGE | CR_INVERT | 0) => falling edge
-            convert_arg == 0 => falling edge (backwards compatibility)
-            convert_arg == 1 => rising edge (backwards compatibility)
-
-  All entries in the channel list must use the same analogue reference.
-  If the analogue reference is not AREF_DIFF (not differential) each
-  pair of channel numbers (0 and 1, 2 and 3, etc.) must use the same
-  input range.  The input ranges used in the sequence must be all
-  bipolar (ranges 0 to 3) or all unipolar (ranges 4 to 6).  The channel
-  sequence must consist of 1 or more identical subsequences.  Within the
-  subsequence, channels must be in ascending order with no repeated
-  channels.  For example, the following sequences are valid: 0 1 2 3
-  (single valid subsequence), 0 2 3 5 0 2 3 5 (repeated valid
-  subsequence), 1 1 1 1 (repeated valid subsequence).  The following
-  sequences are invalid: 0 3 2 1 (invalid subsequence), 0 2 3 5 0 2 3
-  (incompletely repeated subsequence).  Some versions of the PCI230+ and
-  PCI260+ have a bug that requires a subsequence longer than one entry
-  long to include channel 0.
-
-AO Subdevice:
-
-  The AO subdevice has 2 channels with 12-bit resolution.
-
-  The following output ranges are supported:
-
-    0 => [0, 10] V
-    1 => [-10, +10] V
-
-AO Commands:
-
-  +=========+==============+===========+============+==========+
-  |start_src|scan_begin_src|convert_src|scan_end_src| stop_src |
-  +=========+==============+===========+============+==========+
-  |TRIG_INT | TRIG_TIMER(1)| TRIG_NOW  | TRIG_COUNT |TRIG_NONE |
-  |         | TRIG_EXT(2)  |           |            |TRIG_COUNT|
-  |         | TRIG_INT     |           |            |          |
-  +---------+--------------+-----------+------------+----------+
-
-  Note 1: If AI command and AO command are used simultaneously, only
-          one may have scan_begin_src == TRIG_TIMER.
-
-  Note 2: scan_begin_src == TRIG_EXT is only supported if the card is
-          configured as a PCI230+ and is only supported on later
-          versions of the card.  As a card configured as a PCI230+ is
-          not guaranteed to support external triggering, please consider
-          this support to be a bonus.  It uses the EXTTRIG/ EXTCONVCLK
-          input (PCI230+ pin 25).  Triggering will be on the rising edge
-          unless the CR_INVERT flag is set in scan_begin_arg.
-
-  The channels in the channel sequence must be in ascending order with
-  no repeats.  All entries in the channel sequence must use the same
-  output range.
-
-DIO Subdevice:
-
-  The DIO subdevice is a 8255 chip providing 24 DIO channels.  The DIO
-  channels are configurable as inputs or outputs in four groups:
-
-    Port A  - channels  0 to  7
-    Port B  - channels  8 to 15
-    Port CL - channels 16 to 19
-    Port CH - channels 20 to 23
-
-  Only mode 0 of the 8255 chip is supported.
-
-  Bit 0 of port C (DIO channel 16) is also used as an external scan
-  trigger input for AI commands on PCI230 and PCI230+, so would need to
-  be configured as an input to use it for that purpose.
-*/
+ * Driver: amplc_pci230
+ * Description: Amplicon PCI230, PCI260 Multifunction I/O boards
+ * Author: Allan Willcox <allanwillcox@ozemail.com.au>,
+ *   Steve D Sharples <steve.sharples@nottingham.ac.uk>,
+ *   Ian Abbott <abbotti@mev.co.uk>
+ * Updated: Wed, 22 Oct 2008 12:34:49 +0100
+ * Devices: [Amplicon] PCI230 (pci230 or amplc_pci230),
+ *   PCI230+ (pci230+ or amplc_pci230),
+ *   PCI260 (pci260 or amplc_pci230), PCI260+ (pci260+ or amplc_pci230)
+ * Status: works
+ *
+ * Configuration options:
+ *   [0] - PCI bus of device (optional).
+ *   [1] - PCI slot of device (optional).
+ *           If bus/slot is not specified, the first available PCI device
+ *           will be used.
+ *
+ * Configuring a "amplc_pci230" will match any supported card and it will
+ * choose the best match, picking the "+" models if possible.  Configuring
+ * a "pci230" will match a PCI230 or PCI230+ card and it will be treated as
+ * a PCI230.  Configuring a "pci260" will match a PCI260 or PCI260+ card
+ * and it will be treated as a PCI260.  Configuring a "pci230+" will match
+ * a PCI230+ card.  Configuring a "pci260+" will match a PCI260+ card.
+ *
+ * Subdevices:
+ *
+ *                 PCI230(+)    PCI260(+)
+ *                 ---------    ---------
+ *   Subdevices       3            1
+ *         0          AI           AI
+ *         1          AO
+ *         2          DIO
+ *
+ * AI Subdevice:
+ *
+ *   The AI subdevice has 16 single-ended channels or 8 differential
+ *   channels.
+ *
+ *   The PCI230 and PCI260 cards have 12-bit resolution.  The PCI230+ and
+ *   PCI260+ cards have 16-bit resolution.
+ *
+ *   For differential mode, use inputs 2N and 2N+1 for channel N (e.g. use
+ *   inputs 14 and 15 for channel 7).  If the card is physically a PCI230
+ *   or PCI260 then it actually uses a "pseudo-differential" mode where the
+ *   inputs are sampled a few microseconds apart.  The PCI230+ and PCI260+
+ *   use true differential sampling.  Another difference is that if the
+ *   card is physically a PCI230 or PCI260, the inverting input is 2N,
+ *   whereas for a PCI230+ or PCI260+ the inverting input is 2N+1.  So if a
+ *   PCI230 is physically replaced by a PCI230+ (or a PCI260 with a
+ *   PCI260+) and differential mode is used, the differential inputs need
+ *   to be physically swapped on the connector.
+ *
+ *   The following input ranges are supported:
+ *
+ *     0 => [-10, +10] V
+ *     1 => [-5, +5] V
+ *     2 => [-2.5, +2.5] V
+ *     3 => [-1.25, +1.25] V
+ *     4 => [0, 10] V
+ *     5 => [0, 5] V
+ *     6 => [0, 2.5] V
+ *
+ * AI Commands:
+ *
+ *   +=========+==============+===========+============+==========+
+ *   |start_src|scan_begin_src|convert_src|scan_end_src| stop_src |
+ *   +=========+==============+===========+============+==========+
+ *   |TRIG_NOW | TRIG_FOLLOW  |TRIG_TIMER | TRIG_COUNT |TRIG_NONE |
+ *   |TRIG_INT |              |TRIG_EXT(3)|            |TRIG_COUNT|
+ *   |         |              |TRIG_INT   |            |          |
+ *   |         |--------------|-----------|            |          |
+ *   |         | TRIG_TIMER(1)|TRIG_TIMER |            |          |
+ *   |         | TRIG_EXT(2)  |           |            |          |
+ *   |         | TRIG_INT     |           |            |          |
+ *   +---------+--------------+-----------+------------+----------+
+ *
+ *   Note 1: If AI command and AO command are used simultaneously, only
+ *           one may have scan_begin_src == TRIG_TIMER.
+ *
+ *   Note 2: For PCI230 and PCI230+, scan_begin_src == TRIG_EXT uses
+ *           DIO channel 16 (pin 49) which will need to be configured as
+ *           a digital input.  For PCI260+, the EXTTRIG/EXTCONVCLK input
+ *           (pin 17) is used instead.  For PCI230, scan_begin_src ==
+ *           TRIG_EXT is not supported.  The trigger is a rising edge
+ *           on the input.
+ *
+ *   Note 3: For convert_src == TRIG_EXT, the EXTTRIG/EXTCONVCLK input
+ *           (pin 25 on PCI230(+), pin 17 on PCI260(+)) is used.  The
+ *           convert_arg value is interpreted as follows:
+ *
+ *             convert_arg == (CR_EDGE | 0) => rising edge
+ *             convert_arg == (CR_EDGE | CR_INVERT | 0) => falling edge
+ *             convert_arg == 0 => falling edge (backwards compatibility)
+ *             convert_arg == 1 => rising edge (backwards compatibility)
+ *
+ *   All entries in the channel list must use the same analogue reference.
+ *   If the analogue reference is not AREF_DIFF (not differential) each
+ *   pair of channel numbers (0 and 1, 2 and 3, etc.) must use the same
+ *   input range.  The input ranges used in the sequence must be all
+ *   bipolar (ranges 0 to 3) or all unipolar (ranges 4 to 6).  The channel
+ *   sequence must consist of 1 or more identical subsequences.  Within the
+ *   subsequence, channels must be in ascending order with no repeated
+ *   channels.  For example, the following sequences are valid: 0 1 2 3
+ *   (single valid subsequence), 0 2 3 5 0 2 3 5 (repeated valid
+ *   subsequence), 1 1 1 1 (repeated valid subsequence).  The following
+ *   sequences are invalid: 0 3 2 1 (invalid subsequence), 0 2 3 5 0 2 3
+ *   (incompletely repeated subsequence).  Some versions of the PCI230+ and
+ *   PCI260+ have a bug that requires a subsequence longer than one entry
+ *   long to include channel 0.
+ *
+ * AO Subdevice:
+ *
+ *   The AO subdevice has 2 channels with 12-bit resolution.
+ *   The following output ranges are supported:
+ *     0 => [0, 10] V
+ *     1 => [-10, +10] V
+ *
+ * AO Commands:
+ *
+ *   +=========+==============+===========+============+==========+
+ *   |start_src|scan_begin_src|convert_src|scan_end_src| stop_src |
+ *   +=========+==============+===========+============+==========+
+ *   |TRIG_INT | TRIG_TIMER(1)| TRIG_NOW  | TRIG_COUNT |TRIG_NONE |
+ *   |         | TRIG_EXT(2)  |           |            |TRIG_COUNT|
+ *   |         | TRIG_INT     |           |            |          |
+ *   +---------+--------------+-----------+------------+----------+
+ *
+ *   Note 1: If AI command and AO command are used simultaneously, only
+ *           one may have scan_begin_src == TRIG_TIMER.
+ *
+ *   Note 2: scan_begin_src == TRIG_EXT is only supported if the card is
+ *           configured as a PCI230+ and is only supported on later
+ *           versions of the card.  As a card configured as a PCI230+ is
+ *           not guaranteed to support external triggering, please consider
+ *           this support to be a bonus.  It uses the EXTTRIG/ EXTCONVCLK
+ *           input (PCI230+ pin 25).  Triggering will be on the rising edge
+ *           unless the CR_INVERT flag is set in scan_begin_arg.
+ *
+ *   The channels in the channel sequence must be in ascending order with
+ *   no repeats.  All entries in the channel sequence must use the same
+ *   output range.
+ *
+ * DIO Subdevice:
+ *
+ *   The DIO subdevice is a 8255 chip providing 24 DIO channels.  The DIO
+ *   channels are configurable as inputs or outputs in four groups:
+ *
+ *     Port A  - channels  0 to  7
+ *     Port B  - channels  8 to 15
+ *     Port CL - channels 16 to 19
+ *     Port CH - channels 20 to 23
+ *
+ *   Only mode 0 of the 8255 chip is supported.
+ *
+ *   Bit 0 of port C (DIO channel 16) is also used as an external scan
+ *   trigger input for AI commands on PCI230 and PCI230+, so would need to
+ *   be configured as an input to use it for that purpose.
+ */
+
 /*
-Extra triggered scan functionality, interrupt bug-fix added by Steve Sharples.
-Support for PCI230+/260+, more triggered scan functionality, and workarounds
-for (or detection of) various hardware problems added by Ian Abbott.
-*/
+ * Extra triggered scan functionality, interrupt bug-fix added by Steve
+ * Sharples.  Support for PCI230+/260+, more triggered scan functionality,
+ * and workarounds for (or detection of) various hardware problems added
+ * by Ian Abbott.
+ */
 
 #include <linux/module.h>
 #include <linux/pci.h>
@@ -195,12 +196,16 @@ for (or detection of) various hardware problems added by Ian Abbott.
 #include "8253.h"
 #include "8255.h"
 
-/* PCI230 PCI configuration register information */
+/*
+ * PCI230 PCI configuration register information
+ */
 #define PCI_DEVICE_ID_PCI230 0x0000
 #define PCI_DEVICE_ID_PCI260 0x0006
 #define PCI_DEVICE_ID_INVALID 0xffff
 
-/* PCI230 i/o space 1 registers. */
+/*
+ * PCI230 i/o space 1 registers.
+ */
 #define PCI230_PPI_X_BASE	0x00	/* User PPI (82C55) base */
 #define PCI230_PPI_X_A		0x00	/* User PPI (82C55) port A */
 #define PCI230_PPI_X_B		0x01	/* User PPI (82C55) port B */
@@ -216,7 +221,9 @@ for (or detection of) various hardware problems added by Ian Abbott.
 #define PCI230_INT_SCE		0x1E	/* Interrupt source mask (w) */
 #define PCI230_INT_STAT		0x1E	/* Interrupt status (r) */
 
-/* PCI230 i/o space 2 registers. */
+/*
+ * PCI230 i/o space 2 registers.
+ */
 #define PCI230_DACCON		0x00	/* DAC control */
 #define PCI230_DACOUT1		0x02	/* DAC channel 0 (w) */
 #define PCI230_DACOUT2		0x04	/* DAC channel 1 (w) (not FIFO mode) */
@@ -239,24 +246,34 @@ for (or detection of) various hardware problems added by Ian Abbott.
 #define PCI230P2_DACSWTRIG	0x02	/* DAC soft trigger (FIFO mode) (r) */
 #define PCI230P2_DACEN		0x06	/* DAC channel enable (FIFO mode) */
 
-/* Convertor related constants. */
-#define PCI230_DAC_SETTLE 5	/* Analogue output settling time in µs */
-				/* (DAC itself is 1µs nominally). */
-#define PCI230_ADC_SETTLE 1	/* Analogue input settling time in µs */
-				/* (ADC itself is 1.6µs nominally but we poll
-				 * anyway). */
-#define PCI230_MUX_SETTLE 10	/* ADC MUX settling time in µS */
-				/* - 10µs for se, 20µs de. */
+/*
+ * Convertor related constants.
+ */
+/* Analogue output settling time in µs (DAC itself is 1µs nominally). */
+#define PCI230_DAC_SETTLE 5
+/*
+ * Analogue input settling time in µs (ADC itself is 1.6µs nominally but we
+ * poll anyway).
+ */
+#define PCI230_ADC_SETTLE 1
+/* ADC MUX settling time in µS - 10µs for se, 20µs de. */
+#define PCI230_MUX_SETTLE 10
 
-/* DACCON read-write values. */
+/*
+ * DACCON read-write values.
+ */
 #define PCI230_DAC_OR_UNI		(0<<0)	/* Output range unipolar */
 #define PCI230_DAC_OR_BIP		(1<<0)	/* Output range bipolar */
 #define PCI230_DAC_OR_MASK		(1<<0)
-/* The following applies only if DAC FIFO support is enabled in the EXTFUNC
- * register (and only for PCI230+ hardware version 2 onwards). */
+/*
+ * The following applies only if DAC FIFO support is enabled in the EXTFUNC
+ * register (and only for PCI230+ hardware version 2 onwards).
+ */
 #define PCI230P2_DAC_FIFO_EN		(1<<8)	/* FIFO enable */
-/* The following apply only if the DAC FIFO is enabled (and only for PCI230+
- * hardware version 2 onwards). */
+/*
+ * The following apply only if the DAC FIFO is enabled (and only for PCI230+
+ * hardware version 2 onwards).
+ */
 #define PCI230P2_DAC_TRIG_NONE		(0<<2)	/* No trigger */
 #define PCI230P2_DAC_TRIG_SW		(1<<2)	/* Software trigger trigger */
 #define PCI230P2_DAC_TRIG_EXTP		(2<<2)	/* EXTTRIG +ve edge trigger */
@@ -274,22 +291,32 @@ for (or detection of) various hardware problems added by Ian Abbott.
 #define PCI230P2_DAC_INT_FIFO_FULL	(5<<9)
 #define PCI230P2_DAC_INT_FIFO_MASK	(7<<9)
 
-/* DACCON read-only values. */
+/*
+ * DACCON read-only values.
+ */
 #define PCI230_DAC_BUSY			(1<<1)	/* DAC busy. */
-/* The following apply only if the DAC FIFO is enabled (and only for PCI230+
- * hardware version 2 onwards). */
+/*
+ * The following apply only if the DAC FIFO is enabled (and only for PCI230+
+ * hardware version 2 onwards).
+ */
 #define PCI230P2_DAC_FIFO_UNDERRUN_LATCHED	(1<<5)	/* Underrun error */
 #define PCI230P2_DAC_FIFO_EMPTY		(1<<13)	/* FIFO empty */
 #define PCI230P2_DAC_FIFO_FULL		(1<<14)	/* FIFO full */
 #define PCI230P2_DAC_FIFO_HALF		(1<<15)	/* FIFO half full */
 
-/* DACCON write-only, transient values. */
-/* The following apply only if the DAC FIFO is enabled (and only for PCI230+
- * hardware version 2 onwards). */
+/*
+ * DACCON write-only, transient values.
+ */
+/*
+ * The following apply only if the DAC FIFO is enabled (and only for PCI230+
+ * hardware version 2 onwards).
+ */
 #define PCI230P2_DAC_FIFO_UNDERRUN_CLEAR	(1<<5)	/* Clear underrun */
 #define PCI230P2_DAC_FIFO_RESET		(1<<12)	/* FIFO reset */
 
-/* PCI230+ hardware version 2 DAC FIFO levels. */
+/*
+ * PCI230+ hardware version 2 DAC FIFO levels.
+ */
 #define PCI230P2_DAC_FIFOLEVEL_HALF	512
 #define PCI230P2_DAC_FIFOLEVEL_FULL	1024
 /* Free space in DAC FIFO. */
@@ -299,7 +326,9 @@ for (or detection of) various hardware problems added by Ian Abbott.
 #define PCI230P2_DAC_FIFOROOM_HALFTOFULL	1
 #define PCI230P2_DAC_FIFOROOM_FULL		0
 
-/* ADCCON read/write values. */
+/*
+ * ADCCON read/write values.
+ */
 #define PCI230_ADC_TRIG_NONE		(0<<0)	/* No trigger */
 #define PCI230_ADC_TRIG_SW		(1<<0)	/* Software trigger trigger */
 #define PCI230_ADC_TRIG_EXTP		(2<<0)	/* EXTTRIG +ve edge trigger */
@@ -324,31 +353,41 @@ for (or detection of) various hardware problems added by Ian Abbott.
 #define PCI230P_ADC_INT_FIFO_THRESH	(7<<9)	/* FIFO interrupt threshold */
 #define PCI230_ADC_INT_FIFO_MASK	(7<<9)
 
-/* ADCCON write-only, transient values. */
+/*
+ * ADCCON write-only, transient values.
+ */
 #define PCI230_ADC_FIFO_RESET		(1<<12)	/* FIFO reset */
 #define PCI230_ADC_GLOB_RESET		(1<<13)	/* Global reset */
 
-/* ADCCON read-only values. */
+/*
+ * ADCCON read-only values.
+ */
 #define PCI230_ADC_BUSY			(1<<15)	/* ADC busy */
 #define PCI230_ADC_FIFO_EMPTY		(1<<12)	/* FIFO empty */
 #define PCI230_ADC_FIFO_FULL		(1<<13)	/* FIFO full */
 #define PCI230_ADC_FIFO_HALF		(1<<14)	/* FIFO half full */
 #define PCI230_ADC_FIFO_FULL_LATCHED	(1<<5)	/* Indicates overrun occurred */
 
-/* PCI230 ADC FIFO levels. */
+/*
+ * PCI230 ADC FIFO levels.
+ */
 #define PCI230_ADC_FIFOLEVEL_HALFFULL	2049	/* Value for FIFO half full */
 #define PCI230_ADC_FIFOLEVEL_FULL	4096	/* FIFO size */
 
-/* Value to write to ADCSWTRIG to trigger ADC conversion in software trigger
- * mode.  Can be anything.  */
+/*
+ * Value to write to ADCSWTRIG to trigger ADC conversion in software trigger
+ * mode.  Can be anything.
+ */
 #define PCI230_ADC_CONV			0xffff
 
-/* PCI230+ EXTFUNC values. */
+/*
+ * PCI230+ EXTFUNC values.
+ */
+/* Route EXTTRIG pin to external gate inputs. */
 #define PCI230P_EXTFUNC_GAT_EXTTRIG	(1<<0)
-			/* Route EXTTRIG pin to external gate inputs. */
 /* PCI230+ hardware version 2 values. */
+/* Allow DAC FIFO to be enabled. */
 #define PCI230P2_EXTFUNC_DACFIFO	(1<<1)
-			/* Allow DAC FIFO to be enabled. */
 
 /*
  * Counter/timer clock input configuration sources.
@@ -392,7 +431,9 @@ for (or detection of) various hardware problems added by Ian Abbott.
  * Z2-CT2       Z2-CT1-OUT      /Z2-CT0-OUT
  */
 
-/* Interrupt enables/status register values. */
+/*
+ * Interrupt enables/status register values.
+ */
 #define PCI230_INT_DISABLE		0
 #define PCI230_INT_PPI_C0		(1<<0)
 #define PCI230_INT_PPI_C3		(1<<1)
@@ -401,10 +442,12 @@ for (or detection of) various hardware problems added by Ian Abbott.
 /* For PCI230+ hardware version 2 when DAC FIFO enabled. */
 #define PCI230P2_INT_DAC		(1<<4)
 
+/* Assumes bits numbered with zero offset, ie. 0-15 */
 #define PCI230_TEST_BIT(val, n)	((val>>n)&1)
-			/* Assumes bits numbered with zero offset, ie. 0-15 */
 
-/* (Potentially) shared resources and their owners */
+/*
+ * (Potentially) shared resources and their owners
+ */
 enum {
 	RES_Z2CT0,		/* Z2-CT0 */
 	RES_Z2CT1,		/* Z2-CT1 */
@@ -491,9 +534,11 @@ static const struct pci230_board pci230_boards[] = {
 	 },
 };
 
-/* this structure is for data unique to this hardware driver.  If
-   several hardware drivers keep similar information in this structure,
-   feel free to suggest moving the variable to the struct comedi_device struct.  */
+/*
+ * This structure is for data unique to this hardware driver.  If
+ * several hardware drivers keep similar information in this structure,
+ * feel free to suggest moving the variable to the struct comedi_device struct.
+ */
 struct pci230_private {
 	spinlock_t isr_spinlock;	/* Interrupt spin lock */
 	spinlock_t res_spinlock;	/* Shared resources spin lock */
@@ -502,24 +547,24 @@ struct pci230_private {
 	unsigned long state;	/* State flags */
 	unsigned long iobase1;	/* PCI230's I/O space 1 */
 	unsigned int ao_readback[2];	/* Used for AO readback */
-	unsigned int ai_scan_count;	/* Number of analogue input scans
-					 * remaining.  */
-	unsigned int ai_scan_pos;	/* Current position within analogue
-					 * input scan */
-	unsigned int ao_scan_count;	/* Number of analogue output scans
-					 * remaining.  */
+	/* Number of analogue input scans remaining.  */
+	unsigned int ai_scan_count;
+	/* Current position within analogue input scan */
+	unsigned int ai_scan_pos;
+	/* Number of analogue output scans remaining.  */
+	unsigned int ao_scan_count;
 	int intr_cpuid;		/* ID of CPU running interrupt routine. */
 	unsigned short hwver;	/* Hardware version (for '+' models). */
 	unsigned short adccon;	/* ADCCON register value. */
 	unsigned short daccon;	/* DACCON register value. */
-	unsigned short adcfifothresh;	/* ADC FIFO programmable interrupt
-					 * level threshold (PCI230+/260+). */
+	/* ADC FIFO programmable interrupt level threshold (PCI230+/260+). */
+	unsigned short adcfifothresh;
 	unsigned short adcg;	/* ADCG register value. */
 	unsigned char int_en;	/* Interrupt enables bits. */
-	unsigned char ai_bipolar;	/* Set if bipolar input range so we
-					 * know to mangle it. */
-	unsigned char ao_bipolar;	/* Set if bipolar output range so we
-					 * know to mangle it. */
+	/* Set if bipolar input range so we know to mangle it. */
+	unsigned char ai_bipolar;
+	/* Set if bipolar output range so we know to mangle it. */
+	unsigned char ao_bipolar;
 	unsigned char ier;	/* Copy of interrupt enables/status register. */
 	unsigned char intr_running;	/* Flag set in interrupt routine. */
 	unsigned char res_owner[NUM_RESOURCES];	/* Shared resource owners. */
@@ -572,13 +617,16 @@ static unsigned short pci230_ai_read(struct comedi_device *dev)
 
 	/* Read sample. */
 	data = inw(dev->iobase + PCI230_ADCDATA);
-	/* PCI230 is 12 bit - stored in upper bits of 16 bit register (lower
-	 * four bits reserved for expansion). */
-	/* PCI230+ is 16 bit AI. */
+	/*
+	 * PCI230 is 12 bit - stored in upper bits of 16 bit register
+	 * (lower four bits reserved for expansion).  PCI230+ is 16 bit AI.
+	 */
 	data = data >> (16 - thisboard->ai_bits);
 
-	/* If a bipolar range was specified, mangle it (twos
-	 * complement->straight binary). */
+	/*
+	 * If a bipolar range was specified, mangle it
+	 * (twos complement->straight binary).
+	 */
 	if (devpriv->ai_bipolar)
 		data ^= 1 << (thisboard->ai_bits - 1);
 
@@ -591,14 +639,17 @@ static inline unsigned short pci230_ao_mangle_datum(struct comedi_device *dev,
 	const struct pci230_board *thisboard = comedi_board(dev);
 	struct pci230_private *devpriv = dev->private;
 
-	/* If a bipolar range was specified, mangle it (straight binary->twos
-	 * complement). */
+	/*
+	 * If a bipolar range was specified, mangle it
+	 * (straight binary->twos complement).
+	 */
 	if (devpriv->ao_bipolar)
 		datum ^= 1 << (thisboard->ao_bits - 1);
 
-	/* PCI230 is 12 bit - stored in upper bits of 16 bit register (lower
-	 * four bits reserved for expansion). */
-	/* PCI230+ is also 12 bit AO. */
+	/*
+	 * PCI230 is 12 bit - stored in upper bits of 16 bit register (lower
+	 * four bits reserved for expansion).  PCI230+ is also 12 bit AO.
+	 */
 	datum <<= (16 - thisboard->ao_bits);
 	return datum;
 }
@@ -730,8 +781,10 @@ static unsigned int divide_ns(uint64_t ns, unsigned int timebase,
 	return div > UINT_MAX ? UINT_MAX : (unsigned int)div;
 }
 
-/* Given desired period in ns, returns the required internal clock source
- * and gets the initial count. */
+/*
+ * Given desired period in ns, returns the required internal clock source
+ * and gets the initial count.
+ */
 static unsigned int pci230_choose_clk_count(uint64_t ns, unsigned int *count,
 					    unsigned int flags)
 {
@@ -824,7 +877,8 @@ static int pci230_ai_rinsn(struct comedi_device *dev,
 		}
 	}
 
-	/* Use Z2-CT2 as a conversion trigger instead of the built-in
+	/*
+	 * Use Z2-CT2 as a conversion trigger instead of the built-in
 	 * software trigger, as otherwise triggering of differential channels
 	 * doesn't work properly for some versions of PCI230/260.  Also set
 	 * FIFO mode because the ADC busy bit only works for software triggers.
@@ -837,12 +891,16 @@ static int pci230_ai_rinsn(struct comedi_device *dev,
 		/* Differential. */
 		gainshift = chan * 2;
 		if (devpriv->hwver == 0) {
-			/* Original PCI230/260 expects both inputs of the
-			 * differential channel to be enabled. */
+			/*
+			 * Original PCI230/260 expects both inputs of the
+			 * differential channel to be enabled.
+			 */
 			adcen = 3 << gainshift;
 		} else {
-			/* PCI230+/260+ expects only one input of the
-			 * differential channel to be enabled. */
+			/*
+			 * PCI230+/260+ expects only one input of the
+			 * differential channel to be enabled.
+			 */
 			adcen = 1 << gainshift;
 		}
 		adccon |= PCI230_ADC_IM_DIF;
@@ -860,8 +918,10 @@ static int pci230_ai_rinsn(struct comedi_device *dev,
 		adccon |= PCI230_ADC_IR_UNI;
 
 
-	/* Enable only this channel in the scan list - otherwise by default
-	 * we'll get one sample from each channel. */
+	/*
+	 * Enable only this channel in the scan list - otherwise by default
+	 * we'll get one sample from each channel.
+	 */
 	outw(adcen, dev->iobase + PCI230_ADCEN);
 
 	/* Set gain for channel. */
@@ -873,8 +933,10 @@ static int pci230_ai_rinsn(struct comedi_device *dev,
 
 	/* Convert n samples */
 	for (n = 0; n < insn->n; n++) {
-		/* Trigger conversion by toggling Z2-CT2 output (finish with
-		 * output high). */
+		/*
+		 * Trigger conversion by toggling Z2-CT2 output
+		 * (finish with output high).
+		 */
 		i8254_set_mode(devpriv->iobase1 + PCI230_Z2_CT_BASE, 0, 2,
 			       I8254_MODE0);
 		i8254_set_mode(devpriv->iobase1 + PCI230_Z2_CT_BASE, 0, 2,
@@ -908,13 +970,17 @@ static int pci230_ao_winsn(struct comedi_device *dev,
 	chan = CR_CHAN(insn->chanspec);
 	range = CR_RANGE(insn->chanspec);
 
-	/* Set range - see analogue output range table; 0 => unipolar 10V,
-	 * 1 => bipolar +/-10V range scale */
+	/*
+	 * Set range - see analogue output range table; 0 => unipolar 10V,
+	 * 1 => bipolar +/-10V range scale
+	 */
 	devpriv->ao_bipolar = pci230_ao_bipolar[range];
 	outw(range, dev->iobase + PCI230_DACCON);
 
-	/* Writing a list of values to an AO channel is probably not
-	 * very useful, but that's how the interface is defined. */
+	/*
+	 * Writing a list of values to an AO channel is probably not
+	 * very useful, but that's how the interface is defined.
+	 */
 	for (i = 0; i < insn->n; i++) {
 		/* Write value to DAC and store it. */
 		pci230_ao_write_nofifo(dev, data[i], chan);
@@ -924,8 +990,10 @@ static int pci230_ao_winsn(struct comedi_device *dev,
 	return i;
 }
 
-/* AO subdevices should have a read insn as well as a write insn.
- * Usually this means copying a value stored in devpriv. */
+/*
+ * AO subdevices should have a read insn as well as a write insn.
+ * Usually this means copying a value stored in devpriv.
+ */
 static int pci230_ao_rinsn(struct comedi_device *dev,
 			   struct comedi_subdevice *s, struct comedi_insn *insn,
 			   unsigned int *data)
@@ -1026,10 +1094,11 @@ static int pci230_ao_cmdtest(struct comedi_device *dev,
 	err |= cfc_check_trigger_arg_is(&cmd->start_arg, 0);
 
 #define MAX_SPEED_AO	8000	/* 8000 ns => 125 kHz */
+/*
+ * Comedi limit due to unsigned int cmd.  Driver limit =
+ * 2^16 (16bit * counter) * 1000000ns (1kHz onboard clock) = 65.536s
+ */
 #define MIN_SPEED_AO	4294967295u	/* 4294967295ns = 4.29s */
-			/*- Comedi limit due to unsigned int cmd.  Driver limit
-			 * = 2^16 (16bit * counter) * 1000000ns (1kHz onboard
-			 * clock) = 65.536s */
 
 	switch (cmd->scan_begin_src) {
 	case TRIG_TIMER:
@@ -1039,15 +1108,19 @@ static int pci230_ao_cmdtest(struct comedi_device *dev,
 						 MIN_SPEED_AO);
 		break;
 	case TRIG_EXT:
-		/* External trigger - for PCI230+ hardware version 2 onwards. */
+		/*
+		 * External trigger - for PCI230+ hardware version 2 onwards.
+		 */
 		/* Trigger number must be 0. */
 		if ((cmd->scan_begin_arg & ~CR_FLAGS_MASK) != 0) {
 			cmd->scan_begin_arg = COMBINE(cmd->scan_begin_arg, 0,
 						      ~CR_FLAGS_MASK);
 			err |= -EINVAL;
 		}
-		/* The only flags allowed are CR_EDGE and CR_INVERT.  The
-		 * CR_EDGE flag is ignored. */
+		/*
+		 * The only flags allowed are CR_EDGE and CR_INVERT.
+		 * The CR_EDGE flag is ignored.
+		 */
 		if ((cmd->scan_begin_arg
 		     & (CR_FLAGS_MASK & ~(CR_EDGE | CR_INVERT))) != 0) {
 			cmd->scan_begin_arg = COMBINE(cmd->scan_begin_arg, 0,
@@ -1069,9 +1142,7 @@ static int pci230_ao_cmdtest(struct comedi_device *dev,
 	if (err)
 		return 3;
 
-	/* Step 4: fix up any arguments.
-	 * "argument conflict" returned by comedilib to user mode process
-	 * if this fails. */
+	/* Step 4: fix up any arguments */
 
 	if (cmd->scan_begin_src == TRIG_TIMER) {
 		tmp = cmd->scan_begin_arg;
@@ -1120,8 +1191,10 @@ static void pci230_ao_stop(struct comedi_device *dev,
 		/* Using DAC FIFO interrupt. */
 		intsrc = PCI230P2_INT_DAC;
 	}
-	/* Disable interrupt and wait for interrupt routine to finish running
-	 * unless we are called from the interrupt routine. */
+	/*
+	 * Disable interrupt and wait for interrupt routine to finish running
+	 * unless we are called from the interrupt routine.
+	 */
 	spin_lock_irqsave(&devpriv->isr_spinlock, irqflags);
 	devpriv->int_en &= ~intsrc;
 	while (devpriv->intr_running && devpriv->intr_cpuid != THISCPU) {
@@ -1134,8 +1207,10 @@ static void pci230_ao_stop(struct comedi_device *dev,
 	}
 	spin_unlock_irqrestore(&devpriv->isr_spinlock, irqflags);
 	if (devpriv->hwver >= 2) {
-		/* Using DAC FIFO.  Reset FIFO, clear underrun error,
-		 * disable FIFO. */
+		/*
+		 * Using DAC FIFO.  Reset FIFO, clear underrun error,
+		 * disable FIFO.
+		 */
 		devpriv->daccon &= PCI230_DAC_OR_MASK;
 		outw(devpriv->daccon | PCI230P2_DAC_FIFO_RESET
 		     | PCI230P2_DAC_FIFO_UNDERRUN_CLEAR,
@@ -1213,9 +1288,11 @@ static int pci230_handle_ao_fifo(struct comedi_device *dev,
 			dev_err(dev->class_dev, "AO FIFO underrun\n");
 			events |= COMEDI_CB_OVERFLOW | COMEDI_CB_ERROR;
 		}
-		/* Check for buffer underrun if FIFO less than half full
+		/*
+		 * Check for buffer underrun if FIFO less than half full
 		 * (otherwise there will be loads of "DAC FIFO not half full"
-		 * interrupts). */
+		 * interrupts).
+		 */
 		if ((num_scans == 0)
 		    && ((dacstat & PCI230P2_DAC_FIFO_HALF) == 0)) {
 			dev_err(dev->class_dev, "AO buffer underrun\n");
@@ -1251,9 +1328,11 @@ static int pci230_handle_ao_fifo(struct comedi_device *dev,
 		if (cmd->stop_src == TRIG_COUNT) {
 			devpriv->ao_scan_count -= num_scans;
 			if (devpriv->ao_scan_count == 0) {
-				/* All data for the command has been written
+				/*
+				 * All data for the command has been written
 				 * to FIFO.  Set FIFO interrupt trigger level
-				 * to 'empty'. */
+				 * to 'empty'.
+				 */
 				devpriv->daccon = (devpriv->daccon
 						   &
 						   ~PCI230P2_DAC_INT_FIFO_MASK)
@@ -1444,8 +1523,10 @@ static int pci230_ao_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	else	/* TRIG_NONE, user calls cancel */
 		devpriv->ao_scan_count = 0;
 
-	/* Set range - see analogue output range table; 0 => unipolar 10V,
-	 * 1 => bipolar +/-10V range scale */
+	/*
+	 * Set range - see analogue output range table; 0 => unipolar 10V,
+	 * 1 => bipolar +/-10V range scale
+	 */
 	range = CR_RANGE(cmd->chanlist[0]);
 	devpriv->ao_bipolar = pci230_ao_bipolar[range];
 	daccon = devpriv->ao_bipolar ? PCI230_DAC_OR_BIP : PCI230_DAC_OR_UNI;
@@ -1480,9 +1561,11 @@ static int pci230_ao_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	    & ~(PCI230P2_DAC_FIFO_RESET | PCI230P2_DAC_FIFO_UNDERRUN_CLEAR);
 
 	if (cmd->scan_begin_src == TRIG_TIMER) {
-		/* Set the counter timer 1 to the specified scan frequency. */
-		/* cmd->scan_begin_arg is sampling period in ns */
-		/* gate it off for now. */
+		/*
+		 * Set the counter timer 1 to the specified scan frequency.
+		 * cmd->scan_begin_arg is sampling period in ns.
+		 * Gate it off for now.
+		 */
 		outb(GAT_CONFIG(1, GAT_GND),
 		     devpriv->iobase1 + PCI230_ZGAT_SCE);
 		pci230_ct_setup_ns_mode(dev, 1, I8254_MODE3,
@@ -1688,17 +1771,20 @@ static int pci230_ai_cmdtest(struct comedi_device *dev,
 #define MAX_SPEED_AI_SE		3200	/* PCI230 SE:   3200 ns => 312.5 kHz */
 #define MAX_SPEED_AI_DIFF	8000	/* PCI230 DIFF: 8000 ns => 125 kHz */
 #define MAX_SPEED_AI_PLUS	4000	/* PCI230+:     4000 ns => 250 kHz */
+/*
+ * Comedi limit due to unsigned int cmd.  Driver limit =
+ * 2^16 (16bit * counter) * 1000000ns (1kHz onboard clock) = 65.536s
+ */
 #define MIN_SPEED_AI	4294967295u	/* 4294967295ns = 4.29s */
-			/*- Comedi limit due to unsigned int cmd.  Driver limit
-			 * = 2^16 (16bit * counter) * 1000000ns (1kHz onboard
-			 * clock) = 65.536s */
 
 	if (cmd->convert_src == TRIG_TIMER) {
 		unsigned int max_speed_ai;
 
 		if (devpriv->hwver == 0) {
-			/* PCI230 or PCI260.  Max speed depends whether
-			 * single-ended or pseudo-differential. */
+			/*
+			 * PCI230 or PCI260.  Max speed depends whether
+			 * single-ended or pseudo-differential.
+			 */
 			if (cmd->chanlist && (cmd->chanlist_len > 0)) {
 				/* Peek analogue reference of first channel. */
 				if (CR_AREF(cmd->chanlist[0]) == AREF_DIFF)
@@ -1735,8 +1821,10 @@ static int pci230_ai_cmdtest(struct comedi_device *dev,
 							   ~CR_FLAGS_MASK);
 				err |= -EINVAL;
 			}
-			/* The only flags allowed are CR_INVERT and CR_EDGE.
-			 * CR_EDGE is required. */
+			/*
+			 * The only flags allowed are CR_INVERT and CR_EDGE.
+			 * CR_EDGE is required.
+			 */
 			if ((cmd->convert_arg & (CR_FLAGS_MASK & ~CR_INVERT))
 			    != CR_EDGE) {
 				/* Set CR_EDGE, preserve CR_INVERT. */
@@ -1747,9 +1835,11 @@ static int pci230_ai_cmdtest(struct comedi_device *dev,
 				err |= -EINVAL;
 			}
 		} else {
-			/* Backwards compatibility with previous versions. */
-			/* convert_arg == 0 => trigger on -ve edge. */
-			/* convert_arg == 1 => trigger on +ve edge. */
+			/*
+			 * Backwards compatibility with previous versions:
+			 * convert_arg == 0 => trigger on -ve edge.
+			 * convert_arg == 1 => trigger on +ve edge.
+			 */
 			err |= cfc_check_trigger_arg_max(&cmd->convert_arg, 1);
 		}
 	} else {
@@ -1762,9 +1852,11 @@ static int pci230_ai_cmdtest(struct comedi_device *dev,
 		err |= cfc_check_trigger_arg_is(&cmd->stop_arg, 0);
 
 	if (cmd->scan_begin_src == TRIG_EXT) {
-		/* external "trigger" to begin each scan
+		/*
+		 * external "trigger" to begin each scan:
 		 * scan_begin_arg==0 => use PPC0 input -> gate of CT0 -> gate
-		 * of CT2 (sample convert trigger is CT2) */
+		 * of CT2 (sample convert trigger is CT2)
+		 */
 		if ((cmd->scan_begin_arg & ~CR_FLAGS_MASK) != 0) {
 			cmd->scan_begin_arg = COMBINE(cmd->scan_begin_arg, 0,
 						      ~CR_FLAGS_MASK);
@@ -1788,9 +1880,7 @@ static int pci230_ai_cmdtest(struct comedi_device *dev,
 	if (err)
 		return 3;
 
-	/* Step 4: fix up any arguments.
-	 * "argument conflict" returned by comedilib to user mode process
-	 * if this fails. */
+	/* Step 4: fix up any arguments */
 
 	if (cmd->convert_src == TRIG_TIMER) {
 		tmp = cmd->convert_arg;
@@ -1884,17 +1974,21 @@ static int pci230_ai_inttrig_convert(struct comedi_device *dev,
 	if (test_bit(AI_CMD_STARTED, &devpriv->state)) {
 		unsigned int delayus;
 
-		/* Trigger conversion by toggling Z2-CT2 output.  Finish
-		 * with output high. */
+		/*
+		 * Trigger conversion by toggling Z2-CT2 output.
+		 * Finish with output high.
+		 */
 		i8254_set_mode(devpriv->iobase1 + PCI230_Z2_CT_BASE, 0, 2,
 			       I8254_MODE0);
 		i8254_set_mode(devpriv->iobase1 + PCI230_Z2_CT_BASE, 0, 2,
 			       I8254_MODE1);
-		/* Delay.  Should driver be responsible for this?  An
+		/*
+		 * Delay.  Should driver be responsible for this?  An
 		 * alternative would be to wait until conversion is complete,
 		 * but we can't tell when it's complete because the ADC busy
 		 * bit has a different meaning when FIFO enabled (and when
-		 * FIFO not enabled, it only works for software triggers). */
+		 * FIFO not enabled, it only works for software triggers).
+		 */
 		if (((devpriv->adccon & PCI230_ADC_IM_MASK)
 		     == PCI230_ADC_IM_DIF)
 		    && (devpriv->hwver == 0)) {
@@ -1960,8 +2054,10 @@ static void pci230_ai_stop(struct comedi_device *dev,
 		pci230_cancel_ct(dev, 0);
 	}
 	spin_lock_irqsave(&devpriv->isr_spinlock, irqflags);
-	/* Disable ADC interrupt and wait for interrupt routine to finish
-	 * running unless we are called from the interrupt routine. */
+	/*
+	 * Disable ADC interrupt and wait for interrupt routine to finish
+	 * running unless we are called from the interrupt routine.
+	 */
 	devpriv->int_en &= ~PCI230_INT_ADC;
 	while (devpriv->intr_running && devpriv->intr_cpuid != THISCPU) {
 		spin_unlock_irqrestore(&devpriv->isr_spinlock, irqflags);
@@ -1972,8 +2068,10 @@ static void pci230_ai_stop(struct comedi_device *dev,
 		outb(devpriv->ier, devpriv->iobase1 + PCI230_INT_SCE);
 	}
 	spin_unlock_irqrestore(&devpriv->isr_spinlock, irqflags);
-	/* Reset FIFO, disable FIFO and set start conversion source to none.
-	 * Keep se/diff and bip/uni settings */
+	/*
+	 * Reset FIFO, disable FIFO and set start conversion source to none.
+	 * Keep se/diff and bip/uni settings.
+	 */
 	devpriv->adccon = (devpriv->adccon & (PCI230_ADC_IR_MASK
 					      | PCI230_ADC_IM_MASK)) |
 	    PCI230_ADC_TRIG_NONE;
@@ -2006,8 +2104,10 @@ static void pci230_ai_start(struct comedi_device *dev,
 		outb(devpriv->ier, devpriv->iobase1 + PCI230_INT_SCE);
 		spin_unlock_irqrestore(&devpriv->isr_spinlock, irqflags);
 
-		/* Update conversion trigger source which is currently set
-		 * to CT2 output, which is currently stuck high. */
+		/*
+		 * Update conversion trigger source which is currently set
+		 * to CT2 output, which is currently stuck high.
+		 */
 		switch (cmd->convert_src) {
 		default:
 			conv = PCI230_ADC_TRIG_NONE;
@@ -2037,8 +2137,10 @@ static void pci230_ai_start(struct comedi_device *dev,
 			}
 			break;
 		case TRIG_INT:
-			/* Use CT2 output for software trigger due to problems
-			 * in differential mode on PCI230/260. */
+			/*
+			 * Use CT2 output for software trigger due to problems
+			 * in differential mode on PCI230/260.
+			 */
 			conv = PCI230_ADC_TRIG_Z2CT2;
 			break;
 		}
@@ -2048,20 +2150,26 @@ static void pci230_ai_start(struct comedi_device *dev,
 		if (cmd->convert_src == TRIG_INT)
 			async->inttrig = pci230_ai_inttrig_convert;
 
-		/* Update FIFO interrupt trigger level, which is currently
-		 * set to "full".  */
+		/*
+		 * Update FIFO interrupt trigger level, which is currently
+		 * set to "full".
+		 */
 		pci230_ai_update_fifo_trigger_level(dev, s);
 		if (cmd->convert_src == TRIG_TIMER) {
 			/* Update timer gates. */
 			unsigned char zgat;
 
 			if (cmd->scan_begin_src != TRIG_FOLLOW) {
-				/* Conversion timer CT2 needs to be gated by
-				 * inverted output of monostable CT2. */
+				/*
+				 * Conversion timer CT2 needs to be gated by
+				 * inverted output of monostable CT2.
+				 */
 				zgat = GAT_CONFIG(2, GAT_NOUTNM2);
 			} else {
-				/* Conversion timer CT2 needs to be gated on
-				 * continuously. */
+				/*
+				 * Conversion timer CT2 needs to be gated on
+				 * continuously.
+				 */
 				zgat = GAT_CONFIG(2, GAT_VCC);
 			}
 			outb(zgat, devpriv->iobase1 + PCI230_ZGAT_SCE);
@@ -2103,8 +2211,10 @@ static void pci230_ai_start(struct comedi_device *dev,
 				outb(zgat, devpriv->iobase1 + PCI230_ZGAT_SCE);
 				switch (cmd->scan_begin_src) {
 				case TRIG_TIMER:
-					/* Scan period timer CT1 needs to be
-					 * gated on to start counting. */
+					/*
+					 * Scan period timer CT1 needs to be
+					 * gated on to start counting.
+					 */
 					zgat = GAT_CONFIG(1, GAT_VCC);
 					outb(zgat, devpriv->iobase1
 					     + PCI230_ZGAT_SCE);
@@ -2172,8 +2282,10 @@ static void pci230_handle_ai(struct comedi_device *dev,
 			/* Read FIFO state. */
 			status_fifo = inw(dev->iobase + PCI230_ADCCON);
 			if ((status_fifo & PCI230_ADC_FIFO_FULL_LATCHED) != 0) {
-				/* Report error otherwise FIFO overruns will go
-				 * unnoticed by the caller. */
+				/*
+				 * Report error otherwise FIFO overruns will go
+				 * unnoticed by the caller.
+				 */
 				dev_err(dev->class_dev, "AI FIFO overrun\n");
 				events |= COMEDI_CB_OVERFLOW | COMEDI_CB_ERROR;
 				break;
@@ -2247,8 +2359,10 @@ static int pci230_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	 * Determine which shared resources are needed.
 	 */
 	res_mask = 0;
-	/* Need Z2-CT2 to supply a conversion trigger source at a high
-	 * logic level, even if not doing timed conversions. */
+	/*
+	 * Need Z2-CT2 to supply a conversion trigger source at a high
+	 * logic level, even if not doing timed conversions.
+	 */
 	res_mask |= (1U << RES_Z2CT2);
 	if (cmd->scan_begin_src != TRIG_FOLLOW) {
 		/* Using Z2-CT0 monostable to gate Z2-CT2 conversion timer */
@@ -2270,7 +2384,8 @@ static int pci230_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 		devpriv->ai_scan_count = 0;
 	devpriv->ai_scan_pos = 0;	/* Position within scan. */
 
-	/* Steps;
+	/*
+	 * Steps:
 	 * - Set channel scan list.
 	 * - Set channel gains.
 	 * - Enable and reset FIFO, specify uni/bip, se/diff, and set
@@ -2315,12 +2430,16 @@ static int pci230_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 		if (diff) {
 			gainshift = 2 * chan;
 			if (devpriv->hwver == 0) {
-				/* Original PCI230/260 expects both inputs of
-				 * the differential channel to be enabled. */
+				/*
+				 * Original PCI230/260 expects both inputs of
+				 * the differential channel to be enabled.
+				 */
 				adcen |= 3 << gainshift;
 			} else {
-				/* PCI230+/260+ expects only one input of the
-				 * differential channel to be enabled. */
+				/*
+				 * PCI230+/260+ expects only one input of the
+				 * differential channel to be enabled.
+				 */
 				adcen |= 1 << gainshift;
 			}
 		} else {
@@ -2337,38 +2456,48 @@ static int pci230_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	/* Set channel gains. */
 	outw(devpriv->adcg, dev->iobase + PCI230_ADCG);
 
-	/* Set counter/timer 2 output high for use as the initial start
-	 * conversion source. */
+	/*
+	 * Set counter/timer 2 output high for use as the initial start
+	 * conversion source.
+	 */
 	i8254_set_mode(devpriv->iobase1 + PCI230_Z2_CT_BASE, 0, 2, I8254_MODE1);
 
-	/* Temporarily use CT2 output as conversion trigger source and
-	 * temporarily set FIFO interrupt trigger level to 'full'. */
+	/*
+	 * Temporarily use CT2 output as conversion trigger source and
+	 * temporarily set FIFO interrupt trigger level to 'full'.
+	 */
 	adccon |= PCI230_ADC_INT_FIFO_FULL | PCI230_ADC_TRIG_Z2CT2;
 
-	/* Enable and reset FIFO, specify FIFO trigger level full, specify
+	/*
+	 * Enable and reset FIFO, specify FIFO trigger level full, specify
 	 * uni/bip, se/diff, and temporarily set the start conversion source
 	 * to CT2 output.  Note that CT2 output is currently high, and this
 	 * will produce a false conversion trigger on some versions of the
-	 * PCI230/260, but that will be dealt with later. */
+	 * PCI230/260, but that will be dealt with later.
+	 */
 	devpriv->adccon = adccon;
 	outw(adccon | PCI230_ADC_FIFO_RESET, dev->iobase + PCI230_ADCCON);
 
-	/* Delay */
-	/* Failure to include this will result in the first few channels'-worth
+	/*
+	 * Delay -
+	 * Failure to include this will result in the first few channels'-worth
 	 * of data being corrupt, normally manifesting itself by large negative
 	 * voltages. It seems the board needs time to settle between the first
 	 * FIFO reset (above) and the second FIFO reset (below). Setting the
 	 * channel gains and scan list _before_ the first FIFO reset also
-	 * helps, though only slightly. */
+	 * helps, though only slightly.
+	 */
 	udelay(25);
 
 	/* Reset FIFO again. */
 	outw(adccon | PCI230_ADC_FIFO_RESET, dev->iobase + PCI230_ADCCON);
 
 	if (cmd->convert_src == TRIG_TIMER) {
-		/* Set up CT2 as conversion timer, but gate it off for now.
+		/*
+		 * Set up CT2 as conversion timer, but gate it off for now.
 		 * Note, counter/timer output 2 can be monitored on the
-		 * connector: PCI230 pin 21, PCI260 pin 18. */
+		 * connector: PCI230 pin 21, PCI260 pin 18.
+		 */
 		zgat = GAT_CONFIG(2, GAT_GND);
 		outb(zgat, devpriv->iobase1 + PCI230_ZGAT_SCE);
 		/* Set counter/timer 2 to the specified conversion period. */
@@ -2442,9 +2571,11 @@ static irqreturn_t pci230_interrupt(int irq, void *d)
 
 	spin_lock_irqsave(&devpriv->isr_spinlock, irqflags);
 	valid_status_int = devpriv->int_en & status_int;
-	/* Disable triggered interrupts.
+	/*
+	 * Disable triggered interrupts.
 	 * (Only those interrupts that need re-enabling, are, later in the
-	 * handler).  */
+	 * handler).
+	 */
 	devpriv->ier = devpriv->int_en & ~status_int;
 	outb(devpriv->ier, devpriv->iobase1 + PCI230_INT_SCE);
 	devpriv->intr_running = 1;
@@ -2501,8 +2632,10 @@ static bool pci230_match_pci_board(const struct pci230_board *board,
 	/* Looking for a '+' model.  First check length of registers. */
 	if (pci_resource_len(pci_dev, 3) < 32)
 		return false;	/* Not a '+' model. */
-	/* TODO: temporarily enable PCI device and read the hardware version
-	 * register.  For now, assume it's okay. */
+	/*
+	 * TODO: temporarily enable PCI device and read the hardware version
+	 * register.  For now, assume it's okay.
+	 */
 	return true;
 }
 
@@ -2591,8 +2724,10 @@ static int pci230_attach_common(struct comedi_device *dev,
 	if (rc)
 		return rc;
 
-	/* Read base addresses of the PCI230's two I/O regions from PCI
-	 * configuration register. */
+	/*
+	 * Read base addresses of the PCI230's two I/O regions from PCI
+	 * configuration register.
+	 */
 	iobase1 = pci_resource_start(pci_dev, 2);
 	iobase2 = pci_resource_start(pci_dev, 3);
 	dev_dbg(dev->class_dev,
@@ -2602,8 +2737,10 @@ static int pci230_attach_common(struct comedi_device *dev,
 	dev->iobase = iobase2;
 	/* Read bits of DACCON register - only the output range. */
 	devpriv->daccon = inw(dev->iobase + PCI230_DACCON) & PCI230_DAC_OR_MASK;
-	/* Read hardware version register and set extended function register
-	 * if they exist. */
+	/*
+	 * Read hardware version register and set extended function register
+	 * if they exist.
+	 */
 	if (pci_resource_len(pci_dev, 3) >= 32) {
 		unsigned short extfunc = 0;
 
@@ -2617,11 +2754,13 @@ static int pci230_attach_common(struct comedi_device *dev,
 		}
 		if (devpriv->hwver > 0) {
 			if (!thisboard->have_dio) {
-				/* No DIO ports.  Route counters' external gates
+				/*
+				 * No DIO ports.  Route counters' external gates
 				 * to the EXTTRIG signal (PCI260+ pin 17).
 				 * (Otherwise, they would be routed to DIO
 				 * inputs PC0, PC1 and PC2 which don't exist
-				 * on PCI260[+].) */
+				 * on PCI260[+].)
+				 */
 				extfunc |= PCI230P_EXTFUNC_GAT_EXTTRIG;
 			}
 			if ((thisboard->ao_chans > 0)
@@ -2632,8 +2771,10 @@ static int pci230_attach_common(struct comedi_device *dev,
 		}
 		outw(extfunc, dev->iobase + PCI230P_EXTFUNC);
 		if ((extfunc & PCI230P2_EXTFUNC_DACFIFO) != 0) {
-			/* Temporarily enable DAC FIFO, reset it and disable
-			 * FIFO wraparound. */
+			/*
+			 * Temporarily enable DAC FIFO, reset it and disable
+			 * FIFO wraparound.
+			 */
 			outw(devpriv->daccon | PCI230P2_DAC_FIFO_EN
 			     | PCI230P2_DAC_FIFO_RESET,
 			     dev->iobase + PCI230_DACCON);
-- 
2.0.0

