Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753078AbaIOMqq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 08:46:46 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:34909 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752935AbaIOMqb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 08:46:31 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 11/11] staging: comedi: remove comedi_fc module
Date: Mon, 15 Sep 2014 13:46:07 +0100
Message-Id: <1410785167-28506-12-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410785167-28506-1-git-send-email-abbotti@mev.co.uk>
References: <1410785167-28506-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All the exported functions in the "comedi_fc" module have been migrated
to the core "comedi" module and renamed, so it is now just a dummy
module.  Remove it.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/Kconfig             | 31 ------------------------
 drivers/staging/comedi/drivers/Makefile    |  1 -
 drivers/staging/comedi/drivers/comedi_fc.c | 38 ------------------------------
 3 files changed, 70 deletions(-)
 delete mode 100644 drivers/staging/comedi/drivers/comedi_fc.c

diff --git a/drivers/staging/comedi/Kconfig b/drivers/staging/comedi/Kconfig
index fd5f939..ea4948f 100644
--- a/drivers/staging/comedi/Kconfig
+++ b/drivers/staging/comedi/Kconfig
@@ -56,7 +56,6 @@ config COMEDI_BOND
 
 config COMEDI_TEST
 	tristate "Fake waveform generator support"
-	select COMEDI_FC
 	---help---
 	  Enable support for the fake waveform generator.
 	  This driver is mainly for testing purposes, but can also be used to
@@ -170,7 +169,6 @@ config COMEDI_PCL730
 config COMEDI_PCL812
 	tristate "Advantech PCL-812/813 and ADlink ACL-8112/8113/8113/8216"
 	depends on VIRT_TO_BUS && ISA_DMA_API
-	select COMEDI_FC
 	---help---
 	  Enable support for Advantech PCL-812/PG, PCL-813/B, ADLink
 	  ACL-8112DG/HG/PG, ACL-8113, ACL-8216, ICP DAS A-821PGH/PGL/PGL-NDA,
@@ -182,7 +180,6 @@ config COMEDI_PCL812
 config COMEDI_PCL816
 	tristate "Advantech PCL-814 and PCL-816 ISA card support"
 	depends on VIRT_TO_BUS && ISA_DMA_API
-	select COMEDI_FC
 	---help---
 	  Enable support for Advantech PCL-814 and PCL-816 ISA cards
 
@@ -192,7 +189,6 @@ config COMEDI_PCL816
 config COMEDI_PCL818
 	tristate "Advantech PCL-718 and PCL-818 ISA card support"
 	depends on VIRT_TO_BUS && ISA_DMA_API
-	select COMEDI_FC
 	---help---
 	  Enable support for Advantech PCL-818 ISA cards
 	  PCL-818L, PCL-818H, PCL-818HD, PCL-818HG, PCL-818 and PCL-718
@@ -264,7 +260,6 @@ config COMEDI_DAC02
 config COMEDI_DAS16M1
 	tristate "MeasurementComputing CIO-DAS16/M1DAS-16 ISA card support"
 	select COMEDI_8255
-	select COMEDI_FC
 	---help---
 	  Enable support for Measurement Computing CIO-DAS16/M1 ISA cards.
 
@@ -288,7 +283,6 @@ config COMEDI_DAS16
 	tristate "DAS-16 compatible ISA and PC/104 card support"
 	depends on ISA_DMA_API
 	select COMEDI_8255
-	select COMEDI_FC
 	---help---
 	  Enable support for Keithley Metrabyte/ComputerBoards DAS16
 	  and compatible ISA and PC/104 cards:
@@ -304,7 +298,6 @@ config COMEDI_DAS16
 
 config COMEDI_DAS800
 	tristate "DAS800 and compatible ISA card support"
-	select COMEDI_FC
 	---help---
 	  Enable support for Keithley Metrabyte DAS800 and compatible ISA cards
 	  Keithley Metrabyte DAS-800, DAS-801, DAS-802
@@ -317,7 +310,6 @@ config COMEDI_DAS800
 config COMEDI_DAS1800
 	tristate "DAS1800 and compatible ISA card support"
 	depends on VIRT_TO_BUS && ISA_DMA_API
-	select COMEDI_FC
 	---help---
 	  Enable support for DAS1800 and compatible ISA cards
 	  Keithley Metrabyte DAS-1701ST, DAS-1701ST-DA, DAS-1701/AO,
@@ -380,7 +372,6 @@ config COMEDI_DT2817
 
 config COMEDI_DT282X
 	tristate "Data Translation DT2821 series and DT-EZ ISA card support"
-	select COMEDI_FC
 	depends on VIRT_TO_BUS && ISA_DMA_API
 	---help---
 	  Enable support for Data Translation DT2821 series including DT-EZ
