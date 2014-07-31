Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751890AbaGaNsT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 09:48:19 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:57908 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751697AbaGaNsP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 09:48:15 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 16/18] staging: comedi: amplc_pci224: remove PCI_DEVICE_ID_... macros
Date: Thu, 31 Jul 2014 14:47:53 +0100
Message-Id: <1406814475-5923-17-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1406814475-5923-1-git-send-email-abbotti@mev.co.uk>
References: <1406814475-5923-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The macros `PCI_DEVICE_ID_AMPLICON_PCI224` and
`PCI_DEVICE_ID_AMPLICON_PCI234` are only used in the PCI module device
table `amplc_pci224_pci_table[]`.  Just expand the macros where they are
used and remove them.  The macro `PCI_DEVICE_ID_INVALID` is no longer
used either, so remove it.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/amplc_pci224.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/comedi/drivers/amplc_pci224.c b/drivers/staging/comedi/drivers/amplc_pci224.c
index 977894d..4fceb7c 100644
--- a/drivers/staging/comedi/drivers/amplc_pci224.c
+++ b/drivers/staging/comedi/drivers/amplc_pci224.c
@@ -113,13 +113,6 @@
 #include "8253.h"
 
 /*
- * PCI IDs.
- */
-#define PCI_DEVICE_ID_AMPLICON_PCI224 0x0007
-#define PCI_DEVICE_ID_AMPLICON_PCI234 0x0008
-#define PCI_DEVICE_ID_INVALID 0xffff
-
-/*
  * PCI224/234 i/o space 1 (PCIBAR2) registers.
  */
 #define PCI224_Z2_CT0	0x14	/* 82C54 counter/timer 0 */
@@ -1215,8 +1208,8 @@ static int amplc_pci224_pci_probe(struct pci_dev *dev,
 }
 
 static const struct pci_device_id amplc_pci224_pci_table[] = {
-	{ PCI_VDEVICE(AMPLICON, PCI_DEVICE_ID_AMPLICON_PCI224), pci224_model },
-	{ PCI_VDEVICE(AMPLICON, PCI_DEVICE_ID_AMPLICON_PCI234), pci234_model },
+	{ PCI_VDEVICE(AMPLICON, 0x0007), pci224_model },
+	{ PCI_VDEVICE(AMPLICON, 0x0008), pci234_model },
 	{ 0 }
 };
 MODULE_DEVICE_TABLE(pci, amplc_pci224_pci_table);
-- 
2.0.0

