Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756692AbaIIKkz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 06:40:55 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:36167 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752785AbaIIK1P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 06:27:15 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 12/48] staging: comedi: amplc_pci224: replace comedi_board() calls
Date: Tue,  9 Sep 2014 11:26:21 +0100
Message-Id: <1410258417-28230-13-git-send-email-abbotti@mev.co.uk>
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
 drivers/staging/comedi/drivers/amplc_pci224.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers/amplc_pci224.c b/drivers/staging/comedi/drivers/amplc_pci224.c
index b65cd48..fa179d9 100644
--- a/drivers/staging/comedi/drivers/amplc_pci224.c
+++ b/drivers/staging/comedi/drivers/amplc_pci224.c
@@ -393,7 +393,7 @@ static void
 pci224_ao_set_data(struct comedi_device *dev, int chan, int range,
 		   unsigned int data)
 {
-	const struct pci224_board *thisboard = comedi_board(dev);
+	const struct pci224_board *thisboard = dev->board_ptr;
 	struct pci224_private *devpriv = dev->private;
 	unsigned short mangled;
 
@@ -645,7 +645,7 @@ static int pci224_ao_check_chanlist(struct comedi_device *dev,
 				    struct comedi_subdevice *s,
 				    struct comedi_cmd *cmd)
 {
-	const struct pci224_board *thisboard = comedi_board(dev);
+	const struct pci224_board *thisboard = dev->board_ptr;
 	unsigned int range_check_0;
 	unsigned int chan_mask = 0;
 	int i;
@@ -859,7 +859,7 @@ static void pci224_ao_start_pacer(struct comedi_device *dev,
 
 static int pci224_ao_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 {
-	const struct pci224_board *thisboard = comedi_board(dev);
+	const struct pci224_board *thisboard = dev->board_ptr;
 	struct pci224_private *devpriv = dev->private;
 	struct comedi_cmd *cmd = &s->async->cmd;
 	int range;
@@ -951,7 +951,7 @@ static void
 pci224_ao_munge(struct comedi_device *dev, struct comedi_subdevice *s,
 		void *data, unsigned int num_bytes, unsigned int chan_index)
 {
-	const struct pci224_board *thisboard = comedi_board(dev);
+	const struct pci224_board *thisboard = dev->board_ptr;
 	struct comedi_cmd *cmd = &s->async->cmd;
 	unsigned short *array = data;
 	unsigned int length = num_bytes / sizeof(*array);
-- 
2.1.0