@@ -469,7 +460,6 @@ config COMEDI_ADQ12B
 
 config COMEDI_NI_AT_A2150
 	tristate "NI AT-A2150 ISA card support"
-	select COMEDI_FC
 	depends on VIRT_TO_BUS && ISA_DMA_API
 	---help---
 	  Enable support for National Instruments AT-A2150 cards
@@ -489,7 +479,6 @@ config COMEDI_NI_ATMIO
 	tristate "NI AT-MIO E series ISA-PNP card support"
 	select COMEDI_8255
 	select COMEDI_NI_TIO
-	select COMEDI_FC
 	---help---
 	  Enable support for National Instruments AT-MIO E series cards
 	  National Instruments AT-MIO-16E-1 (ni_atmio),
@@ -678,7 +667,6 @@ config COMEDI_ADDI_APCI_2200
 config COMEDI_ADDI_APCI_3120
 	tristate "ADDI-DATA APCI_3120/3001 support"
 	depends on VIRT_TO_BUS
-	select COMEDI_FC
 	---help---
 	  Enable support for ADDI-DATA APCI_3120/3001 cards
 
@@ -730,7 +718,6 @@ config COMEDI_ADL_PCI8164
 
 config COMEDI_ADL_PCI9111
 	tristate "ADLink PCI-9111HR support"
-	select COMEDI_FC
 	---help---
 	  Enable support for ADlink PCI9111 cards
 
@@ -739,7 +726,6 @@ config COMEDI_ADL_PCI9111
 
 config COMEDI_ADL_PCI9118
 	tristate "ADLink PCI-9118DG, PCI-9118HG, PCI-9118HR support"
-	select COMEDI_FC
 	depends on VIRT_TO_BUS
 	---help---
 	  Enable support for ADlink PCI-9118DG, PCI-9118HG, PCI-9118HR cards
@@ -749,7 +735,6 @@ config COMEDI_ADL_PCI9118
 
 config COMEDI_ADV_PCI1710
 	tristate "Advantech PCI-171x, PCI-1720 and PCI-1731 support"
-	select COMEDI_FC
 	---help---
 	  Enable support for Advantech PCI-1710, PCI-1710HG, PCI-1711,
 	  PCI-1713, PCI-1720 and PCI-1731
@@ -817,7 +802,6 @@ config COMEDI_AMPLC_PC263_PCI
 
 config COMEDI_AMPLC_PCI224
 	tristate "Amplicon PCI224 and PCI234 support"
-	select COMEDI_FC
 	---help---
 	  Enable support for Amplicon PCI224 and PCI234 AO boards
 
@@ -853,7 +837,6 @@ config COMEDI_DAS08_PCI
 
 config COMEDI_DT3000
 	tristate "Data Translation DT3000 series support"
-	select COMEDI_FC
 	---help---
 	  Enable support for Data Translation DT3000 series
 	  DT3001, DT3001-PGL, DT3002, DT3003, DT3003-PGL, DT3004, DT3005 and
@@ -873,7 +856,6 @@ config COMEDI_DYNA_PCI10XX
 
 config COMEDI_GSC_HPDI
 	tristate "General Standards PCI-HPDI32 / PMC-HPDI32 support"
-	select COMEDI_FC
 	---help---
 	  Enable support for General Standards Corporation high speed parallel
 	  digital interface rs485 boards PCI-HPDI32 and PMC-HPDI32.
@@ -924,7 +906,6 @@ config COMEDI_KE_COUNTER
 config COMEDI_CB_PCIDAS64
 	tristate "MeasurementComputing PCI-DAS 64xx, 60xx, and 4020 support"
 	select COMEDI_8255
-	select COMEDI_FC
 	---help---
 	  Enable support for ComputerBoards/MeasurementComputing PCI-DAS 64xx,
 	  60xx, and 4020 series with the PLX 9080 PCI controller
@@ -935,7 +916,6 @@ config COMEDI_CB_PCIDAS64
 config COMEDI_CB_PCIDAS
 	tristate "MeasurementComputing PCI-DAS support"
 	select COMEDI_8255
-	select COMEDI_FC
 	---help---
 	  Enable support for ComputerBoards/MeasurementComputing PCI-DAS with
 	  AMCC S5933 PCIcontroller: PCI-DAS1602/16, PCI-DAS1602/16jr,
@@ -1058,7 +1038,6 @@ config COMEDI_NI_PCIMIO
 	depends on HAS_DMA
 	select COMEDI_NI_TIOCMD
 	select COMEDI_8255
