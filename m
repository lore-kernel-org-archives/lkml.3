Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751618AbaGaNsM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 09:48:12 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:57845 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750775AbaGaNsI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 09:48:08 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 01/18] staging: comedi: amplc_pci224: reformat some comments
Date: Thu, 31 Jul 2014 14:47:38 +0100
Message-Id: <1406814475-5923-2-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1406814475-5923-1-git-send-email-abbotti@mev.co.uk>
References: <1406814475-5923-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reformat comments to fit in with the preferred coding style, including
the copyright and comedi driver description comments at the start of the
file.  Also, remove a boiler-plate comment for the comedi device private
data structure.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/amplc_pci224.c | 214 +++++++++++++-------------
 1 file changed, 109 insertions(+), 105 deletions(-)

diff --git a/drivers/staging/comedi/drivers/amplc_pci224.c b/drivers/staging/comedi/drivers/amplc_pci224.c
index 45aba1f..72506bf 100644
--- a/drivers/staging/comedi/drivers/amplc_pci224.c
+++ b/drivers/staging/comedi/drivers/amplc_pci224.c
@@ -1,102 +1,103 @@
 /*
-    comedi/drivers/amplc_pci224.c
-    Driver for Amplicon PCI224 and PCI234 AO boards.
-
-    Copyright (C) 2005 MEV Ltd. <http://www.mev.co.uk/>
-
-    COMEDI - Linux Control and Measurement Device Interface
-    Copyright (C) 1998,2000 David A. Schleef <ds@schleef.org>
-
-    This program is free software; you can redistribute it and/or modify
-    it under the terms of the GNU General Public License as published by
-    the Free Software Foundation; either version 2 of the License, or
-    (at your option) any later version.
+ * comedi/drivers/amplc_pci224.c
+ * Driver for Amplicon PCI224 and PCI234 AO boards.
+ *
+ * Copyright (C) 2005 MEV Ltd. <http://www.mev.co.uk/>
+ *
+ * COMEDI - Linux Control and Measurement Device Interface
+ * Copyright (C) 1998,2000 David A. Schleef <ds@schleef.org>
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
-*/
 /*
-Driver: amplc_pci224
-Description: Amplicon PCI224, PCI234
-Author: Ian Abbott <abbotti@mev.co.uk>
-Devices: [Amplicon] PCI224 (amplc_pci224 or pci224),
-  PCI234 (amplc_pci224 or pci234)
-Updated: Wed, 22 Oct 2008 12:25:08 +0100
-Status: works, but see caveats
-
-Supports:
-
-  - ao_insn read/write
-  - ao_do_cmd mode with the following sources:
-
-    - start_src         TRIG_INT        TRIG_EXT
-    - scan_begin_src    TRIG_TIMER      TRIG_EXT
-    - convert_src       TRIG_NOW
-    - scan_end_src      TRIG_COUNT
-    - stop_src          TRIG_COUNT      TRIG_EXT        TRIG_NONE
-
-    The channel list must contain at least one channel with no repeated
-    channels.  The scan end count must equal the number of channels in
-    the channel list.
-
-    There is only one external trigger source so only one of start_src,
-    scan_begin_src or stop_src may use TRIG_EXT.
-
-Configuration options - PCI224:
-  [0] - PCI bus of device (optional).
-  [1] - PCI slot of device (optional).
-          If bus/slot is not specified, the first available PCI device
-          will be used.
-  [2] - Select available ranges according to jumper LK1.  All channels
-        are set to the same range:
-        0=Jumper position 1-2 (factory default), 4 software-selectable
-          internal voltage references, giving 4 bipolar and 4 unipolar
-          ranges:
-            [-10V,+10V], [-5V,+5V], [-2.5V,+2.5V], [-1.25V,+1.25V],
-            [0,+10V], [0,+5V], [0,+2.5V], [0,1.25V].
-        1=Jumper position 2-3, 1 external voltage reference, giving
-          1 bipolar and 1 unipolar range:
-            [-Vext,+Vext], [0,+Vext].
-
-Configuration options - PCI234:
-  [0] - PCI bus of device (optional).
-  [1] - PCI slot of device (optional).
-          If bus/slot is not specified, the first available PCI device
-          will be used.
-  [2] - Select internal or external voltage reference according to
-        jumper LK1.  This affects all channels:
-        0=Jumper position 1-2 (factory default), Vref=5V internal.
-        1=Jumper position 2-3, Vref=Vext external.
-  [3] - Select channel 0 range according to jumper LK2:
-        0=Jumper position 2-3 (factory default), range [-2*Vref,+2*Vref]
-          (10V bipolar when options[2]=0).
-        1=Jumper position 1-2, range [-Vref,+Vref]
-          (5V bipolar when options[2]=0).
-  [4] - Select channel 1 range according to jumper LK3: cf. options[3].
-  [5] - Select channel 2 range according to jumper LK4: cf. options[3].
-  [6] - Select channel 3 range according to jumper LK5: cf. options[3].
-
-Passing a zero for an option is the same as leaving it unspecified.
-
-Caveats:
-
-  1) All channels on the PCI224 share the same range.  Any change to the
-     range as a result of insn_write or a streaming command will affect
-     the output voltages of all channels, including those not specified
-     by the instruction or command.
-
-  2) For the analog output command,  the first scan may be triggered
-     falsely at the start of acquisition.  This occurs when the DAC scan
-     trigger source is switched from 'none' to 'timer' (scan_begin_src =
-     TRIG_TIMER) or 'external' (scan_begin_src == TRIG_EXT) at the start
-     of acquisition and the trigger source is at logic level 1 at the
-     time of the switch.  This is very likely for TRIG_TIMER.  For
-     TRIG_EXT, it depends on the state of the external line and whether
-     the CR_INVERT flag has been set.  The remaining scans are triggered
-     correctly.
-*/
+ * Driver: amplc_pci224
+ * Description: Amplicon PCI224, PCI234
+ * Author: Ian Abbott <abbotti@mev.co.uk>
+ * Devices: [Amplicon] PCI224 (amplc_pci224 or pci224),
+ *   PCI234 (amplc_pci224 or pci234)
+ * Updated: Wed, 22 Oct 2008 12:25:08 +0100
+ * Status: works, but see caveats
+ *
+ * Supports:
+ *
+ *   - ao_insn read/write
+ *   - ao_do_cmd mode with the following sources:
+ *
+ *     - start_src         TRIG_INT        TRIG_EXT
+ *     - scan_begin_src    TRIG_TIMER      TRIG_EXT
+ *     - convert_src       TRIG_NOW
+ *     - scan_end_src      TRIG_COUNT
+ *     - stop_src          TRIG_COUNT      TRIG_EXT        TRIG_NONE
+ *
+ *     The channel list must contain at least one channel with no repeated
+ *     channels.  The scan end count must equal the number of channels in
+ *     the channel list.
+ *
+ *     There is only one external trigger source so only one of start_src,
+ *     scan_begin_src or stop_src may use TRIG_EXT.
+ *
+ * Configuration options - PCI224:
+ *   [0] - PCI bus of device (optional).
+ *   [1] - PCI slot of device (optional).
+ *           If bus/slot is not specified, the first available PCI device
+ *           will be used.
+ *   [2] - Select available ranges according to jumper LK1.  All channels
+ *         are set to the same range:
+ *         0=Jumper position 1-2 (factory default), 4 software-selectable
+ *           internal voltage references, giving 4 bipolar and 4 unipolar
+ *           ranges:
+ *             [-10V,+10V], [-5V,+5V], [-2.5V,+2.5V], [-1.25V,+1.25V],
+ *             [0,+10V], [0,+5V], [0,+2.5V], [0,1.25V].
+ *         1=Jumper position 2-3, 1 external voltage reference, giving
+ *           1 bipolar and 1 unipolar range:
+ *             [-Vext,+Vext], [0,+Vext].
+ *
+ * Configuration options - PCI234:
+ *   [0] - PCI bus of device (optional).
+ *   [1] - PCI slot of device (optional).
+ *           If bus/slot is not specified, the first available PCI device
+ *           will be used.
+ *   [2] - Select internal or external voltage reference according to
+ *         jumper LK1.  This affects all channels:
+ *         0=Jumper position 1-2 (factory default), Vref=5V internal.
+ *         1=Jumper position 2-3, Vref=Vext external.
+ *   [3] - Select channel 0 range according to jumper LK2:
+ *         0=Jumper position 2-3 (factory default), range [-2*Vref,+2*Vref]
+ *           (10V bipolar when options[2]=0).
+ *         1=Jumper position 1-2, range [-Vref,+Vref]
+ *           (5V bipolar when options[2]=0).
+ *   [4] - Select channel 1 range according to jumper LK3: cf. options[3].
+ *   [5] - Select channel 2 range according to jumper LK4: cf. options[3].
+ *   [6] - Select channel 3 range according to jumper LK5: cf. options[3].
+ *
+ * Passing a zero for an option is the same as leaving it unspecified.
+ *
+ * Caveats:
+ *
+ *   1) All channels on the PCI224 share the same range.  Any change to the
+ *      range as a result of insn_write or a streaming command will affect
+ *      the output voltages of all channels, including those not specified
+ *      by the instruction or command.
+ *
+ *   2) For the analog output command,  the first scan may be triggered
+ *      falsely at the start of acquisition.  This occurs when the DAC scan
+ *      trigger source is switched from 'none' to 'timer' (scan_begin_src =
+ *      TRIG_TIMER) or 'external' (scan_begin_src == TRIG_EXT) at the start
+ *      of acquisition and the trigger source is at logic level 1 at the
+ *      time of the switch.  This is very likely for TRIG_TIMER.  For
+ *      TRIG_EXT, it depends on the state of the external line and whether
+ *      the CR_INVERT flag has been set.  The remaining scans are triggered
+ *      correctly.
+ */
 
 #include <linux/module.h>
 #include <linux/pci.h>
