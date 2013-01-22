Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753686Ab3AVWhB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 17:37:01 -0500
Received: from mout.gmx.net ([212.227.17.20]:61151 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753360Ab3AVWg6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 17:36:58 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX19bCHlEUs9bxGacFoOjRf6ROTVLZO3ibk4seYuiCJ
	OgHSH2oGVmgLct
From: Peter Huewe <peterhuewe@gmx.de>
To: Ian Abbott <abbotti@mev.co.uk>
Cc: Mori Hess <fmhess@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH] staging/comedi: Use comedi_pci_auto_unconfig directly for pci_driver.remove
Date: Tue, 22 Jan 2013 23:40:03 +0100
Message-Id: <1358894403-26181-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.8.6
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Almost) all comedi pci drivers have some wrapper for their
pci_driver.remove function which simply calls comedi_pci_auto_unconfig
which has the same function prototype as the wrapper.

-> we can remove these wrappers and call comedi_pci_auto_unconfig
directly. This removes a lot some boilerplate code and saves some bytes.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
Maybe we should move the implementation now to drivers.c,
because now it cannot be inlined anymore. 
This would save some more bytes in the .kos but comedi_pci_auto_unconfig
then has to become an exported symbol.


 drivers/staging/comedi/drivers/8255_pci.c       |    7 +------
 drivers/staging/comedi/drivers/addi_apci_035.c  |    7 +------
 drivers/staging/comedi/drivers/addi_apci_1032.c |    7 +------
 drivers/staging/comedi/drivers/addi_apci_1500.c |    7 +------
 drivers/staging/comedi/drivers/addi_apci_1516.c |    7 +------
 drivers/staging/comedi/drivers/addi_apci_1564.c |    7 +------
 drivers/staging/comedi/drivers/addi_apci_16xx.c |    7 +------
 drivers/staging/comedi/drivers/addi_apci_1710.c |    7 +------
 drivers/staging/comedi/drivers/addi_apci_2032.c |    7 +------
 drivers/staging/comedi/drivers/addi_apci_2200.c |    7 +------
 drivers/staging/comedi/drivers/addi_apci_3120.c |    7 +------
 drivers/staging/comedi/drivers/addi_apci_3200.c |    7 +------
 drivers/staging/comedi/drivers/addi_apci_3501.c |    7 +------
 drivers/staging/comedi/drivers/addi_apci_3xxx.c |    7 +------
 drivers/staging/comedi/drivers/adl_pci6208.c    |    7 +------
 drivers/staging/comedi/drivers/adl_pci7x3x.c    |    7 +------
 drivers/staging/comedi/drivers/adl_pci8164.c    |    7 +------
 drivers/staging/comedi/drivers/adl_pci9111.c    |    7 +------
 drivers/staging/comedi/drivers/adl_pci9118.c    |    7 +------
 drivers/staging/comedi/drivers/adv_pci1710.c    |    7 +------
 drivers/staging/comedi/drivers/adv_pci1723.c    |    7 +------
 drivers/staging/comedi/drivers/adv_pci_dio.c    |    7 +------
 drivers/staging/comedi/drivers/amplc_dio200.c   |    7 +------
 drivers/staging/comedi/drivers/amplc_pc236.c    |    7 +------
 drivers/staging/comedi/drivers/amplc_pc263.c    |    7 +------
 drivers/staging/comedi/drivers/amplc_pci224.c   |    7 +------
 drivers/staging/comedi/drivers/amplc_pci230.c   |    7 +------
 drivers/staging/comedi/drivers/cb_pcidas.c      |    7 +------
 drivers/staging/comedi/drivers/cb_pcidas64.c    |    7 +------
 drivers/staging/comedi/drivers/cb_pcidda.c      |    7 +------
 drivers/staging/comedi/drivers/cb_pcimdas.c     |    7 +------
 drivers/staging/comedi/drivers/cb_pcimdda.c     |    7 +------
 drivers/staging/comedi/drivers/contec_pci_dio.c |    7 +------
 drivers/staging/comedi/drivers/daqboard2000.c   |    7 +------
 drivers/staging/comedi/drivers/das08.c          |    7 +------
 drivers/staging/comedi/drivers/dt3000.c         |    7 +------
 drivers/staging/comedi/drivers/dyna_pci10xx.c   |    7 +------
 drivers/staging/comedi/drivers/gsc_hpdi.c       |    7 +------
 drivers/staging/comedi/drivers/icp_multi.c      |    7 +------
 drivers/staging/comedi/drivers/jr3_pci.c        |    7 +------
 drivers/staging/comedi/drivers/ke_counter.c     |    7 +------
 drivers/staging/comedi/drivers/me4000.c         |    7 +------
 drivers/staging/comedi/drivers/me_daq.c         |    7 +------
 drivers/staging/comedi/drivers/ni_6527.c        |    7 +------
 drivers/staging/comedi/drivers/ni_65xx.c        |    7 +------
 drivers/staging/comedi/drivers/ni_660x.c        |    7 +------
 drivers/staging/comedi/drivers/ni_670x.c        |    7 +------
 drivers/staging/comedi/drivers/ni_labpc.c       |    7 +------
 drivers/staging/comedi/drivers/ni_pcidio.c      |    7 +------
 drivers/staging/comedi/drivers/ni_pcimio.c      |    7 +------
 drivers/staging/comedi/drivers/rtd520.c         |    7 +------
 drivers/staging/comedi/drivers/s626.c           |    7 +------
 drivers/staging/comedi/drivers/skel.c           |    7 +------
 53 files changed, 53 insertions(+), 318 deletions(-)

diff --git a/drivers/staging/comedi/drivers/8255_pci.c b/drivers/staging/comedi/drivers/8255_pci.c
index e0a7952..87fe96d 100644
--- a/drivers/staging/comedi/drivers/8255_pci.c
+++ b/drivers/staging/comedi/drivers/8255_pci.c
@@ -314,11 +314,6 @@ static int pci_8255_pci_probe(struct pci_dev *dev,
 	return comedi_pci_auto_config(dev, &pci_8255_driver);
 }
 
-static void pci_8255_pci_remove(struct pci_dev *dev)
-{
-	comedi_pci_auto_unconfig(dev);
-}
-
 static DEFINE_PCI_DEVICE_TABLE(pci_8255_pci_table) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_ADLINK, PCI_DEVICE_ID_ADLINK_PCI7224) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_ADLINK, PCI_DEVICE_ID_ADLINK_PCI7248) },
@@ -342,7 +337,7 @@ static struct pci_driver pci_8255_pci_driver = {
 	.name		= "8255_pci",
 	.id_table	= pci_8255_pci_table,
 	.probe		= pci_8255_pci_probe,
-	.remove		= pci_8255_pci_remove,
+	.remove		= comedi_pci_auto_unconfig,
 };
 module_comedi_pci_driver(pci_8255_driver, pci_8255_pci_driver);
 
diff --git a/drivers/staging/comedi/drivers/addi_apci_035.c b/drivers/staging/comedi/drivers/addi_apci_035.c
index c981d4b..d69d6ec 100644
--- a/drivers/staging/comedi/drivers/addi_apci_035.c
+++ b/drivers/staging/comedi/drivers/addi_apci_035.c
@@ -53,11 +53,6 @@ static int apci035_pci_probe(struct pci_dev *dev,
 	return comedi_pci_auto_config(dev, &apci035_driver);
 }
 
-static void apci035_pci_remove(struct pci_dev *dev)
-{
-	comedi_pci_auto_unconfig(dev);
-}
-
 static DEFINE_PCI_DEVICE_TABLE(apci035_pci_table) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_ADDIDATA,  0x0300) },
 	{ 0 }
@@ -68,7 +63,7 @@ static struct pci_driver apci035_pci_driver = {
 	.name		= "addi_apci_035",
 	.id_table	= apci035_pci_table,
 	.probe		= apci035_pci_probe,
-	.remove		= apci035_pci_remove,
+	.remove		= comedi_pci_auto_unconfig,
 };
 module_comedi_pci_driver(apci035_driver, apci035_pci_driver);
 
diff --git a/drivers/staging/comedi/drivers/addi_apci_1032.c b/drivers/staging/comedi/drivers/addi_apci_1032.c
index 7f94242..d2abfc2 100644
--- a/drivers/staging/comedi/drivers/addi_apci_1032.c
+++ b/drivers/staging/comedi/drivers/addi_apci_1032.c
@@ -375,11 +375,6 @@ static int apci1032_pci_probe(struct pci_dev *dev,
 	return comedi_pci_auto_config(dev, &apci1032_driver);
 }
 
-static void apci1032_pci_remove(struct pci_dev *dev)
-{
-	comedi_pci_auto_unconfig(dev);
-}
-
 static DEFINE_PCI_DEVICE_TABLE(apci1032_pci_table) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_ADDIDATA, 0x1003) },
 	{ 0 }
