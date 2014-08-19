Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067AbaHSRcM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 13:32:12 -0400
Received: from mga14.intel.com ([192.55.52.115]:32762 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753417AbaHSRcI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 13:32:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,896,1400050800"; 
   d="scan'208";a="578872014"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Vinod Koul <vinod.koul@intel.com>, Mark Brown <broonie@kernel.org>,
        Hein Tibosch <hein_tibosch@yahoo.es>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Takashi Iwai <tiwai@suse.de>,
        Kweh Hock Leong <hock.leong.kweh@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Alan Cox <alan@linux.intel.com>, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 12/12] serial: 8250_pci: Add PCI IDs for Intel Braswell
Date: Tue, 19 Aug 2014 20:29:23 +0300
Message-Id: <1408469363-15901-13-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1408469363-15901-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1408469363-15901-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Add new PCI IDs to cover newer Intel SoCs such as Braswell.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/tty/serial/8250/8250_pci.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/tty/serial/8250/8250_pci.c b/drivers/tty/serial/8250/8250_pci.c
index a00c9de..85a2eb9 100644
--- a/drivers/tty/serial/8250/8250_pci.c
+++ b/drivers/tty/serial/8250/8250_pci.c
@@ -1352,6 +1352,9 @@ ce4100_serial_setup(struct serial_private *priv,
 #define PCI_DEVICE_ID_INTEL_BYT_UART1	0x0f0a
 #define PCI_DEVICE_ID_INTEL_BYT_UART2	0x0f0c
 
+#define PCI_DEVICE_ID_INTEL_BSW_UART1	0x228a
+#define PCI_DEVICE_ID_INTEL_BSW_UART2	0x228c
+
 #define BYT_PRV_CLK			0x800
 #define BYT_PRV_CLK_EN			(1 << 0)
 #define BYT_PRV_CLK_M_VAL_SHIFT		1
@@ -1465,10 +1468,12 @@ byt_serial_setup(struct serial_private *priv,
 
 	switch (pdev->device) {
 	case PCI_DEVICE_ID_INTEL_BYT_UART1:
+	case PCI_DEVICE_ID_INTEL_BSW_UART1:
 		rx_param->src_id = 3;
 		tx_param->dst_id = 2;
 		break;
 	case PCI_DEVICE_ID_INTEL_BYT_UART2:
+	case PCI_DEVICE_ID_INTEL_BSW_UART2:
 		rx_param->src_id = 5;
 		tx_param->dst_id = 4;
 		break;
@@ -1927,6 +1932,20 @@ static struct pci_serial_quirk pci_serial_quirks[] __refdata = {
 		.subdevice	= PCI_ANY_ID,
 		.setup		= byt_serial_setup,
 	},
+	{
+		.vendor		= PCI_VENDOR_ID_INTEL,
+		.device		= PCI_DEVICE_ID_INTEL_BSW_UART1,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+		.setup		= byt_serial_setup,
+	},
+	{
+		.vendor		= PCI_VENDOR_ID_INTEL,
+		.device		= PCI_DEVICE_ID_INTEL_BSW_UART2,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+		.setup		= byt_serial_setup,
+	},
 	/*
 	 * ITE
 	 */
@@ -5219,6 +5238,14 @@ static struct pci_device_id serial_pci_tbl[] = {
 		PCI_ANY_ID,  PCI_ANY_ID,
 		PCI_CLASS_COMMUNICATION_SERIAL << 8, 0xff0000,
 		pbn_byt },
+	{	PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_BSW_UART1,
+		PCI_ANY_ID,  PCI_ANY_ID,
+		PCI_CLASS_COMMUNICATION_SERIAL << 8, 0xff0000,
+		pbn_byt },
+	{	PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_BSW_UART2,
+		PCI_ANY_ID,  PCI_ANY_ID,
+		PCI_CLASS_COMMUNICATION_SERIAL << 8, 0xff0000,
+		pbn_byt },
 
 	/*
 	 * Cronyx Omega PCI
-- 
2.1.0

