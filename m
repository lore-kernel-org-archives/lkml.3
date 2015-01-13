Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263AbbAMVS1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 16:18:27 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:50645 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452AbbAMVS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 16:18:26 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] SCSI: initio: remove duplicate module device table
Date: Tue, 13 Jan 2015 22:18:23 +0100
Message-ID: <2519565.3zTHBMRR3g@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:7HoaF1+gl6ir7gqdlde5zl6+8cPcWpTUr4AEhl86fnFs5Lj3t/2
 13pMgg0nLQ3fyulLHfJ2OEYqg3lNwwvt+e+93OXQpxcB9kg3UsgBr7+D+fyDiNaXPsa5sxA
 luF/Fr63GJXgTGa+I3jSXfsQQw7812rNS1UlKI7dS5uK1nfOeH5zUy1esBs/Mjpay4ozmnt
 W09AI5hNmhk3RmeCdB1BQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The initio driver has for many years had two copies of the
same module device table. One of them is also used for registering
the other driver, the other one is entirely useless after the
large scale cleanup that Alan Cox did back in 2007.

The compiler warns about this whenever the driver is built-in:

drivers/scsi/initio.c:131:29: warning: 'i91u_pci_devices' defined but not used [-Wunused-variable]

This removes the extraneous table and the warning.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: 72d39fea901 ("[SCSI] initio: Convert into a real Linux driver and update to modern style")

diff --git a/drivers/scsi/initio.c b/drivers/scsi/initio.c
index e5dae7b54d9a..51063177f18e 100644
--- a/drivers/scsi/initio.c
+++ b/drivers/scsi/initio.c
@@ -110,11 +110,6 @@
 #define i91u_MAXQUEUE		2
 #define i91u_REVID "Initio INI-9X00U/UW SCSI device driver; Revision: 1.04a"
 
-#define I950_DEVICE_ID	0x9500	/* Initio's inic-950 product ID   */
-#define I940_DEVICE_ID	0x9400	/* Initio's inic-940 product ID   */
-#define I935_DEVICE_ID	0x9401	/* Initio's inic-935 product ID   */
-#define I920_DEVICE_ID	0x0002	/* Initio's other product ID      */
-
 #ifdef DEBUG_i91u
 static unsigned int i91u_debug = DEBUG_DEFAULT;
 #endif
@@ -127,17 +122,6 @@ static int setup_debug = 0;
 
 static void i91uSCBPost(u8 * pHcb, u8 * pScb);
 
-/* PCI Devices supported by this driver */
-static struct pci_device_id i91u_pci_devices[] = {
-	{ PCI_VENDOR_ID_INIT,  I950_DEVICE_ID, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{ PCI_VENDOR_ID_INIT,  I940_DEVICE_ID, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{ PCI_VENDOR_ID_INIT,  I935_DEVICE_ID, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{ PCI_VENDOR_ID_INIT,  I920_DEVICE_ID, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{ PCI_VENDOR_ID_DOMEX, I920_DEVICE_ID, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{ }
-};
-MODULE_DEVICE_TABLE(pci, i91u_pci_devices);
-
 #define DEBUG_INTERRUPT 0
 #define DEBUG_QUEUE     0
 #define DEBUG_STATE     0