@@ -390,7 +385,7 @@ static struct pci_driver apci1032_pci_driver = {
 	.name		= "addi_apci_1032",
 	.id_table	= apci1032_pci_table,
 	.probe		= apci1032_pci_probe,
-	.remove		= apci1032_pci_remove,
+	.remove		= comedi_pci_auto_unconfig,
 };
 module_comedi_pci_driver(apci1032_driver, apci1032_pci_driver);
 
diff --git a/drivers/staging/comedi/drivers/addi_apci_1500.c b/drivers/staging/comedi/drivers/addi_apci_1500.c
index 8e686a9..1ac4062 100644
--- a/drivers/staging/comedi/drivers/addi_apci_1500.c
+++ b/drivers/staging/comedi/drivers/addi_apci_1500.c
@@ -53,11 +53,6 @@ static int apci1500_pci_probe(struct pci_dev *dev,
 	return comedi_pci_auto_config(dev, &apci1500_driver);
 }
 
-static void apci1500_pci_remove(struct pci_dev *dev)
-{
-	comedi_pci_auto_unconfig(dev);
-}
-
 static DEFINE_PCI_DEVICE_TABLE(apci1500_pci_table) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_ADDIDATA_OLD, 0x80fc) },
 	{ 0 }
@@ -68,7 +63,7 @@ static struct pci_driver apci1500_pci_driver = {
 	.name		= "addi_apci_1500",
 	.id_table	= apci1500_pci_table,
 	.probe		= apci1500_pci_probe,
-	.remove		= apci1500_pci_remove,
+	.remove		= comedi_pci_auto_unconfig,
 };
 module_comedi_pci_driver(apci1500_driver, apci1500_pci_driver);
 
diff --git a/drivers/staging/comedi/drivers/addi_apci_1516.c b/drivers/staging/comedi/drivers/addi_apci_1516.c
index 8fef04b..0911516 100644
--- a/drivers/staging/comedi/drivers/addi_apci_1516.c
+++ b/drivers/staging/comedi/drivers/addi_apci_1516.c
@@ -323,11 +323,6 @@ static int apci1516_pci_probe(struct pci_dev *dev,
 	return comedi_pci_auto_config(dev, &apci1516_driver);
 }
 
-static void apci1516_pci_remove(struct pci_dev *dev)
-{
-	comedi_pci_auto_unconfig(dev);
-}
-
 static DEFINE_PCI_DEVICE_TABLE(apci1516_pci_table) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_ADDIDATA, PCI_DEVICE_ID_APCI1016) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_ADDIDATA, PCI_DEVICE_ID_APCI1516) },
@@ -340,7 +335,7 @@ static struct pci_driver apci1516_pci_driver = {
 	.name		= "addi_apci_1516",
 	.id_table	= apci1516_pci_table,
 	.probe		= apci1516_pci_probe,
-	.remove		= apci1516_pci_remove,
+	.remove		= comedi_pci_auto_unconfig,
 };
 module_comedi_pci_driver(apci1516_driver, apci1516_pci_driver);
 
diff --git a/drivers/staging/comedi/drivers/addi_apci_1564.c b/drivers/staging/comedi/drivers/addi_apci_1564.c
index 513e536..3556c61 100644
--- a/drivers/staging/comedi/drivers/addi_apci_1564.c
+++ b/drivers/staging/comedi/drivers/addi_apci_1564.c
@@ -50,11 +50,6 @@ static int apci1564_pci_probe(struct pci_dev *dev,
 	return comedi_pci_auto_config(dev, &apci1564_driver);
 }
 
-static void apci1564_pci_remove(struct pci_dev *dev)
-{
-	comedi_pci_auto_unconfig(dev);
-}
-
 static DEFINE_PCI_DEVICE_TABLE(apci1564_pci_table) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_ADDIDATA, 0x1006) },
 	{ 0 }
@@ -65,7 +60,7 @@ static struct pci_driver apci1564_pci_driver = {
 	.name		= "addi_apci_1564",
 	.id_table	= apci1564_pci_table,
 	.probe		= apci1564_pci_probe,
-	.remove		= apci1564_pci_remove,
+	.remove		= comedi_pci_auto_unconfig,
 };
 module_comedi_pci_driver(apci1564_driver, apci1564_pci_driver);
 
diff --git a/drivers/staging/comedi/drivers/addi_apci_16xx.c b/drivers/staging/comedi/drivers/addi_apci_16xx.c
index a04d66c..8b88503 100644
--- a/drivers/staging/comedi/drivers/addi_apci_16xx.c
+++ b/drivers/staging/comedi/drivers/addi_apci_16xx.c
@@ -228,11 +228,6 @@ static int apci16xx_pci_probe(struct pci_dev *dev,
 	return comedi_pci_auto_config(dev, &apci16xx_driver);
 }
 
-static void apci16xx_pci_remove(struct pci_dev *dev)
-{
-	comedi_pci_auto_unconfig(dev);
-}
-
 static DEFINE_PCI_DEVICE_TABLE(apci16xx_pci_table) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_ADDIDATA, PCI_DEVICE_ID_APCI1648) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_ADDIDATA, PCI_DEVICE_ID_APCI1696) },
@@ -244,7 +239,7 @@ static struct pci_driver apci16xx_pci_driver = {
 	.name		= "addi_apci_16xx",
 	.id_table	= apci16xx_pci_table,
 	.probe		= apci16xx_pci_probe,
-	.remove		= apci16xx_pci_remove,
+	.remove		= comedi_pci_auto_unconfig,
 };
 module_comedi_pci_driver(apci16xx_driver, apci16xx_pci_driver);
 
diff --git a/drivers/staging/comedi/drivers/addi_apci_1710.c b/drivers/staging/comedi/drivers/addi_apci_1710.c
index 152e7ef..7eb03b1 100644
--- a/drivers/staging/comedi/drivers/addi_apci_1710.c
+++ b/drivers/staging/comedi/drivers/addi_apci_1710.c
@@ -128,11 +128,6 @@ static int apci1710_pci_probe(struct pci_dev *dev,
 	return comedi_pci_auto_config(dev, &apci1710_driver);
 }
 
-static void apci1710_pci_remove(struct pci_dev *dev)
-{
-	comedi_pci_auto_unconfig(dev);
-}
-
 static DEFINE_PCI_DEVICE_TABLE(apci1710_pci_table) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_ADDIDATA_OLD, APCI1710_BOARD_DEVICE_ID) },
 	{ 0 }
@@ -143,7 +138,7 @@ static struct pci_driver apci1710_pci_driver = {
 	.name		= "addi_apci_1710",
 	.id_table	= apci1710_pci_table,
 	.probe		= apci1710_pci_probe,
-	.remove		= apci1710_pci_remove,
+	.remove		= comedi_pci_auto_unconfig,
 };
 module_comedi_pci_driver(apci1710_driver, apci1710_pci_driver);
 
diff --git a/drivers/staging/comedi/drivers/addi_apci_2032.c b/drivers/staging/comedi/drivers/addi_apci_2032.c
index 4660ec7..5ad9db9 100644
--- a/drivers/staging/comedi/drivers/addi_apci_2032.c
+++ b/drivers/staging/comedi/drivers/addi_apci_2032.c
@@ -376,11 +376,6 @@ static int apci2032_pci_probe(struct pci_dev *dev,
 	return comedi_pci_auto_config(dev, &apci2032_driver);
 }
 
-static void apci2032_pci_remove(struct pci_dev *dev)
-{
-	comedi_pci_auto_unconfig(dev);
-}
-
 static DEFINE_PCI_DEVICE_TABLE(apci2032_pci_table) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_ADDIDATA, 0x1004) },
 	{ 0 }
@@ -391,7 +386,7 @@ static struct pci_driver apci2032_pci_driver = {
 	.name		= "addi_apci_2032",
 	.id_table	= apci2032_pci_table,
 	.probe		= apci2032_pci_probe,
-	.remove		= apci2032_pci_remove,
+	.remove		= comedi_pci_auto_unconfig,
 };
 module_comedi_pci_driver(apci2032_driver, apci2032_pci_driver);
 
diff --git a/drivers/staging/comedi/drivers/addi_apci_2200.c b/drivers/staging/comedi/drivers/addi_apci_2200.c
index 4092faa..a9891b4 100644
--- a/drivers/staging/comedi/drivers/addi_apci_2200.c
+++ b/drivers/staging/comedi/drivers/addi_apci_2200.c
@@ -153,11 +153,6 @@ static int apci2200_pci_probe(struct pci_dev *dev,
 	return comedi_pci_auto_config(dev, &apci2200_driver);
 }
 
-static void apci2200_pci_remove(struct pci_dev *dev)
-{
-	comedi_pci_auto_unconfig(dev);
-}
-
 static DEFINE_PCI_DEVICE_TABLE(apci2200_pci_table) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_ADDIDATA, 0x1005) },
 	{ 0 }
