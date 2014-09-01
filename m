Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909AbaIALKx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 07:10:53 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:39008 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753319AbaIALET (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 07:04:19 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 07/28] staging: comedi: amplc_pci230: set detach handler to comedi_pci_detach()
Date: Mon,  1 Sep 2014 12:03:39 +0100
Message-Id: <1409569440-10979-8-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1409569440-10979-1-git-send-email-abbotti@mev.co.uk>
References: <1409569440-10979-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the comedi driver's "detach`" handler `pci230_detach()` now merely
calls `comedi_pci_detach()` with the same parameter, use
`comedi_pci_detach()` itself as the "detach" handler.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/amplc_pci230.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/staging/comedi/drivers/amplc_pci230.c b/drivers/staging/comedi/drivers/amplc_pci230.c
index 39fa2f6..35d7f0c 100644
--- a/drivers/staging/comedi/drivers/amplc_pci230.c
+++ b/drivers/staging/comedi/drivers/amplc_pci230.c
@@ -2732,16 +2732,11 @@ static int pci230_auto_attach(struct comedi_device *dev,
 	return pci230_attach_common(dev, pci_dev);
 }
 
-static void pci230_detach(struct comedi_device *dev)
-{
-	comedi_pci_detach(dev);
-}
-
 static struct comedi_driver amplc_pci230_driver = {
 	.driver_name	= "amplc_pci230",
 	.module		= THIS_MODULE,
 	.auto_attach	= pci230_auto_attach,
-	.detach		= pci230_detach,
+	.detach		= comedi_pci_detach,
 };
 
 static int amplc_pci230_pci_probe(struct pci_dev *dev,
-- 
2.0.4

