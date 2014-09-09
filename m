Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756635AbaIIKkj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 06:40:39 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:36163 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756387AbaIIK1P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 06:27:15 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 13/48] staging: comedi: amplc_pci230: replace comedi_board() calls
Date: Tue,  9 Sep 2014 11:26:22 +0100
Message-Id: <1410258417-28230-14-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410258417-28230-1-git-send-email-abbotti@mev.co.uk>
References: <1410258417-28230-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The `comedi_board(dev)` inline function calls just return
`dev->board_ptr`.  Expand the inline function calls.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/amplc_pci230.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/comedi/drivers/amplc_pci230.c b/drivers/staging/comedi/drivers/amplc_pci230.c
index eb75012..e9ca174 100644
--- a/drivers/staging/comedi/drivers/amplc_pci230.c
+++ b/drivers/staging/comedi/drivers/amplc_pci230.c
@@ -543,7 +543,7 @@ static const struct comedi_lrange pci230_ao_range = {
 
 static unsigned short pci230_ai_read(struct comedi_device *dev)
 {
-	const struct pci230_board *thisboard = comedi_board(dev);
+	const struct pci230_board *thisboard = dev->board_ptr;
 	struct pci230_private *devpriv = dev->private;
 	unsigned short data;
 
@@ -565,7 +565,7 @@ static unsigned short pci230_ai_read(struct comedi_device *dev)
 static unsigned short pci230_ao_mangle_datum(struct comedi_device *dev,
 					     unsigned short datum)
 {
-	const struct pci230_board *thisboard = comedi_board(dev);
+	const struct pci230_board *thisboard = dev->board_ptr;
 	struct pci230_private *devpriv = dev->private;
 
 	/*
@@ -894,7 +894,7 @@ static int pci230_ao_check_chanlist(struct comedi_device *dev,
 static int pci230_ao_cmdtest(struct comedi_device *dev,
 			     struct comedi_subdevice *s, struct comedi_cmd *cmd)
 {
-	const struct pci230_board *thisboard = comedi_board(dev);
+	const struct pci230_board *thisboard = dev->board_ptr;
 	struct pci230_private *devpriv = dev->private;
 	int err = 0;
 	unsigned int tmp;
@@ -1556,7 +1556,7 @@ static int pci230_ai_check_chanlist(struct comedi_device *dev,
 static int pci230_ai_cmdtest(struct comedi_device *dev,
 			     struct comedi_subdevice *s, struct comedi_cmd *cmd)
 {
-	const struct pci230_board *thisboard = comedi_board(dev);
+	const struct pci230_board *thisboard = dev->board_ptr;
 	struct pci230_private *devpriv = dev->private;
 	int err = 0;
 	unsigned int tmp;
@@ -2487,7 +2487,7 @@ static int pci230_auto_attach(struct comedi_device *dev,
 			"amplc_pci230: BUG! cannot determine board type!\n");
 		return -EINVAL;
 	}
-	thisboard = comedi_board(dev);
+	thisboard = dev->board_ptr;
 	dev->board_name = thisboard->name;
 
 	rc = comedi_pci_enable(dev);
-- 
2.1.0

