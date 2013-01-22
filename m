Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696Ab3AVXAY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 18:00:24 -0500
Received: from mout.gmx.net ([212.227.17.20]:65216 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752959Ab3AVXAX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 18:00:23 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/uOp02aDnudnEI07eoT8HYNPGC3cjKNWJJvcEloW
	RNRHIg5qwZV5op
From: Peter Huewe <peterhuewe@gmx.de>
To: Ian Abbott <abbotti@mev.co.uk>
Cc: Mori Hess <fmhess@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH] staging/comedi: Move comedi_pci_auto_unconfig to drivers.c
Date: Wed, 23 Jan 2013 00:03:30 +0100
Message-Id: <1358895810-27115-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1358894403-26181-1-git-send-email-peterhuewe@gmx.de>
References: <1358894403-26181-1-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since comedi_pci_auto_unconfig cannot be inlined anymore after
 staging/comedi: Use comedi_pci_auto_unconfig directly for
 pci_driver.remove
is applied, it makes sense to move it drivers.c

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/comedi/comedidev.h |    5 +----
 drivers/staging/comedi/drivers.c   |    6 ++++++
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/comedi/comedidev.h b/drivers/staging/comedi/comedidev.h
index 6211d44..e2b7d60 100644
--- a/drivers/staging/comedi/comedidev.h
+++ b/drivers/staging/comedi/comedidev.h
@@ -484,10 +484,7 @@ static inline int comedi_pci_auto_config(struct pci_dev *pcidev,
 	return comedi_auto_config(&pcidev->dev, driver, 0);
 }
 
-static inline void comedi_pci_auto_unconfig(struct pci_dev *pcidev)
-{
-	comedi_auto_unconfig(&pcidev->dev);
-}
+void comedi_pci_auto_unconfig(struct pci_dev *pcidev);
 
 static inline int comedi_usb_auto_config(struct usb_interface *intf,
 					 struct comedi_driver *driver)
diff --git a/drivers/staging/comedi/drivers.c b/drivers/staging/comedi/drivers.c
index 1c7d4da..87eeee5 100644
--- a/drivers/staging/comedi/drivers.c
+++ b/drivers/staging/comedi/drivers.c
@@ -558,6 +558,12 @@ void comedi_pci_driver_unregister(struct comedi_driver *comedi_driver,
 }
 EXPORT_SYMBOL_GPL(comedi_pci_driver_unregister);
 
+void comedi_pci_auto_unconfig(struct pci_dev *pcidev)
+{
+	comedi_auto_unconfig(&pcidev->dev);
+}
+EXPORT_SYMBOL_GPL(comedi_pci_auto_unconfig);
+
 #if IS_ENABLED(CONFIG_PCMCIA)
 int comedi_pcmcia_driver_register(struct comedi_driver *comedi_driver,
 		struct pcmcia_driver *pcmcia_driver)
-- 
1.7.8.6