@@ -168,7 +163,7 @@ static struct pci_driver apci2200_pci_driver = {
 	.name		= "addi_apci_2200",
 	.id_table	= apci2200_pci_table,
 	.probe		= apci2200_pci_probe,
-	.remove		= apci2200_pci_remove,
+	.remove		= comedi_pci_auto_unconfig,
 };
 module_comedi_pci_driver(apci2200_driver, apci2200_pci_driver);
 
diff --git a/drivers/staging/comedi/drivers/addi_apci_3120.c b/drivers/staging/comedi/drivers/addi_apci_3120.c
index fec2962..8cad18f 100644
--- a/drivers/staging/comedi/drivers/addi_apci_3120.c
+++ b/drivers/staging/comedi/drivers/addi_apci_3120.c
@@ -251,11 +251,6 @@ static int apci3120_pci_probe(struct pci_dev *dev,
 	return comedi_pci_auto_config(dev, &apci3120_driver);
 }
 
-static void apci3120_pci_remove(struct pci_dev *dev)
-{
-	comedi_pci_auto_unconfig(dev);
-}
-
 static DEFINE_PCI_DEVICE_TABLE(apci3120_pci_table) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_ADDIDATA_OLD, 0x818d) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_ADDIDATA_OLD, 0x828d) },
@@ -267,7 +262,7 @@ static struct pci_driver apci3120_pci_driver = {
 	.name		= "addi_apci_3120",
 	.id_table	= apci3120_pci_table,
 	.probe		= apci3120_pci_probe,
-	.remove		= apci3120_pci_remove,
+	.remove		= comedi_pci_auto_unconfig,
 };
 module_comedi_pci_driver(apci3120_driver, apci3120_pci_driver);
 
diff --git a/drivers/staging/comedi/drivers/addi_apci_3200.c b/drivers/staging/comedi/drivers/addi_apci_3200.c
index 9085b77..c11bf4b 100644
--- a/drivers/staging/comedi/drivers/addi_apci_3200.c
+++ b/drivers/staging/comedi/drivers/addi_apci_3200.c
@@ -106,15 +106,10 @@ static int apci3200_pci_probe(struct pci_dev *dev,
 	return comedi_pci_auto_config(dev, &apci3200_driver);
 }
 
-static void apci3200_pci_remove(struct pci_dev *dev)
-{
-	comedi_pci_auto_unconfig(dev);
-}
-
 static struct pci_driver apci3200_pci_driver = {
 	.name		= "addi_apci_3200",
 	.id_table	= apci3200_pci_table,
 	.probe		= apci3200_pci_probe,
-	.remove		= apci3200_pci_remove,
+	.remove		= comedi_pci_auto_unconfig,
 };
 module_comedi_pci_driver(apci3200_driver, apci3200_pci_driver);
diff --git a/drivers/staging/comedi/drivers/addi_apci_3501.c b/drivers/staging/comedi/drivers/addi_apci_3501.c
index ed297de..bb862df 100644
--- a/drivers/staging/comedi/drivers/addi_apci_3501.c
+++ b/drivers/staging/comedi/drivers/addi_apci_3501.c
@@ -57,16 +57,11 @@ static int apci3501_pci_probe(struct pci_dev *dev,
 	return comedi_pci_auto_config(dev, &apci3501_driver);
 }
 
-static void apci3501_pci_remove(struct pci_dev *dev)
-{
-	comedi_pci_auto_unconfig(dev);
-}
-
 static struct pci_driver apci3501_pci_driver = {
 	.name		= "addi_apci_3501",
 	.id_table	= apci3501_pci_table,
 	.probe		= apci3501_pci_probe,
-	.remove		= apci3501_pci_remove,
+	.remove		= comedi_pci_auto_unconfig,
 };
 module_comedi_pci_driver(apci3501_driver, apci3501_pci_driver);
 
diff --git a/drivers/staging/comedi/drivers/addi_apci_3xxx.c b/drivers/staging/comedi/drivers/addi_apci_3xxx.c
index 1562347..69f5bf4 100644
--- a/drivers/staging/comedi/drivers/addi_apci_3xxx.c
+++ b/drivers/staging/comedi/drivers/addi_apci_3xxx.c
@@ -751,11 +751,6 @@ static int apci3xxx_pci_probe(struct pci_dev *dev,
 	return comedi_pci_auto_config(dev, &apci3xxx_driver);
 }
 
-static void apci3xxx_pci_remove(struct pci_dev *dev)
-{
-	comedi_pci_auto_unconfig(dev);
-}
-
 static DEFINE_PCI_DEVICE_TABLE(apci3xxx_pci_table) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_ADDIDATA, 0x3010) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_ADDIDATA, 0x300f) },
@@ -790,7 +785,7 @@ static struct pci_driver apci3xxx_pci_driver = {
 	.name		= "addi_apci_3xxx",
 	.id_table	= apci3xxx_pci_table,
 	.probe		= apci3xxx_pci_probe,
-	.remove		= apci3xxx_pci_remove,
+	.remove		= comedi_pci_auto_unconfig,
 };
 module_comedi_pci_driver(apci3xxx_driver, apci3xxx_pci_driver);
 
diff --git a/drivers/staging/comedi/drivers/adl_pci6208.c b/drivers/staging/comedi/drivers/adl_pci6208.c
index 9a56eed..41df010 100644
--- a/drivers/staging/comedi/drivers/adl_pci6208.c
+++ b/drivers/staging/comedi/drivers/adl_pci6208.c
@@ -270,11 +270,6 @@ static int adl_pci6208_pci_probe(struct pci_dev *dev,
 	return comedi_pci_auto_config(dev, &adl_pci6208_driver);
 }
 
-static void adl_pci6208_pci_remove(struct pci_dev *dev)
-{
-	comedi_pci_auto_unconfig(dev);
-}
-
 static DEFINE_PCI_DEVICE_TABLE(adl_pci6208_pci_table) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_ADLINK, PCI_DEVICE_ID_PCI6208) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_ADLINK, PCI_DEVICE_ID_PCI6216) },
@@ -286,7 +281,7 @@ static struct pci_driver adl_pci6208_pci_driver = {
 	.name		= "adl_pci6208",
 	.id_table	= adl_pci6208_pci_table,
 	.probe		= adl_pci6208_pci_probe,
-	.remove		= adl_pci6208_pci_remove,
+	.remove		= comedi_pci_auto_unconfig,
 };
 module_comedi_pci_driver(adl_pci6208_driver, adl_pci6208_pci_driver);
 
diff --git a/drivers/staging/comedi/drivers/adl_pci7x3x.c b/drivers/staging/comedi/drivers/adl_pci7x3x.c
index 772edc0..2a8bc98 100644
--- a/drivers/staging/comedi/drivers/adl_pci7x3x.c
+++ b/drivers/staging/comedi/drivers/adl_pci7x3x.c
@@ -302,11 +302,6 @@ static int adl_pci7x3x_pci_probe(struct pci_dev *dev,
 	return comedi_pci_auto_config(dev, &adl_pci7x3x_driver);
 }
 
-static void adl_pci7x3x_pci_remove(struct pci_dev *dev)
-{
-	comedi_pci_auto_unconfig(dev);
-}
-
 static DEFINE_PCI_DEVICE_TABLE(adl_pci7x3x_pci_table) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_ADLINK, PCI_DEVICE_ID_PCI7230) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_ADLINK, PCI_DEVICE_ID_PCI7233) },
@@ -322,7 +317,7 @@ static struct pci_driver adl_pci7x3x_pci_driver = {
 	.name		= "adl_pci7x3x",
 	.id_table	= adl_pci7x3x_pci_table,
 	.probe		= adl_pci7x3x_pci_probe,
-	.remove		= adl_pci7x3x_pci_remove,
+	.remove		= comedi_pci_auto_unconfig,
 };
 module_comedi_pci_driver(adl_pci7x3x_driver, adl_pci7x3x_pci_driver);
 
diff --git a/drivers/staging/comedi/drivers/adl_pci8164.c b/drivers/staging/comedi/drivers/adl_pci8164.c
index 4dd9d70..bfa71e0 100644
--- a/drivers/staging/comedi/drivers/adl_pci8164.c
+++ b/drivers/staging/comedi/drivers/adl_pci8164.c
@@ -298,11 +298,6 @@ static int adl_pci8164_pci_probe(struct pci_dev *dev,
 	return comedi_pci_auto_config(dev, &adl_pci8164_driver);
 }
 
-static void adl_pci8164_pci_remove(struct pci_dev *dev)
-{
-	comedi_pci_auto_unconfig(dev);
-}
-
 static DEFINE_PCI_DEVICE_TABLE(adl_pci8164_pci_table) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_ADLINK, PCI_DEVICE_ID_PCI8164) },
 	{0}
@@ -313,7 +308,7 @@ static struct pci_driver adl_pci8164_pci_driver = {
 	.name		= "adl_pci8164",
 	.id_table	= adl_pci8164_pci_table,
 	.probe		= adl_pci8164_pci_probe,
-	.remove		= adl_pci8164_pci_remove,
+	.remove		= comedi_pci_auto_unconfig,
 };
 module_comedi_pci_driver(adl_pci8164_driver, adl_pci8164_pci_driver);
 
