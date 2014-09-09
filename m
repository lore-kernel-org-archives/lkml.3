Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756414AbaIIK1Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 06:27:16 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:36136 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756322AbaIIK1K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 06:27:10 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 02/48] staging: comedi: addi_eeprom: replace comedi_board() calls
Date: Tue,  9 Sep 2014 11:26:11 +0100
Message-Id: <1410258417-28230-3-git-send-email-abbotti@mev.co.uk>
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
 drivers/staging/comedi/drivers/addi-data/addi_eeprom.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi-data/addi_eeprom.c b/drivers/staging/comedi/drivers/addi-data/addi_eeprom.c
index aafc172..b731856 100644
--- a/drivers/staging/comedi/drivers/addi-data/addi_eeprom.c
+++ b/drivers/staging/comedi/drivers/addi-data/addi_eeprom.c
@@ -179,7 +179,7 @@ static void addi_eeprom_read_di_info(struct comedi_device *dev,
 				     unsigned long iobase,
 				     unsigned short addr)
 {
-	const struct addi_board *this_board = comedi_board(dev);
+	const struct addi_board *this_board = dev->board_ptr;
 	struct addi_private *devpriv = dev->private;
 	char *type = this_board->pc_EepromChip;
 	unsigned short tmp;
@@ -200,7 +200,7 @@ static void addi_eeprom_read_do_info(struct comedi_device *dev,
 				     unsigned long iobase,
 				     unsigned short addr)
 {
-	const struct addi_board *this_board = comedi_board(dev);
+	const struct addi_board *this_board = dev->board_ptr;
 	struct addi_private *devpriv = dev->private;
 	char *type = this_board->pc_EepromChip;
 	unsigned short tmp;
@@ -218,7 +218,7 @@ static void addi_eeprom_read_timer_info(struct comedi_device *dev,
 {
 	struct addi_private *devpriv = dev->private;
 #if 0
-	const struct addi_board *this_board = comedi_board(dev);
+	const struct addi_board *this_board = dev->board_ptr;
 	char *type = this_board->pc_EepromChip;
 	unsigned short offset = 0;
 	unsigned short ntimers;
@@ -259,7 +259,7 @@ static void addi_eeprom_read_ao_info(struct comedi_device *dev,
 				     unsigned long iobase,
 				     unsigned short addr)
 {
-	const struct addi_board *this_board = comedi_board(dev);
+	const struct addi_board *this_board = dev->board_ptr;
 	struct addi_private *devpriv = dev->private;
 	char *type = this_board->pc_EepromChip;
 	unsigned short tmp;
@@ -278,7 +278,7 @@ static void addi_eeprom_read_ai_info(struct comedi_device *dev,
 				     unsigned long iobase,
 				     unsigned short addr)
 {
-	const struct addi_board *this_board = comedi_board(dev);
+	const struct addi_board *this_board = dev->board_ptr;
 	struct addi_private *devpriv = dev->private;
 	char *type = this_board->pc_EepromChip;
 	unsigned short offset;
@@ -315,7 +315,7 @@ static void addi_eeprom_read_ai_info(struct comedi_device *dev,
 static void addi_eeprom_read_info(struct comedi_device *dev,
 				  unsigned long iobase)
 {
-	const struct addi_board *this_board = comedi_board(dev);
+	const struct addi_board *this_board = dev->board_ptr;
 	char *type = this_board->pc_EepromChip;
 	unsigned short size;
 	unsigned char nfuncs;
-- 
2.1.0

