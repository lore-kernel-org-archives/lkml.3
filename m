Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738AbaG1MJw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 08:09:52 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:49004 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752253AbaG1MJr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 08:09:47 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/7] staging: comedi: amplc_pc236: move static board data
Date: Mon, 28 Jul 2014 13:09:29 +0100
Message-Id: <1406549375-1864-2-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1406549375-1864-1-git-send-email-abbotti@mev.co.uk>
References: <1406549375-1864-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the static board data in `pc236_isa_boards[]` and `pc236_pci_board`
closer to where they are used.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/amplc_pc236.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/comedi/drivers/amplc_pc236.c b/drivers/staging/comedi/drivers/amplc_pc236.c
index b92fc6f..c96519d 100644
--- a/drivers/staging/comedi/drivers/amplc_pc236.c
+++ b/drivers/staging/comedi/drivers/amplc_pc236.c
@@ -84,18 +84,6 @@ struct pc236_board {
 	enum pc236_bustype bustype;
 };
 
-static const struct pc236_board pc236_isa_boards[] = {
-	{
-		.name = "pc36at",
-		.bustype = isa_bustype,
-	},
-};
-
-static const struct pc236_board pc236_pci_board = {
-	.name = "pci236",
-	.bustype = pci_bustype,
-};
-
 struct pc236_private {
 	unsigned long lcr_iobase; /* PLX PCI9052 config registers in PCIBAR1 */
 	int enable_irq;
@@ -342,6 +330,11 @@ static int pc236_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	return pc236_common_attach(dev, dev->iobase, it->options[1], 0);
 }
 
+static const struct pc236_board pc236_pci_board = {
+	.name = "pci236",
+	.bustype = pci_bustype,
+};
+
 static int pc236_auto_attach(struct comedi_device *dev,
 				       unsigned long context_unused)
 {
@@ -387,6 +380,13 @@ static void pc236_detach(struct comedi_device *dev)
 	}
 }
 
+static const struct pc236_board pc236_isa_boards[] = {
+	{
+		.name = "pc36at",
+		.bustype = isa_bustype,
+	},
+};
+
 static struct comedi_driver amplc_pc236_driver = {
 	.driver_name = "amplc_pc236",
 	.module = THIS_MODULE,
-- 
2.0.0