diff --git a/drivers/staging/comedi/drivers/adl_pci9111.c b/drivers/staging/comedi/drivers/adl_pci9111.c
index a339b9d..1a31e91 100644
--- a/drivers/staging/comedi/drivers/adl_pci9111.c
+++ b/drivers/staging/comedi/drivers/adl_pci9111.c
@@ -963,11 +963,6 @@ static int pci9111_pci_probe(struct pci_dev *dev,
 	return comedi_pci_auto_config(dev, &adl_pci9111_driver);
 }
 
-static void pci9111_pci_remove(struct pci_dev *dev)
-{
-	comedi_pci_auto_unconfig(dev);
-}
-
 static DEFINE_PCI_DEVICE_TABLE(pci9111_pci_table) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_ADLINK, PCI9111_HR_DEVICE_ID) },
 	/* { PCI_DEVICE(PCI_VENDOR_ID_ADLINK, PCI9111_HG_DEVICE_ID) }, */
@@ -979,7 +974,7 @@ static struct pci_driver adl_pci9111_pci_driver = {
 	.name		= "adl_pci9111",
 	.id_table	= pci9111_pci_table,
 	.probe		= pci9111_pci_probe,
-	.remove		= pci9111_pci_remove,
+	.remove		= comedi_pci_auto_unconfig,
 };
 module_comedi_pci_driver(adl_pci9111_driver, adl_pci9111_pci_driver);
 
diff --git a/drivers/staging/comedi/drivers/adl_pci9118.c b/drivers/staging/comedi/drivers/adl_pci9118.c
index b6dda80..d21dfe6 100644
--- a/drivers/staging/comedi/drivers/adl_pci9118.c
+++ b/drivers/staging/comedi/drivers/adl_pci9118.c
@@ -2225,11 +2225,6 @@ static int adl_pci9118_pci_probe(struct pci_dev *dev,
 	return comedi_pci_auto_config(dev, &adl_pci9118_driver);
 }
 
-static void adl_pci9118_pci_remove(struct pci_dev *dev)
-{
-	comedi_pci_auto_unconfig(dev);
-}
-
 static DEFINE_PCI_DEVICE_TABLE(adl_pci9118_pci_table) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMCC, 0x80d9) },
 	{ 0 }
@@ -2240,7 +2235,7 @@ static struct pci_driver adl_pci9118_pci_driver = {
 	.name		= "adl_pci9118",
 	.id_table	= adl_pci9118_pci_table,
 	.probe		= adl_pci9118_pci_probe,
-	.remove		= adl_pci9118_pci_remove,
+	.remove		= comedi_pci_auto_unconfig,
 };
 module_comedi_pci_driver(adl_pci9118_driver, adl_pci9118_pci_driver);
 
diff --git a/drivers/staging/comedi/drivers/adv_pci1710.c b/drivers/staging/comedi/drivers/adv_pci1710.c
index a6fd8c2..d232d0c 100644
--- a/drivers/staging/comedi/drivers/adv_pci1710.c
+++ b/drivers/staging/comedi/drivers/adv_pci1710.c
@@ -1402,11 +1402,6 @@ static int adv_pci1710_pci_probe(struct pci_dev *dev,
 	return comedi_pci_auto_config(dev, &adv_pci1710_driver);
 }
 
-static void adv_pci1710_pci_remove(struct pci_dev *dev)
-{
-	comedi_pci_auto_unconfig(dev);
-}
-
 static DEFINE_PCI_DEVICE_TABLE(adv_pci1710_pci_table) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_ADVANTECH, 0x1710) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_ADVANTECH, 0x1711) },
@@ -1421,7 +1416,7 @@ static struct pci_driver adv_pci1710_pci_driver = {
 	.name		= "adv_pci1710",
 	.id_table	= adv_pci1710_pci_table,
 	.probe		= adv_pci1710_pci_probe,
-	.remove		= adv_pci1710_pci_remove,
+	.remove		= comedi_pci_auto_unconfig,
 };
 module_comedi_pci_driver(adv_pci1710_driver, adv_pci1710_pci_driver);
 
diff --git a/drivers/staging/comedi/drivers/adv_pci1723.c b/drivers/staging/comedi/drivers/adv_pci1723.c
index 5af7314..1be8902 100644
--- a/drivers/staging/comedi/drivers/adv_pci1723.c
+++ b/drivers/staging/comedi/drivers/adv_pci1723.c
@@ -327,11 +327,6 @@ static int adv_pci1723_pci_probe(struct pci_dev *dev,
 	return comedi_pci_auto_config(dev, &adv_pci1723_driver);
 }
 
-static void adv_pci1723_pci_remove(struct pci_dev *dev)
-{
-	comedi_pci_auto_unconfig(dev);
-}
-
 static DEFINE_PCI_DEVICE_TABLE(adv_pci1723_pci_table) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_ADVANTECH, 0x1723) },
 	{ 0 }
@@ -342,7 +337,7 @@ static struct pci_driver adv_pci1723_pci_driver = {
 	.name		= "adv_pci1723",
 	.id_table	= adv_pci1723_pci_table,
 	.probe		= adv_pci1723_pci_probe,
-	.remove		= adv_pci1723_pci_remove,
+	.remove		= comedi_pci_auto_unconfig,
 };
 module_comedi_pci_driver(adv_pci1723_driver, adv_pci1723_pci_driver);
 
diff --git a/drivers/staging/comedi/drivers/adv_pci_dio.c b/drivers/staging/comedi/drivers/adv_pci_dio.c
index 05a663e..35887e4 100644
--- a/drivers/staging/comedi/drivers/adv_pci_dio.c
+++ b/drivers/staging/comedi/drivers/adv_pci_dio.c
@@ -1206,11 +1206,6 @@ static int adv_pci_dio_pci_probe(struct pci_dev *dev,
 	return comedi_pci_auto_config(dev, &adv_pci_dio_driver);
 }
 
-static void adv_pci_dio_pci_remove(struct pci_dev *dev)
-{
-	comedi_pci_auto_unconfig(dev);
-}
-
 static DEFINE_PCI_DEVICE_TABLE(adv_pci_dio_pci_table) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_ADVANTECH, 0x1730) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_ADVANTECH, 0x1733) },
@@ -1234,7 +1229,7 @@ static struct pci_driver adv_pci_dio_pci_driver = {
 	.name		= "adv_pci_dio",
 	.id_table	= adv_pci_dio_pci_table,
 	.probe		= adv_pci_dio_pci_probe,
-	.remove		= adv_pci_dio_pci_remove,
+	.remove		= comedi_pci_auto_unconfig,
 };
 module_comedi_pci_driver(adv_pci_dio_driver, adv_pci_dio_pci_driver);
 
diff --git a/drivers/staging/comedi/drivers/amplc_dio200.c b/drivers/staging/comedi/drivers/amplc_dio200.c
index b09269d..1fadf5d 100644
--- a/drivers/staging/comedi/drivers/amplc_dio200.c
+++ b/drivers/staging/comedi/drivers/amplc_dio200.c
@@ -2078,16 +2078,11 @@ static int amplc_dio200_pci_probe(struct pci_dev *dev,
 	return comedi_pci_auto_config(dev, &amplc_dio200_driver);
 }
 
-static void amplc_dio200_pci_remove(struct pci_dev *dev)
-{
-	comedi_pci_auto_unconfig(dev);
-}
-
 static struct pci_driver amplc_dio200_pci_driver = {
 	.name = DIO200_DRIVER_NAME,
 	.id_table = dio200_pci_table,
 	.probe = &amplc_dio200_pci_probe,
-	.remove = &amplc_dio200_pci_remove
+	.remove		= comedi_pci_auto_unconfig,
 };
 module_comedi_pci_driver(amplc_dio200_driver, amplc_dio200_pci_driver);
 #else
diff --git a/drivers/staging/comedi/drivers/amplc_pc236.c b/drivers/staging/comedi/drivers/amplc_pc236.c
index 2898354..5011016 100644
--- a/drivers/staging/comedi/drivers/amplc_pc236.c
+++ b/drivers/staging/comedi/drivers/amplc_pc236.c
@@ -614,16 +614,11 @@ static int amplc_pc236_pci_probe(struct pci_dev *dev,
 	return comedi_pci_auto_config(dev, &amplc_pc236_driver);
 }
 
-static void amplc_pc236_pci_remove(struct pci_dev *dev)
-{
-	comedi_pci_auto_unconfig(dev);
-}
-
 static struct pci_driver amplc_pc236_pci_driver = {
 	.name = PC236_DRIVER_NAME,
 	.id_table = pc236_pci_table,
 	.probe = &amplc_pc236_pci_probe,
-	.remove = &amplc_pc236_pci_remove
+	.remove		= comedi_pci_auto_unconfig,
 };
 
 module_comedi_pci_driver(amplc_pc236_driver, amplc_pc236_pci_driver);
