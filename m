Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146AbbAERzp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 12:55:45 -0500
Received: from smtp97.iad3a.emailsrvr.com ([173.203.187.97]:45132 "EHLO
	smtp97.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753697AbbAERzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 12:55:43 -0500
X-Sender-Id: abbotti@mev.co.uk
From: Ian Abbott <abbotti@mev.co.uk>
To: <driverdev-devel@linuxdriverproject.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 01/45] staging: comedi: 8255_pci: rewrite comedi driver comment block
Date: Mon,  5 Jan 2015 17:54:29 +0000
Message-Id: <1420480513-14765-2-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1420480513-14765-1-git-send-email-abbotti@mev.co.uk>
References: <1420480513-14765-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rewrite the comedi "driver" comment block to conform to the usual format
for comedi driver comment blocks and reformat it to use the usual block
comment style.  In particular, the "Devices:" line should be a
comma-separated list where the first item is in the following format:

  [Manufacturer] BOARD-NAME (comedi-board-name)

The "[Manufacturer]" and/or "(comedi-board-name)" parts may be omitted
from following items, in which case the parts from the preceding item
are used.  The "Devices:" line may be continued continued over several
lines by using one or more spaces at the start of each continuation line
(not counting the space after the "*" in the block comment).

The original comment indicated the number of DIO channels in each item
on the "Devices:" line.  Move this information into separate paragraphs.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/8255_pci.c | 65 ++++++++++++++++++-------------
 1 file changed, 38 insertions(+), 27 deletions(-)

diff --git a/drivers/staging/comedi/drivers/8255_pci.c b/drivers/staging/comedi/drivers/8255_pci.c
index 8b95898..9847642 100644
--- a/drivers/staging/comedi/drivers/8255_pci.c
+++ b/drivers/staging/comedi/drivers/8255_pci.c
@@ -22,33 +22,44 @@
  */
 
 /*
-Driver: 8255_pci
-Description: Generic PCI based 8255 Digital I/O boards
-Devices: (ADLink) PCI-7224 [adl_pci-7224] - 24 channels
-	 (ADLink) PCI-7248 [adl_pci-7248] - 48 channels
-	 (ADLink) PCI-7296 [adl_pci-7296] - 96 channels
-	 (Measurement Computing) PCI-DIO24 [cb_pci-dio24] - 24 channels
-	 (Measurement Computing) PCI-DIO24H [cb_pci-dio24h] - 24 channels
-	 (Measurement Computing) PCI-DIO48H [cb_pci-dio48h] - 48 channels
-	 (Measurement Computing) PCI-DIO96H [cb_pci-dio96h] - 96 channels
-	 (National Instruments) PCI-DIO-96 [ni_pci-dio-96] - 96 channels
-	 (National Instruments) PCI-DIO-96B [ni_pci-dio-96b] - 96 channels
-	 (National Instruments) PXI-6508 [ni_pxi-6508] - 96 channels
-	 (National Instruments) PCI-6503 [ni_pci-6503] - 24 channels
-	 (National Instruments) PCI-6503B [ni_pci-6503b] - 24 channels
-	 (National Instruments) PCI-6503X [ni_pci-6503x] - 24 channels
-	 (National Instruments) PXI-6503 [ni_pxi-6503] - 24 channels
-Author: H Hartley Sweeten <hsweeten@visionengravers.com>
-Updated: Wed, 12 Sep 2012 11:52:01 -0700
-Status: untested
-
-Some of these boards also have an 8254 programmable timer/counter
-chip. This chip is not currently supported by this driver.
-
-Interrupt support for these boards is also not currently supported.
-
-Configuration Options: not applicable, uses PCI auto config
-*/
+ * Driver: 8255_pci
+ * Description: Generic PCI based 8255 Digital I/O boards
+ * Devices: [ADLink] PCI-7224 (adl_pci-7224), PCI-7248 (adl_pci-7248),
+ *   PCI-7296 (adl_pci-7296),
+ *   [Measurement Computing] PCI-DIO24 (cb_pci-dio24),
+ *   PCI-DIO24H (cb_pci-dio24h), PCI-DIO48H (cb_pci-dio48h),
+ *   PCI-DIO96H (cb_pci-dio96h),
+ *   [National Instruments] PCI-DIO-96 (ni_pci-dio-96),
+ *   PCI-DIO-96B (ni_pci-dio-96b), PXI-6508 (ni_pxi-6508),
+ *   PCI-6503 (ni_pci-6503), PCI-6503B (ni_pci-6503b),
+ *   PCI-6503X (ni_pci-6503x), PXI-6503 (ni_pxi-6503)
+ * Author: H Hartley Sweeten <hsweeten@visionengravers.com>
+ * Updated: Wed, 12 Sep 2012 11:52:01 -0700
+ * Status: untested
+ *
+ * These boards have one or more 8255 digital I/O chips, each of which
+ * is supported as a separate 24-channel DIO subdevice.
+ *
+ * Boards with 24 DIO channels (1 DIO subdevice):
+ *
+ *   PCI-7224, PCI-DIO24, PCI-DIO24H, PCI-6503, PCI-6503B, PCI-6503X,
+ *   PXI-6503
+ *
+ * Boards with 48 DIO channels (2 DIO subdevices):
+ *
+ *   PCI-7248, PCI-DIO48H
+ *
+ * Boards with 96 DIO channels (4 DIO subdevices):
+ *
+ *   PCI-7296, PCI-DIO96H, PCI-DIO-96, PCI-DIO-96B, PXI-6508
+ *
+ * Some of these boards also have an 8254 programmable timer/counter
+ * chip.  This chip is not currently supported by this driver.
+ *
+ * Interrupt support for these boards is also not currently supported.
+ *
+ * Configuration Options: not applicable, uses PCI auto config.
+ */
 
 #include <linux/module.h>
 #include <linux/pci.h>
-- 
2.1.4

