Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756976AbaIIKmX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 06:42:23 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:36163 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756344AbaIIK1N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 06:27:13 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 08/48] staging: comedi: adv_pci_dio: replace comedi_board() calls
Date: Tue,  9 Sep 2014 11:26:17 +0100
Message-Id: <1410258417-28230-9-git-send-email-abbotti@mev.co.uk>
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
 drivers/staging/comedi/drivers/adv_pci_dio.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adv_pci_dio.c b/drivers/staging/comedi/drivers/adv_pci_dio.c
index 99c8ba7..f2e2d7e 100644
--- a/drivers/staging/comedi/drivers/adv_pci_dio.c
+++ b/drivers/staging/comedi/drivers/adv_pci_dio.c
@@ -817,7 +817,7 @@ static int pci1760_reset(struct comedi_device *dev)
 */
 static int pci_dio_reset(struct comedi_device *dev)
 {
-	const struct dio_boardtype *this_board = comedi_board(dev);
+	const struct dio_boardtype *this_board = dev->board_ptr;
 
 	switch (this_board->cardtype) {
 	case TYPE_PCI1730:
@@ -975,7 +975,7 @@ static int pci_dio_add_di(struct comedi_device *dev,
 			  struct comedi_subdevice *s,
 			  const struct diosubd_data *d)
 {
-	const struct dio_boardtype *this_board = comedi_board(dev);
+	const struct dio_boardtype *this_board = dev->board_ptr;
 
 	s->type = COMEDI_SUBD_DI;
 	s->subdev_flags = SDF_READABLE | SDF_GROUND | SDF_COMMON | d->specflags;
@@ -1005,7 +1005,7 @@ static int pci_dio_add_do(struct comedi_device *dev,
 			  struct comedi_subdevice *s,
 			  const struct diosubd_data *d)
 {
-	const struct dio_boardtype *this_board = comedi_board(dev);
+	const struct dio_boardtype *this_board = dev->board_ptr;
 
 	s->type = COMEDI_SUBD_DO;
 	s->subdev_flags = SDF_WRITABLE | SDF_GROUND | SDF_COMMON;
-- 
2.1.0