diff --git a/drivers/staging/comedi/drivers/amplc_pc263.c b/drivers/staging/comedi/drivers/amplc_pc263.c
index dfbff77..c34bb00 100644
--- a/drivers/staging/comedi/drivers/amplc_pc263.c
+++ b/drivers/staging/comedi/drivers/amplc_pc263.c
@@ -372,16 +372,11 @@ static int amplc_pc263_pci_probe(struct pci_dev *dev,
 	return comedi_pci_auto_config(dev, &amplc_pc263_driver);
 }
 
-static void amplc_pc263_pci_remove(struct pci_dev *dev)
-{
-	comedi_pci_auto_unconfig(dev);
-}
-
 static struct pci_driver amplc_pc263_pci_driver = {
 	.name = PC263_DRIVER_NAME,
 	.id_table = pc263_pci_table,
 	.probe = &amplc_pc263_pci_probe,
-	.remove = &amplc_pc263_pci_remove
+	.remove		= comedi_pci_auto_unconfig,
 };
 module_comedi_pci_driver(amplc_pc263_driver, amplc_pc263_pci_driver);
 #else
diff --git a/drivers/staging/comedi/drivers/amplc_pci224.c b/drivers/staging/comedi/drivers/amplc_pci224.c
index 6e2566a..24794f4 100644
--- a/drivers/staging/comedi/drivers/amplc_pci224.c
+++ b/drivers/staging/comedi/drivers/amplc_pci224.c
@@ -1512,11 +1512,6 @@ static int amplc_pci224_pci_probe(struct pci_dev *dev,
 	return comedi_pci_auto_config(dev, &amplc_pci224_driver);
 }
 
-static void amplc_pci224_pci_remove(struct pci_dev *dev)
-{
-	comedi_pci_auto_unconfig(dev);
-}
-
 static DEFINE_PCI_DEVICE_TABLE(amplc_pci224_pci_table) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMPLICON, PCI_DEVICE_ID_AMPLICON_PCI224) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMPLICON, PCI_DEVICE_ID_AMPLICON_PCI234) },
@@ -1528,7 +1523,7 @@ static struct pci_driver amplc_pci224_pci_driver = {
 	.name		= "amplc_pci224",
 	.id_table	= amplc_pci224_pci_table,
 	.probe		= amplc_pci224_pci_probe,
-	.remove		= amplc_pci224_pci_remove,
+	.remove		= comedi_pci_auto_unconfig,
 };
 module_comedi_pci_driver(amplc_pci224_driver, amplc_pci224_pci_driver);
 
diff --git a/drivers/staging/comedi/drivers/amplc_pci230.c b/drivers/staging/comedi/drivers/amplc_pci230.c
index 366c68b..2440596 100644
--- a/drivers/staging/comedi/drivers/amplc_pci230.c
+++ b/drivers/staging/comedi/drivers/amplc_pci230.c
@@ -2863,11 +2863,6 @@ static int amplc_pci230_pci_probe(struct pci_dev *dev,
 	return comedi_pci_auto_config(dev, &amplc_pci230_driver);
 }
 
-static void amplc_pci230_pci_remove(struct pci_dev *dev)
-{
-	comedi_pci_auto_unconfig(dev);
-}
-
 static DEFINE_PCI_DEVICE_TABLE(amplc_pci230_pci_table) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMPLICON, PCI_DEVICE_ID_PCI230) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMPLICON, PCI_DEVICE_ID_PCI260) },
@@ -2879,7 +2874,7 @@ static struct pci_driver amplc_pci230_pci_driver = {
 	.name		= "amplc_pci230",
 	.id_table	= amplc_pci230_pci_table,
 	.probe		= amplc_pci230_pci_probe,
-	.remove		= amplc_pci230_pci_remove
+	.remove		= comedi_pci_auto_unconfig,
 };
 module_comedi_pci_driver(amplc_pci230_driver, amplc_pci230_pci_driver);
 
diff --git a/drivers/staging/comedi/drivers/cb_pcidas.c b/drivers/staging/comedi/drivers/cb_pcidas.c
index aed6863..0fd6fcf 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas.c
@@ -1632,11 +1632,6 @@ static int cb_pcidas_pci_probe(struct pci_dev *dev,
 	return comedi_pci_auto_config(dev, &cb_pcidas_driver);
 }
 
-static void cb_pcidas_pci_remove(struct pci_dev *dev)
-{
-	comedi_pci_auto_unconfig(dev);
-}
-
 static DEFINE_PCI_DEVICE_TABLE(cb_pcidas_pci_table) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_CB, 0x0001) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_CB, 0x000f) },
@@ -1654,7 +1649,7 @@ static struct pci_driver cb_pcidas_pci_driver = {
 	.name		= "cb_pcidas",
 	.id_table	= cb_pcidas_pci_table,
 	.probe		= cb_pcidas_pci_probe,
-	.remove		= cb_pcidas_pci_remove
+	.remove		= comedi_pci_auto_unconfig,
 };
 module_comedi_pci_driver(cb_pcidas_driver, cb_pcidas_pci_driver);
 
diff --git a/drivers/staging/comedi/drivers/cb_pcidas64.c b/drivers/staging/comedi/drivers/cb_pcidas64.c
index d72b46c..e7d2977 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas64.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas64.c
@@ -4220,11 +4220,6 @@ static int cb_pcidas64_pci_probe(struct pci_dev *dev,
 	return comedi_pci_auto_config(dev, &cb_pcidas64_driver);
 }
 
-static void cb_pcidas64_pci_remove(struct pci_dev *dev)
-{
-	comedi_pci_auto_unconfig(dev);
-}
-
 static DEFINE_PCI_DEVICE_TABLE(cb_pcidas64_pci_table) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_CB, 0x001d) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_CB, 0x001e) },
@@ -4253,7 +4248,7 @@ static struct pci_driver cb_pcidas64_pci_driver = {
 	.name		= "cb_pcidas64",
 	.id_table	= cb_pcidas64_pci_table,
 	.probe		= cb_pcidas64_pci_probe,
-	.remove		= cb_pcidas64_pci_remove,
+	.remove		= comedi_pci_auto_unconfig,
 };
 module_comedi_pci_driver(cb_pcidas64_driver, cb_pcidas64_pci_driver);
 
diff --git a/drivers/staging/comedi/drivers/cb_pcidda.c b/drivers/staging/comedi/drivers/cb_pcidda.c
index 7c6029a..04be8c6 100644
--- a/drivers/staging/comedi/drivers/cb_pcidda.c
+++ b/drivers/staging/comedi/drivers/cb_pcidda.c
@@ -438,11 +438,6 @@ static int cb_pcidda_pci_probe(struct pci_dev *dev,
 	return comedi_pci_auto_config(dev, &cb_pcidda_driver);
 }
 
-static void cb_pcidda_pci_remove(struct pci_dev *dev)
-{
-	comedi_pci_auto_unconfig(dev);
-}
-
 static DEFINE_PCI_DEVICE_TABLE(cb_pcidda_pci_table) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_CB, PCI_DEVICE_ID_DDA02_12) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_CB, PCI_DEVICE_ID_DDA04_12) },
@@ -458,7 +453,7 @@ static struct pci_driver cb_pcidda_pci_driver = {
 	.name		= "cb_pcidda",
 	.id_table	= cb_pcidda_pci_table,
 	.probe		= cb_pcidda_pci_probe,
-	.remove		= cb_pcidda_pci_remove,
+	.remove		= comedi_pci_auto_unconfig,
 };
 module_comedi_pci_driver(cb_pcidda_driver, cb_pcidda_pci_driver);
 
diff --git a/drivers/staging/comedi/drivers/cb_pcimdas.c b/drivers/staging/comedi/drivers/cb_pcimdas.c
index b43a5f8..709c5c6 100644
--- a/drivers/staging/comedi/drivers/cb_pcimdas.c
+++ b/drivers/staging/comedi/drivers/cb_pcimdas.c
@@ -299,11 +299,6 @@ static int cb_pcimdas_pci_probe(struct pci_dev *dev,
 	return comedi_pci_auto_config(dev, &cb_pcimdas_driver);
 }
 
-static void cb_pcimdas_pci_remove(struct pci_dev *dev)
-{
-	comedi_pci_auto_unconfig(dev);
-}
-
 static DEFINE_PCI_DEVICE_TABLE(cb_pcimdas_pci_table) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_CB, 0x0056) },
 	{ 0 }
@@ -314,7 +309,7 @@ static struct pci_driver cb_pcimdas_pci_driver = {
 	.name		= "cb_pcimdas",
 	.id_table	= cb_pcimdas_pci_table,
 	.probe		= cb_pcimdas_pci_probe,
-	.remove		= cb_pcimdas_pci_remove,
+	.remove		= comedi_pci_auto_unconfig,
 };
 module_comedi_pci_driver(cb_pcimdas_driver, cb_pcimdas_pci_driver);
 