@@ -299,16 +300,20 @@ static const unsigned short hwrange_pci224_external[2] = {
 	PCI224_DACCON_POLAR_UNI,
 };
 
-/* The hardware selectable Vref*2 external range for PCI234
- * (option[2] == 1, option[3+n] == 0). */
+/*
+ * The hardware selectable Vref*2 external range for PCI234
+ * (option[2] == 1, option[3+n] == 0).
+ */
 static const struct comedi_lrange range_pci234_ext2 = {
 	1, {
 		RANGE_ext(-2, 2)
 	}
 };
 
-/* The hardware selectable Vref external range for PCI234
- * (option[2] == 1, option[3+n] == 1). */
+/*
+ * The hardware selectable Vref external range for PCI234
+ * (option[2] == 1, option[3+n] == 1).
+ */
 static const struct comedi_lrange range_pci234_ext = {
 	1, {
 		RANGE_ext(-1, 1)
@@ -356,9 +361,6 @@ static const struct pci224_board pci224_boards[] = {
 	 },
 };
 
-/* this structure is for data unique to this hardware driver.  If
-   several hardware drivers keep similar information in this structure,
-   feel free to suggest moving the variable to the struct comedi_device struct.  */
 struct pci224_private {
 	const unsigned short *hwrange;
 	unsigned long iobase1;
@@ -428,8 +430,10 @@ pci224_ao_insn_write(struct comedi_device *dev, struct comedi_subdevice *s,
 	chan = CR_CHAN(insn->chanspec);
 	range = CR_RANGE(insn->chanspec);
 
-	/* Writing a list of values to an AO channel is probably not
-	 * very useful, but that's how the interface is defined. */
+	/*
+	 * Writing a list of values to an AO channel is probably not
+	 * very useful, but that's how the interface is defined.
+	 */
 	for (i = 0; i < insn->n; i++)
 		pci224_ao_set_data(dev, chan, range, data[i]);
 
-- 
2.0.0

