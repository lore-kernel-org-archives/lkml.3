Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932561AbaGYJF1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 05:05:27 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:41146 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760102AbaGYJFW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 05:05:22 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 11/12] staging: comedi: amplc_pc236: remove PCI device ID macros
Date: Fri, 25 Jul 2014 10:04:57 +0100
Message-Id: <1406279098-8498-12-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1406279098-8498-1-git-send-email-abbotti@mev.co.uk>
References: <1406279098-8498-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The `PCI_DEVICE_ID_AMPLICON_PCI236` macro is only used once, in the
module device table, so remove it and expand the macro in the table.

`The `PCI_DEVICE_ID_INVALID` macro is no longer used, so remove it.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/amplc_pc236.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/comedi/drivers/amplc_pc236.c b/drivers/staging/comedi/drivers/amplc_pc236.c
index 1aae066..1a7fa45 100644
--- a/drivers/staging/comedi/drivers/amplc_pc236.c
+++ b/drivers/staging/comedi/drivers/amplc_pc236.c
@@ -57,10 +57,6 @@
 #define DO_ISA	IS_ENABLED(CONFIG_COMEDI_AMPLC_PC236_ISA)
 #define DO_PCI	IS_ENABLED(CONFIG_COMEDI_AMPLC_PC236_PCI)
 
-/* PCI236 PCI configuration register information */
-#define PCI_DEVICE_ID_AMPLICON_PCI236 0x0009
-#define PCI_DEVICE_ID_INVALID 0xffff
-
 /* PC36AT / PCI236 registers */
 
 /* Disable, and clear, interrupts */
@@ -407,8 +403,8 @@ static struct comedi_driver amplc_pc236_driver = {
 
 #if DO_PCI
 static const struct pci_device_id pc236_pci_table[] = {
-	{ PCI_DEVICE(PCI_VENDOR_ID_AMPLICON, PCI_DEVICE_ID_AMPLICON_PCI236) },
-	{0}
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMPLICON, 0x0009) },
+	{ 0 }
 };
 
 MODULE_DEVICE_TABLE(pci, pc236_pci_table);
-- 
2.0.0

