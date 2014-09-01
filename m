Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847AbaIALJP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 07:09:15 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:39003 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753350AbaIALEV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 07:04:21 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 11/28] staging: comedi: amplc_pci230: remove ai_chans member
Date: Mon,  1 Sep 2014 12:03:43 +0100
Message-Id: <1409569440-10979-12-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1409569440-10979-1-git-send-email-abbotti@mev.co.uk>
References: <1409569440-10979-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All boards supported by the "amplc_pci230" driver have 16 AI channels,
so the `ai_chans` member of `struct pci230_board` is superfluous and can
be removed.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/amplc_pci230.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/staging/comedi/drivers/amplc_pci230.c b/drivers/staging/comedi/drivers/amplc_pci230.c
index 794e0ca..42a79d2 100644
--- a/drivers/staging/comedi/drivers/amplc_pci230.c
+++ b/drivers/staging/comedi/drivers/amplc_pci230.c
@@ -454,7 +454,6 @@ enum {
 struct pci230_board {
 	const char *name;
 	unsigned short id;
-	int ai_chans;
 	int ai_bits;
 	int ao_chans;
 	int ao_bits;
@@ -466,7 +465,6 @@ static const struct pci230_board pci230_boards[] = {
 	{
 		.name		= "pci230+",
 		.id		= PCI_DEVICE_ID_PCI230,
-		.ai_chans	= 16,
 		.ai_bits	= 16,
 		.ao_chans	= 2,
 		.ao_bits	= 12,
@@ -476,14 +474,12 @@ static const struct pci230_board pci230_boards[] = {
 	{
 		.name		= "pci260+",
 		.id		= PCI_DEVICE_ID_PCI260,
-		.ai_chans	= 16,
 		.ai_bits	= 16,
 		.min_hwver	= 1,
 	},
 	{
 		.name		= "pci230",
 		.id		= PCI_DEVICE_ID_PCI230,
-		.ai_chans	= 16,
 		.ai_bits	= 12,
 		.ao_chans	= 2,
 		.ao_bits	= 12,
@@ -492,7 +488,6 @@ static const struct pci230_board pci230_boards[] = {
 	{
 		.name		= "pci260",
 		.id		= PCI_DEVICE_ID_PCI260,
-		.ai_chans	= 16,
 		.ai_bits	= 12,
 	},
 };
@@ -2660,7 +2655,7 @@ static int pci230_auto_attach(struct comedi_device *dev,
 	/* analog input subdevice */
 	s->type = COMEDI_SUBD_AI;
 	s->subdev_flags = SDF_READABLE | SDF_DIFF | SDF_GROUND;
-	s->n_chan = thisboard->ai_chans;
+	s->n_chan = 16;
 	s->maxdata = (1 << thisboard->ai_bits) - 1;
 	s->range_table = &pci230_ai_range;
 	s->insn_read = pci230_ai_rinsn;
-- 
2.0.4

