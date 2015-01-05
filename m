Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544AbbAESIn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 13:08:43 -0500
Received: from smtp97.iad3a.emailsrvr.com ([173.203.187.97]:41569 "EHLO
	smtp97.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754072AbbAERzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 12:55:44 -0500
X-Sender-Id: abbotti@mev.co.uk
From: Ian Abbott <abbotti@mev.co.uk>
To: <driverdev-devel@linuxdriverproject.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 03/45] staging: comedi: adl_pci7x3x: rewrite comedi driver comment block
Date: Mon,  5 Jan 2015 17:54:31 +0000
Message-Id: <1420480513-14765-4-git-send-email-abbotti@mev.co.uk>
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

The original comment indicated the number of input and output channels
in each item on the "Devices:" line.  Move this information into a
separate paragraph moved from a block comment found elsewhere in the
driver.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/adl_pci7x3x.c | 62 +++++++++++++---------------
 1 file changed, 29 insertions(+), 33 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adl_pci7x3x.c b/drivers/staging/comedi/drivers/adl_pci7x3x.c
index fb8e5f5..618e641 100644
--- a/drivers/staging/comedi/drivers/adl_pci7x3x.c
+++ b/drivers/staging/comedi/drivers/adl_pci7x3x.c
@@ -22,27 +22,35 @@
  */
 
 /*
-Driver: adl_pci7x3x
-Description: 32/64-Channel Isolated Digital I/O Boards
-Devices: (ADLink) PCI-7230 [adl_pci7230] - 16 input / 16 output
-	 (ADLink) PCI-7233 [adl_pci7233] - 32 input
-	 (ADLink) PCI-7234 [adl_pci7234] - 32 output
-	 (ADLink) PCI-7432 [adl_pci7432] - 32 input / 32 output
-	 (ADLink) PCI-7433 [adl_pci7433] - 64 input
-	 (ADLink) PCI-7434 [adl_pci7434] - 64 output
-Author: H Hartley Sweeten <hsweeten@visionengravers.com>
-Updated: Thu, 02 Aug 2012 14:27:46 -0700
-Status: untested
-
-The PCI-7230, PCI-7432 and PCI-7433 boards also support external
-interrupt signals on digital input channels 0 and 1. The PCI-7233
-has dual-interrupt sources for change-of-state (COS) on any 16
-digital input channels of LSB and for COS on any 16 digital input
-lines of MSB. Interrupts are not currently supported by this
-driver.
-
-Configuration Options: not applicable, uses comedi PCI auto config
-*/
+ * Driver: adl_pci7x3x
+ * Description: 32/64-Channel Isolated Digital I/O Boards
+ * Devices: [ADLink] PCI-7230 (adl_pci7230), PCI-7233 (adl_pci7233),
+ *   PCI-7234 (adl_pci7234), PCI-7432 (adl_pci7432), PCI-7433 (adl_pci7433),
+ *   PCI-7434 (adl_pci7434)
+ * Author: H Hartley Sweeten <hsweeten@visionengravers.com>
+ * Updated: Thu, 02 Aug 2012 14:27:46 -0700
+ * Status: untested
+ *
+ * One or two subdevices are setup by this driver depending on
+ * the number of digital inputs and/or outputs provided by the
+ * board. Each subdevice has a maximum of 32 channels.
+ *
+ *	PCI-7230 - 2 subdevices: 0 - 16 input, 1 - 16 output
+ *	PCI-7233 - 1 subdevice: 0 - 32 input
+ *	PCI-7234 - 1 subdevice: 0 - 32 output
+ *	PCI-7432 - 2 subdevices: 0 - 32 input, 1 - 32 output
+ *	PCI-7433 - 2 subdevices: 0 - 32 input, 1 - 32 input
+ *	PCI-7434 - 2 subdevices: 0 - 32 output, 1 - 32 output
+ *
+ * The PCI-7230, PCI-7432 and PCI-7433 boards also support external
+ * interrupt signals on digital input channels 0 and 1. The PCI-7233
+ * has dual-interrupt sources for change-of-state (COS) on any 16
+ * digital input channels of LSB and for COS on any 16 digital input
+ * lines of MSB. Interrupts are not currently supported by this
+ * driver.
+ *
+ * Configuration Options: not applicable, uses comedi PCI auto config
+ */
 
 #include <linux/module.h>
 #include <linux/pci.h>
@@ -155,18 +163,6 @@ static int adl_pci7x3x_auto_attach(struct comedi_device *dev,
 		return ret;
 	dev->iobase = pci_resource_start(pcidev, 2);
 
-	/*
-	 * One or two subdevices are setup by this driver depending on
-	 * the number of digital inputs and/or outputs provided by the
-	 * board. Each subdevice has a maximum of 32 channels.
-	 *
-	 *	PCI-7230 - 2 subdevices: 0 - 16 input, 1 - 16 output
-	 *	PCI-7233 - 1 subdevice: 0 - 32 input
-	 *	PCI-7234 - 1 subdevice: 0 - 32 output
-	 *	PCI-7432 - 2 subdevices: 0 - 32 input, 1 - 32 output
-	 *	PCI-7433 - 2 subdevices: 0 - 32 input, 1 - 32 input
-	 *	PCI-7434 - 2 subdevices: 0 - 32 output, 1 - 32 output
-	 */
 	ret = comedi_alloc_subdevices(dev, board->nsubdevs);
 	if (ret)
 		return ret;
-- 
2.1.4

