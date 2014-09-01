Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753633AbaIALJO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 07:09:14 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:38999 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753194AbaIALEY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 07:04:24 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 16/28] staging: comedi: amplc_pci230: remove 'inline'
Date: Mon,  1 Sep 2014 12:03:48 +0100
Message-Id: <1409569440-10979-17-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1409569440-10979-1-git-send-email-abbotti@mev.co.uk>
References: <1409569440-10979-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some functions in "amplc_pci230.c" are declared `inline`.  Remove the
`inline` specifiers and let the compiler do what it wants with them.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/amplc_pci230.c | 24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/comedi/drivers/amplc_pci230.c b/drivers/staging/comedi/drivers/amplc_pci230.c
index 70b210b..d832268 100644
--- a/drivers/staging/comedi/drivers/amplc_pci230.c
+++ b/drivers/staging/comedi/drivers/amplc_pci230.c
@@ -573,8 +573,8 @@ static unsigned short pci230_ai_read(struct comedi_device *dev)
 	return data;
 }
 
-static inline unsigned short pci230_ao_mangle_datum(struct comedi_device *dev,
-						    unsigned short datum)
+static unsigned short pci230_ao_mangle_datum(struct comedi_device *dev,
+					     unsigned short datum)
 {
 	const struct pci230_board *thisboard = comedi_board(dev);
 	struct pci230_private *devpriv = dev->private;
@@ -593,9 +593,8 @@ static inline unsigned short pci230_ao_mangle_datum(struct comedi_device *dev,
 	return datum;
 }
 
-static inline void pci230_ao_write_nofifo(struct comedi_device *dev,
-					  unsigned short datum,
-					  unsigned int chan)
+static void pci230_ao_write_nofifo(struct comedi_device *dev,
+				   unsigned short datum, unsigned int chan)
 {
 	struct pci230_private *devpriv = dev->private;
 
@@ -604,8 +603,8 @@ static inline void pci230_ao_write_nofifo(struct comedi_device *dev,
 	     devpriv->daqio + ((chan == 0) ? PCI230_DACOUT1 : PCI230_DACOUT2));
 }
 
-static inline void pci230_ao_write_fifo(struct comedi_device *dev,
-					unsigned short datum, unsigned int chan)
+static void pci230_ao_write_fifo(struct comedi_device *dev,
+				 unsigned short datum, unsigned int chan)
 {
 	struct pci230_private *devpriv = dev->private;
 
@@ -650,8 +649,8 @@ static int get_resources(struct comedi_device *dev, unsigned int res_mask,
 	return ok;
 }
 
-static inline int get_one_resource(struct comedi_device *dev,
-				   unsigned int resource, unsigned char owner)
+static int get_one_resource(struct comedi_device *dev,
+			    unsigned int resource, unsigned char owner)
 {
 	return get_resources(dev, 1U << resource, owner);
 }
@@ -675,14 +674,13 @@ static void put_resources(struct comedi_device *dev, unsigned int res_mask,
 	spin_unlock_irqrestore(&devpriv->res_spinlock, irqflags);
 }
 
-static inline void put_one_resource(struct comedi_device *dev,
-				    unsigned int resource, unsigned char owner)
+static void put_one_resource(struct comedi_device *dev,
+			     unsigned int resource, unsigned char owner)
 {
 	put_resources(dev, 1U << resource, owner);
 }
 
-static inline void put_all_resources(struct comedi_device *dev,
-				     unsigned char owner)
+static void put_all_resources(struct comedi_device *dev, unsigned char owner)
 {
 	put_resources(dev, (1U << NUM_RESOURCES) - 1, owner);
 }
-- 
2.0.4