diff --git a/drivers/staging/comedi/drivers/cb_pcimdda.c b/drivers/staging/comedi/drivers/cb_pcimdda.c
index 699b84f..74aa4e0 100644
--- a/drivers/staging/comedi/drivers/cb_pcimdda.c
+++ b/drivers/staging/comedi/drivers/cb_pcimdda.c
@@ -222,11 +222,6 @@ static int cb_pcimdda_pci_probe(struct pci_dev *dev,
 	return comedi_pci_auto_config(dev, &cb_pcimdda_driver);
 }
 
-static void cb_pcimdda_pci_remove(struct pci_dev *dev)
-{
-	comedi_pci_auto_unconfig(dev);
-}
-
 static DEFINE_PCI_DEVICE_TABLE(cb_pcimdda_pci_table) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_CB, PCI_ID_PCIM_DDA06_16) },
 	{ 0 }
@@ -237,7 +232,7 @@ static struct pci_driver cb_pcimdda_driver_pci_driver = {
 	.name		= "cb_pcimdda",
 	.id_table	= cb_pcimdda_pci_table,
 	.probe		= cb_pcimdda_pci_probe,
-	.remove		= cb_pcimdda_pci_remove,
+	.remove		= comedi_pci_auto_unconfig,
 };
 module_comedi_pci_driver(cb_pcimdda_driver, cb_pcimdda_driver_pci_driver);
 
diff --git a/drivers/staging/comedi/drivers/contec_pci_dio.c b/drivers/staging/comedi/drivers/contec_pci_dio.c
index 1a18fa3..e0273c4 100644
--- a/drivers/staging/comedi/drivers/contec_pci_dio.c
+++ b/drivers/staging/comedi/drivers/contec_pci_dio.c
@@ -130,11 +130,6 @@ static int contec_pci_dio_pci_probe(struct pci_dev *dev,
 	return comedi_pci_auto_config(dev, &contec_pci_dio_driver);
 }
 
-static void contec_pci_dio_pci_remove(struct pci_dev *dev)
-{
-	comedi_pci_auto_unconfig(dev);
-}
-
 static DEFINE_PCI_DEVICE_TABLE(contec_pci_dio_pci_table) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_CONTEC, PCI_DEVICE_ID_PIO1616L) },
 	{ 0 }
@@ -145,7 +140,7 @@ static struct pci_driver contec_pci_dio_pci_driver = {
 	.name		= "contec_pci_dio",
 	.id_table	= contec_pci_dio_pci_table,
 	.probe		= contec_pci_dio_pci_probe,
-	.remove		= contec_pci_dio_pci_remove,
+	.remove		= comedi_pci_auto_unconfig,
 };
 module_comedi_pci_driver(contec_pci_dio_driver, contec_pci_dio_pci_driver);
 
diff --git a/drivers/staging/comedi/drivers/daqboard2000.c b/drivers/staging/comedi/drivers/daqboard2000.c
index d206c7b..d1fc190 100644
--- a/drivers/staging/comedi/drivers/daqboard2000.c
+++ b/drivers/staging/comedi/drivers/daqboard2000.c
@@ -799,11 +799,6 @@ static int daqboard2000_pci_probe(struct pci_dev *dev,
 	return comedi_pci_auto_config(dev, &daqboard2000_driver);
 }
 
-static void daqboard2000_pci_remove(struct pci_dev *dev)
-{
-	comedi_pci_auto_unconfig(dev);
-}
-
 static DEFINE_PCI_DEVICE_TABLE(daqboard2000_pci_table) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_IOTECH, 0x0409) },
 	{ 0 }
@@ -814,7 +809,7 @@ static struct pci_driver daqboard2000_pci_driver = {
 	.name		= "daqboard2000",
 	.id_table	= daqboard2000_pci_table,
 	.probe		= daqboard2000_pci_probe,
-	.remove		= daqboard2000_pci_remove,
+	.remove		= comedi_pci_auto_unconfig,
 };
 module_comedi_pci_driver(daqboard2000_driver, daqboard2000_pci_driver);
 
diff --git a/drivers/staging/comedi/drivers/das08.c b/drivers/staging/comedi/drivers/das08.c
index b15e058..37f03c2 100644
--- a/drivers/staging/comedi/drivers/das08.c
+++ b/drivers/staging/comedi/drivers/das08.c
@@ -891,16 +891,11 @@ static int das08_pci_probe(struct pci_dev *dev,
 	return comedi_pci_auto_config(dev, &das08_driver);
 }
 
-static void das08_pci_remove(struct pci_dev *dev)
-{
-	comedi_pci_auto_unconfig(dev);
-}
-
 static struct pci_driver das08_pci_driver = {
 	.id_table = das08_pci_table,
 	.name =  DRV_NAME,
 	.probe = &das08_pci_probe,
-	.remove = &das08_pci_remove
+	.remove		= comedi_pci_auto_unconfig,
 };
 #endif /* DO_PCI */
 
diff --git a/drivers/staging/comedi/drivers/dt3000.c b/drivers/staging/comedi/drivers/dt3000.c
index 960da8d..1fabe88 100644
--- a/drivers/staging/comedi/drivers/dt3000.c
+++ b/drivers/staging/comedi/drivers/dt3000.c
@@ -856,11 +856,6 @@ static int dt3000_pci_probe(struct pci_dev *dev,
 	return comedi_pci_auto_config(dev, &dt3000_driver);
 }
 
-static void dt3000_pci_remove(struct pci_dev *dev)
-{
-	comedi_pci_auto_unconfig(dev);
-}
-
 static DEFINE_PCI_DEVICE_TABLE(dt3000_pci_table) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_DT, PCI_DEVICE_ID_DT3001) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_DT, PCI_DEVICE_ID_DT3001_PGL) },
@@ -877,7 +872,7 @@ static struct pci_driver dt3000_pci_driver = {
 	.name		= "dt3000",
 	.id_table	= dt3000_pci_table,
 	.probe		= dt3000_pci_probe,
-	.remove		= dt3000_pci_remove,
+	.remove		= comedi_pci_auto_unconfig,
 };
 module_comedi_pci_driver(dt3000_driver, dt3000_pci_driver);
 
diff --git a/drivers/staging/comedi/drivers/dyna_pci10xx.c b/drivers/staging/comedi/drivers/dyna_pci10xx.c
index 8497a36..5aa695e 100644
--- a/drivers/staging/comedi/drivers/dyna_pci10xx.c
+++ b/drivers/staging/comedi/drivers/dyna_pci10xx.c
@@ -276,11 +276,6 @@ static int dyna_pci10xx_pci_probe(struct pci_dev *dev,
 	return comedi_pci_auto_config(dev, &dyna_pci10xx_driver);
 }
 
-static void dyna_pci10xx_pci_remove(struct pci_dev *dev)
-{
-	comedi_pci_auto_unconfig(dev);
-}
-
 static DEFINE_PCI_DEVICE_TABLE(dyna_pci10xx_pci_table) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_PLX, 0x1050) },
 	{ 0 }
@@ -291,7 +286,7 @@ static struct pci_driver dyna_pci10xx_pci_driver = {
 	.name		= "dyna_pci10xx",
 	.id_table	= dyna_pci10xx_pci_table,
 	.probe		= dyna_pci10xx_pci_probe,
-	.remove		= dyna_pci10xx_pci_remove,
+	.remove		= comedi_pci_auto_unconfig,
 };
 module_comedi_pci_driver(dyna_pci10xx_driver, dyna_pci10xx_pci_driver);
 
diff --git a/drivers/staging/comedi/drivers/gsc_hpdi.c b/drivers/staging/comedi/drivers/gsc_hpdi.c
index 154598f..6d88b72 100644
--- a/drivers/staging/comedi/drivers/gsc_hpdi.c
+++ b/drivers/staging/comedi/drivers/gsc_hpdi.c
@@ -946,11 +946,6 @@ static int gsc_hpdi_pci_probe(struct pci_dev *dev,
 	return comedi_pci_auto_config(dev, &gsc_hpdi_driver);
 }
 
-static void gsc_hpdi_pci_remove(struct pci_dev *dev)
-{
-	comedi_pci_auto_unconfig(dev);
-}
-
 static DEFINE_PCI_DEVICE_TABLE(gsc_hpdi_pci_table) = {
 	{ PCI_VENDOR_ID_PLX, PCI_DEVICE_ID_PLX_9080, PCI_VENDOR_ID_PLX,
 		    0x2400, 0, 0, 0},
@@ -962,7 +957,7 @@ static struct pci_driver gsc_hpdi_pci_driver = {
 	.name		= "gsc_hpdi",
 	.id_table	= gsc_hpdi_pci_table,
 	.probe		= gsc_hpdi_pci_probe,
-	.remove		= gsc_hpdi_pci_remove
+	.remove		= comedi_pci_auto_unconfig,
 };
 module_comedi_pci_driver(gsc_hpdi_driver, gsc_hpdi_pci_driver);
 
diff --git a/drivers/staging/comedi/drivers/icp_multi.c b/drivers/staging/comedi/drivers/icp_multi.c
index a91a448..0174295 100644
--- a/drivers/staging/comedi/drivers/icp_multi.c
+++ b/drivers/staging/comedi/drivers/icp_multi.c
@@ -623,11 +623,6 @@ static int icp_multi_pci_probe(struct pci_dev *dev,
 	return comedi_pci_auto_config(dev, &icp_multi_driver);
 }
 
-static void icp_multi_pci_remove(struct pci_dev *dev)
-{
-	comedi_pci_auto_unconfig(dev);
-}
-
 static DEFINE_PCI_DEVICE_TABLE(icp_multi_pci_table) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_ICP, PCI_DEVICE_ID_ICP_MULTI) },
 	{ 0 }
