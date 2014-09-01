Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586AbaIALKu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 07:10:50 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:39017 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753347AbaIALEU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 07:04:20 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 09/28] staging: comedi: amplc_pci230: no need to comedi_set_hw_dev() here
Date: Mon,  1 Sep 2014 12:03:41 +0100
Message-Id: <1409569440-10979-10-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1409569440-10979-1-git-send-email-abbotti@mev.co.uk>
References: <1409569440-10979-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The comedi core module calls `comedi_set_hw_dev()` to associate the
hardware `struct device` with the `struct comedi_device` before it calls
the comedi driver's "auto_attach" hook `pci230_auto_attach()`.  There is
no need for `pci230_auto_attach()` to call `comedi_set_hw_dev()` itself,
so remove the call.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/amplc_pci230.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/amplc_pci230.c b/drivers/staging/comedi/drivers/amplc_pci230.c
index 46977e5..bd2e648 100644
--- a/drivers/staging/comedi/drivers/amplc_pci230.c
+++ b/drivers/staging/comedi/drivers/amplc_pci230.c
@@ -2582,8 +2582,6 @@ static int pci230_auto_attach(struct comedi_device *dev,
 	thisboard = comedi_board(dev);
 	devpriv = dev->private;
 
-	comedi_set_hw_dev(dev, &pci_dev->dev);
-
 	dev->board_name = thisboard->name;
 
 	rc = comedi_pci_enable(dev);
-- 
2.0.4

