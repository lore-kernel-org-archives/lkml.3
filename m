Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756993AbaIIKmj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 06:42:39 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:36167 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756352AbaIIK1N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 06:27:13 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 07/48] staging: comedi: adv_pci1710: replace comedi_board() calls
Date: Tue,  9 Sep 2014 11:26:16 +0100
Message-Id: <1410258417-28230-8-git-send-email-abbotti@mev.co.uk>
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
 drivers/staging/comedi/drivers/adv_pci1710.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adv_pci1710.c b/drivers/staging/comedi/drivers/adv_pci1710.c
index b368962..5539bd2 100644
--- a/drivers/staging/comedi/drivers/adv_pci1710.c
+++ b/drivers/staging/comedi/drivers/adv_pci1710.c
@@ -327,7 +327,7 @@ static int pci171x_ai_dropout(struct comedi_device *dev,
 			      unsigned int chan,
 			      unsigned int val)
 {
-	const struct boardtype *board = comedi_board(dev);
+	const struct boardtype *board = dev->board_ptr;
 	struct pci1710_private *devpriv = dev->private;
 
 	if (board->cardtype != TYPE_PCI1713) {
@@ -413,7 +413,7 @@ static void setup_channel_list(struct comedi_device *dev,
 			       unsigned int *chanlist, unsigned int n_chan,
 			       unsigned int seglen)
 {
-	const struct boardtype *this_board = comedi_board(dev);
+	const struct boardtype *this_board = dev->board_ptr;
 	struct pci1710_private *devpriv = dev->private;
 	unsigned int i, range, chanprog;
 
@@ -715,7 +715,7 @@ static int pci1720_insn_write_ao(struct comedi_device *dev,
 static int pci171x_ai_cancel(struct comedi_device *dev,
 			     struct comedi_subdevice *s)
 {
-	const struct boardtype *this_board = comedi_board(dev);
+	const struct boardtype *this_board = dev->board_ptr;
 	struct pci1710_private *devpriv = dev->private;
 
 	switch (this_board->cardtype) {
@@ -828,7 +828,7 @@ static int move_block_from_fifo(struct comedi_device *dev,
 static void pci1710_handle_fifo(struct comedi_device *dev,
 				struct comedi_subdevice *s)
 {
-	const struct boardtype *this_board = comedi_board(dev);
+	const struct boardtype *this_board = dev->board_ptr;
 	struct pci1710_private *devpriv = dev->private;
 	struct comedi_cmd *cmd = &s->async->cmd;
 	int m, samplesinbuf;
@@ -968,7 +968,7 @@ static int pci171x_ai_cmdtest(struct comedi_device *dev,
 			      struct comedi_subdevice *s,
 			      struct comedi_cmd *cmd)
 {
-	const struct boardtype *this_board = comedi_board(dev);
+	const struct boardtype *this_board = dev->board_ptr;
 	struct pci1710_private *devpriv = dev->private;
 	int err = 0;
 	unsigned int arg;
@@ -1045,7 +1045,7 @@ static int pci171x_ai_cmdtest(struct comedi_device *dev,
 */
 static int pci171x_reset(struct comedi_device *dev)
 {
-	const struct boardtype *this_board = comedi_board(dev);
+	const struct boardtype *this_board = dev->board_ptr;
 	struct pci1710_private *devpriv = dev->private;
 
 	outw(0x30, dev->iobase + PCI171x_CNTCTRL);
@@ -1102,7 +1102,7 @@ static int pci1720_reset(struct comedi_device *dev)
 */
 static int pci1710_reset(struct comedi_device *dev)
 {
-	const struct boardtype *this_board = comedi_board(dev);
+	const struct boardtype *this_board = dev->board_ptr;
 
 	switch (this_board->cardtype) {
 	case TYPE_PCI1720:
-- 
2.1.0