@@ -638,7 +633,7 @@ static struct pci_driver icp_multi_pci_driver = {
 	.name		= "icp_multi",
 	.id_table	= icp_multi_pci_table,
 	.probe		= icp_multi_pci_probe,
-	.remove		= icp_multi_pci_remove,
+	.remove		= comedi_pci_auto_unconfig,
 };
 module_comedi_pci_driver(icp_multi_driver, icp_multi_pci_driver);
 
diff --git a/drivers/staging/comedi/drivers/jr3_pci.c b/drivers/staging/comedi/drivers/jr3_pci.c
index c756a35..8d79c76 100644
--- a/drivers/staging/comedi/drivers/jr3_pci.c
+++ b/drivers/staging/comedi/drivers/jr3_pci.c
@@ -844,11 +844,6 @@ static int jr3_pci_pci_probe(struct pci_dev *dev,
 	return comedi_pci_auto_config(dev, &jr3_pci_driver);
 }
 
-static void jr3_pci_pci_remove(struct pci_dev *dev)
-{
-	comedi_pci_auto_unconfig(dev);
-}
-
 static DEFINE_PCI_DEVICE_TABLE(jr3_pci_pci_table) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_JR3, PCI_DEVICE_ID_JR3_1_CHANNEL) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_JR3, PCI_DEVICE_ID_JR3_1_CHANNEL_NEW) },
@@ -863,7 +858,7 @@ static struct pci_driver jr3_pci_pci_driver = {
 	.name		= "jr3_pci",
 	.id_table	= jr3_pci_pci_table,
 	.probe		= jr3_pci_pci_probe,
-	.remove		= jr3_pci_pci_remove,
+	.remove		= comedi_pci_auto_unconfig,
 };
 module_comedi_pci_driver(jr3_pci_driver, jr3_pci_pci_driver);
 
diff --git a/drivers/staging/comedi/drivers/ke_counter.c b/drivers/staging/comedi/drivers/ke_counter.c
index 19c9428..535800a 100644
--- a/drivers/staging/comedi/drivers/ke_counter.c
+++ b/drivers/staging/comedi/drivers/ke_counter.c
@@ -152,11 +152,6 @@ static int ke_counter_pci_probe(struct pci_dev *dev,
 	return comedi_pci_auto_config(dev, &ke_counter_driver);
 }
 
-static void ke_counter_pci_remove(struct pci_dev *dev)
-{
-	comedi_pci_auto_unconfig(dev);
-}
-
 static DEFINE_PCI_DEVICE_TABLE(ke_counter_pci_table) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_KOLTER, CNT_CARD_DEVICE_ID) },
 	{ 0 }
@@ -167,7 +162,7 @@ static struct pci_driver ke_counter_pci_driver = {
 	.name		= "ke_counter",
 	.id_table	= ke_counter_pci_table,
 	.probe		= ke_counter_pci_probe,
-	.remove		= ke_counter_pci_remove,
+	.remove		= comedi_pci_auto_unconfig,
 };
 module_comedi_pci_driver(ke_counter_driver, ke_counter_pci_driver);
 
diff --git a/drivers/staging/comedi/drivers/me4000.c b/drivers/staging/comedi/drivers/me4000.c
index 3c4b022..4312b37 100644
--- a/drivers/staging/comedi/drivers/me4000.c
+++ b/drivers/staging/comedi/drivers/me4000.c
@@ -1734,11 +1734,6 @@ static int me4000_pci_probe(struct pci_dev *dev,
 	return comedi_pci_auto_config(dev, &me4000_driver);
 }
 
-static void me4000_pci_remove(struct pci_dev *dev)
-{
-	comedi_pci_auto_unconfig(dev);
-}
-
 static DEFINE_PCI_DEVICE_TABLE(me4000_pci_table) = {
 	{PCI_DEVICE(PCI_VENDOR_ID_MEILHAUS, PCI_DEVICE_ID_MEILHAUS_ME4650)},
 	{PCI_DEVICE(PCI_VENDOR_ID_MEILHAUS, PCI_DEVICE_ID_MEILHAUS_ME4660)},
@@ -1761,7 +1756,7 @@ static struct pci_driver me4000_pci_driver = {
 	.name		= "me4000",
 	.id_table	= me4000_pci_table,
 	.probe		= me4000_pci_probe,
-	.remove		= me4000_pci_remove,
+	.remove		= comedi_pci_auto_unconfig,
 };
 module_comedi_pci_driver(me4000_driver, me4000_pci_driver);
 
diff --git a/drivers/staging/comedi/drivers/me_daq.c b/drivers/staging/comedi/drivers/me_daq.c
index ce8e3d3..ee8bafc 100644
--- a/drivers/staging/comedi/drivers/me_daq.c
+++ b/drivers/staging/comedi/drivers/me_daq.c
@@ -619,11 +619,6 @@ static int me_daq_pci_probe(struct pci_dev *dev,
 	return comedi_pci_auto_config(dev, &me_daq_driver);
 }
 
-static void me_daq_pci_remove(struct pci_dev *dev)
-{
-	comedi_pci_auto_unconfig(dev);
-}
-
 static DEFINE_PCI_DEVICE_TABLE(me_daq_pci_table) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_MEILHAUS, ME2600_DEVICE_ID) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_MEILHAUS, ME2000_DEVICE_ID) },
@@ -635,7 +630,7 @@ static struct pci_driver me_daq_pci_driver = {
 	.name		= "me_daq",
 	.id_table	= me_daq_pci_table,
 	.probe		= me_daq_pci_probe,
-	.remove		= me_daq_pci_remove,
+	.remove		= comedi_pci_auto_unconfig,
 };
 module_comedi_pci_driver(me_daq_driver, me_daq_pci_driver);
 
diff --git a/drivers/staging/comedi/drivers/ni_6527.c b/drivers/staging/comedi/drivers/ni_6527.c
index 5196b460..67aa6f4 100644
--- a/drivers/staging/comedi/drivers/ni_6527.c
+++ b/drivers/staging/comedi/drivers/ni_6527.c
@@ -452,16 +452,11 @@ static int ni6527_pci_probe(struct pci_dev *dev,
 	return comedi_pci_auto_config(dev, &ni6527_driver);
 }
 
-static void ni6527_pci_remove(struct pci_dev *dev)
-{
-	comedi_pci_auto_unconfig(dev);
-}
-
 static struct pci_driver ni6527_pci_driver = {
 	.name = DRIVER_NAME,
 	.id_table = ni6527_pci_table,
 	.probe = ni6527_pci_probe,
-	.remove = ni6527_pci_remove
+	.remove		= comedi_pci_auto_unconfig,
 };
 module_comedi_pci_driver(ni6527_driver, ni6527_pci_driver);
 
diff --git a/drivers/staging/comedi/drivers/ni_65xx.c b/drivers/staging/comedi/drivers/ni_65xx.c
index 2fb4b77..fb7e8b8 100644
--- a/drivers/staging/comedi/drivers/ni_65xx.c
+++ b/drivers/staging/comedi/drivers/ni_65xx.c
@@ -787,16 +787,11 @@ static int ni_65xx_pci_probe(struct pci_dev *dev,
 	return comedi_pci_auto_config(dev, &ni_65xx_driver);
 }
 
-static void ni_65xx_pci_remove(struct pci_dev *dev)
-{
-	comedi_pci_auto_unconfig(dev);
-}
-
 static struct pci_driver ni_65xx_pci_driver = {
 	.name = "ni_65xx",
 	.id_table = ni_65xx_pci_table,
 	.probe = ni_65xx_pci_probe,
-	.remove = ni_65xx_pci_remove
+	.remove		= comedi_pci_auto_unconfig,
 };
 module_comedi_pci_driver(ni_65xx_driver, ni_65xx_pci_driver);
 
diff --git a/drivers/staging/comedi/drivers/ni_660x.c b/drivers/staging/comedi/drivers/ni_660x.c
index 26baf9c..bdef2e4 100644
--- a/drivers/staging/comedi/drivers/ni_660x.c
+++ b/drivers/staging/comedi/drivers/ni_660x.c
@@ -1327,11 +1327,6 @@ static int ni_660x_pci_probe(struct pci_dev *dev,
 	return comedi_pci_auto_config(dev, &ni_660x_driver);
 }
 
