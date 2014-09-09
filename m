Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757071AbaIIKnN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 06:43:13 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:36161 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756340AbaIIK1M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 06:27:12 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 06/48] staging: comedi: adl_pci9118: replace comedi_board() calls
Date: Tue,  9 Sep 2014 11:26:15 +0100
Message-Id: <1410258417-28230-7-git-send-email-abbotti@mev.co.uk>
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
 drivers/staging/comedi/drivers/adl_pci9118.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/adl_pci9118.c b/drivers/staging/comedi/drivers/adl_pci9118.c
index 41fa615..27d9a1d 100644
--- a/drivers/staging/comedi/drivers/adl_pci9118.c
+++ b/drivers/staging/comedi/drivers/adl_pci9118.c
@@ -1709,7 +1709,7 @@ static int pci9118_common_attach(struct comedi_device *dev, int disable_irq,
 				 int master, int ext_mux, int softsshdelay,
 				 int hw_err_mask)
 {
-	const struct pci9118_boardinfo *board = comedi_board(dev);
+	const struct pci9118_boardinfo *board = dev->board_ptr;
 	struct pci_dev *pcidev = comedi_to_pci_dev(dev);
 	struct pci9118_private *devpriv;
 	struct comedi_subdevice *s;
-- 
2.1.0

