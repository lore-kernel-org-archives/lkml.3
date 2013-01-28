Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530Ab3A1XdP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 18:33:15 -0500
Received: from mout.gmx.net ([212.227.15.18]:59233 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751927Ab3A1XdN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 18:33:13 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX184/NdcQh842B/xdwT9ttszRnAlxQ8hR1gZ6VJ4MH
	oaKJsJylS6ubXV
From: Peter Huewe <peterhuewe@gmx.de>
To: Ian Abbott <abbotti@mev.co.uk>
Cc: Mori Hess <fmhess@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Bill Pemberton <wfp5p@virginia.edu>, Peter Huewe <peterhuewe@gmx.de>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging/comedi/adl_pci8164: Don't assign string
Date: Tue, 29 Jan 2013 00:36:39 +0100
Message-Id: <1359416199-30487-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.8.6
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Assigning a string is really bad,
and since we only have 1 char strings here we
can simply use a char to store the value and change the format specifier.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/comedi/drivers/adl_pci8164.c |   28 +++++++++++++-------------
 1 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adl_pci8164.c b/drivers/staging/comedi/drivers/adl_pci8164.c
index bfa71e0..ece84dd 100644
--- a/drivers/staging/comedi/drivers/adl_pci8164.c
+++ b/drivers/staging/comedi/drivers/adl_pci8164.c
@@ -62,35 +62,35 @@ static void adl_pci8164_insn_read(struct comedi_device *dev,
 				  char *action, unsigned short offset)
 {
 	int axis, axis_reg;
-	char *axisname;
+	char axisname;
 
 	axis = CR_CHAN(insn->chanspec);
 
 	switch (axis) {
 	case 0:
 		axis_reg = PCI8164_AXIS_X;
-		axisname = "X";
+		axisname = 'X';
 		break;
 	case 1:
 		axis_reg = PCI8164_AXIS_Y;
-		axisname = "Y";
+		axisname = 'Y';
 		break;
 	case 2:
 		axis_reg = PCI8164_AXIS_Z;
-		axisname = "Z";
+		axisname = 'Z';
 		break;
 	case 3:
 		axis_reg = PCI8164_AXIS_U;
-		axisname = "U";
+		axisname = 'U';
 		break;
 	default:
 		axis_reg = PCI8164_AXIS_X;
-		axisname = "X";
+		axisname = 'X';
 	}
 
 	data[0] = inw(dev->iobase + axis_reg + offset);
 	dev_dbg(dev->class_dev,
-		"pci8164 %s read -> %04X:%04X on axis %s\n",
+		"pci8164 %s read -> %04X:%04X on axis %c\n",
 		action, data[0], data[1], axisname);
 }
 
@@ -142,36 +142,36 @@ static void adl_pci8164_insn_out(struct comedi_device *dev,
 {
 	unsigned int axis, axis_reg;
 
-	char *axisname;
+	char axisname;
 
 	axis = CR_CHAN(insn->chanspec);
 
 	switch (axis) {
 	case 0:
 		axis_reg = PCI8164_AXIS_X;
-		axisname = "X";
+		axisname = 'X';
 		break;
 	case 1:
 		axis_reg = PCI8164_AXIS_Y;
-		axisname = "Y";
+		axisname = 'Y';
 		break;
 	case 2:
 		axis_reg = PCI8164_AXIS_Z;
-		axisname = "Z";
+		axisname = 'Z';
 		break;
 	case 3:
 		axis_reg = PCI8164_AXIS_U;
-		axisname = "U";
+		axisname = 'U';
 		break;
 	default:
 		axis_reg = PCI8164_AXIS_X;
-		axisname = "X";
+		axisname = 'X';
 	}
 
 	outw(data[0], dev->iobase + axis_reg + offset);
 
 	dev_dbg(dev->class_dev,
-		"pci8164 %s write -> %04X:%04X on axis %s\n",
+		"pci8164 %s write -> %04X:%04X on axis %c\n",
 		action, data[0], data[1], axisname);
 
 }
-- 
1.7.8.6