-static void ni_660x_pci_remove(struct pci_dev *dev)
-{
-	comedi_pci_auto_unconfig(dev);
-}
-
 static DEFINE_PCI_DEVICE_TABLE(ni_660x_pci_table) = {
 	{PCI_DEVICE(PCI_VENDOR_ID_NI, 0x2c60)},
 	{PCI_DEVICE(PCI_VENDOR_ID_NI, 0x1310)},
@@ -1345,7 +1340,7 @@ static struct pci_driver ni_660x_pci_driver = {
 	.name		= "ni_660x",
 	.id_table	= ni_660x_pci_table,
 	.probe		= ni_660x_pci_probe,
-	.remove		= ni_660x_pci_remove,
+	.remove		= comedi_pci_auto_unconfig,
 };
 module_comedi_pci_driver(ni_660x_driver, ni_660x_pci_driver);
 
diff --git a/drivers/staging/comedi/drivers/ni_670x.c b/drivers/staging/comedi/drivers/ni_670x.c
index 272caeb..6f3c090 100644
--- a/drivers/staging/comedi/drivers/ni_670x.c
+++ b/drivers/staging/comedi/drivers/ni_670x.c
@@ -309,11 +309,6 @@ static int ni_670x_pci_probe(struct pci_dev *dev,
 	return comedi_pci_auto_config(dev, &ni_670x_driver);
 }
 
-static void ni_670x_pci_remove(struct pci_dev *dev)
-{
-	comedi_pci_auto_unconfig(dev);
-}
-
 static DEFINE_PCI_DEVICE_TABLE(ni_670x_pci_table) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_NI, 0x2c90) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_NI, 0x1920) },
@@ -325,7 +320,7 @@ static struct pci_driver ni_670x_pci_driver = {
 	.name		= "ni_670x",
 	.id_table	= ni_670x_pci_table,
 	.probe		= ni_670x_pci_probe,
-	.remove		= ni_670x_pci_remove,
+	.remove		= comedi_pci_auto_unconfig,
 };
 module_comedi_pci_driver(ni_670x_driver, ni_670x_pci_driver);
 
diff --git a/drivers/staging/comedi/drivers/ni_labpc.c b/drivers/staging/comedi/drivers/ni_labpc.c
index d29c4d7..dedb2ab 100644
--- a/drivers/staging/comedi/drivers/ni_labpc.c
+++ b/drivers/staging/comedi/drivers/ni_labpc.c
@@ -2116,16 +2116,11 @@ static int labpc_pci_probe(struct pci_dev *dev,
 	return comedi_pci_auto_config(dev, &labpc_driver);
 }
 
-static void labpc_pci_remove(struct pci_dev *dev)
-{
-	comedi_pci_auto_unconfig(dev);
-}
-
 static struct pci_driver labpc_pci_driver = {
 	.name = DRV_NAME,
 	.id_table = labpc_pci_table,
 	.probe = labpc_pci_probe,
-	.remove = labpc_pci_remove
+	.remove		= comedi_pci_auto_unconfig,
 };
 module_comedi_pci_driver(labpc_driver, labpc_pci_driver);
 #else
diff --git a/drivers/staging/comedi/drivers/ni_pcidio.c b/drivers/staging/comedi/drivers/ni_pcidio.c
index 084ebea..ba8c2f2 100644
--- a/drivers/staging/comedi/drivers/ni_pcidio.c
+++ b/drivers/staging/comedi/drivers/ni_pcidio.c
@@ -1224,11 +1224,6 @@ static int ni_pcidio_pci_probe(struct pci_dev *dev,
 	return comedi_pci_auto_config(dev, &ni_pcidio_driver);
 }
 
-static void ni_pcidio_pci_remove(struct pci_dev *dev)
-{
-	comedi_pci_auto_unconfig(dev);
-}
-
 static DEFINE_PCI_DEVICE_TABLE(ni_pcidio_pci_table) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_NI, 0x1150) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_NI, 0x1320) },
@@ -1241,7 +1236,7 @@ static struct pci_driver ni_pcidio_pci_driver = {
 	.name		= "ni_pcidio",
 	.id_table	= ni_pcidio_pci_table,
 	.probe		= ni_pcidio_pci_probe,
-	.remove		= ni_pcidio_pci_remove,
+	.remove		= comedi_pci_auto_unconfig,
 };
 module_comedi_pci_driver(ni_pcidio_driver, ni_pcidio_pci_driver);
 
diff --git a/drivers/staging/comedi/drivers/ni_pcimio.c b/drivers/staging/comedi/drivers/ni_pcimio.c
index fd1662b..26a870c 100644
--- a/drivers/staging/comedi/drivers/ni_pcimio.c
+++ b/drivers/staging/comedi/drivers/ni_pcimio.c
@@ -1791,11 +1791,6 @@ static int ni_pcimio_pci_probe(struct pci_dev *dev,
 	return comedi_pci_auto_config(dev, &ni_pcimio_driver);
 }
 
-static void ni_pcimio_pci_remove(struct pci_dev *dev)
-{
-	comedi_pci_auto_unconfig(dev);
-}
-
 static DEFINE_PCI_DEVICE_TABLE(ni_pcimio_pci_table) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_NI, 0x0162) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_NI, 0x1170) },
@@ -1858,7 +1853,7 @@ static struct pci_driver ni_pcimio_pci_driver = {
 	.name		= "ni_pcimio",
 	.id_table	= ni_pcimio_pci_table,
 	.probe		= ni_pcimio_pci_probe,
-	.remove		= ni_pcimio_pci_remove
+	.remove		= comedi_pci_auto_unconfig,
 };
 module_comedi_pci_driver(ni_pcimio_driver, ni_pcimio_pci_driver);
 
diff --git a/drivers/staging/comedi/drivers/rtd520.c b/drivers/staging/comedi/drivers/rtd520.c
index 8d7c948..5581452 100644
--- a/drivers/staging/comedi/drivers/rtd520.c
+++ b/drivers/staging/comedi/drivers/rtd520.c
@@ -1420,11 +1420,6 @@ static int rtd520_pci_probe(struct pci_dev *dev,
 	return comedi_pci_auto_config(dev, &rtd520_driver);
 }
 
-static void rtd520_pci_remove(struct pci_dev *dev)
-{
-	comedi_pci_auto_unconfig(dev);
-}
-
 static DEFINE_PCI_DEVICE_TABLE(rtd520_pci_table) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_RTD, 0x7520) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_RTD, 0x4520) },
@@ -1436,7 +1431,7 @@ static struct pci_driver rtd520_pci_driver = {
 	.name		= "rtd520",
 	.id_table	= rtd520_pci_table,
 	.probe		= rtd520_pci_probe,
-	.remove		= rtd520_pci_remove,
+	.remove		= comedi_pci_auto_unconfig,
 };
 module_comedi_pci_driver(rtd520_driver, rtd520_pci_driver);
 
diff --git a/drivers/staging/comedi/drivers/s626.c b/drivers/staging/comedi/drivers/s626.c
index 6dc1d28..0c7221c 100644
--- a/drivers/staging/comedi/drivers/s626.c
+++ b/drivers/staging/comedi/drivers/s626.c
@@ -2836,11 +2836,6 @@ static int s626_pci_probe(struct pci_dev *dev,
 	return comedi_pci_auto_config(dev, &s626_driver);
 }
 
-static void s626_pci_remove(struct pci_dev *dev)
-{
-	comedi_pci_auto_unconfig(dev);
-}
-
 /*
  * For devices with vendor:device id == 0x1131:0x7146 you must specify
  * also subvendor:subdevice ids, because otherwise it will conflict with
@@ -2857,7 +2852,7 @@ static struct pci_driver s626_pci_driver = {
 	.name		= "s626",
 	.id_table	= s626_pci_table,
 	.probe		= s626_pci_probe,
-	.remove		= s626_pci_remove,
+	.remove		= comedi_pci_auto_unconfig,
 };
 module_comedi_pci_driver(s626_driver, s626_pci_driver);
 
diff --git a/drivers/staging/comedi/drivers/skel.c b/drivers/staging/comedi/drivers/skel.c
index 48178ca..0aad815 100644
--- a/drivers/staging/comedi/drivers/skel.c
+++ b/drivers/staging/comedi/drivers/skel.c
@@ -707,16 +707,11 @@ static int skel_pci_probe(struct pci_dev *dev,
 	return comedi_pci_auto_config(dev, &skel_driver);
 }
 
-static void skel_pci_remove(struct pci_dev *dev)
-{
-	comedi_pci_auto_unconfig(dev);
-}
-
 static struct pci_driver skel_pci_driver = {
 	.name = "dummy",
 	.id_table = skel_pci_table,
 	.probe = &skel_pci_probe,
-	.remove = &skel_pci_remove
+	.remove		= comedi_pci_auto_unconfig,
 };
 module_comedi_pci_driver(skel_driver, skel_pci_driver);
 #else
-- 
1.7.8.6