-	select COMEDI_FC
 	---help---
 	  Enable support for National Instruments PCI-MIO-E series and M series
 	  (all boards): PCI-MIO-16XE-10, PXI-6030E, PCI-MIO-16E-1,
@@ -1084,7 +1063,6 @@ config COMEDI_RTD520
 
 config COMEDI_S626
 	tristate "Sensoray 626 support"
-	select COMEDI_FC
 	---help---
 	  Enable support for Sensoray 626
 
@@ -1093,7 +1071,6 @@ config COMEDI_S626
 
 config COMEDI_MITE
 	depends on HAS_DMA
-	select COMEDI_FC
 	tristate
 
 config COMEDI_NI_TIOCMD
@@ -1161,7 +1138,6 @@ config COMEDI_NI_MIO_CS
 	tristate "NI DAQCard E series PCMCIA support"
 	select COMEDI_NI_TIO
 	select COMEDI_8255
-	select COMEDI_FC
 	---help---
 	  Enable support for the National Instruments PCMCIA DAQCard E series
 	  DAQCard-ai-16xe-50, DAQCard-ai-16e-4, DAQCard-6062E, DAQCard-6024E
@@ -1172,7 +1148,6 @@ config COMEDI_NI_MIO_CS
 
 config COMEDI_QUATECH_DAQP_CS
 	tristate "Quatech DAQP PCMCIA data capture card support"
-	select COMEDI_FC
 	---help---
 	  Enable support for the Quatech DAQP PCMCIA data capture cards
 	  DAQP-208 and DAQP-308
@@ -1219,7 +1194,6 @@ config COMEDI_USBDUX
 
 config COMEDI_USBDUXFAST
 	tristate "ITL USB-DUXfast support"
-	select COMEDI_FC
 	---help---
 	  Enable support for the Incite Technology Ltd USB-DUXfast Board
 
@@ -1228,7 +1202,6 @@ config COMEDI_USBDUXFAST
 
 config COMEDI_USBDUXSIGMA
 	tristate "ITL USB-DUXsigma support"
-	select COMEDI_FC
 	---help---
 	  Enable support for the Incite Technology Ltd USB-DUXsigma Board
 
@@ -1275,9 +1248,6 @@ config COMEDI_KCOMEDILIB
 	  To compile kcomedilib as a module, choose M here: the module will be
 	  called kcomedilib.
 
-config COMEDI_FC
-	tristate
-
 config COMEDI_AMPLC_DIO200
 	tristate
 
@@ -1292,7 +1262,6 @@ config COMEDI_DAS08
 config COMEDI_NI_LABPC
 	tristate
 	select COMEDI_8255
-	select COMEDI_FC
 
 config COMEDI_NI_LABPC_ISADMA
 	tristate
diff --git a/drivers/staging/comedi/drivers/Makefile b/drivers/staging/comedi/drivers/Makefile
index ba6f6e0..6bc9ef3 100644
--- a/drivers/staging/comedi/drivers/Makefile
+++ b/drivers/staging/comedi/drivers/Makefile
@@ -142,4 +142,3 @@ obj-$(CONFIG_COMEDI_8255)		+= 8255.o
 obj-$(CONFIG_COMEDI_AMPLC_DIO200)	+= amplc_dio200_common.o
 obj-$(CONFIG_COMEDI_AMPLC_PC236)	+= amplc_pc236_common.o
 obj-$(CONFIG_COMEDI_DAS08)		+= das08.o
-obj-$(CONFIG_COMEDI_FC)			+= comedi_fc.o
diff --git a/drivers/staging/comedi/drivers/comedi_fc.c b/drivers/staging/comedi/drivers/comedi_fc.c
deleted file mode 100644
index 6f99a1e..0000000
--- a/drivers/staging/comedi/drivers/comedi_fc.c
+++ /dev/null
@@ -1,38 +0,0 @@
-/*
- * comedi_fc.c
- * This is a place for code driver writers wish to share between
- * two or more drivers.  fc is short for frank-common.
- *
- * Author: Frank Mori Hess <fmhess@users.sourceforge.net>
- * Copyright (C) 2002 Frank Mori Hess
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- */
-
-#include <linux/module.h>
-#include "../comedidev.h"
-
-#include "comedi_fc.h"
-
-static int __init comedi_fc_init_module(void)
-{
-	return 0;
-}
-module_init(comedi_fc_init_module);
-
-static void __exit comedi_fc_cleanup_module(void)
-{
-}
-module_exit(comedi_fc_cleanup_module);
-
-MODULE_AUTHOR("Frank Mori Hess <fmhess@users.sourceforge.net>");
-MODULE_DESCRIPTION("Shared functions for Comedi low-level drivers");
-MODULE_LICENSE("GPL");
-- 
2.1.0

